pragma solidity ^0.4.19;

contract IntegerOverflowAdd {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= (2**256 - 1 - count));
        count += input;
    }
}