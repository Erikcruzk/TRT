import hashlib
import logging
from pathlib import Path
import subprocess
import json
import os
import traceback
from typing import List
import yaml

class SmartContract:
    '''
    A class that represents a Solidity smart contract.

    This class contains methods to load, find, and compare vulnerabilities in a Solidity smart contract. It also includes methods to store and retrieve candidate patches.

    Attributes:
    - path (str): a string representing the file path to the Solidity smart contract.
    - filename (str): a string representing the name of the Solidity smart contract file.
    - language (str): a string representing the programming language of the Solidity smart contract.
    - source_code (str): a string representing the source code of the Solidity smart contract.
    - vulnerabilities (dict): a dictionary that maps the name of a vulnerability detection tool to a list of detected vulnerabilities.
    - candidate_patches (list): a list of candidate patches for the Solidity smart contract.

    Methods:
    - __init__(self, sc_path): constructor method that initializes the SmartContract object.
    - load_vulnerabilities(self): loads the detected vulnerabilities from the results directory of a vulnerability detection tool.
    - find_vulnerabilities(self): finds vulnerabilities in the Solidity smart contract using the SmartBugs vulnerability detection tool.
    - get_vulnerabilities_difference(self, other_sc): compares the vulnerabilities detected in the current SmartContract instance to those detected in another SmartContract instance, and returns the differences.
    '''

    def __init__(self, experiment_settings:dict, sc_path:str, sc_results_dir:str):
        '''
        Constructor method that initializes a SmartContract object with the specified Solidity smart contract file path.

        Args:
        - sc_path (str): a string representing the file path to the Solidity smart contract.
        '''
        self.experiment_settings = experiment_settings
        self.path = sc_path
        self.filename = os.path.basename(self.path)
        self.name, _ = os.path.splitext(self.filename)
        self.language = 'Solidity' if self.filename.endswith('.sol') else 'Unknown'
        self.source_code = open(self.path, 'r').read()
        self.hash = hashlib.sha256(open(self.path, 'rb').read()).hexdigest()
        self.vulnerabilities = {}
        self.candidate_patches = []

        self.results_dir = Path(os.path.join(sc_results_dir,
                self.name))
    
    def set_vulnerabilities(self, tool_name:str, tool_result:dict):
        """
        Set vulnerabilities for a given tool's result.

        Parameters:
        tool_name (str): The name of the tool used to generate the result.
        tool_result (dict): The result of running the tool, including findings and errors.

        Returns:
        None

        """
        try:
            # Create aliases, fill if necessary
            reentrancy_aliases = ['reentrancy', 'Re-Entrancy Vulnerability']
            integer_overflow_aliases = ['integer overflow', 'Integer Overflow']

            vulnerabilities_aliases = {}
            vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in reentrancy_aliases], 'reentrancy'))
            vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in integer_overflow_aliases], 'integer_overflow'))

            self.vulnerabilities[tool_name] = []
            # First check if any errors = no findings TODO: check correct contract
            if not tool_result['findings']:
                self.vulnerabilities[tool_name] = ['error'] + tool_result['errors']
            else:
                for vulnerability_name in [finding['name'] for finding in tool_result['findings']]:
                    vulnerability_name = vulnerability_name.lower()

                    # Check if alias fount
                    if vulnerability_name in vulnerabilities_aliases:
                        self.vulnerabilities[tool_name].append(vulnerabilities_aliases[vulnerability_name])
                        continue
                    
                    # Check if vulnerability_name contains any alias
                    vulnerability_name_contains_alias = vulnerabilities_aliases.get(next((key for key in vulnerabilities_aliases if key in vulnerability_name), None));
                    if vulnerability_name_contains_alias:
                        self.vulnerabilities[tool_name].append(vulnerability_name_contains_alias)
                        continue
                    
                    # Finally add vulnerability name
                    self.vulnerabilities[tool_name].append(vulnerability_name)
            # In strict mode clean undesired vulnerabilities
            if self.experiment_settings["target_vulnerabilities"]:
                self.vulnerabilities[tool_name] = [x for x in self.vulnerabilities[tool_name] if x in self.experiment_settings["target_vulnerabilities"]]            
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)

    def get_vulnerabilities(self) -> None:
        '''
        Load the detected vulnerabilities from the results directory of the vulnerability detection tools.

        This method looks for a subdirectory in the `sb_results` directory with the same name as the Solidity smart contract file.
        For each subdirectory, it loads the detected vulnerabilities from the `result.json` file of each vulnerability detection tool.

        Raises:
        - FileNotFoundError: If the results directory for the Solidity smart contract file cannot be found.

        '''
        try:
            smartbugs_results_dir = os.path.join(self.results_dir, "smartbugs_results")

            for smartbugs_result_file in os.listdir(smartbugs_results_dir):
                full_path = os.path.join(smartbugs_results_dir, smartbugs_result_file)
                if os.path.isdir(full_path):
                    tool_name = os.path.basename(full_path).split('_', 1)[0]
                    with open(os.path.join(full_path, 'result.json'), 'r') as f:
                        tool_result = json.load(f)

                    self.set_vulnerabilities(tool_name, tool_result)
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)

    def run_smartbugs(self) -> None:
        '''
        Use the Smart Bugs tool to find vulnerabilities in the smart contract.

        This method runs the Smart Bugs tool on the Solidity file and loads the resulting
        vulnerabilities into the `vulnerabilities` attribute using the `load_vulnerabilities` method.
        '''

        smartbugs_results_dir = Path(os.path.join(self.results_dir,
                "smartbugs_results"))
            
        #### Step 3: Find Vulnerabilities
        # Create results directory
        if smartbugs_results_dir.exists():
            return # vulnerabilities already found TODO: check results file      
        smartbugs_results_dir.mkdir(parents=True, exist_ok=True)

        #### Create smartbugs config yaml file
        # set the fields that are not editable
        smartbugs_config = {
            'runtime': False,
            'runid': '${YEAR}${MONTH}${DAY}_${HOUR}${MIN}',
            'json': True,
            'tools': self.experiment_settings["smartbugs_tools"],
            'results': os.path.join(smartbugs_results_dir, "${TOOL}_${RUNID}"),
            'log': os.path.join(self.results_dir,'smartbugs_logs', '{RUNID}.log')
        }

        # write the data to a YAML file
        smartbugs_config_path = os.path.join(self.results_dir,'smartbugs_config.yml')
        with open(smartbugs_config_path, 'w') as f:
            yaml.dump(smartbugs_config, f)

        output = subprocess.run([f'./smartbugs/smartbugs -c {smartbugs_config_path} -f {self.path}'], capture_output=True, text=True, shell=True)
        self.get_vulnerabilities()

        # Save vulnerabilities
        with open(os.path.join(self.results_dir, "vulnerabilities.json"), "w") as outfile:
            outfile.write(json.dumps(self.vulnerabilities))

    def get_repaired_vulnerabilities(self, repaired_sc) -> dict:
        '''
        Returns a dictionary containing the vulnerabilities that have been repaired in a given SmartContract object, `repaired_sc`.

        Args:
            - repaired_sc: A SmartContract object containing the attempted repair.

        Returns:
            A dictionary where the keys represent the tool used to detect the vulnerabilities, and the values represent the list of vulnerabilities that have been repaired, that is they are not present in the tool.
        '''
        try:
            repaired_vulnerabilities = {}
            for tool, vulnerabilities in repaired_sc.vulnerabilities.items():
                if('error' in vulnerabilities):
                    repaired_vulnerabilities[tool] = vulnerabilities
                    continue

                repaired_vulnerabilities[tool] = [x for x in self.vulnerabilities[tool] if x not in vulnerabilities]
            
            return repaired_vulnerabilities
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)
            return {"error": str(e), 'stacktrace': traceback.format_exc()}
        