pragma solidity ^0.4.18;

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    function Token(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] >= _value && _value > 0);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
} 

// Changes Made:
// 1. Changed the type of balances mapping from uint to uint256
// 2. Made the Token constructor public
// 3. Added a check in transfer function to ensure that the sender has enough balance and the value to transfer is greater than 0. 
// 4. Removed the integer underflow and overflow vulnerabilities in the transfer function.