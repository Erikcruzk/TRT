pragma solidity ^0.4.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked);
        locked = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked = false;
    }

    function () public payable {}
}