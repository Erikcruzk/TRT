// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/libraries/SafeCast.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  SafeCast
/// @notice Safely cast between uint256 and uint128
library SafeCast {
    /// @notice reverts if x > type(uint128).max
    function toUint128(uint256 x) internal pure returns (uint128 z) {
        require(x <= type(uint128).max);
        z = uint128(x);
    }
}
