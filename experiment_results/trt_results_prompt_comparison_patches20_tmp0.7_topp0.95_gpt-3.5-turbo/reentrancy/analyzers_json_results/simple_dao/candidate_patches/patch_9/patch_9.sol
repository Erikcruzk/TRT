pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) public payable {
        require(!frozenAccount[to]);
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
    
    function freezeAccount(address to) public {
        frozenAccount[to] = true;
    }
    
    function unfreezeAccount(address to) public {
        frozenAccount[to] = false;
    }
}