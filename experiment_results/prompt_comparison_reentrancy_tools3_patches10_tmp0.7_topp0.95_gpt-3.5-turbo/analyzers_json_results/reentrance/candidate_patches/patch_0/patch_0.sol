pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public locked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked[msg.sender]);
        require(balances[msg.sender] >= _amount);

        locked[msg.sender] = true;
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        locked[msg.sender] = false;
    }

    function() public payable {}
} 

// Changes Made:
// 1. Added a new mapping called locked to keep track of locked accounts during withdrawal to prevent reentrancy.
// 2. Added a require statement to check if the account is not locked before proceeding with withdrawal.
// 3. Changed the external call to msg.sender.transfer() to transfer the amount to prevent reentrancy.
// 4. Moved the deduction of the withdrawn amount from the balance to after the transfer to prevent reentrancy.