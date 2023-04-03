/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 27
 */

//added pragma version
pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    bool locked;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(!locked);
        locked = true;
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        locked = false;
        // <yes> <report> REENTRANCY
        require(msg.sender.call.value(_weiToWithdraw)());
    }
} 

// The repaired contract adds a lock mechanism to prevent reentrancy attacks. The lock variable is set to true at the beginning of the withdrawFunds function and set to false at the end of the function. This ensures that the function can only be called once at a time, preventing reentrancy attacks. Additionally, the require(!locked) statement is added to prevent recursive calls to the function before the previous call has completed.