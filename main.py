import yaml
import os
from TransformativeRepair import TransformativeRepair
from dotenv import load_dotenv
import shutil


def main():
    # Load settings from YAML file
    with open('config.yml', 'r') as f:
        config = yaml.safe_load(f)

    # Load variables from .env file
    load_dotenv()

    # 0. Initialize TFR!
    tfr = TransformativeRepair(config["experiment_settings"], config["llm_settings"])
    tfr.start()
if __name__ == "__main__":
    main()
