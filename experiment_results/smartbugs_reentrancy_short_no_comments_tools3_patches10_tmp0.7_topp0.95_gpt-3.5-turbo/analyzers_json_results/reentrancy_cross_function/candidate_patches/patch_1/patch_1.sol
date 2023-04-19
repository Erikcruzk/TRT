pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    
    mapping (address => uint) private userBalances;
    bool private locked;
    
    function transfer(address to, uint amount) {
        require(!locked);
        require(userBalances[msg.sender] >= amount);
        locked = true;
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
        locked = false;
    }

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked = false;
    }
} 

// The repaired smart contract includes a locking mechanism to prevent reentrancy attacks. The transfer function now includes require statements to check if the contract is locked and if the sender has enough funds to transfer. The withdrawBalance function also includes require statements to check if the contract is locked and if the user has enough funds to withdraw. The function now transfers funds to the user's address using the transfer function instead of calling the user's code directly, preventing reentrancy attacks.