// File: ../sc_datasets/DAppSCAN/Quantstamp-Popsicle/PopsicleV3Optimizer-d1513776bffd634e9e83330495adce9d9d0a5cb0/contracts/popsicle-v3-optimizer/libraries/FixedPoint96.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.4.0;

/// @title FixedPoint96
/// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
/// @dev Used in SqrtPriceMath.sol
library FixedPoint96 {
    uint8 internal constant RESOLUTION = 96;
    uint256 internal constant Q96 = 0x1000000000000000000000000;
}
