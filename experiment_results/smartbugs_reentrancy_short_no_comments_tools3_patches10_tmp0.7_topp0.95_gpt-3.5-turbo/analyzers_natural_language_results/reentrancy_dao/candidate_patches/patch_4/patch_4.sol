pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            balance -= oCredit;
            bool callResult = msg.sender.call.value(oCredit)();
            require (callResult);
        }
    }

    function deposit() public payable {
        require(msg.value > 0); // Prevents integer underflow
        credit[msg.sender] = safeAdd(credit[msg.sender], msg.value);
        balance = safeAdd(balance, msg.value);
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        assert(c >= a && c >= b); // Prevents integer overflow
        return c;
    }
}