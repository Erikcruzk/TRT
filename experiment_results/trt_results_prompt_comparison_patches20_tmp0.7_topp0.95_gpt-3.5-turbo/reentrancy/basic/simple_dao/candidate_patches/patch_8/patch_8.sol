pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // added a require statement to check if the sender has enough credit
        credit[msg.sender] -= amount;
        bool res = msg.sender.send(amount); // changed call to send as it is safer
    }

    function queryCredit(address to) public view returns (uint) { // added view modifier to indicate that it is a read-only function
        return credit[to];
    }
}