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
    #TransformativeRepair.create_summary(config["experiment_settings"], config["llm_settings"], None, True)
    tfr.start()

    toc = time.perf_counter()
    print(f'Time for completin = {toc-tic}')
if __name__ == "__main__":
    main()
