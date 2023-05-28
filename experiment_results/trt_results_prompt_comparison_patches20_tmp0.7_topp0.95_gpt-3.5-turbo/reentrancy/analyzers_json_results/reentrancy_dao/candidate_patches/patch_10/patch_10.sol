pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
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

// The reentrancy vulnerability was fixed by moving the state variable update before the external call to prevent reentrant calls from being executed after the state variable is updated.