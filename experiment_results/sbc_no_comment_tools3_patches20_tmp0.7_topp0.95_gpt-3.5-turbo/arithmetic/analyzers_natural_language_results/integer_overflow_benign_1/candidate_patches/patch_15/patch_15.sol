pragma solidity ^0.4.19;

contract IntegerOverflowBenign1 {
    uint public count = 1;

    function run(uint256 input) public returns (uint256) {
        require(input <= count);
        uint256 res = count - input;
        return res;
    }
}