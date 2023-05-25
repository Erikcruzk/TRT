pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;
    bool locked;

    function withdrawAll() public {
        require(!locked);
        uint oCredit = credit[msg.sender];
        require(oCredit > 0);
        credit[msg.sender] = 0;
        locked = true;
        msg.sender.transfer(oCredit);
        balance -= oCredit;
        locked = false;
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}