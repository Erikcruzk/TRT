pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;
    address public owner;

    event Withdraw(address indexed from, uint amount);
    event Deposit(address indexed to, uint amount);
    event FrozenFunds(address indexed target, bool frozen);

    constructor() public {
        owner = msg.sender;
    }

    function donate(address to) public payable {
        credit[to] += msg.value;
        emit Deposit(to, msg.value);
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount);
        require(!frozenAccount[msg.sender]);
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address target, bool freeze) public {
        require(msg.sender == owner);
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
}