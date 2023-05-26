pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) reentrancy_lock;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!reentrancy_lock[msg.sender]);
        require(balances[msg.sender] >= _amount);
        reentrancy_lock[msg.sender] = true;
        if (msg.sender.call.value(_amount)()) {
            balances[msg.sender] -= _amount;
        }
        reentrancy_lock[msg.sender] = false;
    }

    function() public payable {}
}