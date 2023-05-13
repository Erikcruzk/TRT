pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
}