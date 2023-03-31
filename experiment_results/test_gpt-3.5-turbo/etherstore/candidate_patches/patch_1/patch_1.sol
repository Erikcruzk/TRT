/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe
 */

pragma solidity ^0.4.24;

contract EtherStore {
    uint256 private withdrawalLimit = 1 ether;
    mapping(address => uint256) private lastWithdrawTime;
    mapping(address => uint256) private balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        // <yes> <report> REENTRANCY
        lastWithdrawTime[msg.sender] = now;
        balances[msg.sender] -= _weiToWithdraw;
        msg.sender.transfer(_weiToWithdraw);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function increaseWithdrawalLimit(uint256 _newLimit) public {
        require(_newLimit > withdrawalLimit);
        withdrawalLimit = _newLimit;
    }
}