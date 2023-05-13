pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function donate(address to) public payable {
        require(!frozenAccount[msg.sender]);
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address account) public {
        require(msg.sender == owner);
        frozenAccount[account] = true;
    }

    function unfreezeAccount(address account) public {
        require(msg.sender == owner);
        frozenAccount[account] = false;
    }
}