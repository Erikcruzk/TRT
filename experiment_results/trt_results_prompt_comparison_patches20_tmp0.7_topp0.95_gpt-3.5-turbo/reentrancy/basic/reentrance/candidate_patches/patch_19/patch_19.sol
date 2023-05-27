pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    bool locked;

    function donate(address _to) public payable {
        require(!locked);
        locked = true;
        balances[_to] += msg.value;
        locked = false;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked);
        require(balances[msg.sender] >= _amount);
        locked = true;
        balances[msg.sender] -= _amount;
        locked = false;
        msg.sender.transfer(_amount);
    }

    function() public payable {}
}