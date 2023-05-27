pragma solidity ^0.4.10;

contract Caller {
    function callAddress(address a) {
        require(address(this).balance >= 1 wei, "Insufficient balance to make call.");
        bool success;
        bytes memory empty;
        (success, ) = a.call.value(1 wei)(empty);
        require(success, "External call failed.");
    }
}