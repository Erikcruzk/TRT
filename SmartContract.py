import copy
from datetime import datetime
import hashlib
import logging
from pathlib import Path
import shutil
import subprocess
import json
import os
from typing import List
import yaml
import re
import atexit

def exit_handler(process):
    # Try to gracefully terminate the process
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        # If the process does not terminate in 5 seconds, kill it
        process.kill()

class SmartContract:
    def __init__(self, experiment_settings:dict, sc_path:Path):
        self.experiment_settings:dict = experiment_settings
        self.path:Path = sc_path
        self.results_dir:Path = self.path.parent.absolute()

        self.filename = os.path.basename(self.path)
        self.name, _ = os.path.splitext(self.filename)
        self.language = "Solidity" if self.filename.endswith(".sol") else "Unknown"
        self.source_code = open(self.path, "r").read().strip()
        self.hash = SmartContract.get_stripped_source_code_hash(self.source_code)

        vulnerabilities_file_path = os.path.join(self.results_dir, "vulnerabilities.json")
        try:
            with open(vulnerabilities_file_path, "r") as f:
                self.vulnerabilities = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError):
            self.vulnerabilities = {}

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



    @staticmethod
    def get_vulnerability_aliases() -> dict:
        # Create aliases, fill if necessary
        reentrancy_aliases = ["reentrancy", "reentrance"
                              "Re-Entrancy Vulnerability", # Oyente
                              "External Call To User-Supplied Address (SWC 107)", "State access after external call (SWC 107)", "SWC 107", # Mythril https://mythril-classic.readthedocs.io/en/master/module-list.html#external-calls
                              "DAO", "ReentrancyNoETH", "ReentrancyBenign" # Securify https://github.com/eth-sri/securify2#supported-vulnerabilities
                              "reentrancy-eth", "reentrancy-no-eth", "reentrancy-benign", "reentrancy-events", "reentrancy-unlimited-gas" # Slither https://github.com/crytic/slither#detectors
                              "Unprotected Ether Withdrawal", "reentrance"]
        integer_aliases = ["overflow", "underflow", "integer overflow"]
        unhandled_exception_aliases = ["Unhandled Exception", "unhandled", "UnhandledException", "Exception Disorder"]
        unchecked_call_aliases = ["Unchecked Low Level Call", "Unchecked return value from external call", "unchecked"]
        callstack_aliases = ["callstack", "avoid-low-level-calls", "avoid-call-value"] 

        vulnerabilities_aliases = {}
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in reentrancy_aliases], "reentrancy"))
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in integer_aliases], "integer_over-underflow"))
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in unhandled_exception_aliases], "unhandled_exception"))
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in unchecked_call_aliases], "unchecked_low_level_call"))
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in callstack_aliases], "callstack"))

        return vulnerabilities_aliases
    
    @staticmethod
    def rename_findings_with_aliases(findings:List[dict]) -> list:
        vulnerabilities_aliases = SmartContract.get_vulnerability_aliases()

        findings_renamed = copy.deepcopy(findings)
        for finding in findings_renamed:
            
            vulnerability_name = finding["name"].lower()

            # Check if alias fount
            if vulnerability_name in vulnerabilities_aliases:
                finding["name"] = vulnerabilities_aliases[vulnerability_name]
                continue
            
            # Check if vulnerability_name contains any alias
            vulnerability_name_contains_alias = vulnerabilities_aliases.get(next((key for key in vulnerabilities_aliases if key in vulnerability_name), None));
            if vulnerability_name_contains_alias:
                finding["name"] = vulnerability_name_contains_alias
                continue
        
        return findings_renamed

    @staticmethod
    def get_analyzer_results_for_summary(vulnerabilities:dict) -> dict:
        analyzer_results_for_summary = {}

        vulnerabilities_aliases = SmartContract.get_vulnerability_aliases()

        for tool_name, tool_result in vulnerabilities["analyzer_results"].items():
            analyzer_results_for_summary[tool_name] = []
            findings = tool_result["vulnerability_findings"]
            
            if not tool_result.get("successfull_analysis", False) == True:
                analyzer_results_for_summary[tool_name].append("unsuccessfull_analysis")

            for finding in findings:
                vulnerability_name = finding["name"].lower()

                # Check if alias fount
                if vulnerability_name in vulnerabilities_aliases:
                    analyzer_results_for_summary[tool_name].append(vulnerabilities_aliases[vulnerability_name])
                    continue
                
                # Check if vulnerability_name contains any alias
                vulnerability_name_contains_alias = vulnerabilities_aliases.get(next((key for key in vulnerabilities_aliases if key in vulnerability_name), None));
                if vulnerability_name_contains_alias:
                    analyzer_results_for_summary[tool_name].append(vulnerability_name_contains_alias)
                    continue
                
                # Finally add vulnerability name
                #print(vulnerability_name)
                analyzer_results_for_summary[tool_name].append(vulnerability_name)
            
            # Delete duplicates
            analyzer_results_for_summary[tool_name] = list(set(analyzer_results_for_summary[tool_name]))

            # Only focus on one vulnerability
            # analyzer_results_with_aliases[tool_name] = [x for x in analyzer_results_with_aliases[tool_name] if x == target_vulnerability] 
        return analyzer_results_for_summary

    @staticmethod
    def check_if_compiles(analyzer_results:dict, compilation_tools:list) -> bool:
        compiles = True

        errorTexts = ["solidity compilation failed", "unsuccessfull_analysis"]

        for tool_vulnerabilities  in {k: v for k, v in analyzer_results.items() if k in compilation_tools}.values():
            lower_vulnerabilities =  [x.lower() for x in tool_vulnerabilities]

            if(any(elem in lower_vulnerabilities for elem in errorTexts)):
                compiles = False
        return compiles
    
    def create_vulnerabilities_from_sb_results(self, tool_name:str, tool_result:dict) -> None:
        
        lines = self.source_code.split("\n")
        tool_vulnerabilities = {}
        tool_vulnerabilities["successfull_analysis"] = False if (tool_result["errors"] or tool_result["fails"]) and not tool_result["findings"] else True
        tool_vulnerabilities["errors"] = tool_result["errors"] + tool_result.get("fails", [])

        vulnerability_findings = []
        for finding in tool_result["findings"]:
            vulnerability = {}
            vulnerability["name"] = finding["name"]

            from_line = finding.get("line", None)
            vulnerability["vulnerability_from_line"] = from_line
            to_line = finding.get("line_end", None)
            vulnerability["vulnerability_to_line"] = to_line
    
            if from_line and to_line:
                code = "\n".join(lines[from_line - 1 : to_line - 1])
            elif from_line:
                code = lines[from_line - 1]
            else:
                code = None

            vulnerability["vulnerability_code"] = code        

            vulnerability["message"] = finding.get("message", None)

            vulnerability_findings.append(vulnerability)
        
        tool_vulnerabilities["vulnerability_findings"] = vulnerability_findings
        self.vulnerabilities["analyzer_results"][tool_name] = tool_vulnerabilities
    
    def remove_old_smartbugs_directories(self):
        smartbugs_results_dir = Path(os.path.join(self.results_dir, "smartbugs_results"))
        dirs = os.listdir(smartbugs_results_dir)
        tool_dirs = {}
        for d in dirs:
            if os.path.isdir(os.path.join(smartbugs_results_dir, d)):
                parts = d.split("_")
                tool = parts[0]
                date_str = parts[1]
                time_str = parts[2]
                date_time = datetime.strptime(date_str + " " + time_str, "%Y%m%d %H%M%S")
                
                if tool not in tool_dirs:
                    tool_dirs[tool] = (d, date_time)
                else:
                    newest_dir, newest_date = tool_dirs[tool]
                    if date_time > newest_date:
                        tool_dirs[tool] = (d, date_time)

        for tool, (newest_dir, _) in tool_dirs.items():
            for d in dirs:
                if tool in d and d != newest_dir:
                    shutil.rmtree(os.path.join(smartbugs_results_dir, d))

    def set_vulnerabilities(self):
        smartbugs_results_dir = Path(os.path.join(self.results_dir, "smartbugs_results"))
        self.vulnerabilities["smartbugs_completed"] = False
        self.vulnerabilities["analyzer_results"] = {}        

        # Loop through all smartbugs_results
        for smartbugs_result_file in [os.path.join(smartbugs_results_dir, f) for f in os.listdir(smartbugs_results_dir) if os.path.isdir(os.path.join(smartbugs_results_dir, f))]:
            sb_result_dir = os.path.join(smartbugs_results_dir, smartbugs_result_file)
            tool_name = os.path.basename(sb_result_dir).split("_", 1)[0]
            tool_result = json.load(open(os.path.join(sb_result_dir, "result.json"), "r"))
            self.create_vulnerabilities_from_sb_results(tool_name, tool_result)
        
        if not self.vulnerabilities["analyzer_results"] == {}:
            self.vulnerabilities["smartbugs_completed"] = True

    def write_vulnerabilities_to_results_dir(self):
        with open(os.path.join(self.results_dir, "vulnerabilities.json"), "w") as outfile:
            outfile.write(json.dumps(self.vulnerabilities, indent=2))

    def run_smartbugs(self) -> None:    
        try:
            # Create smsrtbugs results directory
            smartbugs_results_dir = Path(os.path.join(self.results_dir, "smartbugs_results"))
            smartbugs_results_dir.mkdir(parents=True, exist_ok=True)            

            #### Create smartbugs config yaml file
            # set the fields that are not editable
            smartbugs_config = {
                "runtime": False,
                "runid": "${YEAR}${MONTH}${DAY}_${HOUR}${MIN}",
                "json": True,
                "tools": self.experiment_settings["smartbugs_tools"],
                "results": os.path.join(smartbugs_results_dir, "${TOOL}_${RUNID}"),
                "log": os.path.join(self.results_dir,"smartbugs_logs", "{RUNID}.log"),
                "processes": self.experiment_settings["smartbugs_processes"],
                "timeout": 60*7
            }

            # write the data to a YAML file
            smartbugs_config_path = os.path.join(self.results_dir,"smartbugs_config.yml")
            with open(smartbugs_config_path, "w") as f:
                yaml.dump(smartbugs_config, f)

            # Run smartbugs
            process = subprocess.Popen(f'./smartbugs/smartbugs -c {smartbugs_config_path} -f {self.path}', shell=True, stdout=subprocess.DEVNULL)
            #process = subprocess.Popen(f'./smartbugs/smartbugs -c {smartbugs_config_path} -f {self.path}', shell=True) # DEBUG

            atexit.register(exit_handler, process)

            # Wait for the process to complete and get the exit code
            exit_code = process.wait()

            # clean all old runs:
            self.remove_old_smartbugs_directories()
            # Save vulnerabilities
            self.set_vulnerabilities()

        except Exception as e:
            self.vulnerabilities["smartbugs_completed"] = str(e)
            logging.critical(f"Smartbugs failure {self.results_dir} {str(e)}", exc_info=True)
        
        self.write_vulnerabilities_to_results_dir()