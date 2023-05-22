pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) private locked;

    function getBalance(address u) constant public returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint amount = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(amount);
        locked[msg.sender] = false;
    }
}