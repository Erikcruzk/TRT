pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public locked;

    function donate(address _to) public payable {
        require(!locked[_to]); // prevent donation if already in a reentrant call
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked[msg.sender]); // prevent reentrancy
        require(balances[msg.sender] >= _amount);

        locked[msg.sender] = true; // lock the sender to prevent reentrant calls
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        locked[msg.sender] = false; // unlock the sender after the call
    }

    function() public payable {}
}