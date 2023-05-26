pragma solidity ^0.4.26;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    event FrozenFunds(address target, bool frozen);

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender], "Your account is frozen");
        require(credit[msg.sender] >= amount, "Insufficient balance");
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address target, bool freeze) public {
        require(msg.sender == address(0x123), "Only the contract owner can freeze accounts");
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
}