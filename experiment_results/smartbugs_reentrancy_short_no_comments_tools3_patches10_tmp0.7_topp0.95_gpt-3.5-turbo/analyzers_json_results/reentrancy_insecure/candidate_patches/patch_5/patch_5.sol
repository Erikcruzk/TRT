pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        require(msg.sender.call.value(amountToWithdraw)());
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}