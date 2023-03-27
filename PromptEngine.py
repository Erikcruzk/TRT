from pathlib import Path
import subprocess
import json
import os
import traceback
from typing import List
import openai
from SmartContract import SmartContract;
import logging

def concatenate_with_and(vulnerabilities:dict) -> str:
    '''
    Concatenates the values of a dictionary into a comma-separated string with "and" before the last element if there are more than one.

    Args:
    - vulnerabilities (dict): A dictionary with string keys and iterable values.

    Returns:
    - str: A string with the concatenated values from the dictionary.
    '''
    try:
        vulnerabilities = list(set(element for value in vulnerabilities.values() for element in value))
        if len(vulnerabilities) == 0:
            return "unknown"
        return vulnerabilities[0] if len(vulnerabilities) == 1 else f"{', '.join(vulnerabilities[:-1])} and {vulnerabilities[-1]}"
    except Exception as e:
        logging.critical("An exception occurred: %s", str(e), exc_info=True)
        return "unknown"

class PromptEngine:    

    def __init__(self, sc: SmartContract):
        """
        Initializes the PromptEngine with a given Solidity smart contract.
        
        Args:
        - sc: A SmartContract object representing the Solidity smart contract to be repaired.
        """
        self.sc = sc
        self.prompt = None
        
    def generate_prompt(self, experiment_settings:dict) -> str:
        """
        Generates a prompt for the OpenAI Codex API based on the given prompt type.

        Args:
        - prompt_style: A string indicating the type of prompt to generate. Default is 'C_vulnerability_examples'.
        
        Returns:
        - A string representing the generated prompt.
        
        Raises:
        - KeyError: if an invalid prompt type is given.
        - FileExistsError: if no repair examples
        """
        try:
            basic = f'/// The task is to repair the vulnerable below {self.sc.language} Smart Contract\n\n/// Vulnerable {self.sc.language} Smart Contract\n{self.sc.source_code}\n\n/// Fixed {self.sc.language} Smart Contract'
            vulnerability_context = f'/// The task is to repair the below {self.sc.language} Smart Contract that is, according to smart contract analyzers, vulnerable to {concatenate_with_and(self.sc.vulnerabilities)} attacks\n\n/// Vulnerable {self.sc.language} Smart Contract\n{self.sc.source_code}\n\n/// Fixed {self.sc.language} Smart Contract'

            if experiment_settings["prompt_style"] == 'A_basic':
                return basic
            elif experiment_settings["prompt_style"] == 'B_vulnerability_context':
                return vulnerability_context
            elif experiment_settings["prompt_style"] == 'C_vulnerability_examples':
                directories = [f'{experiment_settings["patch_examples_directory"]}/{x}' for x in list(set(element for value in self.sc.vulnerabilities.values() for element in value))]
                directories = [x for x in directories if os.path.exists(x)]

                if not directories:
                    raise FileExistsError
                repair_examples = "\n".join([f"\n/// Repair Example {i+1} of {os.path.basename(directory)} attack\n{open(os.path.join(directory, file)).read()}" for directory in directories for i, file in enumerate(os.listdir(directory))])
                return f'/// Here are some examples of vulnerable {self.sc.language} Smart Contracts and how to repair them\n{repair_examples}\n\n{vulnerability_context}'
            else:
                raise KeyError()
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)
            return vulnerability_context

    def get_codex_repaired_sc(self, experiment_settings:dict, llm_settings:dict, sc:SmartContract, prompt:str) -> List[str]:
        """
        Generates a repaired version of the Solidity smart contract using the OpenAI Codex API.

        Args:
        - prompt_style: A string indicating the prompt style to use. Default is 'C_vulnerability_examples'.
        - temperature: A float value indicating the creativity of the generated code. Default is 0.8.
        - top_p: A float value indicating the diversity of the generated code. Default is 0.95.
        - n: An integer indicating the number of alternative repaired contracts to generate. Default is 1.
        
        Returns:
        - A list of SmartContract objects representing the alternative repaired versions of the Solidity smart contract.
        """
        try:
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

                    patch_path = os.path.join(repaired_sc_dir, f'patch_{i}.sol')
                    
                    with open(patch_path, 'w') as repaired_sc:
                        repaired_sc.write(choice["message"]["content"].strip())
                    
                    candidate_patches_paths.append(patch_path)
                except Exception as e:
                    raise IOError(f"Fail on '{patch_path}': {str(e)}")         

            return candidate_patches_paths
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)
            return []