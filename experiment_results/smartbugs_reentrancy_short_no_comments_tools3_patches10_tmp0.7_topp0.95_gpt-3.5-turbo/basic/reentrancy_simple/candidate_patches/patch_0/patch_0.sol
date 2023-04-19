pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    bool locked;

    function getBalance(address u) public constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked);
        locked = true;
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(balanceToWithdraw)) {
            userBalance[msg.sender] = balanceToWithdraw;
            locked = false;
            revert();
        }
        locked = false;
    }
}