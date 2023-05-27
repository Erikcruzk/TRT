# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | trt_results_patches20_tmp0.7_topp0.95_gpt-3.5-turbo_unchecked_low_level_calls_analyzers_natural_language_results |
| dataset | sc_datasets/smartbugs_curated_no_comment/unchecked_low_level_calls |
| smartbugs_tools | ['smartcheck', 'mythril', 'manticore', 'securify'] |
| prompt_style | analyzers_natural_language_results |
| n_threads | sb_threads=60 llm_rapair_threads=10 |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.7, 'top_p': 0.95, 'num_candidate_patches': 20, 'max_time': 3600, 'stop': ['///']} |
| run_time | 7:44:04 |

## Target Vulnerabilities


### unchecked_low_level_calls

#### Summary
| n_plausible_patches/n_contracts | n_unique patches/n_patches | n_patches_compiles/n_unique_patches |
| --- | --- | --- |
| 48/48 | 653/960 | 653/653 |

#### Results
| n | sc_name | vuln_detected | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | manticore-0.3.7 | mythril-0.23.15 | securify | smartcheck |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 0x07f7ecb66d788ab01dc93b9b71a88401de7d0f2e | True | 20 | 17/17 | patch_1 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 2 | 0x0cbe050f75bc8f8c2d6c0d249fea125fd6e1acc9 | True | 20 | 2/2 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 3 | 0x2972d548497286d18e92b5fa1f8f9139e5653fd2 | True | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 4 | 0x39cfd754c85023648bf003bea2dd498c5612abfa | True | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 5 | 0x3a0e9acd953ffc0dd18d63603488846a6b8b2b01 | True | 20 | 20/20 | patch_1 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 6 | 0x3e013fc32a54c4c5b6991ba539dcd0ec4355c859 | True | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 7 | 0x3f2ef511aa6e75231e4deafc7a3d2ecab3741de2 | True | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 8 | 0x4051334adc52057aca763453820cb0e045076ef3 | True | 20 | 7/7 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 9 | 0x4a66ad0bca2d700f11e1f2fc2c106f7d3264504c | True | 20 | 8/8 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 10 | 0x4b71ad9c1a84b9b643aa54fdd66e2dec96e8b152 | True | 20 | 10/10 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 11 | 0x524960d55174d912768678d8c606b4d50b79d7b1 | True | 20 | 14/14 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 12 | 0x52d2e0f9b01101a59b38a3d05c80b7618aeed984 | True | 20 | 17/17 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 13 | 0x5aa88d2901c68fda244f1d0584400368d2c8e739 | True | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 14 | 0x610495793564aed0f9c7fc48dc4c7c9151d34fd6 | True | 20 | 16/16 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 15 | 0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839 | True | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 16 | 0x70f9eddb3931491aab1aeafbc1e7f1ca2a012db4 | True | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 17 | 0x78c2a1e91b52bca4130b6ed9edd9fbcfd4671c37 | True | 20 | 15/15 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 18 | 0x7a4349a749e59a5736efb7826ee3496a2dfd5489 | True | 20 | 17/17 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 19 | 0x7d09edb07d23acb532a82be3da5c17d9d85806b4 | True | 20 | 18/18 | patch_1 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 20 | 0x806a6bd219f162442d992bdc4ee6eba1f2c5a707 | True | 20 | 15/15 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 21 | 0x84d9ec85c9c568eb332b7226a8f826d897e0a4a8 | True | 20 | 18/18 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 22 | 0x8fd1e427396ddb511533cf9abdbebd0a7e08da35 | True | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 23 | 0x958a8f594101d2c0485a52319f29b2647f2ebc06 | True | 20 | 16/16 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 24 | 0x9d06cbafa865037a01d322d3f4222fa3e04e5488 | True | 20 | 16/16 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 25 | 0xa1fceeff3acc57d257b917e30c4df661401d6431 | True | 20 | 6/6 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 26 | 0xa46edd6a9a93feec36576ee5048146870ea2c3ae | True | 20 | 7/7 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 27 | 0xb0510d68f210b7db66e8c7c814f22680f2b8d1d6 | True | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 28 | 0xb11b2fed6c9354f7aa2f658d3b4d7b31d8a13b77 | True | 20 | 19/19 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 29 | 0xb37f18af15bafb869a065b61fc83cfc44ed9cc27 | True | 20 | 12/12 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 30 | 0xb620cee6b52f96f3c6b253e6eea556aa2d214a99 | True | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 31 | 0xb7c5c5aa4d42967efe906e1b66cb8df9cebf04f7 | True | 20 | 8/8 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 32 | 0xbaa3de6504690efb064420d89e871c27065cdd52 | True | 20 | 16/16 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 33 | 0xbebbfe5b549f5db6e6c78ca97cac19d1fb03082c | True | 20 | 18/18 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 34 | 0xd2018bfaa266a9ec0a1a84b061640faa009def76 | True | 20 | 10/10 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 35 | 0xd5967fed03e85d1cce44cab284695b41bc675b5c | True | 20 | 12/12 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 36 | 0xdb1c55f6926e7d847ddf8678905ad871a68199d2 | True | 20 | 10/10 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 37 | 0xe4eabdca81e31d9acbc4af76b30f532b6ed7f3bf | True | 20 | 10/10 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 38 | 0xe82f0742a71a02b9e9ffc142fdcb6eb1ed06fb87 | True | 20 | 13/13 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 39 | 0xe894d54dca59cb53fe9cbc5155093605c7068220 | True | 20 | 5/5 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 40 | 0xec329ffc97d75fe03428ae155fc7793431487f63 | True | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 41 | 0xf2570186500a46986f3139f65afedc2afe4f445d | True | 20 | 5/5 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 42 | 0xf29ebe930a539a60279ace72c707cba851a57707 | True | 20 | 7/7 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 43 | 0xf70d589d76eebdd7c12cc5eec99f8f6fa4233b9e | True | 20 | 15/15 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 44 | etherpot_lotto | True | 20 | 20/20 | patch_0 | True | True | Fix/Fix | Fix/Fix | Fix/Fix | Bug/Fix|
| 45 | king_of_the_ether_throne | True | 20 | 17/17 | patch_1 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 46 | lotto | True | 20 | 7/7 | patch_4 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 47 | mishandled | True | 20 | 8/8 | patch_2 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
| 48 | unchecked_return_value | True | 20 | 7/7 | patch_0 | True | True | Fix/Fix | Bug/Fix | Fix/Fix | Bug/Fix|
