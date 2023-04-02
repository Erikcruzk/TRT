# Settings of experiment

| Setting | Value |
| --- | --- |
| experiment_name | smrtbugs_2_gpt-3.5-turbo |
| dataset | sc_to_repair |
| smartbugs_tools | ['oyente', 'slither', 'conkas', 'honeybadger', 'osiris'] |
| prompt_style | D_vulnerability_info |
| llm_settings | {'model_name': 'gpt-3.5-turbo', 'secret_api_key': 'KTH_OPENAI_API_KEY', 'temperature': 0.5, 'top_p': 0.9, 'num_candidate_patches': 5, 'max_time': 3600, 'stop': ['///']} |

## Target Vulnerabilities


### reentrancy
n_plausible_patches/n_contracts = `1/1`

| sc_name | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | osiris | honeybadger | conkas | oyente | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| etherstore | 5 | 1/5 | patch_1 | True | True | Bug/Fix | Fix/Fix | Bug/Fix | Bug/Fix | Bug/Fix|

### integer_over-underflow
n_plausible_patches/n_contracts = `0/1`

| sc_name | n_patches | unique_paches_that_compile | best_patch | compiles | plausible_patch | osiris | honeybadger | conkas | oyente | slither |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| etherstore | 5 | 1/5 | patch_1 | True | False | Bug/Bug | Fix/Fix | Bug/Bug | Bug/Bug | Fix/Fix|
