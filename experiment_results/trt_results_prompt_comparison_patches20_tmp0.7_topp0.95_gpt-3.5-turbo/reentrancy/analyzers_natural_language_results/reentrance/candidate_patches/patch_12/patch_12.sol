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
        require(!locked[msg.sender]); // Prevent reentrancy
        require(balances[msg.sender] >= _amount);
        locked[msg.sender] = true; // Lock the user's account to prevent reentrancy

        if (msg.sender.call.value(_amount)()) {
            balances[msg.sender] -= _amount;
        }
        locked[msg.sender] = false; // Unlock the user's account
    }

    function() public payable {}
}