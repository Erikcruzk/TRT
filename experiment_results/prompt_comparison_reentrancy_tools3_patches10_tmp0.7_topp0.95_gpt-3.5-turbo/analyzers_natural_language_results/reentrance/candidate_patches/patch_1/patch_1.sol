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
        require(!locked[msg.sender]); // check if the sender is already in a withdraw state
        require(balances[msg.sender] >= _amount); // check if the balance is sufficient
        locked[msg.sender] = true; // set the sender in a withdraw state
        if (msg.sender.call.value(_amount)()) {
            balances[msg.sender] -= _amount;
        }
        locked[msg.sender] = false; // reset the withdraw state
    }

    function() public payable {}
}