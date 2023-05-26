pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint256) public credit;
    mapping(address => bool) public locked;

    function donate(address _to) public payable {
        credit[_to] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(credit[msg.sender] >= _amount);
        require(!locked[msg.sender]);

        locked[msg.sender] = true;
        bool res = msg.sender.call.value(_amount)();
        locked[msg.sender] = false;

        if (res) {
            credit[msg.sender] -= _amount;
        }
    }

    function queryCredit(address _to) public view returns (uint256) {
        return credit[_to];
    }
}