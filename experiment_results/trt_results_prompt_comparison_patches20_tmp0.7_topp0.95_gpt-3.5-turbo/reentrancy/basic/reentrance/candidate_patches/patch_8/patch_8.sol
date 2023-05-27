pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    bool locked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked);
        if (balances[msg.sender] >= _amount) {
            locked = true;
            msg.sender.transfer(_amount);
            balances[msg.sender] -= _amount;
            locked = false;
        }
    }

    function() public payable {}
}