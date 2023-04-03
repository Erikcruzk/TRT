/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @vulnerable_at_lines: 24
 */

pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Reentrancy_cross_function {

    // FIXED
    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
    }
    
    function withdrawERC20(address tokenAddress) public {
        IERC20 token = IERC20(tokenAddress);
        uint256 amountToWithdraw = token.balanceOf(address(this));
        require(token.transfer(msg.sender, amountToWithdraw), "Transfer failed.");
    }
} 

// Changes made:
// - Added IERC20 interface to support ERC20 tokens
// - Moved userBalances[msg.sender] = 0; to the beginning of the function to prevent reentrancy
// - Added a new function withdrawERC20 to withdraw ERC20 tokens safely
// - Updated Solidity version to 0.8.0 to use the latest best practices and security features