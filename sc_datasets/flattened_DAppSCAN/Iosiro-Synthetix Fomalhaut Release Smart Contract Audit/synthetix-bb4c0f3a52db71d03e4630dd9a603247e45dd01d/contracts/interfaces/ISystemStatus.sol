// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-bb4c0f3a52db71d03e4630dd9a603247e45dd01d/contracts/interfaces/ISystemStatus.sol

pragma solidity >=0.4.24;


interface ISystemStatus {
    struct Status {
        bool canSuspend;
        bool canResume;
    }

    struct Suspension {
        bool suspended;
        // reason is an integer code,
        // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
        uint248 reason;
    }

    // Views
    function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);

    function requireSystemActive() external view;

    function requireIssuanceActive() external view;

    function requireExchangeActive() external view;

    function requireSynthActive(bytes32 currencyKey) external view;

    function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;

    function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);

    // Restricted functions
    function suspendSynth(bytes32 currencyKey, uint256 reason) external;

    function updateAccessControl(
        bytes32 section,
        address account,
        bool canSuspend,
        bool canResume
    ) external;
}
