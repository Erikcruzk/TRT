pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0; // Update state variable before making external call
            balance -= oCredit;

            (bool callResult, ) = msg.sender.call{value: oCredit}(""); // Use new syntax for external calls and include empty data parameter
            require(callResult, "External call failed"); // Add error message for require statement
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}