// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/tokens/wrapper/interfaces/IMeta.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IMeta {

    function wrappedCodeHash() external view returns (bytes32);
    function deposit(address meta, uint256 id, uint256 amount, bytes memory data) external;
    function withdraw(address wrapped, uint256 amount) external;
    function createWrap(string memory name, string memory symbol, address meta, uint256 assetId, bytes memory data) external returns (address wrapped);
}
