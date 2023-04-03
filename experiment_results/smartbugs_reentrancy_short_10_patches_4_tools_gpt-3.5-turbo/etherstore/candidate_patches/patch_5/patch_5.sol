/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your Name]
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
        // <yes> <report> REENTRANCY
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success);
    }
 } 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Used block.timestamp instead of now
// 3. Moved the state changes before the external call to prevent reentrancy attacks
// 4. Used the new Solidity syntax for external calls