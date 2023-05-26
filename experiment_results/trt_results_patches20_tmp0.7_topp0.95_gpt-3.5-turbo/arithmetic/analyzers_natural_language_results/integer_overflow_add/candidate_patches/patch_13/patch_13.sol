pragma solidity ^0.4.19;

contract IntegerOverflowAdd {
    uint public count = 1;

    function run(uint256 input) public {
        require(count + input >= count); // add a check to prevent integer overflow
        count += input;
    }
}