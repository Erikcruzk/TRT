pragma solidity ^0.4.19;

contract IntegerOverflowBenign1 {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= count); // input must be less than or equal to count
        uint res = count - input;
    }
}