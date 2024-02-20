


pragma solidity 0.8.3;


library DecMath {
    uint256 internal constant PRECISION = 10**18;

    function decmul(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a * b) / PRECISION;
    }

    function decdiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a * PRECISION) / b;
    }
}