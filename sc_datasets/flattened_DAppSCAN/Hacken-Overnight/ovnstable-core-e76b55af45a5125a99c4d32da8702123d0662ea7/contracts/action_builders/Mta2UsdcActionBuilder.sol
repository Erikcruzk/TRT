// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/interfaces/ITokenExchange.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

interface ITokenExchange {

    function exchange(
        address spender,
        IERC20 from,
        address receiver,
        IERC20 to,
        uint256 amount
    ) external;

}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/interfaces/IMark2Market.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

interface IMark2Market {
    struct AssetPrices {
        address asset;
        uint256 amountInVault; // balance on Vault
        uint256 usdcPriceInVault; // current total price of balance at USDC
        //
        uint256 usdcPriceDenominator;
        uint256 usdcSellPrice;
        uint256 usdcBuyPrice;
        //
        uint256 decimals;
        string name;
        string symbol;
    }

    struct TotalAssetPrices {
        AssetPrices[] assetPrices;
        uint256 totalUsdcPrice;
    }

    struct BalanceAssetPrices {
        address asset;
        int256 diffToTarget; // diff token to target in portfolio
        bool targetIsZero; // mean that we should trade all tokens to zero ownership
    }

    function assetPrices() external view returns (TotalAssetPrices memory);

    // Return value 10*18
    function totalSellAssets() external view returns (uint256);

    // Return value 10*18
    function totalBuyAssets() external view returns (uint256);

    function assetPricesForBalance() external view returns (BalanceAssetPrices[] memory);

    function assetPricesForBalance(address withdrawToken, uint256 withdrawAmount) external view returns (BalanceAssetPrices[] memory);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/interfaces/IActionBuilder.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;



interface IActionBuilder {
    struct ExchangeAction {
        ITokenExchange tokenExchange;
        bytes32 code;
        IERC20 from;
        IERC20 to;
        uint256 amount; // amount at usdc with 6 digit fractions
        bool exchangeAll; // mean that we should trade all tokens to zero ownership
        bool executed;
    }

    function getActionCode() external pure returns (bytes32);

    function buildAction(
        IMark2Market.BalanceAssetPrices[] memory assetPrices,
        ExchangeAction[] memory actions
    ) external view returns (ExchangeAction memory);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/action_builders/Mta2UsdcActionBuilder.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;




contract Mta2UsdcActionBuilder is IActionBuilder {
    bytes32 constant ACTION_CODE = keccak256("Mta2Usdc");

    ITokenExchange public tokenExchange;
    IERC20 public usdcToken;
    IERC20 public mtaToken;

    constructor(
        address _tokenExchange,
        address _usdcToken,
        address _mtaToken
    ) {
        require(_tokenExchange != address(0), "Zero address not allowed");
        require(_usdcToken != address(0), "Zero address not allowed");
        require(_mtaToken != address(0), "Zero address not allowed");

        tokenExchange = ITokenExchange(_tokenExchange);
        usdcToken = IERC20(_usdcToken);
        mtaToken = IERC20(_mtaToken);
    }

    function getActionCode() external pure override returns (bytes32) {
        return ACTION_CODE;
    }

    function buildAction(
        IMark2Market.BalanceAssetPrices[] memory assetPrices,
        ExchangeAction[] memory actions
    ) external view override returns (ExchangeAction memory) {
        // get diff from iteration over prices because can't use mapping in memory params to external functions
        IMark2Market.BalanceAssetPrices memory mtaPrices;
        IMark2Market.BalanceAssetPrices memory usdcPrices;
        for (uint8 i = 0; i < assetPrices.length; i++) {
            if (assetPrices[i].asset == address(mtaToken)) {
                mtaPrices = assetPrices[i];
            } else if (assetPrices[i].asset == address(usdcToken)) {
                usdcPrices = assetPrices[i];
            }
        }

        // because we know that mta is leaf in tree and we can use this value
        int256 diff = mtaPrices.diffToTarget;

        uint256 amount;
        IERC20 from;
        IERC20 to;
        bool targetIsZero;
        if (mtaPrices.targetIsZero || diff < 0) {
            amount = uint256(- diff);
            from = mtaToken;
            to = usdcToken;
            targetIsZero = mtaPrices.targetIsZero;
        } else {
            amount = uint256(diff);
            from = usdcToken;
            to = mtaToken;
            targetIsZero = usdcPrices.targetIsZero;
        }

        ExchangeAction memory action = ExchangeAction(
            tokenExchange,
            ACTION_CODE,
            from,
            to,
            amount,
            targetIsZero,
            false
        );

        return action;
    }
}
