import os
import json

def find_vulnerable_files(directory_path):
    vulnerable_files = []
    for root, dirs, files in os.walk(directory_path):
        if 'result.json' in files:
            with open(os.path.join(root, 'result.json')) as results_file:
                results = json.load(results_file)
                if results['findings']:
                    with open(os.path.join(root, 'smartbugs.json')) as smartbugs_file:
                        smartbugs = json.load(smartbugs_file)
                        file_path = os.path.join(root, smartbugs['filename'])
                        if file_path not in [path for _, path in vulnerable_files]:
                            vulnerable_files.append((smartbugs['filename'], file_path))
    with open('vulnerable_files.txt', 'w') as file:
        for filename, _ in vulnerable_files:
            file.write(f'{filename}\n')  # Only write the filename to the file

def save_results(results_path, sc_path):

    with open(sc_path) as sc_file:
        lines = sc_file.readlines()
    
    #load results
    try:
        with open(results_path) as results_file:
            results = json.load(results_file)
    except FileNotFoundError:
        results = {"errors": ["Smartbugs results not found"], "fails": [], "findings": []}
        print(f"Smartbugs results not found for {results_path}")

    tool_vulnerabilities = {}

    tool_vulnerabilities["successfull_analysis"] = False if (results["errors"] or results["fails"]) and not results["findings"] else True
    tool_vulnerabilities["errors"] = results["errors"] + results.get("fails", [])

    vulnerability_findings = []

    for finding in results["findings"]:
        vulnerability = {}
        vulnerability["name"] = finding["name"]
        from_line = finding.get("line", None)
        vulnerability["vulnerability_from_line"] = from_line
        to_line = finding.get("line_end", None)
        vulnerability["vulnerability_to_line"] = to_line

        if from_line and to_line:
            code = "\n".join(lines[from_line - 1: to_line - 1])
        elif from_line:
            code = lines[from_line - 1]
        else:
            code = None

        vulnerability["vulnerability_code"] = code
        vulnerability["message"] = finding.get("message", None)
        vulnerability_findings.append(vulnerability)

    tool_vulnerabilities["vulnerability_findings"] = vulnerability_findings

    return tool_vulnerabilities

def create_vulnerabilities(source_code_dir, smartbugs_results_dir, output_dir, sbtools):
    

    for project in os.listdir(source_code_dir):
        vulnerabilities = {}
        project_path = os.path.join(source_code_dir, project)
        for root, dirs, files in os.walk(project_path):
            for file in files:
                # if file is solidity file
                if file.endswith('.sol'):
                    # look for results in smartbugs_results_dir
                    analyzer_results = {}
                    suffix = root.split(project)[-1][1:]
                    sc_path = os.path.join(root, file)
                    for sbtool in sbtools:
                        sbtool_path = os.path.join(smartbugs_results_dir, sbtool)
                        sb_result_path = os.path.join(sbtool_path,'sc_datasets/compiled_DAppSCAN', project, suffix, file, 'result.json')
                        analyzer_results[sbtool] = save_results(sb_result_path, sc_path)
                    vulnerabilities[os.path.join(suffix, file)] = analyzer_results

        if not os.path.exists(os.path.join(output_dir, project)):
            os.mkdir(os.path.join(output_dir, project))
        with open(os.path.join(output_dir, project, 'vulnerabilities.json'), 'w') as vulnerabilities_file:
            json.dump(vulnerabilities, vulnerabilities_file, indent=4)



   

if __name__ == "__main__":
    # find_vulnerable_files('/Users/gabrielemorello/Code/require-data/DAppSCAN')
    create_vulnerabilities('/Users/gabrielemorello/Code/TRT/sc_datasets/compiled_DAppSCAN', '/Users/gabrielemorello/Code/require-data/DAppSCAN/results_smartbugs', '/Users/gabrielemorello/Code/TRT/vulnerabilities', ['semgrep', 'slither', 'smartcheck', 'oyente', 'mythril', 'osiris'])