// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-bb4c0f3a52db71d03e4630dd9a603247e45dd01d/contracts/interfaces/ISystemSettings.sol

pragma solidity >=0.4.24;


interface ISystemSettings {
    // Views
    function priceDeviationThresholdFactor() external view returns (uint);

    function waitingPeriodSecs() external view returns (uint);

    function issuanceRatio() external view returns (uint);

    function feePeriodDuration() external view returns (uint);

    function targetThreshold() external view returns (uint);

    function liquidationDelay() external view returns (uint);

    function liquidationRatio() external view returns (uint);

    function liquidationPenalty() external view returns (uint);

    function rateStalePeriod() external view returns (uint);

    function exchangeFeeRate(bytes32 currencyKey) external view returns (uint);

    function minimumStakeTime() external view returns (uint);
}