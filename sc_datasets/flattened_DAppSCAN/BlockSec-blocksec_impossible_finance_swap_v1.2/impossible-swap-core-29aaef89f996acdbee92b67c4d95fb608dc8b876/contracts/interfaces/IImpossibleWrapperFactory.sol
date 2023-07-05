// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossibleWrapperFactory.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IImpossibleWrapperFactory {
    event WrapCreated(address, address, uint256, uint256);
    event WrapDeleted(address, address);

    function tokensToWrappedTokens(address) external view returns (address);

    function wrappedTokensToTokens(address) external view returns (address);
}
