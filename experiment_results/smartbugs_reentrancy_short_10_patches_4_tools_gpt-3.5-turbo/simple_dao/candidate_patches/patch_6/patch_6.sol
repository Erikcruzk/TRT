/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping (address => uint) public credit;
    mapping (address => bool) public frozenAccount;

    event LogDonate(address indexed _from, address indexed _to, uint _value);
    event LogWithdrawal(address indexed _from, uint _value);
    event LogFreeze(address indexed _account);
    event LogUnfreeze(address indexed _account);

    function donate(address _to) public payable {
        require(!frozenAccount[_to], "Account is frozen");
        credit[_to] += msg.value;
        emit LogDonate(msg.sender, _to, msg.value);
    }

    function withdraw(uint _amount) public {
        require(!frozenAccount[msg.sender], "Account is frozen");
        require(credit[msg.sender] >= _amount, "Insufficient balance");
        credit[msg.sender] -= _amount;
        emit LogWithdrawal(msg.sender, _amount);
        msg.sender.transfer(_amount);
    }

    function queryCredit(address _to) public view returns (uint) {
        return credit[_to];
    }

    function freezeAccount(address _account) public {
        require(!frozenAccount[_account], "Account already frozen");
        frozenAccount[_account] = true;
        emit LogFreeze(_account);
    }

    function unfreezeAccount(address _account) public {
        require(frozenAccount[_account], "Account not frozen");
        frozenAccount[_account] = false;
        emit LogUnfreeze(_account);
    }
} 

// Changes Made:
// 1. Added events to track donations, withdrawals, and account freeze/unfreeze.
// 2. Added a mapping to keep track of frozen accounts.
// 3. Replaced call.value() with transfer() to prevent reentrancy vulnerability.
// 4. Added require statements to check for frozen accounts and sufficient balance.