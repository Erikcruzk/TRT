// File: ../sc_datasets/DAppSCAN/consensys-PoolTogether_Pods/pods-v3-contracts-879dc8b911fc506dd6bead1f36eade919ccfea57/contracts/libraries/ExtendedSafeCast.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

library ExtendedSafeCast {
    /**
     * @dev Converts an unsigned uint256 into a unsigned uint128.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxUint118.
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value < 2**128, "SafeCast: value doesn't fit in an uint128");
        return uint128(value);
    }

    /**
     * @dev Converts an unsigned uint256 into a unsigned uint112.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxUint112.
     */
    function toUint112(uint256 value) internal pure returns (uint112) {
        require(value < 2**112, "SafeCast: value doesn't fit in an uint112");
        return uint112(value);
    }
}