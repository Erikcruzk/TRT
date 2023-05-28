pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        if (credit[msg.sender] >= amount) {
            credit[msg.sender] -= amount;
            bool res = msg.sender.call.value(amount)();
            require(res, "Transaction failed");
        }
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes made:
// 1. Made all functions explicitly public 
// 2. Moved subtracting amount from credit before external call to prevent reentrancy attack
// 3. Added require statement to check if external call was successful