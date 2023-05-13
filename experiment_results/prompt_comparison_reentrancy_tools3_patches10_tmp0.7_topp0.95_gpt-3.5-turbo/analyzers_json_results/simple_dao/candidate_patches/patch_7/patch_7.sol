pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;
    address public owner;

    event LogDeposit(address sender, uint amount);
    event LogWithdrawal(address receiver, uint amount);

    constructor() public {
        owner = msg.sender;
    }

    function donate(address to) public payable {
        require(!frozenAccount[msg.sender]);
        credit[to] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
        emit LogWithdrawal(msg.sender, amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address target) public {
        require(msg.sender == owner);
        frozenAccount[target] = true;
    }

    function unfreezeAccount(address target) public {
        require(msg.sender == owner);
        frozenAccount[target] = false;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}