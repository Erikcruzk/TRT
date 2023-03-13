import json
import os
import random
import networkx as nx
from pyvis.network import Network
from SmartContract import SmartContract
from PromptEngine import PromptEngine
from networkx.readwrite import json_graph
import multiprocessing

class TransformativeRepair:
    
    def show_prompt_types(self, sc_path):
        """
        Displays example prompts generated by the PromptEngine for a given Solidity smart contract.

        This function takes a file path to a Solidity smart contract as a parameter, creates an instance of the SmartContract class with the file path, sets its vulnerabilities attribute to a dictionary of detected vulnerabilities, and then creates a PromptEngine instance with the SmartContract instance as a parameter.

        The function then generates and displays three types of prompts using the PromptEngine's generate_prompt() method, each identified by a string parameter: "A_basic", "B_vulnerability_context", and "C_vulnerability_examples". The generated prompts are printed to the console.

        Note: Vulnerability detection tools are not used in this demo function.

        Args:
        - sc_path (str): a string representing the file path to the Solidity smart contract to be analyzed

        """
        sc = SmartContract(sc_path)
        sc.vulnerabilities = {'oyente': ['reentrancy', 'reentrancy']}

        pe = PromptEngine(sc)
        print(f'A_basic\n\n{pe.generate_prompt("A_basic")}\n\n')
        print(f'B_vulnerability_context\n\n{pe.generate_prompt("B_vulnerability_context")}\n\n')
        print(f'C_vulnerability_examples\n\n{pe.generate_prompt("C_vulnerability_examples")}\n\n')
    
    # Visualize
    def visualize_graph_pyvis(self, G:nx.DiGraph, results_path:str):
        nt = Network('800', '100%', directed=True)
        nt.from_nx(G)
        # nt.show_buttons(filter_=['physics'])
        nt.set_options('''{
        "physics": {
            "forceAtlas2Based": {
            "theta": 0.1,
            "gravitationalConstant": -104,
            "springLength": 0,
            "springConstant": 0.5,
            "damping": 1,
            "avoidOverlap": 1
            },
            "maxVelocity": 85,
            "minVelocity": 10,
            "solver": "forceAtlas2Based",
            "timestep": 0.1
        },
        "layout":{
            "randomSeed":2
            }
        }''')
        
        os.makedirs(os.path.dirname(f'{results_path}.html'), exist_ok=True)
        nt.write_html(f'{results_path}.html')
        
        # Save to Json
        data = json_graph.node_link_data(G)
        with open(f'{results_path}.json', 'w') as outfile:
            json.dump(data, outfile)

    @staticmethod
    def create_repair_results_network(sc_path:str, promt_style:str='C_vulnerability_examples', vulnerability_limitations:list=[], temperature:float=0.8, top_p:str=0.95, n_repairs:int=1) -> nx.DiGraph:
        '''
        Finds vulnerabilities in a smart contract and attempts to repair it using Codex. Then, creates a network of the original smart contract and its repaired versions, showing the repaired vulnerabilities, if any.

        :param sc_path: The file path of the smart contract to repair.
        :type sc_path: str
        :param prompt_style: The prompt style to use for the Codex API, defaults to 'C_vulnerability_examples'.
        :type prompt_style: str
        :param vulnerability_limitations: A list of vulnerability limitations to consider when finding and repairing vulnerabilities, defaults to an empty list.
        :type vulnerability_limitations: list
        :param temperature: A temperature value to use for the Codex API, defaults to 0.8.
        :type temperature: float
        :param top_p: A top-p value to use for the Codex API, defaults to 0.95.
        :type top_p: float
        :param n_repairs: The number of repairs to attempt using the Codex API, defaults to 1.
        :type n_repairs: int
        :return: Graph.
        :rtype: nx.DiGraph
        '''
        G = nx.DiGraph()

        start_sc = SmartContract(sc_path)
        start_sc.find_vulnerabilities(vulnerability_limitations)

        pe = PromptEngine(start_sc)
        repaired_contracts = pe.get_codex_repaired_sc(promt_style, temperature, top_p, n_repairs)

        # Create Network
        # Add START node
        G.add_node(start_sc.filename, group=1, size=30)
        for repaired_sc in repaired_contracts:
            repaired_sc.find_vulnerabilities(vulnerability_limitations)
            repaired_vulnerabilities = start_sc.get_repaired_vulnerabilities(repaired_sc)
            
            G.add_node(repaired_sc.filename, 
                group = random.randint(4, 24))

            color = 'green'
            dashes = False
            for tool in repaired_vulnerabilities:
                if 'error' in tool:
                    color = 'red'
                    dashes = True
                elif not tool:
                    color = 'red'
                    dashes = False
            
            G.add_edge(start_sc.filename, repaired_sc.filename, 
                color = color,
                dashes = dashes,
                weight=0.0,
                title=f'Equal={start_sc.hash == repaired_sc.hash} RV={json.dumps(repaired_vulnerabilities)}',
                equal= f'Equal={start_sc.hash == repaired_sc.hash}',
                capacity=0,
                length=0,
                alpha=0.9)
        return G
            
    def find_vulnerabilities_and_repair_sc_in_directory(self, directory_path:str, prompt_style:str='C_vulnerability_examples', vulnerability_limitations:list=[], temperature:float=0.8, top_p:str=0.95, n_repairs:int=1):
        
        sc_paths = [os.path.join(directory_path, sc_path) for sc_path in os.listdir(directory_path) if os.path.isfile(os.path.join(directory_path, sc_path))]

        
        with multiprocessing.Pool(processes=multiprocessing.cpu_count()) as pool:
            subgraphs = []
            for sc_path in sc_paths:
                subgraphs.append(pool.apply_async(self.create_repair_results_network, args=(sc_path, prompt_style, vulnerability_limitations, temperature, top_p, n_repairs)))
            pool.close()
            pool.join()
        
            results = [subgraph.get() for subgraph in subgraphs]

        # Merge the sub-graphs into a single large graph
        G = nx.compose_all(results)

        return G

        