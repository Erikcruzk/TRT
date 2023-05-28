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
        msg.sender.transfer(_weiToWithdraw);
    }
} 

// Changes:
// 1. Updated the solidity version to ^0.4.24
// 2. Reordered the statements in the withdrawFunds function to first update the state variables and then transfer the funds to prevent reentrancy attacks
// 3. Replaced msg.sender.call.value() with msg.sender.transfer() to prevent reentrancy attacks
// 4. Removed the unnecessary null values from the vulnerability findings in the comments