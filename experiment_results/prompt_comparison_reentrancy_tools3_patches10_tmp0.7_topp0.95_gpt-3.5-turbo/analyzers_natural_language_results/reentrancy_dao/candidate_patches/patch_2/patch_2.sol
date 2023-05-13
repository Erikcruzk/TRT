pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0; // Set credit to 0 before making external call to prevent reentrancy
            balance -= oCredit;

            bool callResult = msg.sender.call.value(oCredit)();
            require(callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}