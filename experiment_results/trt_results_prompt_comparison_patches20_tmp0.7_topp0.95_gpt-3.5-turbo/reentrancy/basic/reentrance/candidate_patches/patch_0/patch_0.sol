pragma solidity ^0.8.0;

contract Reentrance {
    mapping(address => uint) public balances;
    bool private locked;

    constructor() {
        locked = false;
    }

    function donate(address _to) public payable {
        require(!locked, "Contract is locked for withdrawal");
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked, "Contract is locked for withdrawal");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        locked = true;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Withdrawal failed");
        balances[msg.sender] -= _amount;
        locked = false;
    }

    receive() external payable {}

    fallback() external payable {}
}