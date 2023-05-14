pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lock;

    function withdrawBalance() public {
        require(!lock[msg.sender]);
        lock[msg.sender] = true;

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        lock[msg.sender] = false;
    }
} 

// The repaired smart contract adds a reentrancy guard to prevent untrusted callers from re-entering the contract in an intermediate state. 
// The reentrancy guard is implemented using a boolean lock that prevents multiple calls from the same address until the first one completes. 
// The order of operations has also been adjusted so that the state variables are written before the external call is made.