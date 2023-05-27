pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) public credit; // Made credit public for visibility
    uint public balance; // Made balance public for visibility

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            balance -= oCredit;
            credit[msg.sender] = 0;
            require(msg.sender.call.value(oCredit)()); // Moved require statement to prevent reentrancy
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}