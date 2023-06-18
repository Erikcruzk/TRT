# The Transformative Repair Tool

<img src="./logos/TRT_logo_white.png" alt="Alternative Text" style="opacity:0.9;" width="200"/>

TRT is the first tool for Automatic Program Repair (APR) of Solidity Smart Contracts.

## Run i Docker

1. Clone repo
2. Add your openAI as in the .env file
```
cd transformative_repair
touch .env
echo "OPENAI_API_KEY=<your_openai_key>" > .env
```
3. Run docker
   - Docker compose
```
cd transformative_repair
docker-compose up -d --build
```
   - Docker
```
cd transformative_repair
docker build -t trt:latest .
docker run -tid\
  -v $(pwd)/config.yml:/app/config.yml \
  -v $(pwd)/experiment_results:/app/experiment_results \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  --name trt_container \
  trt:latest
```
4. Edit experiment configs `config.yml`
5. Enter container and run experiments
```
docker-compose exec trt_container bash
tmux new -s trt_session
python3 main.py
```

## Run locally

1. Clone repo
2. Add your openAI as in the .env file
```
cd transformative_repair
touch .env
echo "OPENAI_API_KEY=<your_openai_key>" > .env
```
3. Install smartbugs
```
cd transformative_repair
git clone https://github.com/smartbugs/smartbugs
cd smartbugs
install/setup-venv.sh
```

4. Install pip requirements
`pip3 install -r requirements.txt`

5. Run TRT
`python3 main.py`

## TRT run experiments
1. Clone repo
2. cd transformative_repair
3. Add .env file with openAI credentials
4. docker build --pull --rm -f "Dockerfile" -t trt:latest "."
5. Start containers

- access_control
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

- arithmetic
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

- reentrancy
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

- tod
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

- unchecked
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
3. Enter Container
```
docker exec -it trt_container_<name> bash
```
4. Stop container
```
docker stop trt_container_<name>
```
5. count active containers
```
docker ps --format "{{.ID}}" | wc -l
```

## Docker Cleanup procedure
1. Remove all smartbugs images
```
docker ps -a | grep -E 'smartbugs/mythril:0.23.15|smartbugs/smartcheck|smartbugs/security:usolc|smartbugs/manticore:0.3.7|smartbugs/oyente:480e725|smartbugs/slither|smartbugs/maian:solc5.10|smartbugs/osiris:d1ecc37|trt:latest' | awk '{print $1}' | xargs docker rm -f
```

2. Remove all trt containers
```
docker ps -a | grep trt:latest | awk '{print $1}' | xargs docker rm -f
```

#### Prompt experiment roadmap
Temperature 0.5 and 0.7. Top_p 0.95

1. Basic. Just Fix this vulnerable Solidity Smart Contract `basic`
2. Json info from analyzers `analyzers_json_results`
3. Natural language info from analyzers `analyzers_natural_language_results`


### Improvements to Smartbugs
- Allow for parsing to common vulnerability types (labelled vulnerabilities)
- Know what tools detect these different labels
- Establish voting system between tools (vote in/out false positives)
- Provide summary report of errors encountered
- Get tools depending on vulnerability
- Better Manticore Support
- Select tmp folder location
- Do not mute underlyning container logs (Mythril?). I want to be able to inspect the logs when I am inside

### Improvements to TRT
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
