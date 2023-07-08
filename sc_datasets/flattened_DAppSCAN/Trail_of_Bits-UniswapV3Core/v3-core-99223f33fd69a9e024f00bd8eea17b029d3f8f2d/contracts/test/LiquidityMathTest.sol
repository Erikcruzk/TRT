// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/libraries/LiquidityMath.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

/// @title Math library for liquidity
library LiquidityMath {
    /// @notice Add a signed liquidity delta to liquidity and revert if it overflows or underflows
    /// @return z The liquidity delta
    function addDelta(uint128 x, int128 y) internal pure returns (uint128 z) {
        if (y < 0) {
            require((z = x - uint128(-y)) < x, 'LS');
        } else {
            require((z = x + uint128(y)) >= x, 'LA');
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/test/LiquidityMathTest.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

contract LiquidityMathTest {
    function addDelta(uint128 x, int128 y) external pure returns (uint128 z) {
        return LiquidityMath.addDelta(x, y);
    }

    function getGasCostOfAddDelta(uint128 x, int128 y) external view returns (uint256) {
        uint256 gasBefore = gasleft();
        LiquidityMath.addDelta(x, y);
        return gasBefore - gasleft();
    }
}
