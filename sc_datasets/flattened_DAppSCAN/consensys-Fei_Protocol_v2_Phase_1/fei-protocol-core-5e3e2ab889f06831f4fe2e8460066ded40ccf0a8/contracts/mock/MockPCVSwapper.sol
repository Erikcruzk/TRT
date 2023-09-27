// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/mock/MockPCVSwapper.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

contract MockPCVSwapper {

    bool public swapped;

    function swap() public {
        swapped = true;
    }
}