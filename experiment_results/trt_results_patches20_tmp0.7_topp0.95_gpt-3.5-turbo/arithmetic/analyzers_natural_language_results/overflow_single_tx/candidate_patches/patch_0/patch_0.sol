pragma solidity ^0.4.23;

contract IntegerOverflowSingleTransaction {
    uint256 public count = 1;

    function overflowaddtostate(uint256 input) public {
        require(input <= uint256(-1) - count, "SafeMath: Addition overflow");
        count += input;
    }

    function overflowmultostate(uint256 input) public {
        require(count == 0 || input <= uint256(-1) / count, "SafeMath: Multiplication overflow");
        count *= input;
    }

    function underflowtostate(uint256 input) public {
        require(input <= count, "SafeMath: Subtraction overflow");
        count -= input;
    }

    function overflowlocalonly(uint256 input) public view returns (uint256) {
        return count + input;
    }

    function overflowmulocalonly(uint256 input) public view returns (uint256) {
        return count * input;
    }

    function underflowlocalonly(uint256 input) public view returns (uint256) {
        return count - input;
    }
}