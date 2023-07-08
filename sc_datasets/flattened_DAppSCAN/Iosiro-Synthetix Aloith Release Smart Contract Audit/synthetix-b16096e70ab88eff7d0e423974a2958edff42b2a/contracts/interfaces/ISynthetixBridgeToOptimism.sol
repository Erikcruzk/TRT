// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Aloith Release Smart Contract Audit/synthetix-b16096e70ab88eff7d0e423974a2958edff42b2a/contracts/interfaces/ISynthetixBridgeToOptimism.sol

pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

interface ISynthetixBridgeToOptimism {
    function migrateEscrow(uint256[][] calldata entryIDs) external;

    function depositReward(uint amount) external;

    function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] calldata entryIDs) external;
}
