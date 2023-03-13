from TransformativeRepair import TransformativeRepair

def main():
    sc_path = 'experiments/sc_to_repair/reentrance.sol'
    sc_directory = 'experiments/sc_to_repair'

    # 0. Initialize TFR!
    tfr = TransformativeRepair()

    # 1. Activate to show the different prompt_styles
    # tfr.show_prompt_types(sc_path)

    # 2. Activate to Generate a simple Network Graph of a simple repair
    # G = tfr.create_repair_results_network(sc_path, promt_style='C_vulnerability_examples', vulnerability_limitations=['reentrancy'], temperature=0.5, top_p=0.95, n_repairs=2)
    # tfr.visualize_graph_pyvis(G, 'results/simple_example')

    # 3. Activate to Generate Network Grah of repairs of directory
    G = tfr.find_vulnerabilities_and_repair_sc_in_directory(sc_directory, prompt_style='C_vulnerability_examples', vulnerability_limitations=['reentrancy'], temperature=0.5, top_p=0.95, n_repairs=2)
    tfr.visualize_graph_pyvis(G, 'results/test_sb_curated_reentrancy')

if __name__ == "__main__":
    main()
