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

#### Install solidity compiler

`Linux`
```
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```


`Mac OS`
```
brew update
brew upgrade
brew tap ethereum/ethereum
brew install solidity
```

#### Add the API Key for OpenAI

Add .env file with openAI-key

`OPENAI_API_KEY=XXXXX`
