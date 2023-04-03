/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author:
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.24;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount); // Check if the balance of the sender is greater than or equal to the amount to withdraw
    credit[msg.sender] -= amount; // Update the balance of the sender
    bool res = msg.sender.call.value(amount)(); // Send the amount to the sender
    require(res); // Check if the transaction was successful
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
} 

// Changes Made:
// 1. Added "public" visibility modifier to all functions to make them accessible from outside the contract
// 2. Added "require" statement to check if the balance of the sender is greater than or equal to the amount to withdraw
// 3. Updated the order of statements in the "withdraw" function to first update the balance of the sender and then send the amount to the sender
// 4. Added "view" modifier to the "queryCredit" function to make it a read-only function
// 5. Updated the Solidity version to ^0.4.24 to use the latest compiler version.