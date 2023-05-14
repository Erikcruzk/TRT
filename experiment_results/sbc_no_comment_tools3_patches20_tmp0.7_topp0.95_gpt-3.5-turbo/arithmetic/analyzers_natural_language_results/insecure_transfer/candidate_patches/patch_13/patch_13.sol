pragma solidity ^0.4.25;

contract IntegerOverflowAdd {
    mapping(address => uint256) public balanceOf;

    function transfer(address _to, uint256 _value) public {
        require(_value <= balanceOf[msg.sender]); // check if sender has enough balance
        require(balanceOf[_to] + _value >= balanceOf[_to]); // check for overflow

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}