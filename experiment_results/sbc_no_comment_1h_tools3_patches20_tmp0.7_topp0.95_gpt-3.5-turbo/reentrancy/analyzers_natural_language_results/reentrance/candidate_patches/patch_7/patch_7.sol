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
        require(!locked[msg.sender]); // add reentrancy guard
        if (balances[msg.sender] >= _amount) {
            locked[msg.sender] = true; // lock the sender
            if (msg.sender.call.value(_amount)()) {
                _amount;
            }
            balances[msg.sender] -= _amount;
            locked[msg.sender] = false; // unlock the sender
        }
    }

    function() public payable {}
}