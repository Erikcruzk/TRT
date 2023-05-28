pragma solidity ^0.4.2;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        if (credit[msg.sender] >= amount) {
            credit[msg.sender] -= amount;
            bool res = msg.sender.call.value(amount)();
            require(res, "Withdrawal failed");
        }
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
}