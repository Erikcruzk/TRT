pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;
    
    event LogDonation(address indexed donor, uint value);
    event LogWithdrawal(address indexed beneficiary, uint value);

    function donate(address to) public payable {
        credit[to] += msg.value;
        emit LogDonation(msg.sender, msg.value);
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
        frozenAccount[target] = true;
    }

    function unfreezeAccount(address target) public {
        frozenAccount[target] = false;
    }
}