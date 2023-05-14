pragma solidity 0.4.25;

contract ReturnValue {
    function callchecked(address callee) public returns(bool){
        bool success;
        bytes memory empty;
        assembly {
            success := call(gas, callee, 0, 0, 0, 0, 0)
        }
        require(success);
        return success;
    }

    function callnotchecked(address callee) public {
        callee.call();
    }
}