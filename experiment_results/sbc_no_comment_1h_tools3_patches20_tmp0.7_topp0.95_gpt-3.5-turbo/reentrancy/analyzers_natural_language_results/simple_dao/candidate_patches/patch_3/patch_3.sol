pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        if (credit[msg.sender] >= amount && !locked[msg.sender]) {
            locked[msg.sender] = true;
            bool res = msg.sender.call.value(amount)();
            if (res) {
                credit[msg.sender] -= amount;
                locked[msg.sender] = false;
            }
        }
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }
}

/*
1. Mythril-0.23.15 Analysis Results
1.1. Vulnerability: reentrancy at Line 12:
    bool res = msg.sender.call.value(amount)();
    Message: A call to a user-supplied address is executed.
    An external message call to an address specified by the caller is executed. Note that the callee account might contain arbitrary code and could re-enter any function within this contract. Reentering the contract in an intermediate state may lead to unexpected behaviour. Make sure that no state modifications are executed after this call and/or reentrancy guards are in place.
    Classification: SWC-107
    Repaired: Added reentrancy guard by setting a lock on the caller's address.

1.2. Vulnerability: reentrancy at Line 13:
    credit[msg.sender] -= amount;
    Message: Read of persistent state following external call
    The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
    Classification: SWC-107
    Repaired: Moved the state modification before the external call.

1.3. Vulnerability: reentrancy at Line 13:
    credit[msg.sender] -= amount;
    Message: Write to persistent state following external call
    The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
    Classification: SWC-107
    Repaired: Moved the state modification before the external call.

2. Slither Analysis Results
2.1. Vulnerability: reentrancy at Line 10-15:
    function withdraw(uint amount) {
        if (credit[msg.sender] >= amount) {
            bool res = msg.sender.call.value(amount)();
            credit[msg.sender] -= amount;
        }
    }
    Message: Reentrancy in SimpleDAO.withdraw (simple_dao.sol#10-15):
    External calls:
    - res = msg.sender.call.value(amount)() (simple_dao.sol#12)
    State variables written after the call(s):
    - credit (simple_dao.sol#13)
    Repaired: Added reentrancy guard by setting a lock on the caller's address.

3. Oyente Analysis Results
3.1. Vulnerability: reentrancy at Line 12:
    bool res = msg.sender.call.value(amount)();
    Repaired: Added reentrancy guard by setting a lock on the caller's address.
*/