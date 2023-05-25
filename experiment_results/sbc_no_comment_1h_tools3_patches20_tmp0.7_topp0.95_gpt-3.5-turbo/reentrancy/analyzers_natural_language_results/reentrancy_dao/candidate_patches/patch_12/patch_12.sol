pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;
    bool locked;

    function withdrawAll() public {
        require(!locked);
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            locked = true;
            balance -= oCredit;
            credit[msg.sender] = 0;
            locked = false;

            bool callResult = msg.sender.call.value(oCredit)();
            require(callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}