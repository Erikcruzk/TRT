pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    bool private locked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked);
        locked = true;
        if (balances[msg.sender] >= _amount) {
            balances[msg.sender] -= _amount;
            msg.sender.transfer(_amount);
        }
        locked = false;
    }

    function() public payable {}
}