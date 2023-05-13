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
        require(balances[msg.sender] >= _amount); // Check if the sender has enough balance
        require(!locked[msg.sender]); // Check if the sender is not locked
        locked[msg.sender] = true; // Lock the sender
        msg.sender.transfer(_amount); // Send the amount to the sender
        balances[msg.sender] -= _amount; // Deduct the amount from the sender's balance
        locked[msg.sender] = false; // Unlock the sender
    }

    function() public payable {}
}