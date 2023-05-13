pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        if (credit[msg.sender] >= amount && !frozenAccount[msg.sender]) {
            credit[msg.sender] -= amount;
            bool res = msg.sender.call.value(amount)();
            require(res);
        }
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
    
    function freezeAccount(address target, bool freeze) public {
        frozenAccount[target] = freeze;
    }
}