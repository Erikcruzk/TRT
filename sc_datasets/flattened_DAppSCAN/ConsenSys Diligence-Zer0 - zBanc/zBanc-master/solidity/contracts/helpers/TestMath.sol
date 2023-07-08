// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/SafeMath.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Library for basic math operations with overflow/underflow protection
*/
library SafeMath {
    /**
      * @dev returns the sum of _x and _y, reverts if the calculation overflows
      *
      * @param _x   value 1
      * @param _y   value 2
      *
      * @return sum
    */
    function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 z = _x + _y;
        require(z >= _x, "ERR_OVERFLOW");
        return z;
    }

    /**
      * @dev returns the difference of _x minus _y, reverts if the calculation underflows
      *
      * @param _x   minuend
      * @param _y   subtrahend
      *
      * @return difference
    */
    function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
        require(_x >= _y, "ERR_UNDERFLOW");
        return _x - _y;
    }

    /**
      * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
      *
      * @param _x   factor 1
      * @param _y   factor 2
      *
      * @return product
    */
    function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        // gas optimization
        if (_x == 0)
            return 0;

        uint256 z = _x * _y;
        require(z / _x == _y, "ERR_OVERFLOW");
        return z;
    }

    /**
      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
      *
      * @param _x   dividend
      * @param _y   divisor
      *
      * @return quotient
    */
    function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
        require(_y > 0, "ERR_DIVIDE_BY_ZERO");
        uint256 c = _x / _y;
        return c;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Math.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Library for complex math operations
*/
library Math {
    using SafeMath for uint256;

    /**
      * @dev returns the largest integer smaller than or equal to the square root of a positive integer
      *
      * @param _num a positive integer
      *
      * @return the largest integer smaller than or equal to the square root of the positive integer
    */
    function floorSqrt(uint256 _num) internal pure returns (uint256) {
        uint256 x = _num / 2 + 1;
        uint256 y = (x + _num / x) / 2;
        while (x > y) {
            x = y;
            y = (x + _num / x) / 2;
        }
        return x;
    }

    /**
      * @dev computes a reduced-scalar ratio
      *
      * @param _n   ratio numerator
      * @param _d   ratio denominator
      * @param _max maximum desired scalar
      *
      * @return ratio's numerator and denominator
    */
    function reducedRatio(uint256 _n, uint256 _d, uint256 _max) internal pure returns (uint256, uint256) {
        if (_n > _max || _d > _max)
            return normalizedRatio(_n, _d, _max);
        return (_n, _d);
    }

    /**
      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
    */
    function normalizedRatio(uint256 _a, uint256 _b, uint256 _scale) internal pure returns (uint256, uint256) {
        if (_a == _b)
            return (_scale / 2, _scale / 2);
        if (_a < _b)
            return accurateRatio(_a, _b, _scale);
        (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
        return (x, y);
    }

    /**
      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a < b".
    */
    function accurateRatio(uint256 _a, uint256 _b, uint256 _scale) internal pure returns (uint256, uint256) {
        uint256 maxVal = uint256(-1) / _scale;
        if (_a > maxVal) {
            uint256 c = _a / (maxVal + 1) + 1;
            _a /= c;
            _b /= c;
        }
        uint256 x = roundDiv(_a * _scale, _a.add(_b));
        uint256 y = _scale - x;
        return (x, y);
    }

    /**
      * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
    */
    function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
        return _n / _d + _n % _d / (_d - _d / 2);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/helpers/TestMath.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

contract TestMath {
    using Math for *;

    function floorSqrtTest(uint256 _num) external pure returns (uint256) {
        return Math.floorSqrt(_num);
    }

    function reducedRatioTest(uint256 _n, uint256 _d, uint256 _max) external pure returns (uint256, uint256) {
        return Math.reducedRatio(_n, _d, _max);
    }

    function normalizedRatioTest(uint256 _a, uint256 _b, uint256 _scale) external pure returns (uint256, uint256) {
        return Math.normalizedRatio(_a, _b, _scale);
    }

    function accurateRatioTest(uint256 _a, uint256 _b, uint256 _scale) external pure returns (uint256, uint256) {
        return Math.accurateRatio(_a, _b, _scale);
    }

    function roundDivTest(uint256 _n, uint256 _d) external pure returns (uint256) {
        return Math.roundDiv(_n, _d);
    }
}
