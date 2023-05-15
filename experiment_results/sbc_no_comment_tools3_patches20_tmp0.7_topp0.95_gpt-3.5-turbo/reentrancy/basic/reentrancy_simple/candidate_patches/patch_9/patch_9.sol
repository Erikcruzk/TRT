pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool private locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        require(!locked);
        locked = true;
        userBalance[msg.sender] += msg.value;
        locked = false;
    }

    function withdrawBalance() public {
        require(!locked);
        locked = true;
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balanceToWithdraw);
        locked = false;
    }
}