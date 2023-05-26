pragma solidity ^0.4.18;

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    function Token(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }
}

// Changes made:
// 1. Changed mapping value type to uint256
// 2. Added "public" to constructor function
// 3. Changed "require" statement in transfer function to check if sender balance is greater than or equal to the transfer value
// 4. Removed unnecessary subtraction check for sender balance in transfer function