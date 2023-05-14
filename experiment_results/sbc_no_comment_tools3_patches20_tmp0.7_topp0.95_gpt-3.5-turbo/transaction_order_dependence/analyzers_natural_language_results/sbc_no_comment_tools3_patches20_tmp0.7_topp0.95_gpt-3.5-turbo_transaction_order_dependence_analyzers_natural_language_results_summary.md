# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | sbc_no_comment_tools3_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_transaction_order_dependence_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/front_running |
| smartbugs_tools | ['mythril', 'oyente', 'slither'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=30 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 0:04:46 |

## Target Vulnerabilities


### transaction_order_dependence

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 4/4 | 33/80 | 18/33 |

#### Results
| n | sc_name | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | mythril-0.23.15 | oyente | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ERC20 | 20 | 5/15 | patch_3 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 2 | FindThisHash | 20 | 3/7 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 3 | eth_tx_order_dependence_minimal | 20 | 7/7 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix|
| 4 | odds_and_evens | 20 | 3/4 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix|
