// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-d7671c94a22130f19e8aa19f6a1974a257dde9e6/contracts/interfaces/ISynthetixState.sol

pragma solidity >=0.4.24;


// https://docs.synthetix.io/contracts/source/interfaces/isynthetixstate
interface ISynthetixState {
    // Views
    function debtLedger(uint index) external view returns (uint);

    function issuanceData(address account) external view returns (uint initialDebtOwnership, uint debtEntryIndex);

    function debtLedgerLength() external view returns (uint);

    function hasIssued(address account) external view returns (bool);

    function lastDebtLedgerEntry() external view returns (uint);

    // Mutative functions
    function incrementTotalIssuerCount() external;

    function decrementTotalIssuerCount() external;

    function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;

    function appendDebtLedgerValue(uint value) external;

    function clearIssuanceData(address account) external;
}
