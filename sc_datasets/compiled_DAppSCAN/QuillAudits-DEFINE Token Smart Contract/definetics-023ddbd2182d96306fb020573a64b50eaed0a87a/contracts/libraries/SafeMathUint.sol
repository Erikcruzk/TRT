// File: ../sc_datasets/DAppSCAN/QuillAudits-DEFINE Token Smart Contract/definetics-023ddbd2182d96306fb020573a64b50eaed0a87a/contracts/libraries/SafeMathUint.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title SafeMathUint
 * @dev Math operations with safety checks that revert on error
 */
library SafeMathUint {
  function toInt256Safe(uint256 a) internal pure returns (int256) {
    int256 b = int256(a);
    require(b >= 0);
    return b;
  }
}
