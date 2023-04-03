/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 27
 * @description: This contract fixes the vulnerabilities found in the original EtherStore contract
 */

//added pragma version
pragma solidity ^0.5.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(!locked[msg.sender], "Account is locked");
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit, "Withdrawal limit exceeded");
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks, "Withdrawal not allowed yet");
        // lock account before making external call
        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call.value(_weiToWithdraw)("");
        require(success, "External call failed");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // unlock account after successful withdrawal
        locked[msg.sender] = false;
    }
}