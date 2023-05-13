pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            balance -= oCredit;
            credit[msg.sender] = 0;
            (bool callResult, ) = msg.sender.call{value: oCredit}("");
            require(callResult, "Failed to transfer ether");
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}