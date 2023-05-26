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
        locked[msg.sender] = true; // set locked state to prevent reentrancy
        msg.sender.transfer(_amount); // transfer funds before modifying balances
        balances[msg.sender] -= _amount;
        locked[msg.sender] = false; // release locked state
    }

    function() public payable {}
}