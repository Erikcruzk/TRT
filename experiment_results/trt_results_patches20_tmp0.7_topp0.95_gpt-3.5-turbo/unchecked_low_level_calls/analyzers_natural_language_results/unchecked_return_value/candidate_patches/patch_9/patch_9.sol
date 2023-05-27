pragma solidity 0.4.25;

contract ReturnValue {
    function callchecked(address callee) public returns(bool){
        require(callee.call());
        return true;
    }

    function callnotchecked(address callee) public {
        require(callee.call());
    }
}