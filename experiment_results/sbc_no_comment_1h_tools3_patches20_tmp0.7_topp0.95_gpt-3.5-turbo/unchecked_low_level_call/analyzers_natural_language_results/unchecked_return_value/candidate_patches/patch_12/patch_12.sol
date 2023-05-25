pragma solidity 0.4.25;

contract ReturnValue {
    function callchecked(address callee) public returns (bool) {
        return callee.call();
    }

    function callnotchecked(address callee) public {
        callee.call();
        require(true); // Add a require statement to check for success or failure
    }
}