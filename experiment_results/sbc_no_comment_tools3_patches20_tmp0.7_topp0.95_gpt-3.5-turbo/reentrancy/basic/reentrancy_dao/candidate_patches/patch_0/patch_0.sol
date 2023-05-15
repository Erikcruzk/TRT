pragma solidity ^0.5.0;

contract ReentrancyDAO {
    mapping(address => uint) public credit;
    uint public balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            balance -= oCredit;

            (bool callResult, ) = msg.sender.call.value(oCredit)("");
            require(callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}