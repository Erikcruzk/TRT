// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-MapleFinance/debt-locker-05b4f2fe119e2ddf3dc0e441055c602f748e7d52/contracts/interfaces/Interfaces.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IERC20Like {

    function decimals() external view returns (uint256 decimals_);

    function balanceOf(address account_) external view returns (uint256 balanceOf_);

}

interface ILiquidatorLike {

    function auctioneer() external view returns (address auctioneer_);
}

interface IMapleGlobalsLike {

   function defaultUniswapPath(address fromAsset_, address toAsset_) external view returns (address intermediateAsset_);

   function investorFee() external view returns (uint256 investorFee_);

   function mapleTreasury() external view returns (address mapleTreasury_);

   function treasuryFee() external view returns (uint256 treasuryFee_);

   function getLatestPrice(address asset_) external view returns (uint256 price_);

}

interface IMapleLoanLike {

    function acceptNewTerms(address refinancer_, bytes[] calldata calls_, uint256 amount_) external;

    function claimableFunds() external view returns (uint256 claimableFunds_);

    function collateralAsset() external view returns (address collateralAsset_);

    function fundsAsset() external view returns (address fundsAsset_);

    function lender() external view returns (address lender_);

    function principal() external view returns (uint256 principal_);

    function principalRequested() external view returns (uint256 principalRequested_);

    function claimFunds(uint256 amount_, address destination_) external;

    function repossess(address destination_) external returns (uint256 collateralAssetAmount_, uint256 fundsAssetAmount_);

}

interface IPoolLike {

    function poolDelegate() external view returns (address poolDelegate_);

    function superFactory() external view returns (address superFactory_);

}

interface IPoolFactoryLike {

    function globals() external pure returns (address globals_);

}

interface IUniswapRouterLike {

    function swapExactTokensForTokens(
        uint amountIn_,
        uint amountOutMin_,
        address[] calldata path_,
        address to_,
        uint deadline_
    ) external returns (uint[] memory amounts_);

}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-MapleFinance/debt-locker-05b4f2fe119e2ddf3dc0e441055c602f748e7d52/contracts/DebtLockerStorage.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

/// @title DebtLockerStorage maps the storage layout of a DebtLocker.
contract DebtLockerStorage {

    address internal _loan;
    address internal _liquidator;
    address internal _pool;

    uint256 internal _allowedSlippage;
    uint256 internal _amountRecovered;
    uint256 internal _fundsToCapture;
    uint256 internal _minRatio;
    uint256 internal _principalRemainingAtLastClaim;

    bool internal _repossessed;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-MapleFinance/debt-locker-05b4f2fe119e2ddf3dc0e441055c602f748e7d52/contracts/DebtLockerInitializer.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

/// @title DebtLockerInitializer is intended to initialize the storage of a DebtLocker proxy.
contract DebtLockerInitializer is DebtLockerStorage {

    function encodeArguments(address loan_, address pool_) external pure returns (bytes memory encodedArguments_) {
        return abi.encode(loan_, pool_);
    }

    function decodeArguments(bytes calldata encodedArguments_) public pure returns (address loan_, address pool_) {
        ( loan_, pool_ ) = abi.decode(encodedArguments_, (address, address));
    }

    fallback() external {
        ( address loan_, address pool_ ) = decodeArguments(msg.data);

        _loan = loan_;
        _pool = pool_;

        _principalRemainingAtLastClaim = IMapleLoanLike(loan_).principalRequested();
    }

}
