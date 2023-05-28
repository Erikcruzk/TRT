pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if locked
        locked[msg.sender] = true; // lock
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balanceToWithdraw);
        locked[msg.sender] = false; // unlock
    }
}