pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) isReentrant;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!isReentrant[msg.sender]);
        isReentrant[msg.sender] = true;

        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;

        if (!msg.sender.send(balance)) {
            userBalance[msg.sender] = balance;
            isReentrant[msg.sender] = false;
            revert();
        }

        isReentrant[msg.sender] = false;
    }
}