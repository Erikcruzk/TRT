// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-3b03563c0808adf13227bf729df42d8b7869c55a/contracts/interfaces/ISynth.sol

pragma solidity >=0.4.24;


// https://docs.synthetix.io/contracts/source/interfaces/isynth
interface ISynth {
    // Views
    function currencyKey() external view returns (bytes32);

    function transferableSynths(address account) external view returns (uint);

    // Mutative functions
    function transferAndSettle(address to, uint value) external returns (bool);

    function transferFromAndSettle(
        address from,
        address to,
        uint value
    ) external returns (bool);

    // Restricted: used internally to Synthetix
    function burn(address account, uint amount) external;

    function issue(address account, uint amount) external;
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-3b03563c0808adf13227bf729df42d8b7869c55a/contracts/interfaces/IDebtCache.sol

pragma solidity >=0.4.24;

// https://docs.synthetix.io/contracts/source/interfaces/idebtcache
interface IDebtCache {
    // Views

    function cachedDebt() external view returns (uint);

    function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);

    function cacheTimestamp() external view returns (uint);

    function cacheInvalid() external view returns (bool);

    function cacheStale() external view returns (bool);

    function currentSynthDebts(bytes32[] calldata currencyKeys)
        external
        view
        returns (uint[] memory debtValues, bool anyRateIsInvalid);

    function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);

    function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);

    function cacheInfo()
        external
        view
        returns (
            uint debt,
            uint timestamp,
            bool isInvalid,
            bool isStale
        );

    // Mutative functions

    function takeDebtSnapshot() external;

    function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
}
