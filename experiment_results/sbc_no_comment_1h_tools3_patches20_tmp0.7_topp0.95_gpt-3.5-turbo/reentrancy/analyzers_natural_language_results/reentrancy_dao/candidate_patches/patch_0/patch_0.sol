pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    bool private locked;

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function withdrawAll() public noReentrancy {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            balance -= oCredit;

            bool callResult = msg.sender.call.value(oCredit)();
            require(callResult);
            credit[msg.sender] = 0;
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}