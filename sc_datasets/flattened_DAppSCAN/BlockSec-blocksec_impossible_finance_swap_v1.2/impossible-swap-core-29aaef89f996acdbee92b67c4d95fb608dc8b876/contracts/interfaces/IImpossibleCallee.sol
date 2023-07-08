// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossibleCallee.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IImpossibleCallee {
    function ImpossibleCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}
