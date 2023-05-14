pragma solidity ^0.4.19;

contract IntegerOverflowMinimal {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= count); // ensure input is not greater than count
        count -= input;
    }
}