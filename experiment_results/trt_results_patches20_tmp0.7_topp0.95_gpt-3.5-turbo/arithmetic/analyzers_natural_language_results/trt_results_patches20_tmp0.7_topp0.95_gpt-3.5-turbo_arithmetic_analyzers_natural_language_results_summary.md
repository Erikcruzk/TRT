# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_arithmetic_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/arithmetic |
| smartbugs_tools | ['manticore', 'mythril', 'smartcheck', 'osiris', 'oyente'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=60 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 1:06:49 |

## Target Vulnerabilities


### arithmetic

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 12/15 | 161/300 | 119/161 |

#### Results
| n | sc_name | vuln_detected | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | manticore-0.3.7 | mythril-0.23.15 | osiris | oyente | smartcheck |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | BECToken | True | 20 | 0/19 | patch_0 | False | False | Fix/Bug | Fix/Bug | Fix/Bug | Bug/Bug | Fix/Bug|
| 2 | insecure_transfer | True | 20 | 1/1 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 3 | integer_overflow_1 | True | 20 | 4/4 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 4 | integer_overflow_add | True | 20 | 4/6 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 5 | integer_overflow_benign_1 | True | 20 | 1/1 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Bug/Fix | Fix/Fix|
| 6 | integer_overflow_mapping_sym_1 | True | 20 | 5/5 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 7 | integer_overflow_minimal | True | 20 | 2/2 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 8 | integer_overflow_mul | True | 20 | 9/9 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Fix/Fix | Fix/Fix|
| 9 | integer_overflow_multitx_multifunc_feasible | True | 20 | 14/14 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 10 | integer_overflow_multitx_onefunc_feasible | True | 20 | 18/18 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 11 | overflow_simple_add | True | 20 | 9/10 | patch_1 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 12 | overflow_single_tx | True | 20 | 11/20 | patch_2 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Fix/Fix|
| 13 | timelock | True | 20 | 14/20 | patch_0 | True | False | Fix/Fix | Bug/Fix | Bug/Bug | Bug/Fix | Fix/Fix|
| 14 | token | True | 20 | 12/13 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix | Bug/Fix|
| 15 | tokensalechallenge | True | 20 | 15/19 | patch_7 | True | False | Fix/Fix | Bug/Fix | Bug/Bug | Bug/Fix | Fix/Fix|
