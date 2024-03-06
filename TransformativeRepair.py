import atexit
import datetime
import json
import logging
import os
import random
import re
import threading
import time
import networkx as nx
import openai
import tiktoken

from pyvis.network import Network
from SmartContract import SmartContract
from PromptEngine import PromptEngine
from networkx.readwrite import json_graph
from typing import List
from pathlib import Path
import queue
import shutil
from tqdm import tqdm
import difflib
from lib.py_sol_analyzer import explorer, reducer, stack


def clear_queue(queue: queue.Queue):
    while not queue.empty():
        queue.get(timeout=1)


def close_all_threads(stop_event: threading.Event, sleep=0):
    time.sleep(sleep)
    for thread in threading.enumerate():
        if thread != threading.main_thread():
            stop_event.set()


class TransformativeRepair:

    failed_llm_repair_list = []
    successful_repair_list = []
    failed_enclosing_nodes_list = []

    def __init__(self, experiment_settings: dict, llm_settings: dict) -> None:
        """
        Initialize an Experiment object with experiment settings and LLM (Language Model) settings.

        Args:
            experiment_settings (dict): Experiment settings.
            llm_settings (dict): LLM settings.
        """
        # Store experiment settings and LLM settings
        self.experiment_settings = experiment_settings
        self.llm_settings = llm_settings
        self.llm_model_name = experiment_settings["llm_model_name"]



        # Get the list of smartbugs tools
        self.smartbugs_tools = SmartContract.get_smartbugs_tools(experiment_settings["smartbugs_tools"])

        # Generate the extended experiment name for result directory
        self.smartbugs_tools:List[str] = SmartContract.get_smartbugs_tools(self.experiment_settings["smartbugs_tools"])
        extended_experiment_name = os.path.join(f'{Path(experiment_settings["experiment_name"]).parts[0]}_patches{self.llm_settings[self.llm_model_name]["num_candidate_patches"]}_tmp{self.llm_settings[self.llm_model_name]["temperature"]}_topp{self.llm_settings[self.llm_model_name]["top_p"]}_{self.llm_model_name}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        self.experiment_results_dir:Path = Path(os.path.join("experiment_results", 
            extended_experiment_name, 
            child_dirs))

        # Delete previous experiment results if requested
        self._delete_old_experiment_results()

        # Set other experiment-related directories and settings
        self.vulnerable_contracts_dir = experiment_settings["vulnerable_contracts_directory"]
        self.target_vulnerabilities = experiment_settings["target_vulnerabilities"]
        self.patch_examples_dir = experiment_settings["patch_examples_directory"]

        self.prompt_style = experiment_settings["prompt_style"]

        # Set setting to shave long contracts
        self.shave = experiment_settings["shave"]
        self.threshold = experiment_settings["threshold"]

        self.preanalized = experiment_settings["preanalized"]
        self.analysis_results_directory = experiment_settings["analysis_results_directory"]

        # Create queues for smartbugs and repair smart contracts
        self.smartbugs_sc_queue = queue.Queue()
        self.repair_sc_queue = queue.Queue()

        # Register cleanup functions for the queues
        atexit.register(clear_queue, self.smartbugs_sc_queue)
        atexit.register(clear_queue, self.repair_sc_queue)


    def _get_llm_setting(self, setting_name: str) -> str:
        """
        Get the specified LLM setting for the current LLM model.

        Args:
            setting_name (str): Name of the LLM setting.

        Returns:
            str: Value of the specified LLM setting.
        """
        return self.llm_settings[self.llm_model_name][setting_name]


    def _delete_old_experiment_results(self) -> None:
        """
        Delete the previous experiment results directory if requested.
        """
        if self.experiment_settings["delete_old_experiment_name"] and os.path.exists(self.experiment_results_dir):
            shutil.rmtree(self.experiment_results_dir)

    # Visualize
    @staticmethod
    def save_graph(G: nx.DiGraph, results_dir: Path, name: str):

        heading_name = f'{name.capitalize()}'
        nt = Network(heading=heading_name, height='1200px', directed=True)  # TODO: unify networks with filter_menu=True
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
    def generate_summary_markdown(summary: dict, results_dir: Path) -> None:
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
            summary_headers = ["n_plausible_patches/n_contracts", "n_unique patches/n_patches",
                               "n_patches_compiles/n_unique_patches"]
            summary_results = [f'{target_summary["n_plausible_patches"]}/{target_summary["n_contracts"]}',
                               f'{target_summary["unique_patches"]}/{target_summary["n_patches"]}',
                               f'{target_summary["n_unique_paches_that_compile"]}/{target_summary["unique_patches"]}']
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
            markdown += f'| n | {" | ".join(str(k) for k in contracts[next(iter(contracts.keys()))].keys())} |\n'
            # Add table format
            markdown += f'| --- | {" | ".join("---" for k in contracts[next(iter(contracts.keys()))].keys())} |\n'
            # Add table content
            for i, (contract, info) in enumerate(sorted(contracts.items())):
                n = i + 1
                markdown += f'| {n} | {" | ".join([str(info[k]) for k in info])}|\n'

        # Save markdown to file
        experiment_name = summary["experiment_name"]
        with open(os.path.join(results_dir, f'{summary["experiment_name"]}_summary.md'), 'w') as f:
            f.write(markdown)

    @staticmethod
    def save_best_patch_and_diff(target_vulnerability, original_sc_path: Path, best_patch_path: Path):
        original_sc_dir = os.path.dirname(original_sc_path)
        original_sc_name, _ = os.path.splitext(os.path.basename(original_sc_path))
        bect_patch_name, _ = os.path.splitext(os.path.basename(best_patch_path))

        # Copy over best patch
        best_patch_copy_location = Path(os.path.join(original_sc_dir,
                                                     f'{original_sc_name}_best_patch_{target_vulnerability}_{bect_patch_name}.sol'))
        shutil.copy2(best_patch_path, best_patch_copy_location)

        # Save diff of original path and best patch   
        with open(original_sc_path, 'r') as file1, open(best_patch_path, 'r') as file2:
            file1_lines = file1.readlines()
            file2_lines = file2.readlines()

        # diff = difflib.unified_diff(file1_lines, file2_lines, fromfile=f'{original_sc_path}', tofile=f'{best_patch_path}')
        diff = difflib.ndiff(file1_lines, file2_lines)
        # diff = difflib.context_diff(file1_lines, file2_lines, fromfile=f'{original_sc_path}', tofile=f'{best_patch_path}')

        with open(os.path.join(original_sc_dir,
                               f'{original_sc_name}_best_patch_{target_vulnerability}_{bect_patch_name}_diff.diff'),
                  'w') as output_file:
            for line in diff:
                output_file.write(line)

    @staticmethod
    def create_targets_summary_and_graphs(experiment_settings: dict, llm_settings: dict) -> dict:
        # Add more info to dir
        extended_experiment_name = os.path.join(
            f'{Path(experiment_settings["experiment_name"]).parts[0]}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(
            Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir: Path = Path(os.path.join("experiment_results",
                                              extended_experiment_name,
                                              child_dirs))

        target_summaries = {}
        repair_target_graphs = {}
        compile_graph = nx.DiGraph()

        if experiment_settings['preanalized']:
            sc_result_dirs = []
            print(results_dir)
            for root, dirs, files in os.walk(results_dir):
                for item in dirs:
                    if item.endswith(".sol"):
                        sc_result_dirs.append(os.path.join(root, item))
        else:
            sc_result_dirs = [os.path.join(results_dir, item) for item in os.listdir(results_dir) if
                              os.path.isdir(os.path.join(results_dir, item))]

        for sc_dir in sc_result_dirs:
            sc_name = os.path.basename(sc_dir).replace(".sol", "")

            # Add to compile graph
            compile_graph.add_node(sc_name,
                                   # sc_data=start_sc,
                                   group=1,
                                   size=30)

            # Get original sc
            original_vulnerabilities = json.load(open(os.path.join(sc_dir, "vulnerabilities.json"), 'r'))
            original_analyzer_results_with_aliases = SmartContract.get_analyzer_results_for_summary(
                original_vulnerabilities)
            candidate_patches_dir = os.path.join(sc_dir, "candidate_patches")
            patch_results = json.load(open(os.path.join(candidate_patches_dir, "patch_results.json"), 'r'))

            n_patches = len([name for name in os.listdir(candidate_patches_dir) if
                             os.path.isdir(os.path.join(candidate_patches_dir, name))])
            n_unique_paches = len(patch_results["unique_patches"])
            n_unique_patches_that_compile = 0

            target_max_repair = {}

            if n_patches == 0:
                print(sc_dir, " has no patches")
                continue

            for patch_file_name in patch_results["unique_patches"].keys():
                patch_name, _ = os.path.splitext(patch_file_name)
                patch_node_name = f'{sc_name}_{patch_name}'

                patch_vulnerabilities = json.load(
                    open(os.path.join(candidate_patches_dir, patch_name, "vulnerabilities.json"), 'r'))
                patch_analyzer_results_with_aliases = SmartContract.get_analyzer_results_for_summary(
                    patch_vulnerabilities)

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
                        repairs_of_target = sum(target_vulnerability not in my_list for my_list in
                                                patch_analyzer_results_with_aliases.values())
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
                        target_summaries[target_vulnerability]["plausible_patches"] = target_summaries[
                            target_vulnerability].get("plausible_patches", 0)
                        G.add_node(patch_node_name,
                                   color="red")

                    G.add_edge(sc_name, patch_node_name)

                    # New best patch
                    if repairs_of_target > current_max:
                        target_max_repair[target_vulnerability] = repairs_of_target
                        patch_data["sc_name"] = sc_name
                        patch_data["vuln_detected"] = False
                        patch_data["n_patches"] = n_patches
                        patch_data["unique_paches_that_compile"] = None
                        patch_data["best_patch"] = patch_name
                        patch_data["compiles"] = compiles
                        patch_data["plausible_patch"] = is_plausible_patch

                        for tool_name, tool_vulnerabilities in sorted(patch_analyzer_results_with_aliases.items()):
                            original_status = 'Fix'
                            if target_vulnerability in original_analyzer_results_with_aliases[tool_name]:
                                original_status = 'Bug'
                                patch_data["vuln_detected"] = True

                            repaired_status = "Fix"
                            if target_vulnerability in tool_vulnerabilities or not compiles:
                                repaired_status = "Bug"

                            patch_data[tool_name] = f'{original_status}/{repaired_status}'

                        target_summaries[target_vulnerability]["contracts"][sc_name] = patch_data

            for target_vulnerability in target_summaries.keys():
                target_summaries[target_vulnerability]["contracts"][sc_name][
                    "unique_paches_that_compile"] = f'{n_unique_patches_that_compile}/{n_unique_paches}'

                target_summaries[target_vulnerability]["summary"]["n_contracts"] += 1
                target_summaries[target_vulnerability]["summary"]["n_patches"] += n_patches
                target_summaries[target_vulnerability]["summary"]["n_plausible_patches"] = sum(
                    1 for contract in target_summaries[target_vulnerability]["contracts"].values() if
                    contract.get("plausible_patch"))
                target_summaries[target_vulnerability]["summary"]["unique_patches"] += n_unique_paches
                target_summaries[target_vulnerability]["summary"][
                    "n_unique_paches_that_compile"] += n_unique_patches_that_compile

                original_sc_path = Path(os.path.join(sc_dir, f'{sc_name}.sol'))
                best_patch_name = target_summaries[target_vulnerability]["contracts"][sc_name]["best_patch"]
                best_patch_path = Path(os.path.join(candidate_patches_dir, best_patch_name, f'{best_patch_name}.sol'))
                TransformativeRepair.save_best_patch_and_diff(target_vulnerability, original_sc_path, best_patch_path)

        # Create pyvis graphs for results
        base_graph_name = os.path.join(extended_experiment_name, child_dirs).replace("/", "_")
        if repair_target_graphs:
            for target_vulnerability in experiment_settings["target_vulnerabilities"]:
                TransformativeRepair.save_graph(repair_target_graphs[target_vulnerability], results_dir,
                                                f'{base_graph_name}_{target_vulnerability}')

                # Create pyvis graphs for compilation
            TransformativeRepair.save_graph(compile_graph, results_dir, f'{base_graph_name}_compilation')

        return target_summaries

    @staticmethod
    def create_summary(experiment_settings: dict, llm_settings: dict, start_time: datetime) -> None:
        # Add more info to dir
        extended_experiment_name = os.path.join(
            f'{Path(experiment_settings["experiment_name"]).parts[0]}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(
            Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir: Path = Path(os.path.join("experiment_results",
                                              extended_experiment_name,
                                              child_dirs))

        # Create summary
        summary = {}
        summary["experiment_name"] = os.path.join(extended_experiment_name, child_dirs).replace("/", "_")
        summary["dataset"] = experiment_settings["vulnerable_contracts_directory"]
        summary["smartbugs_tools"] = SmartContract.get_smartbugs_tools(experiment_settings["smartbugs_tools"])
        summary["prompt_style"] = experiment_settings["prompt_style"]
        summary[
            "n_threads"] = f'sb_threads={experiment_settings["n_smartbugs_threads"]} llm_rapair_threads={experiment_settings["n_repair_threads"]}'
        summary["llm_settings"] = llm_settings[experiment_settings["llm_model_name"]]
        summary["target_vulnerabilities"] = TransformativeRepair.create_targets_summary_and_graphs(experiment_settings,
                                                                                                   llm_settings)
        summary["run_time"] = str(datetime.datetime.utcnow() - start_time).split('.')[0]

        # Save JSON summary
        with open(os.path.join(results_dir, f'{summary["experiment_name"]}_summary.json'), "w") as outfile:
            outfile.write(json.dumps(summary, indent=2))

        # Save Markdown summary
        TransformativeRepair.generate_summary_markdown(summary, results_dir)

    @staticmethod
    def shutdown_thread(experiment_settings: dict, llm_settings: dict, stop_event: threading.Event = None,
                        finished=False):
        atexit.register(close_all_threads, stop_event)
        start_time = datetime.datetime.utcnow()

        # Add more info to dir
        extended_experiment_name = os.path.join(
            f'{Path(experiment_settings["experiment_name"]).parts[0]}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(
            Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir: Path = Path(os.path.join("experiment_results",
                                              extended_experiment_name,
                                              child_dirs))
                                              
        # Loop that checks that all patches have got their vulnerablities.json => they are done
        sleep = 0
        while not finished:
            time.sleep(sleep)
            try:
                finished = True
                
                
                if experiment_settings['preanalized']:
                    sc_result_dirs = []
                    for root, dirs, files in os.walk(results_dir):
                        for item in dirs:
                            if item.endswith(".sol"):
                                sc_result_dirs.append(os.path.join(root, item))
                else:
                    sc_result_dirs = [os.path.join(results_dir, item) for item in os.listdir(results_dir) if
                                    os.path.isdir(os.path.join(results_dir, item))]
                    
                for sc_dir in sc_result_dirs:
                    candidate_patches_dir = os.path.join(sc_dir, "candidate_patches")
                    patch_results_path = os.path.join(candidate_patches_dir, "patch_results.json")
                    patch_results = json.load(open(patch_results_path, 'r')) if os.path.isfile(
                        patch_results_path) else {}
                    # Check that all patch generations have completed
                    if patch_results.get("patch_generation_completed", False) == "Contract too long. Reparing skipped" or \
                            patch_results.get("patch_generation_completed", False) == "No vulnerabilities found":
                        # skip this contract
                        # print("Skipping contract: ", sc_dir)
                        continue
                    elif not patch_results.get("patch_generation_completed", False) == True:
                        # print("Detected unfinished patch generation: ", sc_dir)   
                        finished = False
                        break

                    # Check that all unique contracts have run smartbugs
                    for patch_vulnerability_path in [
                        os.path.join(candidate_patches_dir, key.replace('.sol', ''), "vulnerabilities.json") for key in
                        patch_results["unique_patches"].keys()]:
                        patch_vulnerability = json.load(open(patch_vulnerability_path, 'r')) if os.path.isfile(
                            patch_vulnerability_path) else {}
                        if not patch_vulnerability.get("smartbugs_completed", False) == True:
                            finished = False
                            break
                        elif patch_vulnerability.get("smartbugs_completed", False) == "Contract too long. Reparing skipped":
                            # Move directory to unfinished
                            print("Moving contract to unfinished: ", sc_dir)
                            unfinished_dir = os.path.join(results_dir, "unfinished")
                            print("Moving to: ", unfinished_dir)
                            Path(unfinished_dir).mkdir(parents=True, exist_ok=True)
                            shutil.move(sc_dir, unfinished_dir)
                            finished = False
                            break
                            
            except Exception as e:
                print(f'An exception occurred when checking if all patches have finished: {str(e)}')
                finished = False
            sleep = 5

        # Create summary
        TransformativeRepair.create_summary(experiment_settings, llm_settings, start_time)

        # Stop all threads and finish program
        close_all_threads(stop_event, 5)


    @staticmethod
    def shutdown_thread_v2(experiment_settings: dict, llm_settings: dict, stop_event: threading.Event = None,
                        finished=False):
        
        atexit.register(close_all_threads, stop_event)
        start_time = datetime.datetime.utcnow()

        # Add more info to dir
        extended_experiment_name = os.path.join(
            f'{Path(experiment_settings["experiment_name"]).parts[0]}_patches{llm_settings[experiment_settings["llm_model_name"]]["num_candidate_patches"]}_tmp{llm_settings[experiment_settings["llm_model_name"]]["temperature"]}_topp{llm_settings[experiment_settings["llm_model_name"]]["top_p"]}_{experiment_settings["llm_model_name"]}')
        child_dirs = os.path.join(*(Path(experiment_settings.get("experiment_name", "")).parts[1:])) if len(
            Path(experiment_settings.get("experiment_name", "")).parts) > 1 else ""
        results_dir: Path = Path(os.path.join("experiment_results",
                                              extended_experiment_name,
                                              child_dirs))
                                              
        # Loop that checks that all patches have got their vulnerablities.json => they are done
        sleep = 0
        while not finished:
            time.sleep(sleep)
            try:
                finished = True
                
                print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 456` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')

                if experiment_settings['preanalized']:
                    print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 459` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                    sc_result_dirs = []
                    for root, dirs, files in os.walk(results_dir):
                        for item in dirs:
                            if item.endswith(".sol"):
                                print(f'$ $ $ $ $\n$ $ $ $ $  item: {item}')
                                print(f"smartbugs_tools: {experiment_settings['smartbugs_tools']}")
                                for analyzer in experiment_settings['smartbugs_tools']:
                                    print(f'$ $ $ $ $\n$ $ $ $ $  analyzer: {analyzer}')
                                    for analyzer_root, vulnerability_dirs, _ in os.walk(os.path.join(root, item, analyzer)):
                                        print(f'$ $ $ $ $\n$ $ $ $ $  vulnerability_dirs: {vulnerability_dirs}')
                                        for vulnerability_dir in vulnerability_dirs:
                                            vulnerability_dir_path =  os.path.join(root, item, analyzer, vulnerability_dir)
                                            sc_result_dirs.append(vulnerability_dir_path)
                                            print(f'$ $ $ $ $\n$ $ $ $ $  discovered: {vulnerability_dir_path}\n')
                                
                else:
                    print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 466` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                    sc_result_dirs = [os.path.join(results_dir, item) for item in os.listdir(results_dir) if
                                    os.path.isdir(os.path.join(results_dir, item))]
                    
                print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 469` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                for sc_dir in sc_result_dirs:
                    print(f'::::::::>>>> sc_dir is: {sc_dir}')
                    candidate_patches_dir = os.path.join(sc_dir, "candidate_patches")
                    patch_results_path = os.path.join(candidate_patches_dir, "patch_results.json")
                    patch_results = json.load(open(patch_results_path, 'r')) if os.path.isfile(
                        patch_results_path) else {}
                    # Check that all patch generations have completed
                    if patch_results.get("patch_generation_completed", False) == "Contract too long. Reparing skipped" or \
                            patch_results.get("patch_generation_completed", False) == "No vulnerabilities found":
                        # skip this contract
                        # print("Skipping contract: ", sc_dir)
                        print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 481` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                        continue
                    elif not patch_results.get("patch_generation_completed", False) == True:
                        # print("Detected unfinished patch generation: ", sc_dir)   
                        print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 485` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                        finished = False
                        break

                    # Check that all unique contracts have run smartbugs
                    for patch_vulnerability_path in [
                        os.path.join(candidate_patches_dir, key.replace('.sol', ''), "vulnerabilities.json") for key in
                        patch_results["unique_patches"].keys()]:
                        patch_vulnerability = json.load(open(patch_vulnerability_path, 'r')) if os.path.isfile(
                            patch_vulnerability_path) else {}
                        if not patch_vulnerability.get("smartbugs_completed", False) == True:
                            finished = False
                            break
                        elif patch_vulnerability.get("smartbugs_completed", False) == "Contract too long. Reparing skipped":
                            # Move directory to unfinished
                            print("Moving contract to unfinished: ", sc_dir)
                            unfinished_dir = os.path.join(results_dir, "unfinished")
                            print("Moving to: ", unfinished_dir)
                            Path(unfinished_dir).mkdir(parents=True, exist_ok=True)
                            shutil.move(sc_dir, unfinished_dir)
                            print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 505` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                            finished = False
                            break
                            
            except Exception as e:
                print(f'An exception occurred when checking if all patches have finished: {str(e)}')
                print('` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` line 511` ` ` ` ` `  ` ` ` ` ` ` ` ` ` ` ` ` `  ` ` ` ` ` ` ')
                print(e)
                finished = False
            sleep = 5

        # Create summary
        TransformativeRepair.create_summary(experiment_settings, llm_settings, start_time)

        # Stop all threads and finish program
        close_all_threads(stop_event, 5)




    @staticmethod
    def find_vulnerabilities(experiment_settings: dict, sc_path: Path, do_repair_sc: bool, repair_sc_queue: queue.Queue,
                             progressbar: tqdm) -> None:
        print(f'Finding vulnerabilities for contract={sc_path}')
        try:
            #### Step 1: Initialize SC
            sc = SmartContract(experiment_settings, sc_path)
            
            if not sc.vulnerabilities.get("smartbugs_completed", False):
                #### Step 2: Find Vulnerabilities
                sc.run_smartbugs()
            else:
                sc.remove_old_smartbugs_directories()

            #### Step 3: Enqueue to repair queue
            if do_repair_sc:
                repair_sc_queue.put(sc.path)

            if sc.vulnerabilities.get("smartbugs_completed", False):
                progressbar.update(1)
        except Exception as e:
            logging.critical(f'An exception occurred when finding vulnerabilities for contract={sc_path}: {str(e)}',
                             exc_info=True)

    @staticmethod
    def consumer_of_vulnerabilities_queue(experiment_setting: dict, smartbugs_sc_queue: queue.Queue,
                                          repair_sc_queue: queue.Queue, stop_event: threading.Event,
                                          progressbar: tqdm) -> None:
        atexit.register(clear_queue, smartbugs_sc_queue)
        atexit.register(clear_queue, repair_sc_queue)
        while not stop_event.is_set():
            try:
                
                sc_path, do_repair_sc = smartbugs_sc_queue.get(block=False)
                TransformativeRepair.find_vulnerabilities(experiment_setting, sc_path, do_repair_sc, repair_sc_queue,
                                                          progressbar)
                # print(progressbar.n) 
            except queue.Empty:
                time.sleep(1)

    @staticmethod
    def repair_sc(experiment_settings: dict, llm_settings: dict, sc_path: Path, smartbugs_sc_queue: queue.Queue,
                  progressbar: tqdm, repair_sc_queue: queue.Queue):
        '''
        candidate_patches_dir = Path(os.path.join(sc_path.parent.absolute(), f"{analyzer}", f"{result_index}", "candidate_patches"))
        print(f"Candidate patches directory is: {candidate_patches_dir}")
        candidate_patches_dir.mkdir(parents=True, exist_ok=True)

        Load patch results if exists
        patches_results_path = os.path.join(candidate_patches_dir, "patch_results.json")
        patches_results = json.load(open(patches_results_path, 'r')) if os.path.isfile(patches_results_path) else {}
        patches_results["patch_generation_completed"] = patches_results.get("patch_generation_completed", False) == True

        Return if patches already generated and successfull
        if patches_results["patch_generation_completed"]:
            for patch_name, duplicate_list in patches_results["unique_patches"].items():
                patch_dir, _ = os.path.splitext(patch_name)
                patch_path = Path(os.path.join(candidate_patches_dir, patch_dir, patch_name))

                sc = SmartContract(experiment_settings, patch_path)
                if not sc.vulnerabilities.get("smartbugs_completed", False):
                    smartbugs_sc_queue.put((patch_path, False))
                else:
                    sc.remove_old_smartbugs_directories()
                    progressbar.update(1)

                    # Add duplicate patches as completed
                progressbar.update(len(duplicate_list))
                # print(progressbar.n)
            return
        '''
        
        
        #### Step 1: Initialize SC
        sc = SmartContract(experiment_settings, sc_path)
        #sc.source_code = reducer.remove_NatSpec_and_comments(sc.source_code)
        with open(os.path.join(str(sc_path.parent.absolute()), "reduced-vulnerable-src.sol"), 'w') as reduced_vuln_file:
            reduced_vuln_file.write(sc.source_code)
                    
        filtered_analysis_results = PromptEngine.delete_empty_analyzers(sc.vulnerabilities["analyzer_results"], experiment_settings["target_vulnerabilities"], sc.path)
        
        if filtered_analysis_results:
            #### Step 2: Iterate over all target analyzers as well as their detected vulnerabilities
            for analyzer, results in filtered_analysis_results.items():

                if analyzer not in experiment_settings["smartbugs_tools"]:
                    continue

                result_index = -1 # the index of this vulnerability specific to {analyzer} for this specific Solidity file
                for result in results['vulnerability_findings']:
                    result_index += 1

                    candidate_patches_dir = Path(os.path.join(sc_path.parent.absolute(), f"{analyzer}", f"vulnerability-{result_index}", "candidate_patches"))
                    candidate_patches_dir.mkdir(parents=True, exist_ok=True)

                    patches_results_path = os.path.join(candidate_patches_dir, "patch_results.json")
                    patches_results = json.load(open(patches_results_path, 'r')) if os.path.isfile(patches_results_path) else {}
                    patches_results["patch_generation_completed"] = patches_results.get("patch_generation_completed", False) == True
                    
                    
                    if patches_results["patch_generation_completed"]:
                        for patch_name, duplicate_list in patches_results["unique_patches"].items():
                            patch_dir, _ = os.path.splitext(patch_name)
                            patch_path = Path(os.path.join(candidate_patches_dir, patch_dir, patch_name))

                            sc = SmartContract(experiment_settings, patch_path)
                            
                            if not sc.vulnerabilities.get("smartbugs_completed", False):
                                smartbugs_sc_queue.put((patch_path, False))
                            else:
                                sc.remove_old_smartbugs_directories()
                                progressbar.update(1)

                                # Add duplicate patches as completed
                            progressbar.update(len(duplicate_list))
                            # print(progressbar.n)
                        continue
                    

                    vulnerability_name = result['name']
                    # Shaved source code should be available via sc.source_code
                    sc_language = 'Solidity'
                    vulnerable_chunk = result['vulnerability_code']
                    analyzer_message = result['message']
                    
                    repair_template_inputs = {
                        "sc_language": sc_language,
                        "vulnerable_chunk": vulnerable_chunk,
                        "flattened_sc_source_code": sc.source_code,
                        "vulnerability_name": vulnerability_name,
                        "analyzer_message": analyzer_message,
                        "analyzer": analyzer,
                        "vulnerability_from_line": result["vulnerability_from_line"],
                        "vulnerability_to_line": result["vulnerability_to_line"]
                    }

                    #### Step 3: Create Prompt Engine and generate prompt
                    pe = PromptEngine(sc, experiment_settings)
                    
                    prompt = pe.generate_prompt(experiment_settings["prompt_style"], filtered_analysis_results, repair_template_inputs)
                    encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
                    
                    # assumption: whatever immediately encloses the vulnerable chunk will be what LLM will return to us as the repaired chunk
                    try: 
                        explorer.Explorer.DEBUG = True
                        vulnerable_chunk_enclosing_nodes = explorer.Explorer.get_enclosing_nodes(sc.source_code, result['vulnerability_from_line']-1 if result['vulnerability_from_line'] is not None else None, result['vulnerability_to_line']-1 if result['vulnerability_to_line'] is not None else None)
                        print(f"\n\n$$$$ Vulnerable chunk enclosing nodes is: \n{vulnerable_chunk_enclosing_nodes} \n\n")
                    except stack.StackEmptyError as e:
                        TransformativeRepair.failed_enclosing_nodes_list.append({
                            'sc_path': str(sc_path),
                            'analyzer': analyzer,
                            'detection': result
                        })
                        #exit()

                        print(f'\nError: {e}\n')
                        print('Trying again with debugging enabled')
                        print(f'\n\nFile: {sc.path}\n\n')
                        explorer.Explorer.DEBUG = True
                        vulnerable_chunk_enclosing_nodes = explorer.Explorer.get_enclosing_nodes(sc.source_code, result['vulnerability_from_line']-1 if result['vulnerability_from_line'] is not None else None, result['vulnerability_to_line']-1 if result['vulnerability_to_line'] is not None else None)
                        
                    if vulnerable_chunk_enclosing_nodes['function'] is not None:
                        vulnerable_chunk_enclosing_type = 'function'
                    elif vulnerable_chunk_enclosing_nodes['contract'] is not None:
                        vulnerable_chunk_enclosing_type = 'contract' 
                    else:
                        # code chunk lies outside of real function boundries; we categorize this as another failure & log it
                        # FAILURE
                        pass

                    vulnerable_chunk_enclosing_start = vulnerable_chunk_enclosing_nodes[vulnerable_chunk_enclosing_type]['start_line']      
                    vulnerable_chunk_enclosing_end = vulnerable_chunk_enclosing_nodes[vulnerable_chunk_enclosing_type]['end_line']     

                    vulnerable_chunk_info = {
                        'enclosing_type': vulnerable_chunk_enclosing_type,
                        'enclosing_start_line_in_source': vulnerable_chunk_enclosing_start,
                        'enclosing_end_line_in_source': vulnerable_chunk_enclosing_end,
                        'detector': result['name'],
                        'vulnerable_chunk_start_line_in_source': result['vulnerability_from_line']-1 if result['vulnerability_from_line'] is not None else None, 
                        'vulnerable_chunk_end_line_in_source': result['vulnerability_to_line']-1 if result['vulnerability_to_line'] is not None else None
                    }
                    
                    this_vuln_results_directory = f"{sc.results_dir}/{analyzer}/vulnerability-{result_index}"

                    #### Store vulnerable chunk info to be retrieved later for analysis and comparison
                    with open(os.path.join(this_vuln_results_directory, "vulnerable_chunk_info.json"), "w") as vulnerable_chunk_info_file: 
                        json.dump(vulnerable_chunk_info, vulnerable_chunk_info_file)

                    #### Step 4: Save prompt
                    with open(os.path.join(this_vuln_results_directory, "prompt.txt"), 'w') as file:
                        file.write(prompt)

                    #### Step 5: Repair smart contract
                    model_name = experiment_settings["llm_model_name"]
                    candidate_patches_paths = []
                    
                    try:
                        #print(f'{"* * "*5}\nSending the following smart contract for patching the {result_index}-th vulnerability. Original contract is: {sc.path};') #\nVulnerability is: {result} \n{"* * "*100}\n\n\n')
                        candidate_patches_paths = pe.get_codex_repaired_sc(experiment_settings, llm_settings[model_name], sc, prompt, this_vuln_results_directory)
                        TransformativeRepair.successful_repair_list.append({
                            'sc_path': str(sc_path),
                            'analyzer': analyzer,
                            'detection': result
                        })
                        progressbar.update(1)
                        #exit()
                    except Exception as e:
                        # if contract too long 
                        if isinstance(e, openai.error.InvalidRequestError):
                            sc.vulnerabilities["smartbugs_completed"] = "Contract too long. Reparing skipped"
                            sc.write_vulnerabilities_to_results_dir()
                            raise Exception("Contract too long. Repairing skipped")
                        logging.critical(f'An exception occurred when repairing contract={sc_path}: {str(e)}', exc_info=True)
                        TransformativeRepair.failed_llm_repair_list.append({
                            'sc_path': str(sc_path),
                            'analyzer': analyzer,
                            'detection': result
                        })
                        progressbar.update(1)
                        #exit()
                    
                    
                    # Step 6: Find all unique patches and add them to the repair queue
                    try:
                        patches_results = {}
                        unique_patches = {}
                        hash_to_first_patch = {}
                        for candidate_patch_path in candidate_patches_paths:
                            sc_candidate_patch = SmartContract(experiment_settings, candidate_patch_path)

                            # Unique patch
                            if sc_candidate_patch.hash not in hash_to_first_patch:
                                hash_to_first_patch[sc_candidate_patch.hash] = sc_candidate_patch.filename
                                unique_patches[sc_candidate_patch.filename] = []
                                smartbugs_sc_queue.put((candidate_patch_path, False))
                                continue

                            # Dubplicate patch has same hash
                            unique_contract = hash_to_first_patch[sc_candidate_patch.hash]
                            unique_patches[unique_contract].append(sc_candidate_patch.filename)
                            sc_candidate_patch.vulnerabilities["smartbugs_completed"] = "Duplicate patch. Smartbugs skipped"
                            sc_candidate_patch.write_vulnerabilities_to_results_dir()
                            #progressbar.update(1)
                            # print(progressbar.n)

                        patches_results["unique_patches"] = unique_patches
                        patches_results["patch_generation_completed"] = True
                    except Exception as e:
                        patches_results["unique_patches"] = {}
                        patches_results["patch_generation_completed"] = str(e)
                        if isinstance(e, openai.error.RateLimitError):
                            sleep = 100 * random.random()
                            logging.info(f"RateLimit error sleep={sleep}s. Enqueueing for repair again {sc_path}: {str(e)}",
                                        exc_info=True)
                            time.sleep(sleep)
                            with open(patches_results_path, "w") as outfile:
                                outfile.write(json.dumps(patches_results, indent=2))
                            repair_sc_queue.put(sc.path)
                            return
                        else:
                            if str(e) != "No vulnerabilities found":
                                logging.critical(f"An exception occurred for {sc_path}: {str(e)}", exc_info=True)
                    
                    with open(patches_results_path, "w") as outfile:
                        outfile.write(json.dumps(patches_results, indent=2))              
        else:
            sc.vulnerabilities["smartbugs_completed"] = "No vulnerabilities found"
            sc.write_vulnerabilities_to_results_dir()
            #progressbar.update(1)
            #print(f'\nFor file: {sc.path}\n     > No target vulnerabilities found to fix')
            #raise Exception("No vulnerabilities found")
        
            """
            #### Step 6: Find all unique patches and add them to the repair queue
            
            patches_results = {}
            unique_patches = {}
            hash_to_first_patch = {}
            for candidate_patch_path in candidate_patches_paths:
                sc_candidate_patch = SmartContract(experiment_settings, candidate_patch_path)

                # Loading back the original vulnerability and file info
                vulnerable_chunk_info = dict()
                with open(os.path.join(f"{sc_candidate_patch.path.parent.parent.parent}", "vulnerable_chunk_info.json"), 'r') as file:
                    vulnerable_chunk_info = json.load(file)
                
                reduced_vulnerable_src_path = os.path.join(sc_candidate_patch.path.parent.parent.parent.parent.parent, "reduced-vulnerable-src.sol")
                reduced_vulnerable_src = open(reduced_vulnerable_src_path, 'r').read()  
                
                # blind replacement
                lines = reduced_vulnerable_src.split('\n')
                patch_lines = sc_candidate_patch.source_code.split('\n')
                all_lines = lines[:vulnerable_chunk_info['start_line_in_source']] + patch_lines + lines[vulnerable_chunk_info['end_line_in_source']:]
                sc_candidate_patch.source_code =  '\n'.join(all_lines)

                # Unique patch
                if sc_candidate_patch.hash not in hash_to_first_patch:
                    hash_to_first_patch[sc_candidate_patch.hash] = sc_candidate_patch.filename
                    unique_patches[sc_candidate_patch.filename] = []
                    
                    
                    # buggy, let's comment and proceed with blind replacement
                    '''
                    patch_chunk_info = explorer.detect_solidity_definition_and_name(reduced_vulnerable_src)
                    print('\n\n')
                    if patch_chunk_info['type'] == vulnerable_chunk_info['type']:
                        lines = reduced_vulnerable_src.split('\n')
                        patch_lines = sc_candidate_patch.source_code.split('\n')
                        all_lines = lines[:vulnerable_chunk_info['start_line_in_source']] + patch_lines + lines[vulnerable_chunk_info['end_line_in_source']:]
                        sc_candidate_patch.source_code =  '\n'.join(all_lines)
                    else:
                        print('FAILURE: The patch and vulnerable code chunk are not part of the same node')
                    '''

                    
                    

                    smartbugs_sc_queue.put((candidate_patch_path, False))
                    continue
                
                # Dubplicate patch has same hash
                unique_contract = hash_to_first_patch[sc_candidate_patch.hash]
                unique_patches[unique_contract].append(sc_candidate_patch.filename)
                sc_candidate_patch.vulnerabilities["smartbugs_completed"] = "Duplicate patch. Smartbugs skipped"
                
                sc_candidate_patch.write_vulnerabilities_to_results_dir()
                progressbar.update(1)
                # print(progressbar.n)

            #print(f' ### For this series of patches, unique patches are only {len(unique_patches)}')
            patches_results["unique_patches"] = unique_patches
            patches_results["patch_generation_completed"] = True

        except Exception as e:
            patches_results["unique_patches"] = {}
            patches_results["patch_generation_completed"] = str(e)
            if isinstance(e, openai.error.RateLimitError):
                sleep = 100 * random.random()
                logging.info(f"RateLimit error sleep={sleep}s. Enqueueing for repair again {sc_path}: {str(e)}",
                             exc_info=True)
                time.sleep(sleep)
                with open(patches_results_path, "w") as outfile:
                    outfile.write(json.dumps(patches_results, indent=2))
                repair_sc_queue.put(sc.path)
                return
            else:
                if str(e) != "No vulnerabilities found":
                    logging.critical(f"An exception occurred for {sc_path}: {str(e)}", exc_info=True)

        # Write to patches_results.json
        print('# LINE: 723 => trying to write to patches_results.json')
        with open(patches_results_path, "w") as outfile:
            outfile.write(json.dumps(patches_results, indent=2))
        """
        
    @staticmethod
    def consumer_of_repair_queue(experiment_setting: dict, llm_settings: dict, smartbugs_sc_queue: queue.Queue,
                                 repair_sc_queue: queue.Queue, stop_event: threading.Event, progressbar: tqdm, ):
        atexit.register(clear_queue, smartbugs_sc_queue)
        atexit.register(clear_queue, repair_sc_queue)
        while not stop_event.is_set():
            try:
                sc_path = repair_sc_queue.get(block=False)
                TransformativeRepair.repair_sc(experiment_setting, llm_settings, sc_path, smartbugs_sc_queue,
                                               progressbar, repair_sc_queue)
                #print(f'\n### Items currently left in repair_sc_queue are: {repair_sc_queue.qsize()} ;;; stop_event is not set! \n')
                if repair_sc_queue.qsize() == 0:

                    TransformativeRepair.failed_enclosing_nodes_list
                    TransformativeRepair.failed_llm_repair_list
                    TransformativeRepair.successful_repair_list

                    with open(f"{os.path.join('failed_enclosing_nodes_list.json')}", 'w') as file:
                        json.dump(TransformativeRepair.failed_enclosing_nodes_list, file, indent=4) 

                    with open(f"{os.path.join('failed_llm_repair_list.json')}", 'w') as file:
                        json.dump(TransformativeRepair.failed_llm_repair_list, file, indent=4) 

                    with open(f"{os.path.join('successful_repair_list.json')}", 'w') as file:
                        json.dump(TransformativeRepair.successful_repair_list, file, indent=4) 

                    exit()
            except queue.Empty:
                time.sleep(1)

    def start(self):
        #### Start!
        print(f'Starting experiment: {self.experiment_results_dir}')

        if not self.preanalized:
            self.full_analysis()
        else:
            self.minimal_analysis()
            #self.partial_analysis()

    def full_analysis(self):

        #### Step 1: Add all vulnerable sc to smartbugs_sc_queue
        self.experiment_results_dir.mkdir(parents=True, exist_ok=True)

        shutil.copyfile('config.yml', os.path.join(self.experiment_results_dir, "config.yml"))

        sc_vulnerable_count = 0

        # Create sc_dirs
        for root, dirs, files in os.walk(self.vulnerable_contracts_dir):
            for sc_filename in files:
                sc_name, file_extension = os.path.splitext(os.path.basename(sc_filename))
                sc_path = os.path.join(root, sc_filename)
                if file_extension == ".sol":
                    # Create dir for contract
                    results_dir = Path(os.path.join(self.experiment_results_dir, sc_name))

                    results_dir.mkdir(parents=True, exist_ok=True)

                    # Copy vulnerable sc to results
                    sc_results_path = Path(os.path.join(results_dir, sc_filename))
                    shutil.copyfile(sc_path, sc_results_path)

                    # Add to results
                    sc_vulnerable_count += 1
                    self.smartbugs_sc_queue.put((sc_results_path, True))

        # Initialize progress bar
        n_candidate_patches = self.llm_settings[self.experiment_settings["llm_model_name"]]["num_candidate_patches"]
        progressbar = tqdm(total=sc_vulnerable_count + sc_vulnerable_count * n_candidate_patches,
                           desc="Smartbugs processes", colour='#ff5a5f')

        stop_event = threading.Event()
        atexit.register(close_all_threads, stop_event)

        #### Step 2: Consume smartbugs_queue
        for i in range(self.experiment_settings["n_smartbugs_threads"]):
            smartbugs_thread = threading.Thread(target=TransformativeRepair.consumer_of_vulnerabilities_queue, args=(
                self.experiment_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event, progressbar))
            smartbugs_thread.start()

        #### Step 2: Consume smart repair_sc_queue
        for i in range(self.experiment_settings["n_repair_threads"]):
            repair_thread = threading.Thread(target=TransformativeRepair.consumer_of_repair_queue, args=(
                self.experiment_settings, self.llm_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event,
                progressbar))
            repair_thread.start()

        #### Start Summary Thread
        shutdown_thread = threading.Thread(target=TransformativeRepair.shutdown_thread,
                                           args=(self.experiment_settings, self.llm_settings, stop_event))
        shutdown_thread.start()

    def partial_analysis(self):

        #### Step 1: Add all vulnerable sc to smartbugs_sc_queue
        self.experiment_results_dir.mkdir(parents=True, exist_ok=True)

        shutil.copyfile('config.yml', os.path.join(self.experiment_results_dir, "config.yml"))

        sc_vulnerable_count = 0

        for project in os.listdir(self.analysis_results_directory):

            results_dir = Path(os.path.join(self.experiment_results_dir, project))
            results_dir.mkdir(parents=True, exist_ok=True)
            
            project_vulnerabilities_src = Path(os.path.join(self.analysis_results_directory, project, "vulnerabilities.json"))
            
            try:
                with open(project_vulnerabilities_src, 'r') as f:
                    
                    project_vulnerabilities = json.load(f)
                    
                    for k, v in project_vulnerabilities.items():

                        # Create dir for contract and copy vulnerable sc to results
                        source_code_path = Path(os.path.join(self.vulnerable_contracts_dir, project, k))
                        if not source_code_path.exists():
                            continue
                        result_path = Path(os.path.join(results_dir, k))
                        file_name = os.path.basename(source_code_path)
                        result_path.mkdir(parents=True, exist_ok=True)
                        shutil.copyfile(source_code_path, os.path.join(result_path, file_name))

                        # Retrieve the reduced version of the original code and copy it alongside the original vulnerable code
                        #shutil.copyfile(source_code_path, os.path.join(result_path, "original-src-reduced.sol"))
                        
                        # Add vulnerabilities to results
                        with open(os.path.join(result_path, "vulnerabilities.json"), 'w') as vulnerabilities_file:
                            vulnerabilites_formatted = {}
                            vulnerabilites_formatted["smartbugs_completed"] = True
                            vulnerabilites_formatted["analyzer_results"] = v
                            json.dump(vulnerabilites_formatted, vulnerabilities_file, indent=2)
                        
                        sc_vulnerable_count += 1
                        self.repair_sc_queue.put(Path(os.path.join(result_path, file_name)))

            except NotADirectoryError as e:
                print(f'Skipping {project_vulnerabilities_src} project as no vulnerabilities.json detected.')
            try: 
                shutil.copyfile(project_vulnerabilities_src, os.path.join(results_dir, "project_vulnerabilities.json"))
            except NotADirectoryError as e:
                print(f'Skipping {project_vulnerabilities_src} project as no vulnerabilities.json detected.')
        # Initialize progress bar
        n_candidate_patches = self.llm_settings[self.experiment_settings["llm_model_name"]]["num_candidate_patches"]
        print(f"Vulnerability count is {sc_vulnerable_count * n_candidate_patches}")
        #progressbar = tqdm(total=sc_vulnerable_count + sc_vulnerable_count * n_candidate_patches,
        #                   desc="Smartbugs processes", colour='#ff5a5f')
        progressbar = tqdm(total=sc_vulnerable_count * n_candidate_patches,
                          desc="Smartbugs processes", colour='#ff5a5f')

        stop_event = threading.Event()
        atexit.register(close_all_threads, stop_event)

        #### Step 2: Consume smartbugs_queue
        for i in range(self.experiment_settings["n_smartbugs_threads"]):
            smartbugs_thread = threading.Thread(target=TransformativeRepair.consumer_of_vulnerabilities_queue, args=(
                self.experiment_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event, progressbar))
            smartbugs_thread.start()

        #### Step 2: Consume smart repair_sc_queue
        for i in range(self.experiment_settings["n_repair_threads"]):
            repair_thread = threading.Thread(target=TransformativeRepair.consumer_of_repair_queue, args=(
                self.experiment_settings, self.llm_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event,
                progressbar))
            repair_thread.start()

        #### Start Summary Thread
        shutdown_thread = threading.Thread(target=TransformativeRepair.shutdown_thread,
                                           args=(self.experiment_settings, self.llm_settings, stop_event))
        shutdown_thread.start()

        return
   
    def minimal_analysis(self):
        
        #### Step 1: Add all vulnerable sc to smartbugs_sc_queue
        self.experiment_results_dir.mkdir(parents=True, exist_ok=True)

        shutil.copyfile('config.yml', os.path.join(self.experiment_results_dir, "config.yml"))

        sc_vulnerable_count = 0
        target_vulnerabilities_found = 0
        count_srcs_containing_at_least_one_vulnerability = 0

        for project in os.listdir(self.analysis_results_directory):

            results_dir = Path(os.path.join(self.experiment_results_dir, project))
            results_dir.mkdir(parents=True, exist_ok=True)
            
            project_vulnerabilities_src = Path(os.path.join(self.analysis_results_directory, project, "vulnerabilities.json"))
            
            try:
                with open(project_vulnerabilities_src, 'r') as f:
                    
                    project_vulnerabilities = json.load(f)
                    
                    for k, v in project_vulnerabilities.items():
                        #print(f"\n\n source file: {k}\n\n")    
                        
                        filtered_analysis_results = PromptEngine.delete_empty_analyzers(v, self.experiment_settings["target_vulnerabilities"], "")
                        
                        if filtered_analysis_results:
                            count_srcs_containing_at_least_one_vulnerability += 1
                        
                        if v:
                            #### Step 2: Iterate over all target analyzers as well as their detected vulnerabilities
                            for analyzer, results in filtered_analysis_results.items():

                                if analyzer not in self.experiment_settings["smartbugs_tools"]:
                                    continue
                                
                                # vulnerability array is accessible through results['vulnerability_findings']
                                for result in results['vulnerability_findings']:
                                    #print(f"\n\n Vulnerability: {result}\n\n")        
                                    target_vulnerabilities_found += 1
                                

                        # Create dir for contract and copy vulnerable sc to results
                        source_code_path = Path(os.path.join(self.vulnerable_contracts_dir, project, k))
                        if not source_code_path.exists():
                            continue
                        result_path = Path(os.path.join(results_dir, k))
                        file_name = os.path.basename(source_code_path)
                        result_path.mkdir(parents=True, exist_ok=True)
                        shutil.copyfile(source_code_path, os.path.join(result_path, file_name))

                        # Retrieve the reduced version of the original code and copy it alongside the original vulnerable code
                        #shutil.copyfile(source_code_path, os.path.join(result_path, "original-src-reduced.sol"))
                        
                        # Add vulnerabilities to results
                        with open(os.path.join(result_path, "vulnerabilities.json"), 'w') as vulnerabilities_file:
                            vulnerabilites_formatted = {}
                            vulnerabilites_formatted["smartbugs_completed"] = True
                            vulnerabilites_formatted["analyzer_results"] = v
                            json.dump(vulnerabilites_formatted, vulnerabilities_file, indent=2)
                        
                        #print(f'\nk is: {k}\n\nv is: {v}\n\n')

                        sc_vulnerable_count += 1
                        self.repair_sc_queue.put(Path(os.path.join(result_path, file_name)))
                # print(f'The total target_vulnerabilities_found is: {target_vulnerabilities_found}')
                # print(f'Total number of files at least contained one vulnerability: {count_srcs_containing_at_least_one_vulnerability}')

            except NotADirectoryError as e:
                print(f'Skipping {project_vulnerabilities_src} project as no vulnerabilities.json detected.')
            try: 
                shutil.copyfile(project_vulnerabilities_src, os.path.join(results_dir, "project_vulnerabilities.json"))
            except NotADirectoryError as e:
                print(f'Skipping {project_vulnerabilities_src} project as no vulnerabilities.json detected.')
        # Initialize progress bar
        n_candidate_patches = self.llm_settings[self.experiment_settings["llm_model_name"]]["num_candidate_patches"]
        #print(f"Vulnerability count is {sc_vulnerable_count * n_candidate_patches}")
        progressbar = tqdm(total=target_vulnerabilities_found,
                           desc="Smartbugs processes", colour='#ff5a5f')
        
        stop_event = threading.Event()
        atexit.register(close_all_threads, stop_event)

        #### Step 2: Consume smartbugs_queue
        for i in range(self.experiment_settings["n_smartbugs_threads"]):
            smartbugs_thread = threading.Thread(target=TransformativeRepair.consumer_of_vulnerabilities_queue, args=(
                self.experiment_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event, progressbar))
            smartbugs_thread.start()

        #### Step 2: Consume smart repair_sc_queue

        for i in range(self.experiment_settings["n_repair_threads"]):
            repair_thread = threading.Thread(target=TransformativeRepair.consumer_of_repair_queue, args=(
                self.experiment_settings, self.llm_settings, self.smartbugs_sc_queue, self.repair_sc_queue, stop_event,
                progressbar))
            repair_thread.start()

        #### Start Summary Thread
        shutdown_thread = threading.Thread(target=TransformativeRepair.shutdown_thread,
                                           args=(self.experiment_settings, self.llm_settings, stop_event))
        shutdown_thread.start()

        return   