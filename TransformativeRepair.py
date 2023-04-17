import atexit
import datetime
import json
import logging
import os
import re
import threading
import time
import networkx as nx
from pyvis.network import Network
from SmartContract import SmartContract
from PromptEngine import PromptEngine
from networkx.readwrite import json_graph
from typing import List
from pathlib import Path
import queue
import shutil
from tqdm import tqdm

def clear_queue(queue:queue.Queue):
    while not queue.empty():
        queue.get(timeout=1)

def close_all_threads(stop_event:threading.Event, sleep=0):
    time.sleep(sleep)
    for thread in threading.enumerate():
        if thread != threading.main_thread():
            stop_event.set()
class TransformativeRepair:
    
    def __init__(self, experiment_settings:dict, llm_settings:dict) -> None:
        
        self.experiment_settings = experiment_settings
        self.llm_settings = llm_settings
        self.llm_model_name:str = experiment_settings["llm_model_name"]

        # Add more info to dir
        extended_experiment_name = os.path.join(f'{Path(experiment_settings["experiment_name"]).parts[0]}_tools{len(self.experiment_settings["smartbugs_tools"])}_patches{self.llm_settings[self.llm_model_name]["num_candidate_patches"]}_tmp{self.llm_settings[self.llm_model_name]["temperature"]}_topp{self.llm_settings[self.llm_model_name]["top_p"]}_{self.llm_model_name}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        self.experiment_results_dir:Path = Path(os.path.join("experiment_results", 
            extended_experiment_name, 
            child_dirs))
        
        # Delete experiment resuts if requested
        if self.experiment_settings["delete_old_experiment_name"] and os.path.exists(self.experiment_results_dir):
            shutil.rmtree(self.experiment_results_dir)

        self.vulnerable_contracts_dir:str = experiment_settings["vulnerable_contracts_directory"]
        self.target_vulnerabilities:List[str] = experiment_settings["target_vulnerabilities"]
        self.patch_examples_dir:str = experiment_settings["patch_examples_directory"]
        self.smartbugs_tools:List[str] = experiment_settings["smartbugs_tools"]
        
        self.prompt_style:str = experiment_settings["prompt_style"]

        self.smartbugs_sc_queue = queue.Queue()
        self.repair_sc_queue = queue.Queue()
        atexit.register(clear_queue, self.smartbugs_sc_queue)
        atexit.register(clear_queue, self.repair_sc_queue)
    
    # Visualize
    @staticmethod
    def save_graph(G:nx.DiGraph, results_dir:Path, name:str):
        
        heading_name = f'{name.capitalize()}';
        nt = Network(heading=heading_name, height='1200px', directed=True) # TODO: unify networks with filter_menu=True
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
        
        file_name = f'{os.path.basename(results_dir)}_{name}'
        nt.write_html(os.path.join(results_dir, f'pyvis_{file_name}.html'))

        # Fix for Pyvis open issue where double titles appear
        pyvis_path = os.path.join(results_dir, f'pyvis_{file_name}.html')
        with open(pyvis_path, "r") as f:
            html = f.read()
        with open(pyvis_path, "w") as f:
            f.write(re.sub(r'<center>.+?<\/h1>\s+<\/center>', '', html, 1, re.DOTALL))

        # Save to Json
        data = json_graph.node_link_data(G)
        with open(os.path.join(results_dir, f'pyvis_{file_name}.json'), 'w') as outfile:
            json.dump(data, outfile)    
    
    @staticmethod
    def generate_summary_markdown(summary:dict, results_dir:Path) -> None:
        # Generate settings of experiment
        markdown = f"# Settings of experiment\n\n| Setting | Value |\n| --- | --- |\n"
        for key, value in summary.items():
            if key != "target_vulnerabilities":
                markdown += f"| {key} | {value} |\n"
        
        # Generate Results of Experiments
        markdown += "\n## Target Vulnerabilities\n\n"
        for vulnerability, vulnerability_data in summary["target_vulnerabilities"].items():
            contracts = vulnerability_data["contracts"]
            
            markdown += f"\n### {vulnerability}\n"
            
            #### Summary
            target_summary = vulnerability_data["summary"]
            summary_headers = ["n_plausible_patches/n_contracts", "n_unique patches/n_patches", "n_patches_compiles/n_unique_patches"]
            summary_results = [f'{target_summary["n_plausible_patches"]}/{target_summary["n_contracts"]}', f'{target_summary["unique_patches"]}/{target_summary["n_patches"]}', f'{target_summary["n_unique_paches_that_compile"]}/{target_summary["unique_patches"]}']
            # Add Title
            markdown += f"\n#### Summary\n"
            # Add table headers
            markdown += f'| {" | ".join(summary_headers)} |\n'
            # Add table format
            markdown += f'| {" | ".join("---" for k in summary_headers)} |\n'
            # Add table content
            markdown += f'| {" | ".join(summary_results)} |\n' 
            
            #### Results
            # Add title
            markdown += f"\n#### Results\n"
            # Add table headers
            markdown += f'| {" | ".join(str(k) for k in contracts[next(iter(contracts.keys()))].keys())} |\n' 
            # Add table format
            markdown += f'| {" | ".join("---" for k in contracts[next(iter(contracts.keys()))].keys())} |\n'
            # Add table content
            for contract, info in contracts.items():
                markdown += f'| {" | ".join([str(info[k]) for k in info])}|\n'

        # Save markdown to file
        experiment_name = summary["experiment_name"]
        with open(os.path.join(results_dir, f'{summary["experiment_name"]}_summary.md'), 'w') as f:
            f.write(markdown)


    @staticmethod
    def create_targets_summary_and_graphs(experiment_settings:dict, llm_settings:dict) -> dict:
        # Add more info to dir
        extended_experiment_name = os.path.join(f'{Path(experiment_settings["experiment_name"]).parts[0]}_tools{len(experiment_settings["smartbugs_tools"])}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir:Path = Path(os.path.join("experiment_results", 
            extended_experiment_name, 
            child_dirs))
        
        
        target_summaries = {}
        repair_target_graphs = {}
        compile_graph = nx.DiGraph()

        for sc_dir in [os.path.join(results_dir, item) for item in os.listdir(results_dir) if os.path.isdir(os.path.join(results_dir, item))]:
            sc_name = os.path.basename(sc_dir)

            # Add to compile graph
            compile_graph.add_node(sc_name, 
                # sc_data=start_sc, 
                group=1, 
                size=30)

            # Get original sc
            original_vulnerabilities = json.load(open(os.path.join(sc_dir, "vulnerabilities.json"), 'r'))
            original_analyzer_results_with_aliases = SmartContract.get_analyzer_results_for_summary(original_vulnerabilities)
            candidate_patches_dir = os.path.join(sc_dir, "candidate_patches")
            patch_results = json.load(open(os.path.join(candidate_patches_dir,  "patch_results.json"), 'r'))
            
            n_patches = len([name for name in os.listdir(candidate_patches_dir) if os.path.isdir(os.path.join(candidate_patches_dir, name))])
            n_unique_paches = len(patch_results["unique_patches"])
            n_unique_patches_that_compile = 0

            target_max_repair = {}
            
            for patch_file_name in patch_results["unique_patches"].keys():
                patch_name, _ = os.path.splitext(patch_file_name)
                patch_node_name = f'{sc_name}_{patch_name}'
                
                patch_vulnerabilities = json.load(open(os.path.join(candidate_patches_dir, patch_name, "vulnerabilities.json"), 'r'))
                patch_analyzer_results_with_aliases = SmartContract.get_analyzer_results_for_summary(patch_vulnerabilities)

                compiles = SmartContract.check_if_compiles(patch_analyzer_results_with_aliases, ["oyente", "slither"])
                if compiles:
                    n_unique_patches_that_compile += 1
                    compile_graph.add_node(patch_node_name,
                        color="green")
                else:
                    compile_graph.add_node(patch_node_name, 
                        color="red")
                
                compile_graph.add_edge(sc_name, patch_node_name)

                for target_vulnerability in experiment_settings["target_vulnerabilities"]:  
                    if target_vulnerability not in target_summaries:
                        target_summaries[target_vulnerability] = {}
                        
                        target_summaries[target_vulnerability]["summary"] = {}
                        target_summaries[target_vulnerability]["summary"]["n_contracts"] = 0
                        target_summaries[target_vulnerability]["summary"]["n_patches"] = 0
                        target_summaries[target_vulnerability]["summary"]["n_plausible_patches"] = 0
                        target_summaries[target_vulnerability]["summary"]["unique_patches"] = 0
                        target_summaries[target_vulnerability]["summary"]["n_unique_paches_that_compile"] = 0
                        
                        target_summaries[target_vulnerability]["contracts"] = {}
                        repair_target_graphs[target_vulnerability] = nx.DiGraph()

                    if sc_name not in target_summaries[target_vulnerability]["contracts"]:
                        target_summaries[target_vulnerability]["contracts"][sc_name] = {}
                        G = repair_target_graphs[target_vulnerability]
                        G.add_node(sc_name, 
                            # sc_data=start_sc, 
                            group=1, 
                            size=30)
                    
                    patch_data = {}                               

                    current_max = target_max_repair.get(target_vulnerability, -1)
                    n_smatbug_tools = len(patch_analyzer_results_with_aliases.keys())

                    if compiles:
                        repairs_of_target = sum(target_vulnerability not in my_list for my_list in patch_analyzer_results_with_aliases.values())
                        is_plausible_patch = repairs_of_target == n_smatbug_tools
                    else:
                        repairs_of_target = 0
                        is_plausible_patch = False
                        
                    # Add patch to graph
                    G = repair_target_graphs[target_vulnerability]
                    if is_plausible_patch:
                                 
                        G.add_node(patch_node_name,
                            color="green")
                    else:
                        target_summaries[target_vulnerability]["plausible_patches"] = target_summaries[target_vulnerability].get("plausible_patches",0)
                        G.add_node(patch_node_name, 
                            color="red")
                    
                    G.add_edge(sc_name, patch_node_name)

                    # New best patch
                    if repairs_of_target > current_max:
                        target_max_repair[target_vulnerability] = repairs_of_target   
                        patch_data["sc_name"] = sc_name                    
                        patch_data["n_patches"] = n_patches
                        patch_data["unique_paches_that_compile"] =  None
                        patch_data["best_patch"] =  patch_name
                        patch_data["compiles"] = compiles
                        patch_data["plausible_patch"] = is_plausible_patch


                        for tool_name, tool_vulnerabilities in patch_analyzer_results_with_aliases.items():
                            original_status = 'Fix'
                            if target_vulnerability in original_analyzer_results_with_aliases[tool_name]:
                                original_status = 'Bug'
                            
                            repaired_status = "Fix"
                            if target_vulnerability in tool_vulnerabilities or not compiles:
                                repaired_status = "Bug"

                            patch_data[tool_name] =  f'{original_status}/{repaired_status}'
                        
                        target_summaries[target_vulnerability]["contracts"][sc_name] = patch_data
            
            for target_vulnerability in target_summaries.keys():
                target_summaries[target_vulnerability]["contracts"][sc_name]["unique_paches_that_compile"] =  f'{n_unique_patches_that_compile}/{n_unique_paches}'       

                target_summaries[target_vulnerability]["summary"]["n_contracts"] += 1
                target_summaries[target_vulnerability]["summary"]["n_patches"] += n_patches
                target_summaries[target_vulnerability]["summary"]["n_plausible_patches"] = sum(1 for contract in target_summaries[target_vulnerability]["contracts"].values() if contract.get("plausible_patch"))
                target_summaries[target_vulnerability]["summary"]["unique_patches"] += n_unique_paches
                target_summaries[target_vulnerability]["summary"]["n_unique_paches_that_compile"] += n_unique_patches_that_compile


        
        # Create pyvis graphs for results
        base_graph_name = os.path.join(extended_experiment_name, child_dirs).replace("/", "_")
        for target_vulnerability in experiment_settings["target_vulnerabilities"]:
            TransformativeRepair.save_graph(repair_target_graphs[target_vulnerability], results_dir, f'{base_graph_name}_{target_vulnerability}')   

        # Create pyvis graphs for compilation
        TransformativeRepair.save_graph(compile_graph, results_dir, f'{base_graph_name}_compilation') 

        return target_summaries

    @staticmethod
    def create_summary(experiment_settings:dict, llm_settings:dict, start_time:datetime) -> None:        
        # Add more info to dir
        extended_experiment_name = os.path.join(f'{Path(experiment_settings["experiment_name"]).parts[0]}_tools{len(experiment_settings["smartbugs_tools"])}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir:Path = Path(os.path.join("experiment_results", 
            extended_experiment_name, 
            child_dirs))
        
        # Create summary
        summary = {}
        summary["experiment_name"] = os.path.join(extended_experiment_name, child_dirs).replace("/", "_")
        summary["dataset"] = experiment_settings["vulnerable_contracts_directory"]
        summary["smartbugs_tools"] = experiment_settings["smartbugs_tools"]
        summary["prompt_style"] = experiment_settings["prompt_style"]
        summary["n_threads"] = f'sb_threads={experiment_settings["n_smartbugs_threads"]} llm_rapair_threads={experiment_settings["n_repair_threads"]}'
        summary["llm_settings"] = llm_settings[experiment_settings["llm_model_name"]]
        summary["target_vulnerabilities"] = TransformativeRepair.create_targets_summary_and_graphs(experiment_settings, llm_settings)
        summary["run_time"] = str(datetime.datetime.utcnow() - start_time).split('.')[0]

        # Save JSON summary
        with open(os.path.join(results_dir, f'{summary["experiment_name"]}_summary.json'), "w") as outfile:
            outfile.write(json.dumps(summary, indent=2))
        
        # Save Markdown summary
        TransformativeRepair.generate_summary_markdown(summary, results_dir)

    @staticmethod
    def shutdown_thread(experiment_settings:dict, llm_settings:dict, stop_event:threading.Event=None, finished=False):

        atexit.register(close_all_threads, stop_event)
        start_time = datetime.datetime.utcnow()

        # Add more info to dir
        extended_experiment_name = os.path.join(f'{Path(experiment_settings["experiment_name"]).parts[0]}_tools{len(experiment_settings["smartbugs_tools"])}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir:Path = Path(os.path.join("experiment_results", 
            extended_experiment_name, 
            child_dirs))
        
        # Loop that checks that all patches have got their vulnerablities.json => they are done
        sleep = 0
        while not finished:
            time.sleep(sleep)
            try:
                finished = True
                for sc_dir in [os.path.join(results_dir, item) for item in os.listdir(results_dir) if os.path.isdir(os.path.join(results_dir, item))]:
                    candidate_patches_dir = os.path.join(sc_dir, "candidate_patches")
                    patch_results_path = os.path.join(candidate_patches_dir, "patch_results.json")
                    patch_results = json.load(open(patch_results_path, 'r')) if os.path.isfile(patch_results_path) else {}

                    # Check that all patch generations have completed
                    if not patch_results.get("patch_generation_completed", False) == True:
                        finished = False
                        break
                    
                    # Check that all unique contracts have run smartbugs
                    for patch_vulnerability_path in [os.path.join(candidate_patches_dir, key.replace('.sol', ''), "vulnerabilities.json") for key in patch_results["unique_patches"].keys()]:
                        patch_vulnerability = json.load(open(patch_vulnerability_path, 'r')) if os.path.isfile(patch_vulnerability_path) else {}
                        if not patch_vulnerability.get("smartbugs_completed", False) == True:
                            finished = False
                            break
            except Exception as e:
                finished = False  
            sleep = 5

        # Create summary
        TransformativeRepair.create_summary(experiment_settings, llm_settings, start_time)        

        # Stop all threads and finish program
        close_all_threads(stop_event, 5)


    
    @staticmethod
    def find_vulnerabilities(experiment_settings:dict, sc_path:Path, do_repair_sc:bool, repair_sc_queue:queue.Queue) -> None:

        try:
            #### Step 1: Initialize SC
            sc = SmartContract(experiment_settings, sc_path)
            
            if not sc.vulnerabilities.get("smartbugs_completed", False) == True:
                #### Step 2: Find Vulnerabilities
                sc.run_smartbugs()
            else:
                sc.remove_old_smartbugs_directories()

            #### Step 3: Enqueue to repair queue
            if do_repair_sc:
                repair_sc_queue.put(sc.path)
        except Exception as e:
            logging.critical(f'An exception occurred when finding vulnerabilities for contract={sc_path}: {str(e)}', exc_info=True)            


    @staticmethod
    def consumer_of_vulnerabilities_queue(experiment_setting:dict, smartbugs_sc_queue:queue.Queue, repair_sc_queue:queue.Queue, stop_event:threading.Event, progressbar:tqdm) -> None:
        atexit.register(clear_queue, smartbugs_sc_queue)
        atexit.register(clear_queue, repair_sc_queue)
        while not stop_event.is_set():
            try:
                sc_path, do_repair_sc = smartbugs_sc_queue.get(block=False)
                TransformativeRepair.find_vulnerabilities(experiment_setting, sc_path, do_repair_sc, repair_sc_queue)
                progressbar.update(1)
                # print(progressbar.n) 
            except queue.Empty:
                time.sleep(1)


    @staticmethod
    def repair_sc(experiment_settings:dict, llm_settings:dict, sc_path:Path, smartbugs_sc_queue:queue.Queue, progressbar:tqdm):
        
        candidate_patches_dir = Path(os.path.join(sc_path.parent.absolute(), "candidate_patches"))
        candidate_patches_dir.mkdir(parents=True, exist_ok=True)

        # Load patch results if exists
        patches_results_path = os.path.join(candidate_patches_dir, "patch_results.json")
        patches_results = json.load(open(patches_results_path, 'r')) if os.path.isfile(patches_results_path) else {}
        patches_results["patch_generation_completed"] = patches_results.get("patch_generation_completed", False) == True

        # Return if patches already generated and successfull
        if patches_results["patch_generation_completed"]:
            for patch_name in patches_results["unique_patches"].keys():
                patch_dir, _ = os.path.splitext(patch_name)
                patch_path = Path(os.path.join(candidate_patches_dir, patch_dir, patch_name))

                sc = SmartContract(experiment_settings, patch_path)
                if not sc.vulnerabilities.get("smartbugs_completed", False) == True:
                    smartbugs_sc_queue.put((patch_path, False))
                else:
                    sc.remove_old_smartbugs_directories()
                    progressbar.update(1) 
                    # print(progressbar.n)           
            return

        try:
            #### Step 1: Initialize SC
            sc = SmartContract(experiment_settings, sc_path)
            
            #### Step 2: Create Prompt Engine and generate prompt
            pe = PromptEngine(sc, experiment_settings)
            prompt = pe.generate_prompt(experiment_settings["prompt_style"])

            #### Step 3: Save prompt
            with open(os.path.join(sc.results_dir, "prompt.txt"), 'w') as file:
                file.write(prompt)
            
            #### Step 4: Repair smart contract
            model_name = experiment_settings["llm_model_name"]
            candidate_patches_paths = []
            if model_name == "gpt-3.5-turbo":
                candidate_patches_paths = pe.get_codex_repaired_sc(experiment_settings, llm_settings[model_name], sc, prompt)
            else:
                raise KeyError(f'model_name={model_name} not found!')
            
            #### Step 5: Find all unique patches and add them to the repair queue
            patches_results = {}
            unique_patches = {}
            hash_to_first_patch = {}
            for candidate_patch_path in candidate_patches_paths:
                patch_name = os.path.basename(candidate_patch_path)
                hash = SmartContract.get_stripped_source_code_hash(open(candidate_patch_path, 'r').read())
                
                # Unique patch
                if hash not in hash_to_first_patch:
                    hash_to_first_patch[hash] = patch_name
                    unique_patches[patch_name] = []
                    smartbugs_sc_queue.put((candidate_patch_path, False))
                    continue
                
                # Dubplicate patch
                unique_contract = hash_to_first_patch[hash]
                unique_patches[unique_contract].append(patch_name)
                progressbar.update(1)
                #print(progressbar.n) 
                
            patches_results["unique_patches"] = unique_patches
            patches_results["patch_generation_completed"] = True

        except Exception as e:
            patches_results["patch_generation_error"] = str(e)
            logging.critical("An exception occurred: %s", str(e), exc_info=True)

        with open(patches_results_path, "w") as outfile:
            outfile.write(json.dumps(patches_results, indent=2))

    @staticmethod
    def consumer_of_repair_queue(experiment_setting:dict, llm_settings:dict, smartbugs_sc_queue:queue.Queue, repair_sc_queue:queue.Queue, stop_event:threading.Event, progressbar:tqdm, ):
        atexit.register(clear_queue, smartbugs_sc_queue)
        atexit.register(clear_queue, repair_sc_queue)
        while not stop_event.is_set():
            try:
                sc_path = repair_sc_queue.get(block=False)
                TransformativeRepair.repair_sc(experiment_setting, llm_settings, sc_path, smartbugs_sc_queue, progressbar)
            except queue.Empty:
                time.sleep(1)
    
    def start(self):
        #### Start!
        print(f'Starting experiment: {self.experiment_results_dir}')

        #### Step 1: Add all vulnerable sc to smartbugs_sc_queue
        self.experiment_results_dir.mkdir(parents=True, exist_ok=True)

        shutil.copyfile('config.yml', os.path.join(self.experiment_results_dir, "config.yml"))

        sc_vulnerable_count = 0

        # Create sc_dirs
        for sc_filename in os.listdir(self.vulnerable_contracts_dir):
            sc_name, file_extension = os.path.splitext(os.path.basename(sc_filename))
            sc_path = os.path.join(self.vulnerable_contracts_dir, sc_filename)
            if os.path.isfile(sc_path) and file_extension == ".sol":
                # Create dir for contract
                results_dir =  Path(os.path.join(self.experiment_results_dir, sc_name))
                results_dir.mkdir(parents=True, exist_ok=True)

                # Copy vulnerable sc to results
                sc_results_path = Path(os.path.join(results_dir, sc_filename))
                shutil.copyfile(sc_path, sc_results_path)
                
                # Add to results
                sc_vulnerable_count += 1
                self.smartbugs_sc_queue.put((sc_results_path, True))

        # Initialize progress bar
        n_candidate_patches = self.llm_settings[self.experiment_settings["llm_model_name"]]["num_candidate_patches"]
        progressbar = tqdm(total=sc_vulnerable_count + sc_vulnerable_count * n_candidate_patches, desc="Smartbugs processes", colour='#ff5a5f')

        stop_event = threading.Event()
        atexit.register(close_all_threads, stop_event)

        #### Step 2: Consume smartbugs_queue
        for i in range(self.experiment_settings["n_smartbugs_threads"]):
            smartbugs_thread = threading.Thread(target=TransformativeRepair.consumer_of_vulnerabilities_queue, args=(self.experiment_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event, progressbar))
            smartbugs_thread.start()

        #### Step 2: Consume smart repair_sc_queue
        for i in range(self.experiment_settings["n_repair_threads"]):
            repair_thread = threading.Thread(target=TransformativeRepair.consumer_of_repair_queue, args=(self.experiment_settings, self.llm_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event, progressbar))
            repair_thread.start()

        #### Start Summary Thread
        shutdown_thread = threading.Thread(target=TransformativeRepair.shutdown_thread, args=(self.experiment_settings, self.llm_settings, stop_event))
        shutdown_thread.start()


        