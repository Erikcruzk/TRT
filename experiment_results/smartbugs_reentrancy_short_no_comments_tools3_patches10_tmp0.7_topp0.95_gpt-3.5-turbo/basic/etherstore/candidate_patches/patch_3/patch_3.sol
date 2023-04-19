pragma solidity ^0.5.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance.");
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit, "Withdrawal amount exceeds limit.");
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks, "You can only withdraw once in a week.");
        require(msg.sender.send(_weiToWithdraw), "Transaction failed.");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
    }
}