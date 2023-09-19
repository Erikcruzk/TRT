import re

class SmartContract:
    def __init__(self):
        path = 'sc_datasets/reentrancy-attacks/shave_test/AbracadabraMoney.sol'
        with open(path, 'r') as f:
            self.sc = f.read()

    def remove_NatSpec(self):
        # removes all docstrings from the solidity code
        self.sc = re.sub(r'\/\*\*.*?\*\/\n|\/\/\/.*?\n', '', self.sc, flags=re.DOTALL)    
    
    def remove_comments(self):
        # removes all file directives from the solidity code
        self.sc = re.sub(r'\/\*[\s\S]*?\*\/\n|\/\/.*\n', '', self.sc)

    def remove_definitions(self):
        # removes all common libraries from the solidity code using a dictionary of common libraries names

        lines = self.sc.split('\n')  # Convert self.sc to a list of lines
        modified_lines = []
    
        common = ['Proxy', 'SafeMath', 'SafeERC20', 'Ownable', 'IERC20', 'Address', 'EnumerableSet', 'EnumerableMap', 'Strings', 'Context', 'ReentrancyGuard', 'Pausable', 'ERC20', 'ERC20Detailed', 'ERC20Burnable', 'ERC20Mintable', 'ERC20Pausable', 'ERC20Capped', 'ERC721', 'ERC721Enumerable', 'ERC721Metadata', 'ERC721Pausable', 'ERC721Burnable', 'ERC721Holder', 'ERC721Receiver', 'ERC721MetadataMintable', 'ERC721MetadataMintable', 'ERC721Full']
        
        in_definition = False
        brace_count = 0

        for line in lines:
            line_stripped = line.strip()
            if any(f'library {def_name}' in line_stripped for def_name in common) or any(f'interface {def_name}' in line_stripped for def_name in common):
                in_definition = True
                brace_count = 0
                if '{' in line:
                    brace_count += line.count('{')
                if '}' in line:
                    brace_count -= line.count('}')
            elif in_definition:
                if '{' in line:
                    brace_count += line.count('{')
                if '}' in line:
                    brace_count -= line.count('}')
                if brace_count <= 0:
                    in_definition = False
                    continue
            else:
                modified_lines.append(line)
        
        self.sc = '\n'.join(modified_lines)
        


if __name__ == "__main__":
    sc = SmartContract()
    sc.remove_NatSpec()
    sc.remove_comments()
    sc.remove_definitions()
    # write to file
    with open('clean.sol', 'w') as f:
        f.write(sc.sc)