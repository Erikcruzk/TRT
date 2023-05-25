pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        if (credit[msg.sender] >= amount) {
            credit[msg.sender] -= amount;
            bool res = msg.sender.call.value(amount)();
            require(res, "External call failed");
        }
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}

// The repaired contract includes the following changes:
// 1. Added visibility keywords to functions
// 2. Moved state modifications before the external call in the withdraw function
// 3. Added a require statement to check for successful external call in the withdraw function