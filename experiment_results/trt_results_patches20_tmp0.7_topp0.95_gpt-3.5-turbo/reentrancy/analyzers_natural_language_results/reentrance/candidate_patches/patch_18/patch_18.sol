pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public lock;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!lock[msg.sender]); // Check if the sender is already in a withdrawal process
        require(balances[msg.sender] >= _amount); // Check if the sender has enough balance to withdraw
        lock[msg.sender] = true; // Set the lock to prevent reentrancy
        balances[msg.sender] -= _amount; // Update the balance before sending the ether
        msg.sender.transfer(_amount); // Send ether to the sender
        lock[msg.sender] = false; // Release the lock
    }

    function() public payable {}
}