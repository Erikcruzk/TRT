pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;  // update credit before external call

            bool callResult = msg.sender.call.value(oCredit)();
            require(callResult);
            balance -= oCredit;  // update balance after external call
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}