// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-UniswapV3Core/v3-core-99223f33fd69a9e024f00bd8eea17b029d3f8f2d/contracts/libraries/FixedPoint96.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0;

/// @title FixedPoint96
/// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
/// @dev Used in SqrtPriceMath.sol
library FixedPoint96 {
    uint8 internal constant RESOLUTION = 96;
    uint256 internal constant Q96 = 0x1000000000000000000000000;
}
