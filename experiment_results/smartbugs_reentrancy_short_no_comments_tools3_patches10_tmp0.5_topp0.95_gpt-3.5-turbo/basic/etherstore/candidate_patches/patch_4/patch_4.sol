pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(_weiToWithdraw <= withdrawalLimit);
        require(balances[msg.sender] >= _weiToWithdraw);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        require(msg.sender.send(_weiToWithdraw));
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
    }
}