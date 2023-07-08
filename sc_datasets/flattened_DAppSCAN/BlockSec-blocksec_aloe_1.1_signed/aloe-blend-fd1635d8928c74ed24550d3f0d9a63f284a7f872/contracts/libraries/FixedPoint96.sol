// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/libraries/FixedPoint96.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.4.0;

/// @title FixedPoint96
/// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
/// @dev Used in SqrtPriceMath.sol
library FixedPoint96 {
    uint8 internal constant RESOLUTION = 96;
    uint256 internal constant Q96 = 0x1000000000000000000000000;
}
