pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;
    bool internal locked;

    function withdrawAll() public {
        require(!locked);
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            locked = true;
            balance -= oCredit;

            bool callResult = msg.sender.call.value(oCredit)();
            require(callResult);
            credit[msg.sender] = 0;
            locked = false;
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}