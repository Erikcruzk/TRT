pragma solidity 0.4.25;

contract ReturnValue {
    function callchecked(address callee) public returns (bool success) {
        success = callee.call();
        require(success);
    }

    function callnotchecked(address callee) public {
        callee.call();
    }
} 

// The changes made:
// 1. Added a return value to the callchecked function to check for success of the call.
// 2. Added a require statement to check the success of the call in the callchecked function.
// 3. No changes made to the callnotchecked function as it is intentionally left unchecked.