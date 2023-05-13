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

// Changes made:
// 1. Made donate and withdraw functions as public
// 2. Added require statement to check if the sender has enough credit to withdraw
// 3. Moved the decrement statement above the external call
// 4. Added require statement to check if the external call was successful