// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-feature-nftPool/contracts/SmartRoute/intf/IGambit.sol

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface IGambit {
    function swap(address _tokenIn, address _tokenOut, address _receiver) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-feature-nftPool/contracts/SmartRoute/intf/IDODOAdapter.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface IDODOAdapter {
    
    function sellBase(address to, address pool, bytes memory data) external;

    function sellQuote(address to, address pool, bytes memory data) external;
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-feature-nftPool/contracts/SmartRoute/adapter/GambitAdapter.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;


contract GambitAdapter is IDODOAdapter {

    function _gambitSwap(address to, address pool, bytes memory moreInfo) internal {
        (address tokenIn, address tokenOut) = abi.decode(moreInfo, (address, address));

        IGambit(pool).swap(tokenIn, tokenOut, to);
    }

    function sellBase(address to, address pool, bytes memory moreInfo) external override {
        _gambitSwap(to, pool, moreInfo);
    }

    function sellQuote(address to, address pool, bytes memory moreInfo) external override {
        _gambitSwap(to, pool, moreInfo);
    }
}
