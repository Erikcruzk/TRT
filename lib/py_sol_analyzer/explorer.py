from .stack import Stack
import re


class Explorer:
    DEBUG = False

    @staticmethod
    def dprint(arg):
        if Explorer.DEBUG:
            print(arg)

    @staticmethod
    def get_node_info(statement: str) -> dict:
        enclosing_node = {
            'type': None,
            'name': None
        }
        if "function" in statement:
            keyword_index = statement.strip().split(' ').index('function')
            fn_name = statement.strip().split(' ')[keyword_index + 1].split('(')[0]
            enclosing_node.update({
                'type': 'function',
                'name': fn_name
            })
        elif "constructor" in statement:
            #keyword_index = statement.strip().split(' ').index('constructor')
            #fn_name = statement.strip().split(' ')[keyword_index + 1]
            enclosing_node.update({
                'type': 'constructor',
                'name': 'constructor'
            })
        elif "contract" in statement:
            keyword_index = statement.strip().split(' ').index('contract')
            contract_name = statement.strip().split(' ')[keyword_index + 1]
            enclosing_node.update({
                'type': 'contract',
                'name': contract_name
            })
        elif "interface" in statement:
            keyword_index = statement.strip().split(' ').index('interface')
            int_name = statement.strip().split(' ')[keyword_index + 1]
            enclosing_node.update({
                'type': 'contract',
                'name': int_name
            })
        elif "library" in statement:
            keyword_index = statement.strip().split(' ').index('library')
            lib_name = statement.strip().split(' ')[keyword_index + 1]
            enclosing_node.update({
                'type': 'contract',
                'name': lib_name
            })
        elif "abstract contract" in statement:
            keyword_index = statement.strip().split(' ').index('abstract')
            contract_name = statement.strip().split(' ')[keyword_index + 2]
            enclosing_node.update({
                'type': 'contract',
                'name': contract_name
            })
        elif "modifier" in statement:
            keyword_index = statement.strip().split(' ').index('modifier')
            modifier_name = statement.strip().split(' ')[keyword_index + 1].split('(')[0]
            enclosing_node.update({
                'type': 'modifier',
                'name': modifier_name
            })
        

        return enclosing_node
    
    @staticmethod
    def get_enclosing_nodes(src, start, end) -> dict:
        Explorer.dprint(f"\nstart: {start}, end: {end}\n")
        '''
        if end is None and start is not None:
            end = start + 1
        if end is None and start is None:
            return {
                'function': None,
                'contract': None
            }
        '''
        end = start + 1

        if start > end:
            raise ValueError("Start line cannot be greater than the end line.")
        function_keywords = [
            "constructor",
            "function"
        ]

        modifier_keywords = [
            "modifier"
        ]

        contract_keywords = [
            "contract",
            "library",
            "abstract contract",
            "interface"
        ]

        stack = Stack()

        up = start + 1
        down = end - 1

        src_lines = src.split('\n')
        len_src_lines = len(src_lines)

        to_find = ['function', 'contract', 'modifier']
        enclosing_nodes = {
            'function': None,
            'contract': None
        }
        
        direction = 'down'
        c_down = 0
        c_up = 0

        while down < len_src_lines - 1 or up > 0:
            if direction == 'down':
                down += 1
                Explorer.dprint(f'-    -     -    -     -    -     -    -     -   c_down: {c_down}, down: {down}')
                if down > len_src_lines - 1:
                    Explorer.dprint(f"Reaching the end of the file, going up (next up is {up-1})... ---- stack items: {stack.items}")
                    direction = 'up'
                    continue
                if "{" in src_lines[down] and "}" in src_lines[down]:
                    pass
                elif "}" in src_lines[down] and c_down == 0:                    
                    stack.push({
                        'token': "}",
                        'line': down
                    })
                    Explorer.dprint(f"Just saw a }} going down at line {down}, going up (next up is {up-1}) ---- stack items: {stack.items}")
                    direction = 'up'
                elif "{" in src_lines[down]:
                    Explorer.dprint(f"Saw a {{ at line {down} (going down), and skipping it... ---- stack items: {stack.items}")
                    c_down += 1
                elif "}" in src_lines[down] and c_down > 0:
                    Explorer.dprint(f"Saw a }} at line {down} (going down), and skipping it... ---- stack items: {stack.items}")
                    c_down -= 1
            if direction == 'up':
                up -= 1
                if up <= 0:
                    Explorer.dprint(f"Reaching the begining of the file going up, going down (next down is {down+1}) ---- stack items: {stack.items}")
                    direction = 'down'
                    continue

                if "{" in src_lines[up] and "}" in src_lines[up]:
                    pass    
                elif "{" in src_lines[up] and c_up == 0:
                    stack.push({
                        'token': "{",
                        'line': up
                    })
                    top = stack.pop()
                    found_statement = src_lines[top['line']]
                    start_of_found_statement = top['line']

                    top = stack.pop()
                    end_of_found_statement = top['line']
                    
                    desirble = any(element in found_statement for element in function_keywords+contract_keywords+modifier_keywords)
                    if desirble:
                        statement_info = Explorer.get_node_info(found_statement)
                        to_find.remove(statement_info['type']) 
                        enclosing_nodes[statement_info['type']] = {
                            'start_line': start_of_found_statement,
                            'end_line': end_of_found_statement,
                            'name': statement_info['name']
                        }

                        if len(to_find) > 0:
                            Explorer.dprint(f"Just identified an enclosing node (at line {up}) while moving up, going down now (next down is: {down+1})")
                            direction = 'down'
                            continue
                    elif len(to_find) > 0:
                        Explorer.dprint(f"Just identified an enclosing node (at line {up}) while moving up, going down now (next down is: {down+1}) ---- stack items: {stack.items}")                            
                        direction = 'down'
                        continue
                    else:
                        break
                elif "}" in src_lines[up]:
                    Explorer.dprint(f"Saw a }} going up (at line {up}); now skipping it... ---- stack items: {stack.items}")                    
                    c_up += 1
                    Explorer.dprint(f"{'^   '*10} c_up: {c_up}")
                elif "{" in src_lines[up] and c_up > 0:
                    Explorer.dprint(f"{'^   '*10}Saw a {{ going up (at line {up}); skpping it... ---- stack items: {stack.items}")
                    c_up -= 1
                    Explorer.dprint(f"{'^   '*10} c_up: {c_up}")
        
        return enclosing_nodes

    @staticmethod
    def detect_solidity_definition_and_name(src: str) -> dict:
        
        patterns = {
            'library': r'\blibrary\b\s+(\w+)\s*{',
            'abstract contract': r'\babstract\s+contract\b\s+(\w+)\s*{',
            'contract': r'\bcontract\b\s+(\w+)\s*{',
            'interface': r'\binterface\b\s+(\w+)\s*{',
            'function': r'\bfunction\b\s+(\w+)\s*',
            'modifier': r'\bmodifier\b\s+(\w+)\s*'
        }

        matches = []
        for definition, pattern in patterns.items():
            for match in re.finditer(pattern, src):
                name = match.group(1) if definition != 'constructor' else None
                matches.append((match.start(), definition, name))

        matches.sort(key=lambda x: x[0])

        if matches:
            match = matches[0]
            return {
                'type': match[1], 
                'name': match[2]
            }
        else:
            return {
                'type': None, 
                'name': None
            }
    

    @staticmethod
    def extract_code_context_with_line_numbers(full_code, start_line, end_line=None, context_span=20):
        # If end_line is None, set it to start_line
        if end_line is None:
            end_line = start_line
        
        # Ensure line numbers are indexed from 0 for internal processing
        start_line -= 1
        end_line -= 1
        
        # Split the full code into lines
        lines = full_code.split('\n')
        
        # Calculate start and end indices, making sure they are within the bounds of the source code lines
        start_index = max(0, start_line - context_span)
        end_index = min(len(lines), end_line + context_span + 1) # +1 to include the end line itself
        
        # Join the relevant lines back into a single string
        context = '\n'.join(lines[start_index:end_index])
        
        return context
