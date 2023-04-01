/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your name here]
 * @vulnerable_at_lines: 17, 25, 27
 */

//added pragma version
pragma solidity ^0.8.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    //added a variable to prevent reentrancy
    bool private locked;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(!locked, "Withdrawal is locked");
        locked = true;
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);
        // <yes> <report> REENTRANCY
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "Transfer failed.");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
        locked = false;
    }
 } 

// Changes made:
// 1. Updated pragma version to ^0.8.0
// 2. Added a bool variable 'locked' to prevent reentrancy
// 3. Used block.timestamp instead of now
// 4. Used the new syntax for external function calls
// 5. Added error handling for external function calls