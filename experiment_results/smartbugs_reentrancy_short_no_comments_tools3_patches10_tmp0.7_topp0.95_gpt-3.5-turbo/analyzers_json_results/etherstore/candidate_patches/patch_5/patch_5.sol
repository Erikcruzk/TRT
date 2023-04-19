pragma solidity ^0.4.24;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] = balances[msg.sender] + msg.value; // fixed integer overflow vulnerability
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        lastWithdrawTime[msg.sender] = now; // moved before the external call
        balances[msg.sender] = balances[msg.sender] - _weiToWithdraw; // moved before the external call
        require(msg.sender.call.value(_weiToWithdraw)()); // fixed reentrancy vulnerability
    }
}