pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!locked[msg.sender]); // check if the caller is not already in a withdraw call
        require(credit[msg.sender] >= amount); // check if the caller has enough credit to withdraw
        locked[msg.sender] = true; // lock the caller to prevent reentrancy
        msg.sender.transfer(amount); // send the amount to the caller
        credit[msg.sender] -= amount; // update the credit after the transfer
        locked[msg.sender] = false; // unlock the caller
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}