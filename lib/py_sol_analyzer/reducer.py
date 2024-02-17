import re

def smart_replace(match):
    if (match.group().startswith('"') and match.group().endswith('"')) or \
       (match.group().startswith("'") and match.group().endswith("'")):
        return match.group()  # Return the string literal unchanged
    else:
        # It's a comment; apply the original logic
        num_newlines = match.group().count('\n')
        if num_newlines:
            return '\n' * num_newlines
        else:
            return ' '

def remove_NatSpec_and_comments(src):
    # This pattern tries to match strings or comments
    pattern = r'".*?"|\'.*?\'|\/\/.*?$|\/\*[\s\S]*?\*\/'
    src = re.sub(pattern, smart_replace, src, flags=re.MULTILINE)
    return src


'''
Sample usage:
source_code = remove_NatSpec_and_comments(source_code)
'''