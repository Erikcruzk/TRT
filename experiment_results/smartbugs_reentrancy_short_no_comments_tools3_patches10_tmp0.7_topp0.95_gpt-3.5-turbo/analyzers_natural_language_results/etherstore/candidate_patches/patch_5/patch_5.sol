pragma solidity ^0.8.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw, "Insufficient balance");
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit, "Exceeded withdrawal limit");
        // limit the time allowed to withdraw
        require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks, "Cannot withdraw yet");
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = block.timestamp;
        (bool success, ) = msg.sender.call{value: _weiToWithdraw}("");
        require(success, "Transfer failed");
    }
}