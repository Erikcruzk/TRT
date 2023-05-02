pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;

    function getBalance(address u) public constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() public payable {
        require(msg.value > 0);
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(userBalance[msg.sender] > 0);
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balance);
    }
}