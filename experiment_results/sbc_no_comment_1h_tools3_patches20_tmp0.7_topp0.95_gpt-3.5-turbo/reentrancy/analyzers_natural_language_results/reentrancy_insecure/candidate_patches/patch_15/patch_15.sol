pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
}

// The repaired contract adds a reentrancy lock to prevent untrusted callees from re-entering the contract in an intermediate state. It also replaces the external call with a transfer, which sends the funds directly to the user's address and prevents any reentrancy issues. Finally, it updates the Solidity version to ^0.4.24 to ensure compatibility with newer versions of Solidity.