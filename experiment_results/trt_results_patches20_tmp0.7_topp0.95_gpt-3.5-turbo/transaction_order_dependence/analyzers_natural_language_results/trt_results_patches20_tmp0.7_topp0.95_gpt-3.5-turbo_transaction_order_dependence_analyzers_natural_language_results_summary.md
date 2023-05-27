# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_transaction_order_dependence_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/front_running |
| smartbugs_tools | ['securify'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=60 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 0:04:20 |

## Target Vulnerabilities


### transaction_order_dependence

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 3/4 | 45/80 | 45/45 |

#### Results
| n | sc_name | vuln_detected | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | securify |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ERC20 | False | 20 | 17/17 | patch_0 | True | True | Fix/Fix|
| 2 | FindThisHash | False | 20 | 7/7 | patch_0 | True | True | Fix/Fix|
| 3 | eth_tx_order_dependence_minimal | True | 20 | 10/10 | patch_0 | True | False | Bug/Bug|
| 4 | odds_and_evens | True | 20 | 11/11 | patch_7 | True | True | Bug/Fix|
