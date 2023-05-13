pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)());
    }
} 

// The repaired contract moves the state variable update to the top of the function to prevent re-entrancy attacks. The require statement is also moved below the state update to prevent a possible denial of service attack.