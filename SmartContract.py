import hashlib
import logging
from pathlib import Path
import subprocess
import json
import os
import traceback
from typing import List
import yaml
import re

class SmartContract:
    def __init__(self, experiment_settings:dict, sc_path:Path):
        self.experiment_settings:dict = experiment_settings
        self.path:Path = sc_path
        self.results_dir:Path = self.path.parent.absolute()

        self.filename = os.path.basename(self.path)
        self.name, _ = os.path.splitext(self.filename)
        self.language = 'Solidity' if self.filename.endswith('.sol') else 'Unknown'
        self.source_code = open(self.path, 'r').read()
        self.hash = SmartContract.get_stripped_source_code_hash(self.source_code)

        vulnerabilities_file_path = os.path.join(self.results_dir, "vulnerabilities.json")
        self.vulnerabilities = json.load(open(vulnerabilities_file_path, 'r')) if os.path.isfile(vulnerabilities_file_path) else {}
        self.candidate_patches = []

    @staticmethod
    def remove_comments(string):
        pattern = r"(\".*?\"|\'.*?\')|(/\*.*?\*/|//[^\r\n]*$)"
        # first group captures quoted strings (double or single)
        # second group captures comments (//single-line or /* multi-line */)
        regex = re.compile(pattern, re.MULTILINE|re.DOTALL)
        def _replacer(match):
            # if the 2nd group (capturing comments) is not None,
            # it means we have captured a non-quoted (real) comment string.
            if match.group(2) is not None:
                return "" # so we will return empty to remove the comment
            else: # otherwise, we will return the 1st group
                return match.group(1) # captured quoted-string
        return regex.sub(_replacer, string)
    
    @staticmethod
    def get_stripped_source_code_hash(source_code) -> str:
        # Remove comments
        stripped_source_code = SmartContract.remove_comments(source_code)
        
        # Remove new lines, tabs, and spaces
        stripped_source_code = re.sub(r"[\n\t\s]*", "", stripped_source_code)

        # Create a SHA-256 hash of the stripped source code
        hash_object = hashlib.sha256(stripped_source_code.encode())
        return hash_object.hexdigest()

    def create_vulnerabilities_from_sb_results(self, tool_name:str, tool_result:dict) -> None:
        tool_vulnerabilities = {}
        tool_vulnerabilities["successfull_analysis"] = False if tool_result["errors"] and not tool_result['findings'] else True
        tool_vulnerabilities["errors"] = tool_result["errors"]

        vulnerability_findings = []
        for finding in tool_result['findings']:
            vulnerability = {}
            vulnerability["name"] = finding["name"]
            vulnerability["line_of_vulnerability"] = finding.get("line", None)
            vulnerability_findings.append(vulnerability)
        
        tool_vulnerabilities["vulnerability_findings"] = vulnerability_findings

        self.vulnerabilities["analyzer_results"][tool_name] = tool_vulnerabilities
    
    def set_vulnerabilities(self):
        smartbugs_results_dir = os.path.join(self.results_dir, "smartbugs_results")
        self.vulnerabilities["analyzer_results"] = {}

        # Loop through all smartbugs_results
        for smartbugs_result_file in [os.path.join(smartbugs_results_dir, f) for f in os.listdir(smartbugs_results_dir) if os.path.isdir(os.path.join(smartbugs_results_dir, f))]:
            sb_result_dir = os.path.join(smartbugs_results_dir, smartbugs_result_file)
            tool_name = os.path.basename(sb_result_dir).split('_', 1)[0]
            tool_result = json.load(open(os.path.join(sb_result_dir, 'result.json'), 'r'))
            self.create_vulnerabilities_from_sb_results(tool_name, tool_result)
            
            

                      

    def get_vulnerabilities(self) -> None:
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
        # Create smsrtbugs results directory
        smartbugs_results_dir = Path(os.path.join(self.results_dir, "smartbugs_results"))
        smartbugs_results_dir.mkdir(parents=True, exist_ok=True)

        #### Create smartbugs config yaml file
        # set the fields that are not editable
        smartbugs_config = {
            'runtime': False,
            'runid': '${YEAR}${MONTH}${DAY}_${HOUR}${MIN}',
            'json': True,
            'tools': self.experiment_settings["smartbugs_tools"],
            'results': os.path.join(smartbugs_results_dir, "${TOOL}_${RUNID}"),
            'log': os.path.join(self.results_dir,'smartbugs_logs', '{RUNID}.log'),
            'processes': self.experiment_settings["smartbugs_processes"],
        }

        # write the data to a YAML file
        smartbugs_config_path = os.path.join(self.results_dir,'smartbugs_config.yml')
        with open(smartbugs_config_path, 'w') as f:
            yaml.dump(smartbugs_config, f)

        # Run smartbugs
        output = subprocess.run([f'./smartbugs/smartbugs -c {smartbugs_config_path} -f {self.path}'], capture_output=True, text=True, shell=True)

        # Save vulnerabilities
        self.set_vulnerabilities()
        self.vulnerabilities["smartbugs_completed"] = True
        with open(os.path.join(self.results_dir, "vulnerabilities.json"), "w") as outfile:
            outfile.write(json.dumps(self.vulnerabilities, indent=2))

    # def get_repaired_vulnerabilities(self, repaired_sc) -> dict:
    #     try:
    #         repaired_vulnerabilities = {}
    #         for tool, vulnerabilities in repaired_sc.vulnerabilities.items():
    #             if('error' in vulnerabilities):
    #                 repaired_vulnerabilities[tool] = vulnerabilities
    #                 continue

    #             repaired_vulnerabilities[tool] = [x for x in self.vulnerabilities[tool] if x not in vulnerabilities]
            
    #         return repaired_vulnerabilities
    #     except Exception as e:
    #         logging.critical("An exception occurred: %s", str(e), exc_info=True)
    #         return {"error": str(e), 'stacktrace': traceback.format_exc()}
        