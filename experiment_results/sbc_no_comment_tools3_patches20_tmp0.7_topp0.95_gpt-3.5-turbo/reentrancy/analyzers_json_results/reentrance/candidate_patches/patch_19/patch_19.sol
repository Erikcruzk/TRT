pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public unlocked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount);
        require(!unlocked[msg.sender]);
        unlocked[msg.sender] = true;
        if (msg.sender.call.value(_amount)()) {
            _amount;
        }
        unlocked[msg.sender] = false;
        balances[msg.sender] -= _amount;
    }

    function() public payable {}
}