// File: ../sc_datasets/DAppSCAN/PeckShield-DSG/core-6f607f77698936e132e4e9b5cb4d75580636d919/contracts/interfaces/ISwapAdapter.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;

interface ISwapAdapter {

    function sellBase(address to, address pool, bytes memory data) external;

    function sellQuote(address to, address pool, bytes memory data) external;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-DSG/core-6f607f77698936e132e4e9b5cb4d75580636d919/contracts/adapter/DODOAdapter.sol

// SPDX-License-Identifier: MIT

pragma solidity > 0.6.9;

interface IDODOSwap {
    function sellBase(address to) external;
    function sellQuote(address to) external;
}

contract DODOAdapter is ISwapAdapter {
    function sellBase(address to, address pool, bytes memory) external override {
        IDODOSwap(pool).sellBase(to);
    }

    function sellQuote(address to, address pool, bytes memory) external override {
        IDODOSwap(pool).sellQuote(to);
    }
}
