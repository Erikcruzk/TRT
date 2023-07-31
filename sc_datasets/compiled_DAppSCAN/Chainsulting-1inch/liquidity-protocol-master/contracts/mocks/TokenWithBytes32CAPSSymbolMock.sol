// File: ../sc_datasets/DAppSCAN/Chainsulting-1inch/liquidity-protocol-master/contracts/mocks/TokenWithBytes32CAPSSymbolMock.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


contract TokenWithBytes32CAPSSymbolMock {
    // solhint-disable var-name-mixedcase
    bytes32 public SYMBOL = "ABC";

    constructor(bytes32 s) public {
        SYMBOL = s;
    }
}
