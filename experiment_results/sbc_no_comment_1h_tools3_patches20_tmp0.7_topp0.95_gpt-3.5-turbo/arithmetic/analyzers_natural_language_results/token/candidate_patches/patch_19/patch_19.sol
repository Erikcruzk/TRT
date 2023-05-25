pragma solidity ^0.4.18;

contract Token {
    mapping(address => uint) balances;
    uint public totalSupply;

    function Token(uint _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] >= _value); // check if sender has enough balance

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) { // change constant to view
        return balances[_owner];
    }
}