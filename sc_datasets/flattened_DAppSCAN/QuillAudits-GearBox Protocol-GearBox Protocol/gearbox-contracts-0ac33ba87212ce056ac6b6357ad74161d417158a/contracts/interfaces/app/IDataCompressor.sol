// File: ../sc_datasets/DAppSCAN/QuillAudits-GearBox Protocol-GearBox Protocol/gearbox-contracts-0ac33ba87212ce056ac6b6357ad74161d417158a/contracts/libraries/data/Types.sol

// SPDX-License-Identifier: BSL-1.1
// Gearbox. Generalized leverage protocol that allows to take leverage and then use it across other DeFi protocols and platforms in a composable way.
// (c) Gearbox.fi, 2021
pragma solidity ^0.7.4;

/// @title DataType library
/// @notice Contains data types used in data compressor.
// SWC-Code With No Effects: L1 - L115
library DataTypes {
    struct Exchange {
        address[] path;
        uint256 amountOutMin;
    }

    struct TokenBalance {
        address token;
        uint256 balance;
    }

    struct ContractAdapter {
        address allowedContract;
        address adapter;
    }

    struct CreditAccountData {
        address addr;
        address borrower;
        bool inUse;
        address creditManager;
        address underlyingToken;
        uint256 borrowedAmountPlusInterest;
        uint256 totalValue;
        uint256 healthFactor;
        uint256 borrowRate;
        TokenBalance[] balances;
    }

    struct CreditAccountDataExtended {
        address addr;
        address borrower;
        bool inUse;
        address creditManager;
        address underlyingToken;
        uint256 borrowedAmountPlusInterest;
        uint256 totalValue;
        uint256 healthFactor;
        uint256 borrowRate;
        TokenBalance[] balances;
        uint256 repayAmount;
        uint256 liquidationAmount;
        bool canBeClosed;
        uint256 borrowedAmount;
        uint256 cumulativeIndexAtOpen;
        uint256 since;
    }

    struct CreditManagerData {
        address addr;
        bool hasAccount;
        address underlyingToken;
        bool isWETH;
        bool canBorrow;
        uint256 borrowRate;
        uint256 minAmount;
        uint256 maxAmount;
        uint256 maxLeverageFactor;
        uint256 availableLiquidity;
        address[] allowedTokens;
        ContractAdapter[] adapters;
    }

    struct PoolData {
        address addr;
        bool isWETH;
        address underlyingToken;
        address dieselToken;
        uint256 linearCumulativeIndex;
        uint256 availableLiquidity;
        uint256 expectedLiquidity;
        uint256 expectedLiquidityLimit;
        uint256 totalBorrowed;
        uint256 depositAPY_RAY;
        uint256 borrowAPY_RAY;
        uint256 dieselRate_RAY;
        uint256 withdrawFee;
        uint256 cumulativeIndex_RAY;
        uint256 timestampLU;
    }

    struct TokenInfo {
        address addr;
        string symbol;
        uint8 decimals;
    }

    struct AddressProviderData {
        address contractRegister;
        address acl;
        address priceOracle;
        address traderAccountFactory;
        address dataCompressor;
        address farmingFactory;
        address accountMiner;
        address treasuryContract;
        address gearToken;
        address wethToken;
        address wethGateway;
    }

    struct MiningApproval {
        address token;
        address swapContract;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-GearBox Protocol-GearBox Protocol/gearbox-contracts-0ac33ba87212ce056ac6b6357ad74161d417158a/contracts/interfaces/app/IDataCompressor.sol

// SPDX-License-Identifier: BSL-1.1
// Gearbox. Generalized leverage protocol that allows to take leverage and then use it across other DeFi protocols and platforms in a composable way.
// (c) Gearbox.fi, 2021
pragma solidity ^0.7.4;
pragma experimental ABIEncoderV2;

interface IDataCompressor {
    /// @dev Returns CreditAccountData for all opened account for particluar borrower
    /// @param borrower Borrower address
    function getCreditAccountList(address borrower)
        external
        view
        returns (DataTypes.CreditAccountData[] memory);

    function hasOpenedCreditAccount(address creditManager, address borrower)
        external
        view
        returns (bool);

    /// @dev Returns CreditAccountData for particular account for creditManager and borrower
    /// @param _creditManager Credit manager address
    /// @param borrower Borrower address
    function getCreditAccountData(address _creditManager, address borrower)
        external
        view
        returns (DataTypes.CreditAccountData memory);

    /// @dev Returns CreditAccountDataExtendeds for particular account for creditManager and borrower
    /// @param creditManager Credit manager address
    /// @param borrower Borrower address
    function getCreditAccountDataExtended(
        address creditManager,
        address borrower
    ) external view returns (DataTypes.CreditAccountDataExtended memory);

    /// @dev Returns all credit managers data + hasOpendAccount flag for bborrower
    /// @param borrower Borrower address
    function getCreditManagersList(address borrower)
        external
        view
        returns (DataTypes.CreditManagerData[] memory);

    /// @dev Returns CreditManagerData for particular _creditManager and
    /// set flg hasOpenedCreditAccount for provided borrower
    /// @param _creditManager CreditManager address
    /// @param borrower Borrower address
    function getCreditManagerData(address _creditManager, address borrower)
        external
        view
        returns (DataTypes.CreditManagerData memory);

    /// @dev Returns PoolData for particulr pool
    /// @param _pool Pool address
    function getPoolData(address _pool)
        external
        view
        returns (DataTypes.PoolData memory);

    /// @dev Returns PoolData for all registered pools
    function getPoolsList() external view returns (DataTypes.PoolData[] memory);

    /// @dev Returns compressed token data for particular token.
    /// Be careful, it can be reverted for non-standart tokens which has no "symbol" method for example
    function getTokenData(address addr)
        external
        view
        returns (DataTypes.TokenInfo memory);

    function calcExpectedHf(
        address creditManager,
        address borrower,
        uint256[] memory balances
    ) external view returns (uint256);
}
