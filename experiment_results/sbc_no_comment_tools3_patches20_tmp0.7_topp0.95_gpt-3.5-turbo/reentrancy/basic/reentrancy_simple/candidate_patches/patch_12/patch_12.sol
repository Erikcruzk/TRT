pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    bool locked;

    function getBalance(address u) public view returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        require(!locked);
        userBalance[msg.sender] += msg.value;
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