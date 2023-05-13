pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public locked;

    function depositFunds() public payable {
        require(!locked[msg.sender]); // prevent deposit if sender is locked
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!locked[msg.sender]); // prevent withdrawal if sender is locked
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        locked[msg.sender] = true; // lock sender to prevent reentrancy
        require(msg.sender.call.value(_weiToWithdraw)());
        locked[msg.sender] = false; // unlock sender after external call completes
    }
} 

// Changes made:
// 1. Added a mapping to keep track of locked senders to prevent reentrancy.
// 2. Added checks to prevent deposit and withdrawal if sender is locked.
// 3. Moved the state variable updates before the external call to prevent reentrancy.