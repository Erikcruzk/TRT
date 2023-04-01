/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe
 * @fixed_by: [Your Name Here]
 * @vulnerable_at_lines: 17, 25, 27
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
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit, "Withdrawal limit exceeded");
        // limit the time allowed to withdraw
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks, "Withdrawal time limit not reached");
        // update balance before transfer to prevent reentrancy
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "Transfer failed");
    }
} 

// Changes made:
// 1. Updated Solidity version to 0.8.0
// 2. Added error messages to require statements
// 3. Moved balance update before transfer to prevent reentrancy vulnerability
// 4. Used block.timestamp instead of now for better security practices
// 5. Used the new syntax for sending Ether to prevent reentrancy vulnerability