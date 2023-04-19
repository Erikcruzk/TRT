pragma solidity ^0.4.26;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance.");
        require(_weiToWithdraw <= withdrawalLimit, "Withdrawal amount exceeds limit.");
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks, "Cannot withdraw before 1 week.");
        balances[msg.sender] = balances[msg.sender] - _weiToWithdraw;
        msg.sender.transfer(_weiToWithdraw);
        lastWithdrawTime[msg.sender] = now;
    }
}