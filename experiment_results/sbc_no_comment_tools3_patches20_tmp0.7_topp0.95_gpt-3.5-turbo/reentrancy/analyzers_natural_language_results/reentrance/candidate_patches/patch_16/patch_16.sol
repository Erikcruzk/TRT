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
        require(!locked[msg.sender]); // ensure that the sender is not already withdrawing
        require(balances[msg.sender] >= _amount); // ensure that sender has sufficient balance
        locked[msg.sender] = true; // lock the sender
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        locked[msg.sender] = false; // unlock the sender
    }

    function() public payable {}
}