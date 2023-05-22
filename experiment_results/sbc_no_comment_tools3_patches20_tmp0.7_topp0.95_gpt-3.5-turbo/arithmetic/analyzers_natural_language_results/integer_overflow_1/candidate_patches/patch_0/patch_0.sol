pragma solidity ^0.4.15;

contract Overflow {
    uint private sellerBalance = 0;

    function add(uint value) returns (bool) {
        require(sellerBalance + value >= sellerBalance); // ensure no overflow occurs
        sellerBalance += value;
        return true;
    }
}