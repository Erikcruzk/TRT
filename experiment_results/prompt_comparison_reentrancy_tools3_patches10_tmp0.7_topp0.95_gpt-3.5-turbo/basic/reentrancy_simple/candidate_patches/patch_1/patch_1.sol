pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool isLocked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!isLocked);
        isLocked = true;
        uint amount = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(amount)) {
            userBalance[msg.sender] = amount;
            isLocked = false;
            revert();
        }
        isLocked = false;
    }
}