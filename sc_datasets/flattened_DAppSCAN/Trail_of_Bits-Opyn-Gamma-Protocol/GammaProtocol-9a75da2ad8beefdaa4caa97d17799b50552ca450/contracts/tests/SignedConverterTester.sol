// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Opyn-Gamma-Protocol/GammaProtocol-9a75da2ad8beefdaa4caa97d17799b50552ca450/contracts/libs/SignedConverter.sol

/**
 * SPDX-License-Identifier: UNLICENSED
 */
pragma solidity 0.6.10;

/**
 * @title SignedConverter
 * @author Opyn Team
 * @notice A library to convert an unsigned integer to signed integer or signed integer to unsigned integer.
 */
library SignedConverter {
    /**
     * @notice convert an unsigned integer to a signed integer
     * @param a uint to convert into a signed integer
     * @return converted signed integer
     */
    function uintToInt(uint256 a) internal pure returns (int256) {
        require(a < 2**255, "FixedPointInt256: out of int range");

        return int256(a);
    }

    /**
     * @notice convert a signed integer to an unsigned integer
     * @param a int to convert into an unsigned integer
     * @return converted unsigned integer
     */
    function intToUint(int256 a) internal pure returns (uint256) {
        if (a < 0) {
            return uint256(-a);
        } else {
            return uint256(a);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Opyn-Gamma-Protocol/GammaProtocol-9a75da2ad8beefdaa4caa97d17799b50552ca450/contracts/tests/SignedConverterTester.sol

/**
 * SPDX-License-Identifier: UNLICENSED
 */
pragma solidity 0.6.10;

pragma experimental ABIEncoderV2;

/**
 * @author Opyn Team
 * @notice SignedConverter contract tester
 */
contract SignedConverterTester {
    using SignedConverter for int256;
    using SignedConverter for uint256;

    function testFromInt(int256 a) external pure returns (uint256) {
        return SignedConverter.intToUint(a);
    }

    function testFromUint(uint256 a) external pure returns (int256) {
        return SignedConverter.uintToInt(a);
    }
}
