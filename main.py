from SC import SC

#sc_path = 'experiments/sc_to_repair/test_reentrancy.sol'
sc_path = 'experiments/sc_to_repair/modifier_reentrancy.sol'



sc = SC(sc_path)
sc.find_vulnerabilities()

repaired_contracts = sc.get_codex_repaired_sc(1, 0.93, 2)

for repaired_sc in repaired_contracts:
    repaired_sc.find_vulnerabilities()

    vulnerability_differences = sc.get_vulnerabilities_difference(repaired_sc)

    print(f'{repaired_sc.sc_path} fixes \n{vulnerability_differences}\n\n')

print('end')


