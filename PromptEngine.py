import copy
from pathlib import Path
import subprocess
import json
import os
import traceback
from typing import Dict, List
import openai
from SmartContract import SmartContract;
import logging
from langchain.prompts import PromptTemplate

def concatenate_with_and(vulnerabilities:dict) -> str:
    try:
        vulnerabilities = list(set(element for value in vulnerabilities.values() for element in value))
        if len(vulnerabilities) == 0:
            return "unknown"
        return vulnerabilities[0] if len(vulnerabilities) == 1 else f"{', '.join(vulnerabilities[:-1])} and {vulnerabilities[-1]}"
    except Exception as e:
        logging.critical("An exception occurred: %s", str(e), exc_info=True)
        return "unknown"

class PromptEngine:    

    def __init__(self, sc: SmartContract, experiment_settings:dict):
        self.sc = sc
        self.templates:Dict[str, PromptTemplate] = PromptEngine.get_templates()
        self.experiment_settings:dict = experiment_settings
        
    def generate_prompt(self, prompt_style:str) -> str:
        try:            
            match prompt_style:
                case "basic":
                    return self.templates["basic"].format(
                        sc_language=self.sc.language, 
                        sc_source_code=self.sc.source_code)
                case "analyzers_json_results":
                    return self.templates["analyzers_json_results"].format(
                        sc_language=self.sc.language, 
                        sc_source_code=self.sc.source_code,
                        analyzer_results=json.dumps(
                        PromptEngine.delete_empty_analyzers_and_rename_findings_to_alias(self.sc.vulnerabilities["analyzer_results"], self.experiment_settings["target_vulnerabilities"])
                        , indent=2))
                # case "analyzers_json_results_slim":
                #     return self.templates["analyzers_json_results"].format(
                #         sc_language=self.sc.language, 
                #         sc_source_code=self.sc.source_code,
                #         analyzer_results=json.dumps(SmartContract.get_vulnerability_aliases(self.sc.vulnerabilities)["analyzer_results"], indent=2))
                case "analyzers_natural_language_results":
                    return self.templates["analyzers_natural_language_results"].format(
                        sc_language=self.sc.language, 
                        sc_source_code=self.sc.source_code,
                        analyzer_results=PromptEngine.format_analyzer_results(
                            PromptEngine.delete_empty_analyzers_and_rename_findings_to_alias(self.sc.vulnerabilities["analyzer_results"], self.experiment_settings["target_vulnerabilities"])
                        ))
                case _:
                    raise KeyError()                
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)
            return ""

    def get_codex_repaired_sc(self, experiment_settings:dict, llm_settings:dict, sc:SmartContract, prompt:str) -> List[str]:
        # Generate Repair
        openai.api_key = os.environ.get(llm_settings["secret_api_key"]) 
        response = openai.ChatCompletion.create(
            model=llm_settings["model_name"],
            messages=[
                {"role": "user", "content": prompt}
            ],
            temperature=llm_settings["temperature"],
            max_tokens=1182, # TODO: calculate tokens
            top_p=llm_settings["top_p"],
            frequency_penalty=0,
            presence_penalty=0,
            stop=llm_settings["stop"],
            n=llm_settings["num_candidate_patches"],
            )

        # Save repair            
        candidate_patches_paths = []
        for i, choice in enumerate(response.choices):
            try:
                repaired_sc_dir = os.path.join(sc.results_dir,
                    "candidate_patches",
                    f'patch_{i}')
                
                Path(repaired_sc_dir).mkdir(parents=True, exist_ok=True) # TODO: minimize mkdir

                patch_path = Path(os.path.join(repaired_sc_dir, f'patch_{i}.sol'))
                
                with open(patch_path, 'w') as repaired_sc:
                    repaired_sc.write(choice["message"]["content"].strip())
                
                candidate_patches_paths.append(patch_path)
            except Exception as e:
                raise IOError(f"Fail on '{patch_path}': {str(e)}")         

        return candidate_patches_paths

    @staticmethod
    def delete_empty_analyzers_and_rename_findings_to_alias(analyzer_results:dict, target_vulnerabilities:list) -> dict:        
        analyzer_results_filtered = {}
        for tool_name, tool_results_dict in analyzer_results.items():
            # Remove analyzers with empty reults
            if tool_results_dict["successfull_analysis"] == False or not tool_results_dict["vulnerability_findings"]:
                continue

            # Rename findings
            renamed_findings = SmartContract.rename_findings_with_aliases(tool_results_dict["vulnerability_findings"])

            # Remove all findings that are not known
            if target_vulnerabilities:
                renamed_findings = [vf for vf in renamed_findings if vf["name"] in target_vulnerabilities]

            # Do not add empty analyzer results              
            if not renamed_findings:
                continue
            
            analyzer_results_filtered[tool_name] = copy.deepcopy(tool_results_dict)
            analyzer_results_filtered[tool_name]["vulnerability_findings"] = renamed_findings
            
        return analyzer_results_filtered
        


        return non_empty_analyzers
    @staticmethod
    def format_analyzer_results(analyzer_results:dict, comment_symbol="/// ", comment_out_code=False):
        context = ""
        tool_counter = 0
        for tool_name, tool_results_dict in analyzer_results.items():
            tool_counter += 1
            context += f"\n{comment_symbol}{tool_counter}. {tool_name.capitalize()} Analysis Results\n"
            
            for i, vulnerability in enumerate(tool_results_dict["vulnerability_findings"]):
                context += f"{comment_symbol}{tool_counter}.{i+1}. Vulnerability: {vulnerability['name']}"
                if vulnerability.get('vulnerability_from_line', None) is not None:
                    context += f" at Line {vulnerability['vulnerability_from_line']}"
                    if vulnerability['vulnerability_to_line'] is not None:
                        context += f"-{vulnerability['vulnerability_to_line']}"
                    context += f":"
                if vulnerability.get('vulnerability_code', None) is not None:
                    if comment_out_code:
                        context += f"{chr(10)}{comment_symbol}  {f'{chr(10)}{comment_symbol}  '.join(vulnerability['vulnerability_code'].splitlines())}"
                    else:
                        context += f"{chr(10)}{f'{chr(10)}'.join(vulnerability['vulnerability_code'].splitlines())}"                  
                if vulnerability.get('message', None) is not None:
                    context += f"\n{comment_symbol} Message:"
                    context += f"\n{comment_symbol}  ".join(vulnerability['message'].strip().split("\n"))                    
                context += f"\n"
            context += f"\n"
        
        return context   

    @staticmethod
    def get_templates() -> dict:
        templates = {}

        # 1. basic Template
        templates["basic"] = PromptTemplate(
                input_variables=["sc_language", "sc_source_code"],
                template="""/// Your task is to repair the following {sc_language} Smart Contract
{sc_source_code}

/// Repaired {sc_language} Smart Contract""")

        # 2. analyzers_json_results Template
        templates["analyzers_json_results"] = PromptTemplate(
                input_variables=["sc_language", "sc_source_code", "analyzer_results"],
                template="""/// Your task is to repair the following {sc_language} Smart Contract
{sc_source_code}

/// This {sc_language} Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{analyzer_results}

/// Repaired {sc_language} Smart Contract""")


        templates["analyzers_natural_language_results"] = PromptTemplate(
                input_variables=["sc_language", "sc_source_code", "analyzer_results"],
                template="""/// Your task is to repair the following {sc_language} Smart Contract
{sc_source_code}

/// This {sc_language} Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.
{analyzer_results}

/// Repaired {sc_language} Smart Contract""")


        return templates
