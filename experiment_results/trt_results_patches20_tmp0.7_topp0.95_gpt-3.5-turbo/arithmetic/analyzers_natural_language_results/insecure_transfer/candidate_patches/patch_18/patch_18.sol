pragma solidity ^0.4.0;

contract IntegerOverflowAdd {
    mapping(address => uint256) public balanceOf;

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]); // check for potential overflow
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}