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
        require(!locked[msg.sender]); // Check if the caller is already withdrawing

        if (balances[msg.sender] >= _amount) {
            locked[msg.sender] = true; // Lock the caller to prevent reentrancy
            if (msg.sender.call.value(_amount)()) {
                _amount;
            }
            balances[msg.sender] -= _amount;
            locked[msg.sender] = false; // Unlock the caller after successful withdrawal
        }
    }

    function() public payable {}
}