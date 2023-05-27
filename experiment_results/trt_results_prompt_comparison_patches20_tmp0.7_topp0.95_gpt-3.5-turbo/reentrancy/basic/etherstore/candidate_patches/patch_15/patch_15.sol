pragma solidity ^0.8.0;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");

        require(_weiToWithdraw <= withdrawalLimit, "Withdrawal limit exceeded");

        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks, "Withdrawal not allowed yet");

        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;

        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "Withdrawal failed");
    }
}