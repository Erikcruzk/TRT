pragma solidity ^0.8.0;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public hasWithdrawn;

    function donate(address to) payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) {
        require(credit[msg.sender] >= amount, "Insufficient credit");
        require(hasWithdrawn[msg.sender] == false, "Withdrawal has already been made");

        hasWithdrawn[msg.sender] = true;
        credit[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal failed");
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// Changes made:
// 1. Added a new mapping to track if a user has already made a withdrawal to prevent reentrancy attack
// 2. Added require statements to check for sufficient credit and if withdrawal has already been made
// 3. Moved the state variable modification before the external call to prevent reentrancy attack
// 4. Updated the syntax for external calls to the latest version of Solidity.