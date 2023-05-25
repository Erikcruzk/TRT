pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;
    bool locked = false;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0 && !locked); // added require statement to prevent reentrancy

        locked = true; // added lock to prevent reentrancy
        balance -= oCredit;

        bool callResult = msg.sender.call.value(oCredit)();
        require(callResult);
        credit[msg.sender] = 0;
        locked = false; // unlocked after external call
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}