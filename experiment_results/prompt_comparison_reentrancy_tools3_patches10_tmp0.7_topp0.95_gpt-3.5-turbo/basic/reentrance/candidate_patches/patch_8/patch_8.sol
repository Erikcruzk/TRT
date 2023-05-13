pragma solidity ^0.4.18;

contract Reentrancy {
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
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        locked[msg.sender] = false;
    }

    function() public payable {}
}