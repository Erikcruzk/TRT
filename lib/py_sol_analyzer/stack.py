class StackEmptyError(Exception):
    """Exception raised when an operation is attempted on an empty stack."""
    def __init__(self, message="Stack is empty!"):
        self.message = message
        super().__init__(self.message)

class Stack:
    def __init__(self):
        self.items = []

    def is_empty(self):
        return self.items == []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if not self.is_empty():
            return self.items.pop()
        else:
            raise StackEmptyError("Attempt to pop from empty stack")

    def peek(self):
        if not self.is_empty():
            return self.items[-1]
        else:
            raise StackEmptyError("Cannot peek, stack is empty!")

    def size(self):
        return len(self.items)
