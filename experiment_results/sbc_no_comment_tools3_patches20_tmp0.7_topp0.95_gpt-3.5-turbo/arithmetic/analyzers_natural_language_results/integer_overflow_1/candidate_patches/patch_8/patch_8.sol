pragma solidity ^0.4.15;

contract Overflow {
    uint private sellerBalance = 0;

    function add(uint value) returns (bool) {
        require(value + sellerBalance >= sellerBalance); // check for overflow
        sellerBalance += value;
        return true;
    }
}