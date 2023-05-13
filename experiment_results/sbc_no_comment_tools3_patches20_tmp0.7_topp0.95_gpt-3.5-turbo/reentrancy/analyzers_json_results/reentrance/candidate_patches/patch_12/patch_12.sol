pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public isLocked;

    function donate(address _to) public payable {
        require(!isLocked[_to]); // prevent reentrancy attack
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!isLocked[msg.sender]); // prevent reentrancy attack
        require(balances[msg.sender] >= _amount);
        isLocked[msg.sender] = true; // lock the contract to prevent multiple withdrawals
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        isLocked[msg.sender] = false; // release the lock
    }

    function() public payable {}
}