pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public locked;

    function donate(address _to) public payable {
        require(!locked[msg.sender]); // prevent reentrancy
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked[msg.sender]); // prevent reentrancy
        require(balances[msg.sender] >= _amount);
        locked[msg.sender] = true; // lock sender before sending funds
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        locked[msg.sender] = false; // unlock sender after funds are sent
    }

    function() public payable {}
}