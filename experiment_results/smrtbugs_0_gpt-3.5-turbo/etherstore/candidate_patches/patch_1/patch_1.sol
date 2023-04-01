//fixed pragma version and reentrancy vulnerability
pragma solidity ^0.5.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(!locked[msg.sender]); // prevent reentrancy
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        locked[msg.sender] = true; // lock the sender
        balances[msg.sender] -= _weiToWithdraw;
        msg.sender.transfer(_weiToWithdraw); // transfer funds
        locked[msg.sender] = false; // unlock the sender
        lastWithdrawTime[msg.sender] = now;
    }
}