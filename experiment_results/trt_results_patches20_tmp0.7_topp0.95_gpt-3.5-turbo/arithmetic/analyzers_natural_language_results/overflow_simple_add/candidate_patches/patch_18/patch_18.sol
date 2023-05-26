pragma solidity 0.4.25;

contract Overflow_Add {
    uint256 public balance = 1;

    function add(uint256 deposit) public {
        require(balance + deposit >= balance, "Integer overflow");
        balance += deposit;
    }
}