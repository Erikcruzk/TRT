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

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/connectors/curve/interfaces/IRewardOnlyGauge.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

interface IRewardOnlyGauge is IERC20 {
    function deposit(
        uint256 _value,
        address _addr,
        bool _claim_rewards
    ) external;

    function deposit(uint256 _value, address _addr) external;

    function deposit(uint256 _value, bool _claim_rewards) external;

    function deposit(uint256 _value) external;

    function withdraw(uint256 _value, bool _claim_rewards) external;

    function withdraw(uint256 _value) external;

    function lp_token() external returns (address);

    function claim_rewards(address _addr, address _receiver) external;

    function claim_rewards(address _addr) external;

    function claim_rewards() external;

    function claimed_reward(address _addr, address _token) external returns (uint256);

    function claimable_reward(address _addr, address _token) external returns (uint256);

    function claimable_reward_write(address _addr, address _token) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/token_exchanges/A3Crv2A3CrvGaugeTokenExchange.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;




contract A3Crv2A3CrvGaugeTokenExchange is ITokenExchange {
    IRewardOnlyGauge public rewardGauge;
    IERC20 public a3CrvToken;
    IERC20 public a3CrvGaugeToken;

    constructor(address _curveGauge) {
        require(_curveGauge != address(0), "Zero address not allowed");

        rewardGauge = IRewardOnlyGauge(_curveGauge);
        a3CrvToken = IERC20(rewardGauge.lp_token());
        a3CrvGaugeToken = IERC20(_curveGauge);
    }

    function exchange(
        address spender,
        IERC20 from,
        address receiver,
        IERC20 to,
        uint256 amount
    ) external override {
        require(
            (from == a3CrvToken && to == a3CrvGaugeToken) ||
                (from == a3CrvGaugeToken && to == a3CrvToken),
            "A3Crv2A3CrvGaugeTokenExchange: Some token not compatible"
        );

        if (amount == 0) {
            from.transfer(spender, from.balanceOf(address(this)));
            return;
        }

        if (from == a3CrvToken && to == a3CrvGaugeToken) {
            //TODO: denominator usage
            uint256 denominator = 10**(18 - IERC20Metadata(address(a3CrvToken)).decimals());
            amount = amount / denominator;

            uint256 a3CrvBalance = a3CrvToken.balanceOf(address(this));
            require(
                a3CrvBalance >= amount,
                "A3Crv2A3CrvGaugeTokenExchange: Not enough a3CrvToken"
            );

            // check after denormilization
            if (amount == 0) {
                a3CrvToken.transfer(spender, a3CrvBalance);
                return;
            }

            // gauge need approve on deposit cause by transferFrom inside deposit
            a3CrvToken.approve(address(rewardGauge), amount);
            rewardGauge.deposit(amount, receiver, false);
        } else {
            //TODO: denominator usage
            uint256 denominator = 10**(18 - IERC20Metadata(address(a3CrvGaugeToken)).decimals());
            amount = amount / denominator;

            uint256 a3CrvGaugeBalance = a3CrvGaugeToken.balanceOf(address(this));
            require(
                a3CrvGaugeBalance >= amount,
                "A3Crv2A3CrvGaugeTokenExchange: Not enough a3CrvGaugeToken"
            );

            // check after denormilization
            if (amount == 0) {
                a3CrvGaugeToken.transfer(spender, a3CrvGaugeBalance);
                return;
            }

            // gauge doesn't need approve on withdraw, but we should have amount token
            // on tokenExchange
            rewardGauge.withdraw(amount, false);

            uint256 a3CrvBalance = a3CrvToken.balanceOf(address(this));
            require(
                a3CrvBalance >= amount,
                "A3Crv2A3CrvGaugeTokenExchange: Not enough a3CrvToken after withdraw"
            );
            // reward gauge transfer tokens to msg.sender, so transfer to receiver
            a3CrvToken.transfer(receiver, a3CrvBalance);
        }
    }
}
