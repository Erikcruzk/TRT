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

#### Conclusions
- Osiris may be flagging false positives (it is reporting all direct calls to external functions vulnerable to reentrancy. Probably expecting to add transfer or send instead)

#### TODOs
1.  experiment_results/smartbugs_reentrancy_short_no_comments_tools3_patches10_tmp0.7_topp0.95_gpt-3.5-turbo/analyzers_natural_language_results/reentrancy_cross_function/candidate_patches/patch_0/patch_0.sol

- manticore, mythril, oyente, slither (have more discussions about what tools to use)
- Check with all tools modifier_reentrancy contract
  - Two ways to patch this SC
  1. Look at email
  2. Remove the external function call vulnerability and reentrancy vulnerability will dissapear too

- Create tests chatGPT and Run tests on remix
   
- FLAG SOMEHOW IF ORIFINAL SC HAS NO BUG
