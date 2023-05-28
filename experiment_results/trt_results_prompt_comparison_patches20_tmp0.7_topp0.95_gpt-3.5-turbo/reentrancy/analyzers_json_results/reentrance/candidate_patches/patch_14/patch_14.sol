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
        require(balances[msg.sender] >= _amount);
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        balances[msg.sender] -= _amount;
        if (msg.sender.call.value(_amount)()) {
            locked[msg.sender] = false;
        }
    }

    function() public payable {}
} 

//Added a locked mapping to prevent reentrancy attacks. Also added require statements to check if the user has enough balance and if the user is not already locked. Finally, moved the balances[msg.sender] -= _amount; statement before the external call to prevent reentrancy attacks.