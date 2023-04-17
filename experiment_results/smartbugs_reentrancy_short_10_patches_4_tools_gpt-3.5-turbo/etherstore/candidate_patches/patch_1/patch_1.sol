/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe
 * @vulnerable_at_lines: 27
 */

//added pragma version
pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    bool reentrancyLock = false;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(!reentrancyLock);
        reentrancyLock = true;
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        reentrancyLock = false;
        require(msg.sender.call.value(_weiToWithdraw)());
    }
}