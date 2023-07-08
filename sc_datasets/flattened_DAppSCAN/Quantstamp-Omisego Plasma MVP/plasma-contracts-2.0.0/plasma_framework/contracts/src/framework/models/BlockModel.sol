// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/models/BlockModel.sol

pragma solidity 0.5.11;

library BlockModel {
    /**
     * @notice Block data structure that is stored in the contract
     * @param root The Merkle root block hash of the Plasma blocks
     * @param timestamp The timestamp, in seconds, when the block is saved
     */
    struct Block {
        bytes32 root;
        uint256 timestamp;
    }
}
