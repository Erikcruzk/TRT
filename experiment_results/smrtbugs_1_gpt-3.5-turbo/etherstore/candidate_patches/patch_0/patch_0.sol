/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 17, 25, 27
 */

pragma solidity ^0.4.24;

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
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        // update balance before sending to prevent reentrancy
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;

        // <yes> <report> REENTRANCY
        require(msg.sender.call.value(_weiToWithdraw)());
    }
}