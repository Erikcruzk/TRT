/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe
 * @vulnerable_at_lines: 27
 */

//added pragma version
pragma solidity ^0.8.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
        // <yes> <report> REENTRANCY
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "Transfer failed.");
    }
} 

// Changes made:
// 1. Updated the Solidity version to 0.8.0
// 2. Changed the now keyword to block.timestamp
// 3. Moved the lastWithdrawTime[msg.sender] = block.timestamp; statement before the external call to prevent reentrancy attacks
// 4. Changed the external call to the new syntax with a boolean return value and added a require statement to check if the transfer was successful.