/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @fixed_at_lines: 11, 19, 21, 24
 */

pragma solidity ^0.4.24;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)("")); // At this point, the caller's code is executed, and can call transfer()
    }
    
    function withdrawERC20(address tokenAddress) public {
        ERC20 token = ERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(msg.sender, balance);
    }
} 

// Changes Made:
// 1. Added ERC20 interface to support transfer of ERC20 tokens
// 2. Added require statement in transfer() function to check if user has enough balance
// 3. Moved userBalances[msg.sender] = 0; statement before require statement in withdrawBalance() function to prevent reentrancy attack
// 4. Added withdrawERC20() function to allow users to withdraw ERC20 tokens from the contract.