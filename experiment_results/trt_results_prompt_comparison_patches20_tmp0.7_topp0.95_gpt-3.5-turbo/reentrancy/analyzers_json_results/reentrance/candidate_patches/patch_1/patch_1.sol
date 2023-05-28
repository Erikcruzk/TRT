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

// Changes made:
// 1. Added a new mapping called 'locked' to prevent reentrancy attack.
// 2. Replaced the external call with transfer in the withdraw function to avoid reentrancy vulnerability.
// 3. Added 'require' statements to check if the user is locked or not and whether they have enough balance to withdraw.