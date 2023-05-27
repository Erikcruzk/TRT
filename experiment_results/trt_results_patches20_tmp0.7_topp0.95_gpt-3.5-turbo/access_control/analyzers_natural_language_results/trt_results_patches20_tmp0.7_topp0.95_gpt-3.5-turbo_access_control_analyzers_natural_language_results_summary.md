# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_access_control_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/access_control |
| smartbugs_tools | ['mythril', 'maian', 'manticore', 'securify', 'slither', 'oyente'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=60 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 2:03:46 |

## Target Vulnerabilities


### access_control

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 13/17 | 210/340 | 174/210 |

#### Results
| n | sc_name | vuln_detected | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | maian | manticore-0.3.7 | mythril-0.23.15 | oyente | securify | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | FibonacciBalance | True | 20 | 14/16 | patch_6 | True | False | Bug/Fix | Fix/Fix | Bug/Bug | Fix/Fix | Fix/Fix | Bug/Bug|
| 2 | arbitrary_location_write_simple | False | 20 | 3/3 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 3 | incorrect_constructor_name1 | False | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 4 | incorrect_constructor_name2 | False | 20 | 11/13 | patch_1 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 5 | incorrect_constructor_name3 | False | 20 | 11/11 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 6 | mapping_write | False | 20 | 3/4 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 7 | multiowned_vulnerable | True | 20 | 19/19 | patch_1 | True | False | Bug/Fix | Fix/Fix | Bug/Bug | Fix/Fix | Fix/Fix | Bug/Bug|
| 8 | mycontract | True | 20 | 9/11 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 9 | parity_wallet_bug_2 | True | 20 | 0/20 | patch_0 | False | False | Bug/Bug | Fix/Bug | Fix/Bug | Fix/Bug | Fix/Bug | Fix/Bug|
| 10 | phishable | True | 20 | 8/8 | patch_0 | True | False | Fix/Fix | Fix/Fix | Bug/Bug | Fix/Fix | Fix/Fix | Bug/Fix|
| 11 | proxy | True | 20 | 9/9 | patch_0 | True | True | Bug/Fix | Fix/Fix | Bug/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 12 | rubixi | False | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 13 | simple_suicide | True | 20 | 10/10 | patch_0 | True | True | Bug/Fix | Fix/Fix | Bug/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 14 | unprotected0 | True | 20 | 9/9 | patch_4 | True | True | Bug/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 15 | wallet_02_refund_nosub | False | 20 | 16/16 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 16 | wallet_03_wrong_constructor | False | 20 | 5/14 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
| 17 | wallet_04_confused_sign | True | 20 | 14/14 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix | Fix/Fix | Fix/Fix | Fix/Fix|
