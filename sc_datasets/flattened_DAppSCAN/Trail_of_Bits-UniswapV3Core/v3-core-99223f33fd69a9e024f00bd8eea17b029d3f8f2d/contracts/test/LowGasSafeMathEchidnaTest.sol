// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/libraries/LowGasSafeMath.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0;

/// @title Optimized overflow and underflow safe math operations
/// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
library LowGasSafeMath {
    /// @notice Returns x + y, reverts if sum overflows uint256
    /// @return z The sum of x and y
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }

    /// @notice Returns x - y, reverts if underflows
    /// @return z The difference of x and y
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }

    /// @notice Returns x * y, reverts if overflows
    /// @return z The product of x and y
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(x == 0 || (z = x * y) / x == y);
    }

    /// @notice Returns x + y, reverts if overflows or underflows
    /// @return z The sum of x and y
    function add(int256 x, int256 y) internal pure returns (int256 z) {
        require((z = x + y) >= x == (y >= 0));
    }

    /// @notice Returns x - y, reverts if overflows or underflows
    /// @return z The difference of x and y
    function sub(int256 x, int256 y) internal pure returns (int256 z) {
        require((z = x - y) <= x == (y >= 0));
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/test/LowGasSafeMathEchidnaTest.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

contract LowGasSafeMathEchidnaTest {
    function checkAdd(uint256 x, uint256 y) external pure {
        uint256 z = LowGasSafeMath.add(x, y);
        assert(z == x + y);
        assert(z >= x && z >= y);
    }

    function checkSub(uint256 x, uint256 y) external pure {
        uint256 z = LowGasSafeMath.sub(x, y);
        assert(z == x - y);
        assert(z <= x);
    }

    function checkMul(uint256 x, uint256 y) external pure {
        uint256 z = LowGasSafeMath.mul(x, y);
        assert(z == x * y);
        assert(x == 0 || y == 0 || (z >= x && z >= y));
    }

    function checkAddi(int256 x, int256 y) external pure {
        int256 z = LowGasSafeMath.add(x, y);
        assert(z == x + y);
        assert(y < 0 ? z < x : z >= x);
    }

    function checkSubi(int256 x, int256 y) external pure {
        int256 z = LowGasSafeMath.sub(x, y);
        assert(z == x - y);
        assert(y < 0 ? z > x : z <= x);
    }
}