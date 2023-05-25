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
        require(!locked[msg.sender]);
        require(balances[msg.sender] >= _amount);
        locked[msg.sender] = true;
        if (msg.sender.call.value(_amount)()) {
            balances[msg.sender] -= _amount;
        }
        locked[msg.sender] = false;
    }

    function() public payable {}
} 

// The contract has been repaired by adding a reentrancy guard. The reentrancy guard is implemented by adding a boolean mapping called "locked". The "locked" mapping keeps track of whether a user is currently in the process of withdrawing funds. If the user is not locked, they can proceed with the withdrawal. If they are locked, the function will revert. The lock is set to true before the external call, and set to false after the call. This ensures that the user cannot re-enter the contract in an intermediate state. The "require" statements are added to ensure that the conditions are met before proceeding with the withdrawal.