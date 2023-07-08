// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/libraries/Math.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

// a library for performing various math operations

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
