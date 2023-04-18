pragma solidity ^0.4.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(_weiToWithdraw > 0);
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        lastWithdrawTime[msg.sender] = now;
        balances[msg.sender] -= _weiToWithdraw;
        msg.sender.transfer(_weiToWithdraw);
    }
}