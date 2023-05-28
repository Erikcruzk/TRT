pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // Add a require statement to check if the user has enough credit to withdraw
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)();
        require(res); // Add a require statement to check if the external call was successful
    }

    function queryCredit(address to) public view returns (uint) { // Add the view keyword to mark the function as a read-only function
        return credit[to];
    }
}