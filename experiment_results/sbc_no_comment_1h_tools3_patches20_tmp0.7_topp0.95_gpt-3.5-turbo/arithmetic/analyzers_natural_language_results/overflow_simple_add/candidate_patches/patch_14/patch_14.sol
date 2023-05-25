pragma solidity ^0.8.0;

contract Overflow_Add {
    uint256 public balance = 1;

    function add(uint256 deposit) public {
        require(deposit + balance > balance, "Deposit causes overflow");
        balance += deposit;
    }
}