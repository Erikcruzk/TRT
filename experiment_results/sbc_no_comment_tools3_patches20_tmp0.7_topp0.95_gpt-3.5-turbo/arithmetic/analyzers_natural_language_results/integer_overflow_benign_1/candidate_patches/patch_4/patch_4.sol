pragma solidity ^0.4.19;

contract IntegerOverflowBenign1 {
    uint public count = 1;

    function run(uint256 input) public {
        require(input <= count); // added input validation
        uint res = count - input;
        assert(res <= count); // added output validation
    }
}