pragma solidity ^0.4.10;

contract Caller {
    function callAddress(address a) public returns(bool){
        return a.call();
    }
}