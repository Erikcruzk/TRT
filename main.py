import time
import yaml
import os
from TransformativeRepair import TransformativeRepair
from pathlib import Path
from dotenv import load_dotenv
import shutil


def main():
    tic = time.perf_counter()

    # Load settings from YAML file
    with open('config.yml', 'r') as f:
        config = yaml.safe_load(f)

    # Load variables from .env file
    load_dotenv()

    # Delete experiment resuts if requested
    experiment_dir = os.path.join("experiment_results", f'{config["experiment_settings"]["experiment_name"]}_{config["experiment_settings"]["llm_model"]}')
    if config["experiment_settings"]["delete_old_experiment_name"] and os.path.exists(experiment_dir):
        shutil.rmtree(experiment_dir)

    # 0. Initialize TFR!
    tfr = TransformativeRepair(config["experiment_settings"], config["llm_settings"])

    # 1. Activate to show the different prompt_styles
    # tfr.show_prompt_styles(sc_path)

    # 2. Activate to Generate a simple Network Graph of a simple repair
    # G = tfr.create_repair_results_network(sc_path, promt_style='C_vulnerability_examples', vulnerability_limitations=['reentrancy'], temperature=0.5, top_p=0.95, n_repairs=2)
    # tfr.visualize_graph_pyvis(G, 'results/simple_example')

    # 3. Activate to Generate Network Grah of repairs of directory
    # G = tfr.find_vulnerabilities_and_repair_sc_in_directory()
    # tfr.visualize_graph_pyvis(G, results_path)

    tfr.start()

    toc = time.perf_counter()
if __name__ == "__main__":
    main()
