pragma solidity ^0.8.0;

contract IntegerOverflowAdd {
    mapping(address => uint256) public balanceOf;

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        unchecked {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
        }
    }
}