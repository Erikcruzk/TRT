from SmartContract import SmartContract
from PromptEngine import PromptEngine
from TransformativeRepair import TransformativeRepair
import os


def find_vulnerabilities_and_repair_sc_in_directory(directory_path):
    for filename in os.listdir(directory_path):
        find_vulnerablities_and_repair_sc(os.path.join(directory_path, filename))



def main():
    sc_path = 'experiments/sc_to_repair/reentrance.sol'

    # 0. Initialize TFR!
    tfr = TransformativeRepair()

    # 1. Activate to show the different prompt_styles
    tfr.show_prompt_types(sc_path)

    # 2. Activate to Generate a simple Network Graph of a simple repair
    tfr.create_repair_results_network(sc_path, promt_style='C_vulnerability_examples', vulnerability_limitations=['reentrancy'], temperature=0.5, top_p=0.95, n_repairs=2)
    tfr.visualize_graph_pyvis('results/test1')

if __name__ == "__main__":
    main()
