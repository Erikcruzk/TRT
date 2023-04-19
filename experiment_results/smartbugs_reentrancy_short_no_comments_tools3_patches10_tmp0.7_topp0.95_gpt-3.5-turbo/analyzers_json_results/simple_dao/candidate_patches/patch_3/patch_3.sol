pragma solidity ^0.8.0;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) payable public {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount, "Insufficient credit");
    credit[msg.sender] -= amount;
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Withdrawal failed");
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
} 

// Changes made:
// 1. Updated Solidity version to 0.8.0
// 2. Made the donate and withdraw functions public
// 3. Added a require statement to check if the user has enough credit to withdraw
// 4. Updated the logic of the withdraw function to first reduce the credit amount and then transfer the funds to the user
// 5. Used the new syntax for external calls and added a require statement to check if the withdrawal was successful.