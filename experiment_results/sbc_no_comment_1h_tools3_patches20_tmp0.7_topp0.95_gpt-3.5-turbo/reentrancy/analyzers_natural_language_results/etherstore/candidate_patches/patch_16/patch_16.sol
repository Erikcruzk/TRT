pragma solidity ^0.4.0;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!locked[msg.sender], "Withdrawal is locked");
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");

        require(_weiToWithdraw <= withdrawalLimit, "Exceeds withdrawal limit");

        require(now >= lastWithdrawTime[msg.sender] + 1 weeks, "Withdrawal not yet available");

        locked[msg.sender] = true;
        if(msg.sender.call.value(_weiToWithdraw)()) {
            balances[msg.sender] -= _weiToWithdraw;
            lastWithdrawTime[msg.sender] = now;
            locked[msg.sender] = false;
        } else {
            locked[msg.sender] = false;
            revert("Transaction failed");
        }
    }
}