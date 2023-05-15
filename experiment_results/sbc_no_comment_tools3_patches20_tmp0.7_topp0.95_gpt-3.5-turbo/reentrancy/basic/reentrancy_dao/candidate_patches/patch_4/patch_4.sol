pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint256) credit;
    uint256 balance;

    function withdrawAll() public {
        uint256 oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            require(balance >= oCredit, "Insufficient balance");
            balance -= oCredit;
            (bool success, ) = msg.sender.call{value: oCredit}("");
            require(success, "Transfer failed");
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}