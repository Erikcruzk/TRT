/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 27
 */

pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    bool private locked;

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public noReentrancy {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        require(msg.sender.call.value(_weiToWithdraw)());
    }
} 

// Changes Made:
// 1. Added a bool variable 'locked' to prevent reentrancy
// 2. Added a modifier 'noReentrancy' to ensure only one instance of the function is running at a time. 
// 3. Moved the 'require' statement for sending ether to the end of the function to prevent reentrancy attacks. 
// 4. Updated the pragma version to 0.4.24 to fix the solc-version vulnerability.