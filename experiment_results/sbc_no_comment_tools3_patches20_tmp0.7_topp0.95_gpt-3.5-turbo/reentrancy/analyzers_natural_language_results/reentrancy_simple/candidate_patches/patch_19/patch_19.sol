pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is already withdrawing funds
        locked[msg.sender] = true; // lock the user from calling this function again until the first call is complete
        uint balanceToWithdraw = userBalance[msg.sender]; // save the balance to withdraw before resetting it to prevent reentrancy
        userBalance[msg.sender] = 0;
        locked[msg.sender] = false; // unlock the user to allow future withdrawals
        if (!msg.sender.call.value(balanceToWithdraw)()) { // transfer the balance to the user
            revert(); // revert the transaction if the transfer fails
        }
    }
}