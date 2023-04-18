pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}