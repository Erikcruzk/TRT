pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool private locked;

    modifier noReentrant() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public noReentrant {
        require(userBalance[msg.sender] > 0);
        uint balance = userBalance[msg.sender];
        msg.sender.transfer(balance);
        userBalance[msg.sender] = 0;
    }
}