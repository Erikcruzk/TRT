pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) public credit;
    uint public balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0, "No credit to withdraw");

        balance -= oCredit;
        credit[msg.sender] = 0;
        (bool callResult, ) = msg.sender.call{value: oCredit}("");
        require(callResult, "Failed to transfer ether");
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}