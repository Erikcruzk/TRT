pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping (address => uint) public credit;
    uint public balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0, "No credit available to withdraw");
        credit[msg.sender] = 0;
        balance -= oCredit;
        (bool callResult, ) = msg.sender.call{value: oCredit}("");
        require(callResult, "Failed to transfer funds");
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}