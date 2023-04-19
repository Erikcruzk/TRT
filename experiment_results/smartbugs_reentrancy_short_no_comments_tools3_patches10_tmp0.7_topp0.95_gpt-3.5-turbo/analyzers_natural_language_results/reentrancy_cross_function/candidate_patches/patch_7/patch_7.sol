pragma solidity ^0.4.0;

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] = userBalances[to] + amount; // Fixed integer overflow vulnerability
            userBalances[msg.sender] = userBalances[msg.sender] - amount; // Fixed integer underflow vulnerability
        }
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Moved before the external call to prevent reentrancy
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // At this point, the caller's code is executed, and can call transfer()
        require(success);
    }
}