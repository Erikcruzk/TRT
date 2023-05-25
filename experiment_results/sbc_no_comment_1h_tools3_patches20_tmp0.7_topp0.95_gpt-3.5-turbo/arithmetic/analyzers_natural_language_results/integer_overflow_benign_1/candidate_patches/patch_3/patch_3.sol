pragma solidity ^0.4.19;

contract IntegerOverflowBenign1 {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= count); // Ensure that input is not greater than count to prevent integer underflow
        uint res = count - input;
    }
}