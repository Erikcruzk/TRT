pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        require(!locked[msg.sender]);
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!locked[msg.sender]);
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        locked[msg.sender] = true;
        require(msg.sender.call.value(_weiToWithdraw)());
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        locked[msg.sender] = false;
    }
} 

// Changes made:
// 1. Added a mapping to track locked accounts to prevent reentrancy.
// 2. Added a check for locked accounts before depositing or withdrawing funds.
// 3. Moved the locking of accounts before the external call.
// 4. Updated the Solidity version to ^0.4.24.