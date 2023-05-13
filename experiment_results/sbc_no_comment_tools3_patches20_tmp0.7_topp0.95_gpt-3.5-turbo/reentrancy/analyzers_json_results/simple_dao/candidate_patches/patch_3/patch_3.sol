pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

//Changes Made:
//1. Made the functions public
//2. Added require statements to check if the sender has sufficient credits and if the external call was successful.
//3. Moved the decrement statement before the external call to prevent reentrancy attacks.