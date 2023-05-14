pragma solidity 0.4.25;

contract ReturnValue {
    function callchecked(address callee) public returns(bool success) {
        success = callee.call();
        require(success);
    }

    function callnotchecked(address callee) public {
        callee.call();
    }
}