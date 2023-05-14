pragma solidity 0.8.0;

contract ReturnValue {
    function callchecked(address callee) public returns(bool) {
        (bool success,) = callee.call("");
        require(success);
        return success;
    }

    function callnotchecked(address callee) public {
        callee.call("");
    }
}