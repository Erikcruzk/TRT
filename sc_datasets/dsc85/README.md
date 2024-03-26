## DSC85
This dataset of 85 contracts is an extract of DeappScan dataset. 
All the contracts in DSC85 have 2 common characteristics:
- 1 The smart contract project(Folder) only has one contract
- 2 The token length of the file is under 4k in total

For reproducibility make sure that before running the experiments on TRT, you
are defining the following variables accordingly:

```yml
vulnerable_contracts_directory: "sc_datasets/dsc85"
preanalized: True
analysis_results_directory: "vuln_datasets/dsc85-vulnerabilities" 
```

Keep in mind that dsc85 only contains the following vulnerabilities:
```python
dcs85_vul_list=['constant-function',
 'deprecated-standards',
 'unused-return',
 'unused-state',
 'reentrancy-benign',
 'shadowing-builtin',
 'assembly',
 'external-function',
 'shadowing-local',
 'solc-version',
 'low-level-calls',
 'incorrect-equality',
 'uninitialized-local',
 'naming-convention',
 'constable-states',
 'calls-loop',
 'erc20-interface',
 'reentrancy-no-eth',
 'shadowing-abstract',
 'uninitialized-state',
 'timestamp',
 'pragma']
```

## Good luck with your experiments :D