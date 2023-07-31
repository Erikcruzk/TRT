// File: ../sc_datasets/DAppSCAN/Quantstamp-Sherlock/sherlock-v1-core-68bcb59daa631b9f295ae0e63256a02dc459dcff/contracts/storage/PayoutStorage.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.7.0;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

library PayoutStorage {
  bytes32 constant PAYOUT_STORAGE_POSITION = keccak256('diamond.sherlock.payout');

  struct Base {
    address govPayout;
  }

  function ps() internal pure returns (Base storage psx) {
    bytes32 position = PAYOUT_STORAGE_POSITION;
    assembly {
      psx.slot := position
    }
  }
}
