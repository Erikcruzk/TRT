pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public locked;

    function donate(address _to) public payable {
        require(!locked[msg.sender]);
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

//The fix involves adding a locking mechanism to prevent re-entrancy attacks. The locked mapping keeps track of whether an address is currently executing the donate or withdraw functions, and reverts if an attempt is made to execute either function while the address is already in the process of executing one of them.