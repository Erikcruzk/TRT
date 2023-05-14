pragma solidity 0.4.25;

contract Overflow_Add {
    uint public balance = 1;

    function add(uint256 deposit) public {
        require(deposit <= (2**256 - 1) - balance); // Check for potential overflow
        balance += deposit;
    }
}