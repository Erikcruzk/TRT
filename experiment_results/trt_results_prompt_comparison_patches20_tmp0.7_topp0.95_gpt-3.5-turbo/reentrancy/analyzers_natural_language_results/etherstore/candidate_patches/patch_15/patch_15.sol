pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        lastWithdrawTime[msg.sender] = now;
        balances[msg.sender] -= _weiToWithdraw;
        require(msg.sender.call.value(_weiToWithdraw)());
    }
} 

// Changes Made:
// 1. Moved the update of state variables before the external call to prevent reentrancy attacks.
// 2. Updated the Solidity version to ^0.4.24 as it is the latest version at the time of writing.