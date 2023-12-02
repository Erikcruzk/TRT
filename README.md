# The Transformative Repair Tool

<img src="./logos/TRT_logo_white.png" alt="Alternative Text" style="opacity:0.9;" width="200"/>

TRT is the first tool for Automatic Program Repair (APR) of Solidity Smart Contracts.

# How To Run TRT
## Init

1. Clone repo
2. Add your openAI key in the .env file
```
cd TRT
touch .env
echo "OPENAI_API_KEY=<your_openai_key>" > .env
```
3. Edit experiment configs [`config.yml`](config.yml)

## Run in Docker

### Docker compose

```
cd TRT
docker-compose up -d --build
```

### Docker

```
cd TRT
docker build -t trt:latest .
docker run -tid\
  -v $(pwd)/config.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container \
  trt:latest
```

### Enter container and run experiments
```
docker-compose exec trt_container bash
tmux new -s trt_session
python3 main.py
```

## Run locally

1. Install smartbugs
```
cd TRT
git clone https://github.com/ASSERT-KTH/smartbugs
cd smartbugs
install/setup-venv.sh
```

2. Install pip requirements
```
pip3 install -r requirements.txt
```

3. Run TRT
```
python3 main.py
```

# TRT experiment results on the Smartbugs Curated Dataset
1. [Prompt Engineering results](experiment_results/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo)
    - [Basic prompt results](experiment_results/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/reentrancy/basic/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_reentrancy_analyzers_natural_language_results_summary.md)
    - [JSON prompt results](experiment_results/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/reentrancy/analyzers_json_results/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_reentrancy_analyzers_json_results_summary.md)
    - [Natural Language prompt results](experiment_results/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/reentrancy/analyzers_natural_language_results/trt_results_prompt_comparison_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_reentrancy_analyzers_natural_language_results_summary.md)
3. [Main Experimentation Results with natural Language Prompt](experiment_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo)
    - [access_control](experiment_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/access_control/analyzers_natural_language_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_access_control_analyzers_natural_language_results_summary.md)
    - [arithmetic](experiment_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/arithmetic/analyzers_natural_language_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_arithmetic_analyzers_natural_language_results_summary.md)
    - [reentrancy](experiment_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/reentrancy/analyzers_natural_language_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_reentrancy_analyzers_natural_language_results_summary.md)
    - [Transaction Order Dependence](experiment_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/transaction_order_dependence/analyzers_natural_language_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_transaction_order_dependence_analyzers_natural_language_results_summary.md)
    - [Unchecked Low Level Calls](experiment_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo/unchecked_low_level_calls/analyzers_natural_language_results/trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_unchecked_low_level_calls_analyzers_natural_language_results_summary.md)


# TRT experiments containers

1. access_control
```
docker run -tid\
  -v $(pwd)/config_access_control.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container_access_control \
  trt:latest
docker exec -it trt_container_access_control bash
```

2. arithmetic
```
docker run -tid\
  -v $(pwd)/config_arithmetic.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container_arithmetic \
  trt:latest
  docker exec -it trt_container_arithmetic bash
```

3. reentrancy
```
docker run -tid\
  -v $(pwd)/config_reentrancy.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container_reentrancy \
  trt:latest
  docker exec -it trt_container_reentrancy bash
```

4. tod
```
docker run -tid\
  -v $(pwd)/config_tod.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container_tod \
  trt:latest
  docker exec -it trt_container_tod bash
```

5. unchecked
```
docker run -tid\
  -v $(pwd)/config_unchecked.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container_unchecked \
  trt:latest
  docker exec -it trt_container_unchecked bash
```

## Helpful commands
1. Enter Container
```
docker exec -it trt_container_<name> bash
```
2. Stop container
```
docker stop trt_container_<name>
```
3. count active containers
```
docker ps --format "{{.ID}}" | wc -l
```

# Docker Cleanup procedure
1. Remove all smartbugs images
```
docker ps -a | grep -E 'smartbugs/mythril:0.23.15|smartbugs/smartcheck|smartbugs/security:usolc|smartbugs/manticore:0.3.7|smartbugs/oyente:480e725|smartbugs/slither|smartbugs/maian:solc5.10|smartbugs/osiris:d1ecc37|trt:latest' | awk '{print $1}' | xargs docker rm -f
```

2. Remove all trt containers
```
docker ps -a | grep trt:latest | awk '{print $1}' | xargs docker rm -f
```

#Prompt experiment roadmap
Temperature 0.5 and 0.7. Top_p 0.95

1. Basic. Just Fix this vulnerable Solidity Smart Contract `basic`
2. Json info from analyzers `analyzers_json_results`
3. Natural language info from analyzers `analyzers_natural_language_results`


# Improvements to Smartbugs
- Allow for parsing to common vulnerability types (labelled vulnerabilities)
- Know what tools detect these different labels
- Establish voting system between tools (vote in/out false positives)
- Provide summary report of errors encountered
- Get tools depending on vulnerability
- Better Manticore Support
- Select tmp folder location
- Do not mute underlyning container logs (Mythril?). I want to be able to inspect the logs when I am inside

# Improvements to TRT
- Adapt to Smartbugs 2.0
- Create compile check on specific version
- Add config file for parsing of results
- Do not reset execution time when retaking experiments
- Automatically create tests for SC => fail if SC bugs are detected
- TAT => Transformative Attack Tool. Shows how to attach an original SC
- TDT => Transformative Detect Tool. Detection with LLMs
- Adapt TRT to fix and assess at bug level
- Build k3s architecture for running docker containers on different machines. To scale execution horizontally.
- Increase dataset. keep hidden from LLMs
- Create test harness for all contracts

# Config.json parameters


| Parameter                   | Description                                        | Options/Examples                               |
|-----------------------------|----------------------------------------------------|------------------------------------------------|
| experiment name^1           | Experiment name                                   |                                                |
| delete old experiment name^1| Delete old experiment results with the same name |                                                |
| n repair threads^1          | Number of threads for repair                     |                                                |
| patch examples directory^1  | Directory for patch examples                      |                                                |
| llm model name^1            | Name of the LLM (Large Language Model) to use    |                                                |
| vulnerable contracts directory^1 | Directory path for vulnerable smart contracts  |                                                |
| target vulnerabilities^1    | List of target vulnerabilities                    | [access_control, arithmetic, transaction_order_dependence, reentrancy, unchecked_low_level_call, unhandled_exception] |
| n smartbugs threads^1       | Number of threads for SmartBugs analysis         |                                                |
| smartbugs tools^1           | List of tools used for SmartBugs analysis        | [access_control_tools, arithmetic_tools, reentrancy_tools, unchecked_calls_tools, transaction_order_dependence_tools] or [oyente, slither, confuzzius, conkas, honeybadger, maian, mythril, osiris, securify, sFuzz, solhint] |
| smartbugs timeout^1         | Timeout for SmartBugs analysis                    |                                                |
| smartbugs processes^1       | Concurrent SmartBugs processes                    |                                                |
| prompt style^1              | Style for prompts                                  | [basic, analyzers_json_results, analyzers_natural_language_results] |
| shave^1                     | List of elements to remove from the contract     | [comments, NatSpec, file directives] |
| threshold^1                 | Number of tokens that trigger shaving process    |                                                |
| model name^2                | Name of the LLM model (second occurrence)        |                                                |
| secret api key^2            | Secret API key for the LLM model (the name of the env variable)              |  |
| temperature^2               | Temperature setting for the LLM model            |                                                |
| top p^2                     | Top-p setting for the LLM model                   |                                                |
| num candidate patches^2     | Number of candidate patches for the LLM model    |                                                |
| max time^2                  | Maximum time setting for the LLM model            |                                                |
| stop^2                      | Stop token(s) for the LLM model                   |  |


*1*: Experiment setting parameter.
*2*: LLM setting parameter.
