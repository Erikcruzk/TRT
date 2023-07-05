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

// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/interfaces/IPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IPriceGetter {
    /**
     * Token buy price at USDC. Amount of USDC we should spend to buy one token.
     * Returned value is [USDC/token]
     * Usage: tokenAmount = usdcAmount * denominator() / getUsdcBuyPrice()
     * Normilized to 10**18
     */
    function getUsdcBuyPrice() external view returns (uint256);

    /**
     * Token sell price at USDC. Amount of USDC we got if sell one token.
     * Returned value is [USDC/token]
     * Usage: usdcAmount = tokenAmount * getUsdcSellPrice() / denominator()
     * Normilized to 10**18
     */
    function getUsdcSellPrice() external view returns (uint256);

    /**
     * Denominator for normalization. Default 10**18.
     */
    function denominator() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/price_getters/AbstractPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract AbstractPriceGetter is IPriceGetter {
    uint256 public constant DENOMINATOR = 10**18;

    function getUsdcBuyPrice() external view virtual override returns (uint256) {
        return DENOMINATOR;
    }

    function getUsdcSellPrice() external view virtual override returns (uint256) {
        return DENOMINATOR;
    }

    function denominator() external view virtual override returns (uint256) {
        return DENOMINATOR;
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/connectors/curve/interfaces/iCurvePool.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title Connector to curve->aave
/// @notice from https://github.com/curvefi/curve-contract-polygon/blob/master/contracts/pools/aave/StableSwapAave.vy
/// @dev check number of coins in pool and add functions  with necessary  uint256[N_COINS]

interface iCurvePool {

// def add_liquidity(_amounts: uint256[N_COINS], _min_mint_amount: uint256, _use_underlying: bool = False) -> uint256:
function add_liquidity (uint[3] memory _amounts, uint256 _min_mint_amount, bool _use_underlying) external returns (uint256); //check uint[3] memory or calldata

 /** def remove_liquidity(
    _amount: uint256,
    _min_amounts: uint256[N_COINS],
    _use_underlying: bool = False,
) -> uint256[N_COINS]:
 */
function remove_liquidity (uint256 _amounts, uint[3] memory _min_amounts, bool _use_underlying) external returns (uint256[3] memory ); //check uint[3] memory or calldata
function underlying_coins (uint i ) external view returns (address);
function lp_token () external view returns (address);
function calc_token_amount(uint[3] memory _amounts, bool _is_deposite) external view  returns (uint256);
function coins(uint256 i) external view returns (address);
function get_virtual_price() external view returns (uint256);
// StableSwap.get_dy(i: int128, j: int128, _dx: uint256) → uint256: view
function get_dy(int128 i, int128 j, uint256 _dx ) external view returns (uint256);
function calc_withdraw_one_coin(uint256 _amount, int128 i) external view returns (uint256);
//remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) → uint256
function remove_liquidity_one_coin(uint256 _token_amount , int128 i, uint256 _min_amount) external returns  (uint256);
// StableSwap.remove_liquidity_imbalance(_amounts: uint256[N_COINS], _max_burn_amount: uint256) → uint256
function remove_liquidity_imbalance(uint[3] memory _amounts, uint256 _maxAmount ) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/price_getters/A3CrvPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;



contract A3CrvPriceGetter is AbstractPriceGetter, Ownable {
    iCurvePool public pool;

    event UpdatedPool(address pool);

    function setPool(address _pool) public onlyOwner {
        require(_pool != address(0), "Zero address not allowed");
        pool = iCurvePool(_pool);
        emit UpdatedPool(_pool);
    }

    function getUsdcBuyPrice() external view override returns (uint256) {
        return pool.get_virtual_price();
    }

    function getUsdcSellPrice() external view override returns (uint256) {
        return pool.get_virtual_price();
    }
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

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/price_getters/A3CrvGaugePriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;






contract A3CrvGaugePriceGetter is AbstractPriceGetter, Ownable {
    A3CrvPriceGetter public a3CrvPriceGetter;

    event UpdatedA3CrvPriceGetter(address a3CrvPriceGetter);

    function setA3CrvPriceGetter(address _a3CrvPriceGetter) public onlyOwner {
        require(_a3CrvPriceGetter != address(0), "Zero address not allowed");
        a3CrvPriceGetter = A3CrvPriceGetter(_a3CrvPriceGetter);
        emit UpdatedA3CrvPriceGetter(_a3CrvPriceGetter);
    }

    function getUsdcBuyPrice() external view override returns (uint256) {
        // a3CrvGauge is 1:1 to a3Crv
        return a3CrvPriceGetter.getUsdcBuyPrice();
    }

    function getUsdcSellPrice() external view override returns (uint256) {
        // a3CrvGauge is 1:1 to a3Crv
        return a3CrvPriceGetter.getUsdcSellPrice();
    }
}
