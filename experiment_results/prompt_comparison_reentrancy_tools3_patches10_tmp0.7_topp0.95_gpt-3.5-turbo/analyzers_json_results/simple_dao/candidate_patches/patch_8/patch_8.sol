pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    event Donation(address indexed from, address indexed to, uint value);
    event Withdrawal(address indexed to, uint value);

    function donate(address to) public payable {
        require(!frozenAccount[msg.sender], "Your account is frozen.");
        credit[to] += msg.value;
        emit Donation(msg.sender, to, msg.value);
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender], "Your account is frozen.");
        require(credit[msg.sender] >= amount, "Insufficient balance.");
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
        emit Withdrawal(msg.sender, amount);
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