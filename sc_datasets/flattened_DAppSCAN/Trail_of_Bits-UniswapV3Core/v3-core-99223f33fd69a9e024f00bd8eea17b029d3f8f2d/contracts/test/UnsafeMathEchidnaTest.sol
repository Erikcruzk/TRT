// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/libraries/UnsafeMath.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

/// @title Math functions that do not check inputs or outputs
/// @notice Contains methods that perform common math functions but do not do any overflow or underflow checks
library UnsafeMath {
    /// @notice Returns ceil(x / y)
    /// @dev panics if y == 0
    function divRoundingUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // addition is safe because (type(uint256).max / 1) + (type(uint256).max % 1 > 0 ? 1 : 0) == type(uint256).max
        z = (x / y) + (x % y > 0 ? 1 : 0);
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/test/UnsafeMathEchidnaTest.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

contract UnsafeMathEchidnaTest {
    function checkDivRoundingUp(uint256 x, uint256 d) external pure {
        require(d > 0);
        uint256 z = UnsafeMath.divRoundingUp(x, d);
        uint256 diff = z - (x / d);
        if (x % d == 0) {
            assert(diff == 0);
        } else {
            assert(diff == 1);
        }
    }
}
