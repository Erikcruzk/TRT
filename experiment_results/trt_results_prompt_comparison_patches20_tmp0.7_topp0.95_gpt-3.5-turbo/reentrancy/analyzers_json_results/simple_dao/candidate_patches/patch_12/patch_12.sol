pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;
    address public owner;

    event Withdraw(address indexed from, address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    function SimpleDAO() {
        owner = msg.sender;
    }

    function donate(address to) payable {
        require(!frozenAccount[msg.sender]); // Check if sender is not frozen
        credit[to] += msg.value;
        Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) {
        require(!frozenAccount[msg.sender]); // Check if sender is not frozen
        require(credit[msg.sender] >= amount); // Check if sender has enough credit
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount); // Use transfer instead of call
        Withdraw(msg.sender, owner, amount);
    }

    function queryCredit(address to) returns (uint) {
        return credit[to];
    }

    function freezeAccount(address target) {
        require(msg.sender == owner); // Only owner can freeze accounts
        frozenAccount[target] = true;
    }

    function unfreezeAccount(address target) {
        require(msg.sender == owner); // Only owner can unfreeze accounts
        frozenAccount[target] = false;
    }
}