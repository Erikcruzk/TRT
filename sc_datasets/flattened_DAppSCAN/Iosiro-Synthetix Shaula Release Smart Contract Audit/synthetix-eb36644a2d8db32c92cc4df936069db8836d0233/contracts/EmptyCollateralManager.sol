// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-eb36644a2d8db32c92cc4df936069db8836d0233/contracts/interfaces/ICollateralManager.sol

pragma solidity >=0.4.24;


interface ICollateralManager {
    // Manager information
    function hasCollateral(address collateral) external view returns (bool);

    function isSynthManaged(bytes32 currencyKey) external view returns (bool);

    // State information
    function long(bytes32 synth) external view returns (uint amount);

    function short(bytes32 synth) external view returns (uint amount);

    function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);

    function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);

    function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);

    function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);

    function getRatesAndTime(uint index)
        external
        view
        returns (
            uint entryRate,
            uint lastRate,
            uint lastUpdated,
            uint newIndex
        );

    function getShortRatesAndTime(bytes32 currency, uint index)
        external
        view
        returns (
            uint entryRate,
            uint lastRate,
            uint lastUpdated,
            uint newIndex
        );

    function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);

    function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
        external
        view
        returns (bool);

    function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
        external
        view
        returns (bool);

    // Loans
    function getNewLoanId() external returns (uint id);

    // Manager mutative
    function addCollaterals(address[] calldata collaterals) external;

    function removeCollaterals(address[] calldata collaterals) external;

    function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;

    function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;

    function addShortableSynths(bytes32[2][] calldata requiredSynthAndInverseNamesInResolver, bytes32[] calldata synthKeys)
        external;

    function removeShortableSynths(bytes32[] calldata synths) external;

    // State mutative
    function updateBorrowRates(uint rate) external;

    function updateShortRates(bytes32 currency, uint rate) external;

    function incrementLongs(bytes32 synth, uint amount) external;

    function decrementLongs(bytes32 synth, uint amount) external;

    function incrementShorts(bytes32 synth, uint amount) external;

    function decrementShorts(bytes32 synth, uint amount) external;
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-eb36644a2d8db32c92cc4df936069db8836d0233/contracts/EmptyCollateralManager.sol

pragma solidity ^0.5.16;

contract EmptyCollateralManager is ICollateralManager {
    // Manager information
    function hasCollateral(address) external view returns (bool) {
        return false;
    }

    function isSynthManaged(bytes32) external view returns (bool) {
        return false;
    }

    // State information
    function long(bytes32) external view returns (uint amount) {
        return 0;
    }

    function short(bytes32) external view returns (uint amount) {
        return 0;
    }

    function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid) {
        return (0, false);
    }

    function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid) {
        return (0, false);
    }

    function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid) {
        return (0, false);
    }

    function getShortRate(bytes32) external view returns (uint shortRate, bool rateIsInvalid) {
        return (0, false);
    }

    function getRatesAndTime(uint)
        external
        view
        returns (
            uint entryRate,
            uint lastRate,
            uint lastUpdated,
            uint newIndex
        )
    {
        return (0, 0, 0, 0);
    }

    function getShortRatesAndTime(bytes32, uint)
        external
        view
        returns (
            uint entryRate,
            uint lastRate,
            uint lastUpdated,
            uint newIndex
        )
    {
        return (0, 0, 0, 0);
    }

    function exceedsDebtLimit(uint, bytes32) external view returns (bool canIssue, bool anyRateIsInvalid) {
        return (false, false);
    }

    function areSynthsAndCurrenciesSet(bytes32[] calldata, bytes32[] calldata) external view returns (bool) {
        return false;
    }

    function areShortableSynthsSet(bytes32[] calldata, bytes32[] calldata) external view returns (bool) {
        return false;
    }

    // Loans
    function getNewLoanId() external returns (uint id) {
        return 0;
    }

    // Manager mutative
    function addCollaterals(address[] calldata) external {}

    function removeCollaterals(address[] calldata) external {}

    function addSynths(bytes32[] calldata, bytes32[] calldata) external {}

    function removeSynths(bytes32[] calldata, bytes32[] calldata) external {}

    function addShortableSynths(bytes32[2][] calldata, bytes32[] calldata) external {}

    function removeShortableSynths(bytes32[] calldata) external {}

    // State mutative
    function updateBorrowRates(uint) external {}

    function updateShortRates(bytes32, uint) external {}

    function incrementLongs(bytes32, uint) external {}

    function decrementLongs(bytes32, uint) external {}

    function incrementShorts(bytes32, uint) external {}

    function decrementShorts(bytes32, uint) external {}
}
