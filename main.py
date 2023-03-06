from SC import SC

def find_vulnerablities_and_repair_sc(sc_path):
    sc = SC(sc_path)
    sc.find_vulnerabilities()

    repaired_contracts = sc.get_codex_repaired_sc(1, 0.93, 1)
    print(f'\n\n{sc.sc_filename} Repairs')
    for repaired_sc in repaired_contracts:
        repaired_sc.find_vulnerabilities()
        vulnerability_differences = sc.get_vulnerabilities_difference(repaired_sc)
        print(f'{repaired_sc.sc_filename} fixes \n{vulnerability_differences}\n')
    

def main():
    sc_path = 'experiments/sc_to_repair/test_reentrancy.sol'
    find_vulnerablities_and_repair_sc(sc_path)

if __name__ == "__main__":
    main()
