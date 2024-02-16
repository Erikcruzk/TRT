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
import tiktoken

def exit_handler(process):
    # Try to gracefully terminate the process
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        # If the process does not terminate in 5 seconds, kill it
        process.kill()

class Stack:
    def __init__(self):
        self.items = []

    def is_empty(self):
        return self.items == []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if not self.is_empty():
            return self.items.pop()
        else:
            raise Exception("Stack is empty!")

    def peek(self):
        if not self.is_empty():
            return self.items[-1]
        else:
            return None

    def size(self):
        return len(self.items)



class SmartContract:
    def __init__(self, experiment_settings: dict, sc_path: Path):
        self.experiment_settings: dict = experiment_settings
        self.path: Path = sc_path
        self.results_dir: Path = self.path.parent.absolute().relative_to(Path.cwd())

        self.filename = os.path.basename(self.path)
        self.name, _ = os.path.splitext(self.filename)
        self.language = "Solidity" if self.filename.endswith(".sol") else "Unknown"
        self.source_code = open(self.path, "r").read().strip()

        self.length = 0

        self.source_code = self.reduce_source_code(self.source_code, self.experiment_settings["shave"], self.experiment_settings["threshold"])

        self.hash = SmartContract.get_stripped_source_code_hash(self.source_code)

        self.smartbugs_tools = SmartContract.get_smartbugs_tools(self.experiment_settings["smartbugs_tools"])

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
        regex = re.compile(pattern, re.MULTILINE | re.DOTALL)

        def _replacer(match):
            # if the 2nd group (capturing comments) is not None,
            # it means we have captured a non-quoted (real) comment string.
            if match.group(2) is not None:
                return ""  # so we will return empty to remove the comment
            else:  # otherwise, we will return the 1st group
                return match.group(1)  # captured quoted-string

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
    def get_smartbugs_tools(smartbugs_tools: List[str]):
        tools = set(smartbugs_tools)

        mapping = {
            "access_control_tools": ["maian", "manticore", "mythril", "oyente", "securify", "slither"],
            "arithmetic_tools": ["manticore", "mythril", "osiris", "oyente", "smartcheck"],
            "reentrancy_tools": ["manticore", "mythril", "oyente", "securify", "slither"],
            "unchecked_calls_tools": ["manticore", "mythril", "securify", "smartcheck"],
            "transaction_order_dependence_tools": ["securify"],
            "analysis": ["smartcheck", "slither", "semgrep"]
        }

        for tool, replacements in mapping.items():
            if tool in tools:
                tools.remove(tool)
                tools.update(replacements)

        return list(tools)

    @staticmethod
    def _get_vulnerability_aliases() -> dict:
        vulnerabilities_aliases = {}
        # Mapping of vulnerabilities
        # https://github.com/smartbugs/smartbugs/wiki/Vulnerabilities-mapping

        # Sources
        # SWC https://swcregistry.io/
        # Oyente
        # Maian https://github.com/ivicanikolicsg/MAIAN
        # Manticore https://github.com/trailofbits/manticore/wiki
        # Mythril https://mythril-classic.readthedocs.io/en/master/module-list.html
        # Slither https://github.com/crytic/slither#detectors  

        # Access Control
        access_control_aliases = ["access_control", "access control",
                                  "SWC 105", "SWC 106", "SWC 112", "SWC 115",  # SWC
                                  "No Ether leak (no send)", "Destructible (verified)",  # Maian
                                  "Delegatecall to user controlled address", "Delegatecall to user controlled function",
                                  "Reachable ether leak to sender", "Reachable ether leak to sender via argument",
                                  "Reachable external call to sender", "Reachable external call to sender via argument",
                                  "Reachable SELFDESTRUCT", "Warning ORIGIN instruction used",  # Manticore
                                  "Unprotected Ether Withdrawal (SWC 105)", "Unprotected Selfdestruct (SWC 106)",
                                  "Delegatecall to user-supplied address (SWC 112)",
                                  "Dependence on tx.origin (SWC 115)",  # Mythril
                                  "Parity Multisig Bug 2"  # Oyente
                                  "UnrestrictedEtherFlow",  # Securify
                                  "arbitrary-send", "controlled-delegatecall", "suicidal", "tx-origin", "events-access"
                                  # Slither
                                  ]
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in access_control_aliases], "access_control"))

        # Arithmetic: integer over and underflow
        arithmetic_aliases = ["overflow", "underflow", "integer overflow"
                                                       "SWC 101",  # SWC
                              "Unsigned integer overflow at ADD instruction",
                              "Unsigned integer overflow at MUL instruction",
                              "Unsigned integer overflow at SUB instruction",  # Manticore
                              "Integer Arithmetic Bugs (SWC 101)",  # Mythril
                              "Division bugs", "Overflow bugs", "Signedness bugs", "Truncation bugs", "Underflow bugs",
                              "Modulo bugs",  # Osiris
                              "Integer Overflow", "Integer Underflow",  # Oyente
                              "SOLIDITY_ARRAY_LENGTH_MANIPULATION", "SOLIDITY_DIV_MUL",
                              "SOLIDITY_UINT_CANT_BE_NEGATIVE", "SOLIDITY_VAR", "SOLIDITY_VAR_IN_LOOP_FOR"  # Smartcheck
                              ]
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in arithmetic_aliases], "arithmetic"))

        # Bad randomness
        bad_randomness_aliases = []  # TODO missing
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in bad_randomness_aliases], "bad_randomness"))

        # Denial of service
        denial_of_service_aliases = [
            "SWC 113", "SWC 128"]  # TODO No tools catch
        vulnerabilities_aliases.update(
            dict.fromkeys([x.lower() for x in denial_of_service_aliases], "denial_of_service"))

        # TOD
        transaction_order_dependence_aliases = [
            "transaction order dependence", "tod",
            "SWC 114",
            # Oyente
            "TODAmount", "TODReceiver", "TODTransfer"  # Securify
        ]
        vulnerabilities_aliases.update(
            dict.fromkeys([x.lower() for x in transaction_order_dependence_aliases], "transaction_order_dependence"))

        # Reentrancy
        reentrancy_aliases = ["reentrancy", "reentrance",
                              "SWC 107",
                              "Re-Entrancy Vulnerability",  # Oyente
                              "External Call To User-Supplied Address (SWC 107)",
                              "State access after external call (SWC 107)",  # Mythril
                              "DAO", "ReentrancyNoETH", "ReentrancyBenign",  # Securify
                              "reentrancy-eth", "reentrancy-no-eth", "reentrancy-benign", "reentrancy-events",
                              "reentrancy-unlimited-gas",  # Slither
                              "Unprotected Ether Withdrawal", "reentrance"]
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in reentrancy_aliases], "reentrancy"))

        # Short Address
        short_addresses_aliases = []  # TODO missing add smartcheck?
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in short_addresses_aliases], "short_addresses"))

        # Time Manipulation
        time_manipulation_aliases = []
        vulnerabilities_aliases.update(
            dict.fromkeys([x.lower() for x in time_manipulation_aliases], "time_manipulation"))

        # unchecked low level call
        unchecked_low_level_calls_aliases = [
            "SWC 104",
            "Returned value at CALL instruction is not used",
            "Returned value at CALL instruction is not used"  # Manticore
            "Unchecked return value from external call. (SWC 104)",  # Mythril
            "UnhandledException",  # Securify
            "unchecked-lowlevel", "low-level-calls", "unused-return",  # Slither
            "SOLIDITY_SEND", "SOLIDITY_UNCHECKED_CALL"  # Smartcheck
        ]
        vulnerabilities_aliases.update(
            dict.fromkeys([x.lower() for x in unchecked_low_level_calls_aliases], "unchecked_low_level_calls"))

        # unhandled exception
        unhandled_exception_aliases = ["Unhandled Exception", "unhandled", "UnhandledException", "Exception Disorder"]
        vulnerabilities_aliases.update(
            dict.fromkeys([x.lower() for x in unhandled_exception_aliases], "unhandled_exception"))

        return vulnerabilities_aliases

    @staticmethod
    def get_vulnerability_aliases() -> dict:
        vulnerabilities_aliases = {}
        # Mapping of vulnerabilities
        
        # Reentrancy
        reentrancy_aliases = ["compound-borrowfresh-reentrancy", "erc721-reentrancy", "curve-readonly-reentrancy", "erc777-reentrancy", "erc677-reentrancy" # Semgrep
                              "reentrancy-benign", "Reentrancy-events", "reentrancy-no-eth", "reentrancy-unlimited-gas", "reentrancy-eth"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in reentrancy_aliases], "reentrancy"))

        # Low level calls
        low_level_calls_aliases = ["Arbitrary-low-level-call" # Semgrep
                                   "SOLIDITY_CALL_WITHOUT_DATA"] # Smartcheck
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in low_level_calls_aliases], "unchecked_low_level_calls"))

        # Access control
        access_control_aliases = ["Compound-sweeptoken-not-restricted", "Erc20-public-burn", "Accessible-selfdestruct", "Oracle-price-update-not-restricted", "Uniswap-callback-not-protected", "Delegatecall-to-arbitrary-address", # Semgrep
                                  "arbitrary-send-erc20", "arbitrary-send-eth", "suicidal", "arbitrary-send-erc20-permit", # Slither
                                  "SOLIDITY_TX_ORIGIN"] # Smartcheck
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in access_control_aliases], "access_control"))

        # Delegation 
        delegation_aliases = ["Delegatecall-to-arbitrary-address", # Semgrep
                              "controlled-delegatecall", "delegatecall-loop"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in delegation_aliases], "delegation"))

        # Arithmetic
        arithmetic_aliases = ["Basic-arithmetic-underflow", # Semgrep
                              "SOLIDITY_DIV_MUL", # Smartcheck
                              "divide-before-multiply"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in arithmetic_aliases], "arithmetic"))

        # Oracle manipulation
        oracle_manipulation_aliases = ["Keeper-network-oracle-manipulation"] # Semgrep
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in oracle_manipulation_aliases], "oracle_manipulation"))

        # Input validation
        input_validation_aliases = ["Missing-zero-check"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in input_validation_aliases], "input_validation"))

        # Shadowing
        shadowing_aliases = ["Shadowing-local", "shadowing-state", "shadowing-abstract"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in shadowing_aliases], "shadowing"))

        # Compliance
        compliance_aliases = ["erc20-interface", # Slither
                              "SOLIDITY_ERC20_TRANSFER_SHOULD_THROW"] # Smartcheck
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in compliance_aliases], "compliance"))

        # Timestamp
        timestamp_aliases = ["timestamp", "weak-prng"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in timestamp_aliases], "timestamp"))

        # Initialization
        initialization_aliases = ["uninitialized-local", "uninitialized-state"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in initialization_aliases], "initialization"))

        # Poor logic flaws
        poor_logic_flaw_aliases = ["incorrect-use-of-blockhash", # Slither
                                   "SOLIDITY_EXACT_TIME", "SOLIDITY_BALANCE_EQUALITY", # Smartcheck
                                   "Incorrect-equality", "boolean-cst"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in poor_logic_flaw_aliases], "poor_logic_flaw"))

        # Denial of service
        denial_of_service_aliases = ["SOLIDITY_LOCKED_MONEY", "SOLIDITY_TRANSFER_IN_LOOP", # Smartcheck
                                     "locked-ether", "calls-loop", "msg-value-loop"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in denial_of_service_aliases], "denial_of_service"))

        # State Corruption
        state_corruption_aliases = ["SOLIDITY_ARRAY_LENGTH_MANIPULATION", # Smartcheck
                                    "controlled-array-length"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in state_corruption_aliases], "state_corruption"))

        # Function Behavior
        function_behavior_aliases = ["incorrect-modifier"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in function_behavior_aliases], "function_behavior"))

        # Transaction Validation
        transaction_validation_aliases = ["unchecked-transfer", "unchecked-lowlevel"] # Slither
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in transaction_validation_aliases], "transaction_validation"))

        # Front Running
        front_running_aliases = ["SOLIDITY_ERC20_APPROVE"]
        vulnerabilities_aliases.update(dict.fromkeys([x.lower() for x in front_running_aliases], "front_running"))

        return vulnerabilities_aliases


    @staticmethod
    def rename_findings_with_aliases(findings: List[dict]) -> list:
        vulnerabilities_aliases = SmartContract.get_vulnerability_aliases()

        findings_renamed = copy.deepcopy(findings)
        for finding in findings_renamed:

            vulnerability_name = finding["name"].lower()

            # Check if alias fount
            if vulnerability_name in vulnerabilities_aliases:
                finding["name"] = vulnerabilities_aliases[vulnerability_name]
                continue

            # Check if vulnerability_name contains any alias
            vulnerability_name_contains_alias = vulnerabilities_aliases.get(
                next((key for key in vulnerabilities_aliases if key in vulnerability_name), None));
            if vulnerability_name_contains_alias:
                finding["name"] = vulnerability_name_contains_alias
                continue

        return findings_renamed

    @staticmethod
    def get_analyzer_results_for_summary(vulnerabilities: dict) -> dict:
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
                vulnerability_name_contains_alias = vulnerabilities_aliases.get(
                    next((key for key in vulnerabilities_aliases if key in vulnerability_name), None));
                if vulnerability_name_contains_alias:
                    analyzer_results_for_summary[tool_name].append(vulnerability_name_contains_alias)
                    continue

                # Finally add vulnerability name
                # print(vulnerability_name)
                analyzer_results_for_summary[tool_name].append(vulnerability_name)

            # Delete duplicates
            analyzer_results_for_summary[tool_name] = list(set(analyzer_results_for_summary[tool_name]))

            # Only focus on one vulnerability
            # analyzer_results_with_aliases[tool_name] = [x for x in analyzer_results_with_aliases[tool_name] if x == target_vulnerability] 
        return analyzer_results_for_summary

    @staticmethod
    def check_if_compiles(analyzer_results: dict, compilation_tools: list) -> bool:
        compiles = True

        errorTexts = ["solidity compilation failed", "unsuccessfull_analysis"]

        for tool_vulnerabilities in {k: v for k, v in analyzer_results.items() if k in compilation_tools}.values():
            lower_vulnerabilities = [x.lower() for x in tool_vulnerabilities]

            if (any(elem in lower_vulnerabilities for elem in errorTexts)):
                compiles = False
        return compiles

    def create_vulnerabilities_from_sb_results(self, tool_name: str, tool_result: dict) -> None:
        with open(self.path, "r") as f:
            source_code = f.read()
        lines = source_code.split("\n")
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
                code = "\n".join(lines[from_line - 1: to_line - 1])
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
        smartbugs_results_dirs = Path(os.path.join(self.results_dir, "smartbugs_results"))
        self.vulnerabilities["smartbugs_completed"] = False
        self.vulnerabilities["analyzer_results"] = {}

        # Loop through all smartbugs_results
        for smartbugs_result_dir in [os.path.join(smartbugs_results_dirs, f) for f in os.listdir(smartbugs_results_dirs)
                                     if os.path.isdir(os.path.join(smartbugs_results_dirs, f))]:
            tool_name = os.path.basename(smartbugs_result_dir).split("_", 1)[0]
            tool_result = json.load(open(os.path.join(smartbugs_result_dir, "result.json"), "r"))
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
                "tools": self.smartbugs_tools,
                "results": os.path.join(smartbugs_results_dir, "${TOOL}_${RUNID}"),
                "log": os.path.join(self.results_dir, "smartbugs_logs", "{RUNID}.log"),
                "processes": self.experiment_settings["smartbugs_processes"],
                "timeout": self.experiment_settings["smartbugs_timeout"]
            }

            # write the data to a YAML file
            smartbugs_config_path = os.path.join(self.results_dir, "smartbugs_config.yml")
            with open(smartbugs_config_path, "w") as f:
                yaml.dump(smartbugs_config, f)


            # Check if file at self.path is not empty
            if os.stat(self.path).st_size == 0:
                self.vulnerabilities["smartbugs_completed"] = False
                self.vulnerabilities["analyzer_results"] = {"smartbugs": "File is empty"}
                self.write_vulnerabilities_to_results_dir()
                return

            # Run smartbugs
            # process = subprocess.Popen(f'./smartbugs/smartbugs -c {smartbugs_config_path} -f {self.path}', shell=True, stdout=subprocess.DEVNULL)
            sb_command = f'./smartbugs/smartbugs -c "{smartbugs_config_path}" -f "{self.path}"'
            print(f'\n\n **** SB command is: {sb_command} ****')
            process = subprocess.Popen(sb_command, shell=True)  # DEBUG

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

    def reduce_source_code(self, sc, shave, threshold):
        # Three possible options: remove all docstrings, remove safe libraries, remove file directives

        # Check if tokenized file longeer than threshold

        encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
        if len(encoding.encode(sc)) >= threshold:
            if "NatSpec" in shave:
                sc = self.remove_NatSpec(sc)
            if "comments" in shave:
                sc = self.remove_comments(sc)
            if "definitions" in shave:
                sc = self.remove_definitions(sc)
        self.length = len(encoding.encode(sc))
        return sc
    
    @staticmethod
    def remove_NatSpec(sc):
        # removes all docstrings from the solidity code
        return re.sub(r'\/\*\*.*?\*\/\n|\/\/\/.*?\n', '', sc, flags=re.DOTALL)    
    
    @staticmethod
    def remove_comments(sc):
        # removes all file directives from the solidity code
        return re.sub(r'\/\*[\s\S]*?\*\/\n|\/\/.*\n', '', sc)

    @staticmethod
    def remove_definitions(sc):
        # removes all common libraries from the solidity code using a dictionary of common libraries names

        lines = sc.split('\n')  # Convert self.sc to a list of lines
        modified_lines = []
    
        common = ['Proxy', 'SafeMath', 'SafeERC20', 'Ownable', 'IERC20', 'Address', 'EnumerableSet', 'EnumerableMap', 'Strings', 'Context', 'ReentrancyGuard', 'Pausable', 'ERC20', 'ERC20Detailed', 'ERC20Burnable', 'ERC20Mintable', 'ERC20Pausable', 'ERC20Capped', 'ERC721', 'ERC721Enumerable', 'ERC721Metadata', 'ERC721Pausable', 'ERC721Burnable', 'ERC721Holder', 'ERC721Receiver', 'ERC721MetadataMintable', 'ERC721MetadataMintable', 'ERC721Full']
        
        in_definition = False
        brace_count = 0

        for line in lines:
            line_stripped = line.strip()
            if any(f'library {def_name}' in line_stripped for def_name in common) or any(f'interface {def_name}' in line_stripped for def_name in common):
                in_definition = True
                brace_count = 0
                if '{' in line:
                    brace_count += line.count('{')
                if '}' in line:
                    brace_count -= line.count('}')
            elif in_definition:
                if '{' in line:
                    brace_count += line.count('{')
                if '}' in line:
                    brace_count -= line.count('}')
                if brace_count <= 0:
                    in_definition = False
                    continue
            else:
                modified_lines.append(line)
        
        return '\n'.join(modified_lines)
    
    def reduce_source_code_structure_preserving(self):
        def replace_with_newlines_or_space(match):
            # Check if the match spans more than one line
            num_newlines = match.group().count('\n')
            if num_newlines:
                # For multiline comments, replace with equivalent number of newlines
                return '\n' * num_newlines
            else:
                # For single line (inline) comments, replace with a space to preserve the line
                return ' '

        def remove_NatSpec(sc):
            # replaces docstrings in the solidity code, taking into account inline comments
            pattern = r'\/\*\*.*?\*\/|\/\/\/.*?$'
            sc = re.sub(pattern, replace_with_newlines_or_space, sc, flags=re.DOTALL | re.MULTILINE)    
            return sc

        def remove_comments(sc):
            # replaces file directives and single line comments in the solidity code, considering inline comments
            pattern = r'\/\*[\s\S]*?\*\/|\/\/.*?$'
            sc = re.sub(pattern, replace_with_newlines_or_space, sc, flags=re.MULTILINE)
            return sc
        
        code_without_NatSpec = remove_NatSpec(self.source_code)
        self.source_code = remove_comments(code_without_NatSpec)