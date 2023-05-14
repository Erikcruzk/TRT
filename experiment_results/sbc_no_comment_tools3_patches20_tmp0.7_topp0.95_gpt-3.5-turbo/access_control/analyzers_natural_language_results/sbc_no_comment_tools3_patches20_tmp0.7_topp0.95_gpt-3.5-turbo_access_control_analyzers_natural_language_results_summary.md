# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | sbc_no_comment_tools3_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_access_control_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/access_control |
| smartbugs_tools | ['mythril', 'oyente', 'slither'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=30 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 0:07:05 |

## Target Vulnerabilities


### access_control

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 16/17 | 200/340 | 146/200 |

#### Results
| n | sc_name | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | mythril-0.23.15 | oyente | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | FibonacciBalance | 20 | 11/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 2 | arbitrary_location_write_simple | 20 | 3/3 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 3 | incorrect_constructor_name1 | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 4 | incorrect_constructor_name2 | 20 | 8/10 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 5 | incorrect_constructor_name3 | 20 | 11/11 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 6 | mapping_write | 20 | 2/3 | patch_1 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 7 | multiowned_vulnerable | 20 | 16/17 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 8 | mycontract | 20 | 5/7 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 9 | parity_wallet_bug_2 | 20 | 0/20 | patch_0 | False | False | Fix/Bug | Fix/Bug | Fix/Bug|
| 10 | phishable | 20 | 3/8 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 11 | proxy | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 12 | rubixi | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 13 | simple_suicide | 20 | 10/10 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 14 | unprotected0 | 20 | 10/10 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 15 | wallet_02_refund_nosub | 20 | 9/20 | patch_2 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 16 | wallet_03_wrong_constructor | 20 | 4/8 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 17 | wallet_04_confused_sign | 20 | 9/15 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
