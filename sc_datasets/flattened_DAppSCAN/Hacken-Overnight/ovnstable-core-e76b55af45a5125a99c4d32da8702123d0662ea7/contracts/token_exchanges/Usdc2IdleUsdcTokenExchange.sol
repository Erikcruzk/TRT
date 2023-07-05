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

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
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

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/interfaces/IConnector.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// @title Common inrterface to DeFi protocol connectors
/// @author @Stanta
/// @notice Every connector have to implement this function
/// @dev Choosing of connector releasing by changing address of connector's contract
interface IConnector {
    function stake(
        address _asset,
        uint256 _amount,
        address _beneficiar
    ) external;

    function unstake(
        address _asset,
        uint256 _amount,
        address _to
    ) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/token_exchanges/Usdc2IdleUsdcTokenExchange.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;




contract Usdc2IdleUsdcTokenExchange is ITokenExchange {
    IConnector public idleConnector;
    IERC20 public usdcToken;
    IERC20 public idleUsdcToken;

    uint256 usdcDenominator;
    uint256 idleUsdcDenominator;

    constructor(
        address _idleConnector,
        address _usdcToken,
        address _idleUsdcToken
    ) {
        require(_idleConnector != address(0), "Zero address not allowed");
        require(_usdcToken != address(0), "Zero address not allowed");
        require(_idleUsdcToken != address(0), "Zero address not allowed");

        idleConnector = IConnector(_idleConnector);
        usdcToken = IERC20(_usdcToken);
        idleUsdcToken = IERC20(_idleUsdcToken);

        usdcDenominator = 10 ** (18 - IERC20Metadata(address(usdcToken)).decimals());
        idleUsdcDenominator = 10 ** (18 - IERC20Metadata(address(idleUsdcToken)).decimals());
    }

    function exchange(
        address spender,
        IERC20 from,
        address receiver,
        IERC20 to,
        uint256 amount
    ) external override {
        require(
            (from == usdcToken && to == idleUsdcToken) || (from == idleUsdcToken && to == usdcToken),
            "Usdc2IdleUsdcTokenExchange: Some token not compatible"
        );

        if (amount == 0) {
            uint256 fromBalance = from.balanceOf(address(this));
            if (fromBalance > 0) {
                from.transfer(spender, fromBalance);
            }
            return;
        }

        if (from == usdcToken && to == idleUsdcToken) {
            //TODO: denominator usage
            amount = amount / usdcDenominator;

            // if amount eq 0 after normalization transfer back balance and skip staking
            uint256 balance = usdcToken.balanceOf(address(this));
            if (amount == 0) {
                if (balance > 0) {
                    usdcToken.transfer(spender, balance);
                }
                return;
            }

            require(
                balance >= amount,
                "Usdc2IdleUsdcTokenExchange: Not enough usdcToken"
            );

            usdcToken.transfer(address(idleConnector), amount);
            idleConnector.stake(address(usdcToken), amount, receiver);

            // transfer back unused amount
            uint256 unusedBalance = usdcToken.balanceOf(address(this));
            if (unusedBalance > 0) {
                usdcToken.transfer(spender, unusedBalance);
            }
        } else {
            //TODO: denominator usage
            amount = amount / idleUsdcDenominator;

            // if amount eq 0 after normalization transfer back balance and skip staking
            uint256 balance = idleUsdcToken.balanceOf(address(this));
            if (amount == 0) {
                if (balance > 0) {
                    idleUsdcToken.transfer(spender, balance);
                }
                return;
            }

            // aToken on transfer can lost/add 1 wei. On lost we need correct amount
            if (balance + 1 == amount) {
                amount = amount - 1;
            }

            require(
                balance >= amount,
                "Usdc2IdleUsdcTokenExchange: Not enough idleUsdcToken"
            );

            // move assets to connector
            idleUsdcToken.transfer(address(idleConnector), amount);

            // correct exchangeAmount if we got diff on aToken transfer
            uint256 onIdleConnectorBalance = idleUsdcToken.balanceOf(address(idleConnector));
            if (onIdleConnectorBalance < amount) {
                amount = onIdleConnectorBalance;
            }
            uint256 withdrewAmount = idleConnector.unstake(address(usdcToken), amount, receiver);

            //TODO: may be add some checks for withdrewAmount

            // transfer back unused amount
            uint256 unusedBalance = idleUsdcToken.balanceOf(address(this));
            if (unusedBalance > 0) {
                idleUsdcToken.transfer(spender, unusedBalance);
            }
        }
    }
}
