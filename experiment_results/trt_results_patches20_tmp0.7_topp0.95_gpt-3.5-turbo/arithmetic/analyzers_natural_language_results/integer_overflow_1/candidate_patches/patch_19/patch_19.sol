pragma solidity ^0.4.15;

contract Overflow {
    uint private sellerBalance = 0;

    function add(uint value) returns (bool) {
        require(sellerBalance + value >= sellerBalance); // Check for integer overflow
        sellerBalance += value;
        return true;
    }
}