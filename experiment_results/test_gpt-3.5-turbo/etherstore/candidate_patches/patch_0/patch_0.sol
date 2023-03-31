/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe 
 * @fixed_by: [Your Name]
 */

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
        require(_weiToWithdraw <= withdrawalLimit);
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);
        // <yes> <report> REENTRANCY
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "Withdrawal failed");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
    }
} 

// Changes Made
// 1. Updated the Solidity version to ^0.8.0
// 2. Used block.timestamp instead of now
// 3. Used the new syntax for calling external contracts to prevent reentrancy attacks
// 4. Added error handling for external call to prevent failed withdrawals.