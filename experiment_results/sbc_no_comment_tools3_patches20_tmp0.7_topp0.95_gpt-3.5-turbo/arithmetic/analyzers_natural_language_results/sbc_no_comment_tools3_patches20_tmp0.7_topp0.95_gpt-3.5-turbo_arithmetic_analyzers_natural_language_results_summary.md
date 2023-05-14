# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | sbc_no_comment_tools3_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_arithmetic_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/arithmetic |
| smartbugs_tools | ['mythril', 'oyente', 'slither'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=30 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 0:16:47 |

## Target Vulnerabilities


### arithmetic

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 14/15 | 137/300 | 109/137 |

#### Results
| n | sc_name | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | mythril-0.23.15 | oyente | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | BECToken | 20 | 0/20 | patch_0 | False | False | Fix/Bug | Fix/Bug | Fix/Bug|
| 2 | insecure_transfer | 20 | 7/9 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 3 | integer_overflow_1 | 20 | 5/5 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 4 | integer_overflow_add | 20 | 7/9 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 5 | integer_overflow_benign_1 | 20 | 3/3 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 6 | integer_overflow_mapping_sym_1 | 20 | 2/2 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 7 | integer_overflow_minimal | 20 | 2/2 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 8 | integer_overflow_mul | 20 | 12/12 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 9 | integer_overflow_multitx_multifunc_feasible | 20 | 13/13 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 10 | integer_overflow_multitx_onefunc_feasible | 20 | 12/12 | patch_0 | True | True | Bug/Fix | Bug/Fix | Fix/Fix|
| 11 | overflow_simple_add | 20 | 9/10 | patch_0 | True | True | Bug/Fix | Fix/Fix | Fix/Fix|
| 12 | overflow_single_tx | 20 | 13/14 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix|
| 13 | timelock | 20 | 4/4 | patch_1 | True | True | Fix/Fix | Bug/Fix | Fix/Fix|
| 14 | token | 20 | 9/9 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 15 | tokensalechallenge | 20 | 11/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
