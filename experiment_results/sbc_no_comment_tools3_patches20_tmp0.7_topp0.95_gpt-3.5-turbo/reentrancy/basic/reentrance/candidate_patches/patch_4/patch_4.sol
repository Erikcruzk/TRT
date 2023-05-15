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
        require(!locked[msg.sender]); // prevent reentrancy
        require(balances[msg.sender] >= _amount);
        locked[msg.sender] = true; // lock the sender's account
        balances[msg.sender] -= _amount;
        if (msg.sender.call.value(_amount)()) {
            // successful transfer
        }
        locked[msg.sender] = false; // unlock the sender's account
    }

    function() public payable {}
}