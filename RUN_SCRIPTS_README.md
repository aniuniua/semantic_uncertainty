# 启动脚本使用说明

本项目提供了几个便捷的启动脚本来运行 Semantic Uncertainty 实验。

## 快速开始

### 1. 运行 Demo（最简单）

```bash
./run_demo.sh
```

这会使用默认配置运行一个快速演示：
- 模型：Llama-2-7b-chat
- 数据集：trivia_qa
- 最大生成token数：50

### 2. 使用配置文件运行完整流程

```bash
# 1. 编辑配置文件（可选）
source config_example.sh

# 2. 运行完整流程
./run_pipeline.sh
```

### 3. 自定义配置运行

```bash
# 设置环境变量
export MODEL_NAME="Llama-2-13b-chat"
export DATASET="squad"
export MODEL_MAX_NEW_TOKENS=100

# 运行
./run_pipeline.sh
```

## 脚本说明

### `run_demo.sh`
最简单的启动脚本，用于快速测试。运行默认配置的演示。

### `run_pipeline.sh`
完整的流程脚本，包含：
1. 环境检查
2. 生成答案 (`generate_answers.py`)
3. 计算不确定性度量（如果启用）
4. 结果分析提示

### `config_example.sh`
配置文件示例，包含所有可配置的参数。可以通过 `source config_example.sh` 来加载配置。

## 配置参数

### 模型选择
- `Llama-2-7b-chat`, `Llama-2-13b-chat`, `Llama-2-70b-chat`
- `falcon-7b`, `falcon-40b`, `falcon-7b-instruct`, `falcon-40b-instruct`
- `Mistral-7B-v0.1`, `Mistral-7B-Instruct-v0.1`

### 数据集选择
- `trivia_qa` - TriviaQA 数据集
- `squad` - SQuAD 数据集
- `bioasq` - BioASQ 数据集（需要手动下载数据）
- `nq` - Natural Questions 数据集
- `svamp` - SVAMP 数据集

### 实验类型配置

#### 短短语生成（Short-phrase）
```bash
export MODEL_MAX_NEW_TOKENS=50
export NUM_FEW_SHOT=0
export BRIEF_PROMPT=""
export METRIC="squad"
```

#### 句子长度生成（Sentence-length）
```bash
export MODEL_MAX_NEW_TOKENS=100
export NUM_FEW_SHOT=0
export BRIEF_PROMPT="chat"
export METRIC="llm_gpt-4"
export ENTAILMENT_MODEL="gpt-3.5"
```

## 环境变量

### 必需的环境变量

- `HUGGING_FACE_HUB_TOKEN` - Hugging Face token（访问某些模型需要，如 LLaMA-2）
- `OPENAI_API_KEY` - OpenAI API key（如果使用 GPT 模型或 GPT 评估指标）

### 可选的环境变量

- `SCRATCH_DIR` - 工作目录（默认为当前目录）
- `WANDB_SEM_UNC_ENTITY` - Weights & Biases 实体名称

## 运行示例

### 示例 1：短短语生成实验
```bash
export MODEL_NAME="Llama-2-7b-chat"
export DATASET="trivia_qa"
export MODEL_MAX_NEW_TOKENS=50
./run_pipeline.sh
```

### 示例 2：句子长度生成实验
```bash
export MODEL_NAME="Llama-2-7b-chat"
export DATASET="trivia_qa"
export MODEL_MAX_NEW_TOKENS=100
export BRIEF_PROMPT="chat"
export METRIC="llm_gpt-4"
export ENTAILMENT_MODEL="gpt-3.5"
export COMPUTE_UNCERTAINTIES=true
./run_pipeline.sh
```

### 示例 3：使用配置文件
```bash
# 编辑 config_example.sh 设置你想要的参数
vim config_example.sh

# 加载配置并运行
source config_example.sh
./run_pipeline.sh
```

## 查看结果

1. **Weights & Biases Dashboard**
   - 脚本会自动将结果记录到 wandb
   - 查看你的 wandb 项目页面

2. **使用 Jupyter Notebook**
   - 打开 `notebooks/example_evaluation.ipynb`
   - 填入你的 `wandb_runid`
   - 运行所有单元格

3. **手动分析结果**
   ```bash
   python semantic_uncertainty/analyze_results.py --wandb_runids=<your_run_id>
   ```

## 注意事项

1. **Conda 环境**：确保已激活 `semantic_uncertainty` conda 环境
2. **GPU 内存**：不同模型需要不同的 GPU 内存
   - 7B 模型：至少 24GB
   - 13B 模型：至少 40GB
   - 70B 模型：需要 2x80GB A100
3. **运行时间**：Demo 在 A100 GPU 上大约需要 1 小时
4. **首次运行**：首次运行会下载模型，可能需要更长时间

## 故障排除

### 问题：找不到 conda 环境
```bash
conda env create -f environment.yaml
conda activate semantic_uncertainty
```

### 问题：Hugging Face token 错误
```bash
export HUGGING_FACE_HUB_TOKEN="your_token_here"
huggingface-cli login
```

### 问题：OpenAI API 错误
确保设置了正确的 API key：
```bash
export OPENAI_API_KEY="your_key_here"
```

### 问题：GPU 内存不足
- 使用更小的模型（如 7B）
- 启用 8-bit 量化（在模型名后加 `-8bit`，如 `Llama-2-7b-chat-8bit`）
- 使用 4-bit 量化（在模型名后加 `-4bit`）

## 更多信息

参考原始仓库：https://github.com/lorenzkuhn/semantic_uncertainty




