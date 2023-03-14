import subprocess
import json
import os
import traceback
import openai
import decouple
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
    config = decouple.AutoConfig(' ')
    openai.api_key = config('OPENAI_API_KEY')   

    def __init__(self, sc: SmartContract):
        """
        Initializes the PromptEngine with a given Solidity smart contract.
        
        Args:
        - sc: A SmartContract object representing the Solidity smart contract to be repaired.
        """
        self.sc = sc
        
    def generate_prompt(self, prompt_style = 'C_vulnerability_examples') -> str:
        """
        Generates a prompt for the OpenAI Codex API based on the given prompt type.

        Args:
        - prompt_type: A string indicating the type of prompt to generate. Default is 'C_vulnerability_examples'.
        
        Returns:
        - A string representing the generated prompt.
        
        Raises:
        - KeyError: if an invalid prompt type is given.
        - FileExistsError: if no repair examples
        """
        try:
            basic = f'/// The task is to repair the vulnerable below {self.sc.language} Smart Contract\n\n/// Vulnerable {self.sc.language} Smart Contract\n{self.sc.source_code}\n\n/// Fixed {self.sc.language} Smart Contract'
            vulnerability_context = f'/// The task is to repair the below {self.sc.language} Smart Contract that is, according to smart contract analyzers, vulnerable to {concatenate_with_and(self.sc.vulnerabilities)} attacks\n\n/// Vulnerable {self.sc.language} Smart Contract\n{self.sc.source_code}\n\n/// Fixed {self.sc.language} Smart Contract'

            if prompt_style == 'A_basic':
                return basic
            elif prompt_style == 'B_vulnerability_context':
                return vulnerability_context
            elif prompt_style == 'C_vulnerability_examples':
                directories = [ f'sc_repair_examples/{x}' for x in list(set(element for value in self.sc.vulnerabilities.values() for element in value))]
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

    def get_codex_repaired_sc(self, prompt_style = 'C_vulnerability_examples', temperature:float = 0.8, top_p:float = 0.95, n:int=1): # TODO: add type of out
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
            response = openai.Completion.create(
                model='code-davinci-002',
                prompt=self.generate_prompt(prompt_style),
                temperature=temperature,
                max_tokens=1182,
                top_p=top_p,
                frequency_penalty=0,
                presence_penalty=0,
                stop=['///'],
                n=n,
                )

            # Save repair
            repaired_sc_path_template = f'experiments/sc_repaired/{{i}}_repaired_{self.sc.filename}'
            repaired_contracts = []
            for i, choice in enumerate(response.choices):
                repaired_sc_path = repaired_sc_path_template.format(i=i)
                try:
                    os.makedirs(os.path.dirname(repaired_sc_path), exist_ok=True)
                    with open(repaired_sc_path, 'w') as the_file:
                        the_file.write(choice.text.strip())
                except Exception as e:
                    raise IOError(f"Failed to write to file '{repaired_sc_path}': {str(e)}")
                finally:
                    the_file.close()
                try:
                    repaired_sc = SmartContract(repaired_sc_path)
                    repaired_contracts.append(repaired_sc)
                except Exception as e:
                    raise ValueError(f"Failed to parse repaired contract from file '{repaired_sc_path}': {str(e)}")

            return repaired_contracts
        except Exception as e:
            logging.critical("An exception occurred: %s", str(e), exc_info=True)
            return []