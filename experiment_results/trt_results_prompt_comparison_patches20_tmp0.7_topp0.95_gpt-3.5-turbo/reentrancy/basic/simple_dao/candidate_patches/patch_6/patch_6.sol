pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint256) public credit;

    function donate(address _to) public payable {
        credit[_to] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(credit[msg.sender] >= _amount, "Insufficient balance");
        credit[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
    }

    function queryCredit(address _to) public view returns (uint256) {
        return credit[_to];
    }
}