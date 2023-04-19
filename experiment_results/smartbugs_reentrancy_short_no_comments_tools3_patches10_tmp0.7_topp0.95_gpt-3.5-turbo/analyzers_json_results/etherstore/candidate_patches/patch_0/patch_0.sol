pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] = balances[msg.sender] + msg.value; //fixed integer overflow-underflow
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] = balances[msg.sender] - _weiToWithdraw; //fixed integer overflow-underflow
        lastWithdrawTime[msg.sender] = now;
        msg.sender.transfer(_weiToWithdraw); //fixed reentrancy vulnerability
    }
 }