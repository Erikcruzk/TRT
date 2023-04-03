/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 27
 */

pragma solidity ^0.5.0;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    bool private locked;

    modifier noReentrancy() {
        require(!locked, "Reentrant call detected!");
        locked = true;
        _;
        locked = false;
    }

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public noReentrancy {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // <yes> <report> REENTRANCY
        (bool success, ) = msg.sender.call.value(_weiToWithdraw)("");
        require(success, "Failed to transfer funds");
    }
} 

// The repaired contract includes a noReentrancy modifier to prevent reentrancy attacks. It also includes a private boolean variable called locked to keep track of whether the contract is currently being executed, and a require statement to check if the locked variable is false before executing the function. Finally, the external call has been moved to the end of the function to prevent reentrancy attacks from occurring.