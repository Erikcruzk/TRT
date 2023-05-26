pragma solidity ^0.4.18;

contract Token {
    mapping(address => uint) balances;
    uint public totalSupply;

    function Token(uint _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
} 

// Changes Made:
// 1. Made Token function public
// 2. Changed require condition to check if sender has enough balance instead of subtracting from balance and checking if it's greater than or equal to 0
// 3. Changed balanceOf function to view instead of constant to comply with new Solidity version.