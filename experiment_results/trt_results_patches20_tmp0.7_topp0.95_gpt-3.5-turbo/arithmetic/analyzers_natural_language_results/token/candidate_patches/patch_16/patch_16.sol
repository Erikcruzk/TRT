pragma solidity ^0.4.18;

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    function Token(uint256 _initialSupply) public {
        balances[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
} 

// The repaired contract initializes the totalSupply variable correctly and uses uint256 instead of uint. Additionally, the transfer function checks if the sender has enough balance before transferring the tokens. Finally, the view keyword is added to the balanceOf function to indicate that it doesn't modify the state of the contract.