pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    event FundsDeposited(address indexed depositor, uint256 amount);
    event FundsWithdrawn(address indexed withdrawer, uint256 amount);

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        emit FundsWithdrawn(msg.sender, _weiToWithdraw);
        require(msg.sender.call.value(_weiToWithdraw)());
    }
} 

// Changes made:
// - Moved the emit FundsWithdrawn event before the external call to prevent reentrancy attack
// - Added emit FundsDeposited event for better transparency
// - Updated pragma version to 0.4.24 for security updates.