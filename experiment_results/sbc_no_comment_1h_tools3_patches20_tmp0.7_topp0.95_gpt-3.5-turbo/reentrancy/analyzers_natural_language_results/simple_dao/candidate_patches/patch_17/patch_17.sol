pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozen;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!frozen[msg.sender], "Your account is frozen.");
        require(credit[msg.sender] >= amount, "Not enough balance.");
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res, "Transaction failed.");
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address account) public {
        frozen[account] = true;
    }

    function unfreezeAccount(address account) public {
        frozen[account] = false;
    }
}