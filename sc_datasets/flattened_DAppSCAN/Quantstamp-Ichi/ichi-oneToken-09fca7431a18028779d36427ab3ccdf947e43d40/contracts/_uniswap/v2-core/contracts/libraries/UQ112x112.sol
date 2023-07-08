// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_uniswap/v2-core/contracts/libraries/UQ112x112.sol

// SPDX-License-Identifier: ISC

pragma solidity =0.7.6;

// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))

// range: [0, 2**112 - 1]
// resolution: 1 / 2**112

library UQ112x112 {
    uint224 constant Q112 = 2**112;

    // encode a uint112 as a UQ112x112
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112; // never overflows
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y);
    }
}
