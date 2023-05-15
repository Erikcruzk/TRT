pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // added require statement to check if the sender has enough credit to withdraw
        credit[msg.sender] -= amount;
        bool res = msg.sender.send(amount); // changed call to send to prevent re-entrancy attacks
    }

    function queryCredit(address to) public view returns (uint) { // added view keyword to indicate that the function does not modify the state of the contract
        return credit[to];
    }
}