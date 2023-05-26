pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!locked[msg.sender]);
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        locked[msg.sender] = true;
        msg.sender.transfer(_weiToWithdraw);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        locked[msg.sender] = false;
    }
} 

// In the repaired contract, we added a new mapping "locked" to keep track of whether an address is currently withdrawing funds. 
// We also replaced the external call with transfer() and added a locking mechanism to prevent reentrancy attacks.