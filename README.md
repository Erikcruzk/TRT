## Transformative Smart Contract Repair

Attempt to repair Smart Contracts using OpenAI Codex model.

## Get Started

### Installation and Configuration

#### Install Python requirements

`pip3 install -r requirements.txt`

#### Install smartbugs

Clone smartbugs and install it in the root directory of our tool:

```
git clone https://github.com/smartbugs/smartbugs
cd smartbugs
install/setup-venv.sh
```

#### Start docker

#### Add the API Key for OpenAI

Add .env file with openAI-key

`OPENAI_API_KEY=XXXXX`

#### Prompt experiment roadmap
Temperature 0.5 and 0.7. Top_p 0.95

1. Basic. Just Fix this vulnerable Solidity Smart Contract `basic`
2. Json info from analyzers `analyzers_json_results`
3. Natural language info from analyzers `analyzers_natural_language_results`

