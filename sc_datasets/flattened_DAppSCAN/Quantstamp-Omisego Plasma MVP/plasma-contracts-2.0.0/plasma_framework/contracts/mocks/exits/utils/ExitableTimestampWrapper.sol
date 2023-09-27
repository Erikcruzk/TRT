// File: openzeppelin-solidity/contracts/math/Math.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/utils/ExitableTimestamp.sol

pragma solidity 0.5.11;

library ExitableTimestamp {
    struct Calculator {
        uint256 minExitPeriod;
    }

    /**
     * @notice Calculates the exitable timestamp for a mined transaction
     * @dev This is the main function when asking for exitable timestamp in most cases.
     *      The only exception is to calculate the exitable timestamp for a deposit output in standard exit.
     *      Should use the function 'calculateDepositTxOutputExitableTimestamp' for that case.
     */
    function calculateTxExitableTimestamp(
        Calculator memory _calculator,
        uint256 _now,
        uint256 _blockTimestamp
    )
        internal
        pure
        returns (uint32)
    {
        return uint32(Math.max(_blockTimestamp + (_calculator.minExitPeriod * 2), _now + _calculator.minExitPeriod));
    }

    /**
     * @notice Calculates the exitable timestamp for deposit transaction output for standard exit
     * @dev This function should only be used in standard exit for calculating exitable timestamp of a deposit output.
     *      For in-fight exit, the priority of a input tx which is a deposit tx should still be using the another function 'calculateTxExitableTimestamp'.
     *      See discussion here: https://git.io/Je4N5
     *      Reason of deposit output has different exitable timestamp: https://git.io/JecCV
     */
    function calculateDepositTxOutputExitableTimestamp(
        Calculator memory _calculator,
        uint256 _now
    )
        internal
        pure
        returns (uint32)
    {
        return uint32(_now + _calculator.minExitPeriod);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/mocks/exits/utils/ExitableTimestampWrapper.sol

pragma solidity 0.5.11;

contract ExitableTimestampWrapper {
    using ExitableTimestamp for ExitableTimestamp.Calculator;
    ExitableTimestamp.Calculator internal calculator;

    constructor(uint256 _minExitPeriod) public {
        calculator = ExitableTimestamp.Calculator(_minExitPeriod);
    }

    function calculateDepositTxOutputExitableTimestamp(
        uint256 _now
    )
        public
        view
        returns (uint64)
    {
        return calculator.calculateDepositTxOutputExitableTimestamp(_now);
    }

    function calculateTxExitableTimestamp(
        uint256 _now,
        uint256 _blockTimestamp
    )
        public
        view
        returns (uint64)
    {
        return calculator.calculateTxExitableTimestamp(_now, _blockTimestamp);
    }
}