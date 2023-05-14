# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | sbc_no_comment_tools3_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_reentrancy_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/reentrancy |
| smartbugs_tools | ['mythril', 'oyente', 'slither'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=30 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 0:14:11 |

## Target Vulnerabilities


### reentrancy

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 29/30 | 509/600 | 437/509 |

#### Results
| n | sc_name | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | mythril-0.23.15 | oyente | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0x01f8c4e3fa3edeb29e514cba738d87ce8c091d3f | 20 | 15/18 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 2 | 0x23a91059fdc9579a9fbd0edc5f2ea0bfdb70deb4 | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 3 | 0x4320e6f8c05b27ab4707cd1f6d5ce6f3e4b3a5a1 | 20 | 13/20 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 4 | 0x4e73b32ed6c35f570686b89848e5f39f20ecc106 | 20 | 18/20 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 5 | 0x561eac93c92360949ab1f1403323e6db345cbf31 | 20 | 14/16 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 6 | 0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839 | 20 | 11/20 | patch_1 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 7 | 0x7541b76cb60f4c60af330c208b0623b7f54bf615 | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 8 | 0x7a8721a9d64c74da899424c1b52acbf58ddc9782 | 20 | 18/19 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 9 | 0x7b368c4e805c3870b6c49a3f1f49f69af8662cf3 | 20 | 7/20 | patch_5 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 10 | 0x8c7777c45481dba411450c228cb692ac3d550344 | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 11 | 0x93c32845fae42c83a70e5f06214c8433665c2ab5 | 20 | 18/19 | patch_1 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 12 | 0x941d225236464a25eb18076df7da6a91d0f95e9e | 20 | 12/19 | patch_0 | True | False | Fix/Fix | Bug/Fix | Bug/Bug|
| 13 | 0x96edbe868531bd23a6c05e9d0c424ea64fb1b78b | 20 | 18/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 14 | 0xaae1f51cf3339f18b6d3f3bdc75a5facd744b0b8 | 20 | 17/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 15 | 0xb5e1b1ee15c6fa0e48fce100125569d430f1bd12 | 20 | 18/18 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 16 | 0xb93430ce38ac4a6bb47fb1fc085ea669353fd89e | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 17 | 0xbaf51e761510c1a11bf48dd87c0307ac8a8c8a4f | 20 | 14/15 | patch_0 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 18 | 0xbe4041d55db380c5ae9d4a9b9703f1ed4e7e3888 | 20 | 17/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 19 | 0xcead721ef5b11f1a7b530171aab69b16c5e66b6e | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 20 | 0xf015c35649c82f5467c9c74b7f28ee67665aad68 | 20 | 19/20 | patch_1 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 21 | etherbank | 20 | 11/11 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 22 | etherstore | 20 | 11/12 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 23 | modifier_reentrancy | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix|
| 24 | reentrance | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 25 | reentrancy_bonus | 20 | 7/9 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 26 | reentrancy_cross_function | 20 | 10/16 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 27 | reentrancy_dao | 20 | 3/4 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
| 28 | reentrancy_insecure | 20 | 13/20 | patch_1 | True | True | Bug/Fix | Bug/Fix | Bug/Fix|
| 29 | reentrancy_simple | 20 | 14/14 | patch_2 | True | True | Fix/Fix | Bug/Fix | Bug/Fix|
| 30 | simple_dao | 20 | 15/15 | patch_0 | True | True | Fix/Fix | Fix/Fix | Bug/Fix|
