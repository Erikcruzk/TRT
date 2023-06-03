pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) reentrancy_lock;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount);
        require(!reentrancy_lock[msg.sender]);
        reentrancy_lock[msg.sender] = true;
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        reentrancy_lock[msg.sender] = false;
    }

    function() public payable {}
} 

// I added a reentrancy_lock to prevent reentrancy attacks. Additionally, I used a transfer() function instead of call.value()() function to protect against reentrancy attacks.