# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | DAppSCAN_first_experiment_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_ |
| dataset | sc_datasets/DAppSCAN/consensys-Paxos/simple-multisig-master |
| smartbugs_tools | ['mythril'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=60 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 0:03:05 |

## Target Vulnerabilities


### arithmetic

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 2/2 | 20/40 | 20/20 |

#### Results
| n | sc_name | vuln_detected | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | mythril-0.23.15 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | SimpleMultiSig | False | 20 | 18/18 | patch_0 | True | True | Fix/Fix|
| 2 | TestRegistry | False | 20 | 2/2 | patch_0 | True | True | Fix/Fix|
