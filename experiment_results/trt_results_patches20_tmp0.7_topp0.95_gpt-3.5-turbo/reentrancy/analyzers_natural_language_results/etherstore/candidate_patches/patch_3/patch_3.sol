pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        require(!locked[msg.sender], "Account is locked");
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!locked[msg.sender], "Account is locked");
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");
        require(_weiToWithdraw <= withdrawalLimit, "Withdrawal limit exceeded");
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks, "Withdrawal not allowed before 1 week");
        locked[msg.sender] = true;
        require(msg.sender.call.value(_weiToWithdraw)(), "Transfer failed");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        locked[msg.sender] = false;
    }
}