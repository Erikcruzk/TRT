pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) private locked;

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
        msg.sender.transfer(_amount);
        locked[msg.sender] = false;
    }

    function() public payable {}
}