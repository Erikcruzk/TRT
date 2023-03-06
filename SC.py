import subprocess
import json
import os
import openai
import decouple

'''Smart Contract'''
class SC:

    config = decouple.AutoConfig(' ')
    openai.api_key = config("OPENAI_API_KEY")   

    def __init__(self, sc_path):
        self.sc_path = sc_path
        self.sc_filename = os.path.basename(self.sc_path)
        self.sc_source_code = open(self.sc_path, "r").read()
        self.vulnerabilities = {}
        self.candidate_patches = []

    def load_vulnerabilities(self):
        # Get vulnerabilities
        results_directory = f'sb_results/{self.sc_filename}'
        for filename in os.listdir(results_directory):
            full_path = os.path.join(results_directory, filename)
            if os.path.isdir(full_path):
                tool_name = os.path.basename(full_path).split('_', 1)[0]
                with open(os.path.join(full_path, 'result.json'), 'r') as f:
                    tool_result = json.load(f)
                
                if(tool_result['errors'] != []):
                    self.vulnerabilities[tool_name] = ['Error'] + tool_result['errors']                
                else:
                    self.vulnerabilities[tool_name] = [finding['name'] for finding in tool_result['findings']]

    def find_vulnerabilities(self):
        output = subprocess.run([f'./smartbugs/smartbugs -c smart_bugs_settings.yaml -f {self.sc_path}'], capture_output=True, text=True, shell=True)
        self.load_vulnerabilities()

    def get_vulnerabilities_difference(self, other_sc):
        vulnerability_differences = {}
        for tool, vulnerabilities in other_sc.vulnerabilities.items():
            if('Error' in vulnerabilities):
                vulnerability_differences[tool] = vulnerabilities

            vulnerability_differences[tool] = [x for x in self.vulnerabilities[tool] if x not in vulnerabilities]
        
        return vulnerability_differences

    def generate_prompt(self) -> str:
        prompt = f'//// Fix the vulnerable below Smart Contract that is vulnerable to reentrancy attack\n/// Vulnerable Smart Contract\n{self.sc_source_code}\n/// Fixed Smart Contract'
        return prompt
    
    def get_codex_repaired_sc(self, temperature:float = 0.8, top_p:float = 0.95, n:int=1):
        # Generate Repair
        response = openai.Completion.create(
            model="code-davinci-002",
            prompt=self.generate_prompt(),
            temperature=temperature,
            max_tokens=3000,
            top_p=top_p,
            frequency_penalty=0,
            presence_penalty=0,
            stop=["///"],
            n=n,
            )

        # Save repair
        repaired_sc_path = f'experiments/sc_repaired/repaired_{self.sc_filename}'

        repaired_contracts = []
        for i, choice in enumerate(response.choices):
            repaired_sc_path = f'experiments/sc_repaired/{i}_repaired_{self.sc_filename}'
            with open(repaired_sc_path, 'w') as the_file:
                the_file.write(choice.text.lstrip())
            repaired_sc = SC(repaired_sc_path)
            repaired_contracts.append(repaired_sc)

        return repaired_contracts