pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // Add a require statement to check if the sender has enough credit to withdraw
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount); // Use transfer() instead of call.value() to prevent reentrancy attacks
    }

    function queryCredit(address to) public view returns (uint) { // Add view keyword to indicate that this function does not modify state
        return credit[to];
    }
}