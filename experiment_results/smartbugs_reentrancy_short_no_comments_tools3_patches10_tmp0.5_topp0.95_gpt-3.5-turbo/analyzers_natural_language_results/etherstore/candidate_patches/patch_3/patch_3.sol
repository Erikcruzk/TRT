pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        require(msg.value > 0);
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] = balances[msg.sender] - _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        msg.sender.transfer(_weiToWithdraw);
    }
}