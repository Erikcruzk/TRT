// File: ../sc_datasets/DAppSCAN/Chainsulting-SPICE/synthetix-develop/contracts/interfaces/IOwnerRelayOnOptimism.sol

pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

interface IOwnerRelayOnOptimism {
    function finalizeRelay(address target, bytes calldata payload) external;

    function finalizeRelayBatch(address[] calldata target, bytes[] calldata payloads) external;
}
