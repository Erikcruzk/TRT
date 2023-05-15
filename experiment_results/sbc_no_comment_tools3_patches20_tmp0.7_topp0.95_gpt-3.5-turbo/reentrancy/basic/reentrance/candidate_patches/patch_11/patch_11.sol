pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    bool locked;

    function donate(address _to) public payable {
        require(!locked); // Added a check to prevent reentrancy
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked); // Added a check to prevent reentrancy
        if (balances[msg.sender] >= _amount) {
            locked = true; // Set the lock before the external call
            msg.sender.transfer(_amount); // Use transfer to prevent reentrancy
            balances[msg.sender] -= _amount;
            locked = false; // Release the lock after the external call
        }
    }

    function() public payable {}
}