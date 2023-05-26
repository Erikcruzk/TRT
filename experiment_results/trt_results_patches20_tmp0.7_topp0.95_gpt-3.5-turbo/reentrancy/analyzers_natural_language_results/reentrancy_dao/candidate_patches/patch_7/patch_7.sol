pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0); // Check if there is any credit to withdraw
        credit[msg.sender] = 0; // Set the credit to zero before sending funds
        balance -= oCredit;

        bool callResult = msg.sender.call.value(oCredit)();
        require(callResult); // Ensure the external call succeeded
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}