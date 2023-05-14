pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private reentrancyGuard;

    function withdrawBalance() public {
        require(reentrancyGuard[msg.sender] == false); // check if reentrancy guard is active
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // check if user has balance to withdraw
        userBalances[msg.sender] = 0; // set balance to 0 before external call
        reentrancyGuard[msg.sender] = true; // activate reentrancy guard
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success); // check if external call succeeded
        reentrancyGuard[msg.sender] = false; // deactivate reentrancy guard
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
}