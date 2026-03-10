#!/bin/bash
# Example configuration file for Semantic Uncertainty pipeline
# Source this file before running run_pipeline.sh
# Usage: source config_example.sh && ./run_pipeline.sh

# Model configuration
# Options: Llama-2-7b-chat, Llama-2-13b-chat, Llama-2-70b-chat, 
#          falcon-7b, falcon-40b, Mistral-7B-v0.1, etc.
# export MODEL_NAME="Llama-2-7b-chat"
export MODEL_NAME="Qwen/Qwen3-8B"

# Dataset configuration
# Options: trivia_qa, squad, bioasq, nq, svamp
export DATASET="trivia_qa"

# Generation parameters
export MODEL_MAX_NEW_TOKENS=50  # For short-phrase generation
# export MODEL_MAX_NEW_TOKENS=100  # For sentence-length generation

# Few-shot settings
export NUM_FEW_SHOT=0  # 0 for short-phrase, or set to desired number

# Prompt settings
export BRIEF_PROMPT="chat"  # For sentence-length: --brief_prompt=chat

# Evaluation metric
# Options: squad, llm, llm_gpt-3.5, llm_gpt-4
export METRIC="squad"

# Entailment model
# Options: deberta, gpt-3.5, gpt-4, gpt-4-turbo, llama
export ENTAILMENT_MODEL="deberta"

# Pipeline control
export COMPUTE_UNCERTAINTIES=true
export ANALYZE_RESULTS=true

# Random seed for reproducibility
export RANDOM_SEED=10

# Debug mode (uses semantic_uncertainty_debug project in wandb)
export DEBUG=false

# Environment variables (set these in your shell or .bashrc)
# export HUGGING_FACE_HUB_TOKEN="your_token_here"
# export OPENAI_API_KEY="your_key_here"  # Required if using GPT models/metrics
# export SCRATCH_DIR="/path/to/scratch"  # Defaults to current directory
# export WANDB_SEM_UNC_ENTITY="your_wandb_entity"  # Optional

# Example configurations for different experiment types:

# Short-phrase generation (default)
# MODEL_MAX_NEW_TOKENS=50
# NUM_FEW_SHOT=0
# BRIEF_PROMPT=""

# Sentence-length generation
# MODEL_MAX_NEW_TOKENS=100
# NUM_FEW_SHOT=0
# BRIEF_PROMPT="chat"
# METRIC="llm_gpt-4"
# ENTAILMENT_MODEL="gpt-3.5"

