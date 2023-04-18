pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0, "No credit available to withdraw");
        credit[msg.sender] = 0;
        balance -= oCredit;
        (bool callResult, ) = msg.sender.call{value: oCredit}("");
        require(callResult, "Failed to send ether");
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}