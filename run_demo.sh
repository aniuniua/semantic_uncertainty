#!/bin/bash
# Quick demo script for Semantic Uncertainty
# Runs a simple example with default settings

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Semantic Uncertainty Demo ==="
echo ""
echo "This will run a demo with:"
echo "  Model: Qwen/Qwen3-8B"
echo "  Dataset: trivia_qa"
echo "  Max tokens: 30"
echo ""

# W&B: avoid interactive prompts (e.g. asking to choose 1/2/3) so this can run in background.
# Default to offline unless the user explicitly sets WANDB_MODE=online.
export WANDB_MODE="${WANDB_MODE:-offline}"
export WANDB_SILENT="${WANDB_SILENT:-true}"

# Check / activate conda environment (inside this script's process)
if command -v conda >/dev/null 2>&1; then
  # Ensure `conda activate` is available in non-interactive shells.
  # shellcheck disable=SC1090
  source "$(conda info --base)/etc/profile.d/conda.sh"

  if [[ "$CONDA_DEFAULT_ENV" != "semantic_uncertainty" ]]; then
    echo "Activating conda environment: semantic_uncertainty"
    conda activate semantic_uncertainty 2>/dev/null || {
      echo "Error: Could not activate conda environment 'semantic_uncertainty'"
      echo "Please create it first: conda env create -f environment.yaml"
      exit 1
    }
  fi

  echo "Conda env in script: ${CONDA_DEFAULT_ENV:-<none>}"
else
  echo "Warning: conda not found in PATH. Skipping conda activate."
fi

# Run the demo
python semantic_uncertainty/semantic_uncertainty/generate_answers.py \
  --model_name=Qwen/Qwen3-8B \
  --dataset=trivia_qa \
  --compute_uncertainties \
  --model_max_new_tokens=50 \
  --num_samples=400 \
  --num_generations=10 \
  --num_few_shot=5 \
  --temperature=1.0 \
  --metric=squad \
  --entailment_model=deberta

echo ""
echo "Demo completed! W&B mode: $WANDB_MODE"

# Llama-2-7b-chat
# model_name=Qwen/Qwen3-8B \
