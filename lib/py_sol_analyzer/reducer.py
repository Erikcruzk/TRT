import re 

def replace_with_newlines_or_space(match):
    num_newlines = match.group().count('\n')
    if num_newlines:
        return '\n' * num_newlines
    else:
        return ' '

def remove_NatSpec(src:str) -> str:
    pattern = r'\/\*\*.*?\*\/|\/\/\/.*?$'
    src = re.sub(pattern, replace_with_newlines_or_space, src, flags=re.DOTALL | re.MULTILINE)    
    return src

def remove_comments(src:str) -> str:
    pattern = r'\/\*[\s\S]*?\*\/|\/\/.*?$'
    src = re.sub(pattern, replace_with_newlines_or_space, src, flags=re.MULTILINE)
    return src

'''
Sample usage:
code_without_NatSpec = remove_NatSpec(source_code)
source_code = remove_comments(code_without_NatSpec)
'''