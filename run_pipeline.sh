#!/bin/bash
# Semantic Uncertainty Pipeline Runner
# Based on: https://github.com/lorenzkuhn/semantic_uncertainty

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default configuration
MODEL_NAME="${MODEL_NAME:-Llama-2-7b-chat}"
DATASET="${DATASET:-trivia_qa}"
NUM_FEW_SHOT="${NUM_FEW_SHOT:-0}"
MODEL_MAX_NEW_TOKENS="${MODEL_MAX_NEW_TOKENS:-50}"
BRIEF_PROMPT="${BRIEF_PROMPT:-chat}"
METRIC="${METRIC:-squad}"
ENTAILMENT_MODEL="${ENTAILMENT_MODEL:-deberta}"
COMPUTE_UNCERTAINTIES="${COMPUTE_UNCERTAINTIES:-true}"
ANALYZE_RESULTS="${ANALYZE_RESULTS:-true}"
RANDOM_SEED="${RANDOM_SEED:-10}"
DEBUG="${DEBUG:-false}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

# Change to project directory
cd "$PROJECT_DIR"

echo -e "${GREEN}=== Semantic Uncertainty Pipeline ===${NC}"
echo "Project directory: $PROJECT_DIR"
echo "Model: $MODEL_NAME"
echo "Dataset: $DATASET"
echo ""

# Check if conda environment is activated
if [[ -z "$CONDA_DEFAULT_ENV" ]]; then
    echo -e "${YELLOW}Warning: No conda environment detected.${NC}"
    echo "Please activate your conda environment first:"
    echo "  conda activate semantic_uncertainty"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check required environment variables
echo -e "${GREEN}Checking environment variables...${NC}"
MISSING_VARS=()

if [[ -z "$HUGGING_FACE_HUB_TOKEN" ]]; then
    echo -e "${YELLOW}Warning: HUGGING_FACE_HUB_TOKEN not set${NC}"
    echo "  You may need this to access some models (e.g., LLaMA-2)"
fi

if [[ -z "$OPENAI_API_KEY" ]] && [[ "$METRIC" == *"gpt"* ]] || [[ "$ENTAILMENT_MODEL" == *"gpt"* ]]; then
    MISSING_VARS+=("OPENAI_API_KEY")
fi

if [[ ${#MISSING_VARS[@]} -gt 0 ]]; then
    echo -e "${RED}Error: Missing required environment variables:${NC}"
    for var in "${MISSING_VARS[@]}"; do
        echo "  - $var"
    done
    exit 1
fi

# Set default scratch directory if not set
if [[ -z "$SCRATCH_DIR" ]]; then
    export SCRATCH_DIR="."
    echo -e "${YELLOW}SCRATCH_DIR not set, using current directory: $SCRATCH_DIR${NC}"
fi

# Build command arguments
PYTHON_CMD="python semantic_uncertainty/generate_answers.py"
ARGS=(
    "--model_name=$MODEL_NAME"
    "--dataset=$DATASET"
    "--model_max_new_tokens=$MODEL_MAX_NEW_TOKENS"
    "--random_seed=$RANDOM_SEED"
    "--metric=$METRIC"
    "--entailment_model=$ENTAILMENT_MODEL"
)

# Add optional arguments
if [[ "$NUM_FEW_SHOT" != "0" ]]; then
    ARGS+=("--num_few_shot=$NUM_FEW_SHOT")
fi

if [[ "$BRIEF_PROMPT" != "" ]]; then
    ARGS+=("--brief_prompt=$BRIEF_PROMPT")
fi

if [[ "$COMPUTE_UNCERTAINTIES" == "true" ]]; then
    ARGS+=("--compute_uncertainties")
fi

if [[ "$DEBUG" == "true" ]]; then
    ARGS+=("--debug")
fi

# Step 1: Generate answers
echo -e "${GREEN}=== Step 1: Generating answers ===${NC}"
echo "Command: $PYTHON_CMD ${ARGS[*]}"
echo ""

$PYTHON_CMD "${ARGS[@]}"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Error: Failed to generate answers${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Step 1 completed successfully${NC}"
echo ""

# Step 2: Compute uncertainty measures (if not done automatically)
if [[ "$COMPUTE_UNCERTAINTIES" != "true" ]]; then
    echo -e "${GREEN}=== Step 2: Computing uncertainty measures ===${NC}"
    
    # Get wandb run ID from the previous step
    # This would need to be extracted from wandb or passed as argument
    echo -e "${YELLOW}Note: You may need to manually specify --eval_wandb_runid${NC}"
    echo "Run: python semantic_uncertainty/compute_uncertainty_measures.py --eval_wandb_runid=<run_id>"
    echo ""
fi

# Step 3: Analyze results (if enabled)
if [[ "$ANALYZE_RESULTS" == "true" ]]; then
    echo -e "${GREEN}=== Step 3: Analyzing results ===${NC}"
    echo -e "${YELLOW}Note: You need to specify --wandb_runids to analyze results${NC}"
    echo "Run: python semantic_uncertainty/analyze_results.py --wandb_runids=<run_id1> [<run_id2> ...]"
    echo ""
fi

echo -e "${GREEN}=== Pipeline completed ===${NC}"
echo ""
echo "Next steps:"
echo "1. Check your wandb dashboard for results"
echo "2. Use the evaluation notebook: notebooks/example_evaluation.ipynb"
echo "3. Pass the wandb_runid to analyze_results.py for detailed metrics"




