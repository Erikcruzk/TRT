pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    event Donate(address indexed _from, address indexed _to, uint _value);
    event Withdraw(address indexed _from, uint _value);

    function donate(address to) public payable {
        require(!frozenAccount[msg.sender]);
        credit[to] += msg.value;
        emit Donate(msg.sender, to, msg.value);
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address target) public {
        frozenAccount[target] = true;
    }

    function unfreezeAccount(address target) public {
        frozenAccount[target] = false;
    }
}