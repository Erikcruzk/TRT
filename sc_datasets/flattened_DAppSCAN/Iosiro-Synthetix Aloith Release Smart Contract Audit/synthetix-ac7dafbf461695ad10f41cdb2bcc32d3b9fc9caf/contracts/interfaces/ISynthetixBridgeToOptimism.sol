// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Aloith Release Smart Contract Audit/synthetix-ac7dafbf461695ad10f41cdb2bcc32d3b9fc9caf/contracts/interfaces/ISynthetixBridgeToOptimism.sol

pragma solidity >=0.4.24;
pragma experimental ABIEncoderV2;

interface ISynthetixBridgeToOptimism {
    // Invoked by the relayer on L1
    function completeWithdrawal(address account, uint amount) external;

    // The following functions can be invoked by users on L1
    function initiateDeposit(uint amount) external;

    function initiateEscrowMigration(uint256[][] calldata entryIDs) external;

    function initiateRewardDeposit(uint amount) external;

    function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] calldata entryIDs) external;
}
