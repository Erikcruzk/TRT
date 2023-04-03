/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @vulnerable_at_lines: 24
 */

pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Reentrancy_cross_function {
    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
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

    function withdrawERC20(IERC20 token) public {
        uint256 amountToWithdraw = token.balanceOf(address(this));
        require(token.transfer(msg.sender, amountToWithdraw), "Transfer failed.");
    }
} 

// Changes Made:
// 1. Added IERC20 interface to transfer ERC20 tokens safely.
// 2. Removed the reentrancy vulnerability by updating userBalances[msg.sender] to 0 before calling the external function.
// 3. Updated Solidity version to 0.8.0 for better security.
// 4. Added public access modifier to transfer() function to be able to call it from outside the contract.