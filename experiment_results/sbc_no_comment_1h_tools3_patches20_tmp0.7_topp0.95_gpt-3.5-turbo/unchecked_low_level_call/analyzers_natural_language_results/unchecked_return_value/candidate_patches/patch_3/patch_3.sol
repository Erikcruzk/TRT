pragma solidity 0.4.25;

contract ReturnValue {
    function callchecked(address callee) public returns(bool) {
        bool success;
        require(callee.call());
        success = true;
        return success;
    }

    function callnotchecked(address callee) public {
        callee.call();
    }
}