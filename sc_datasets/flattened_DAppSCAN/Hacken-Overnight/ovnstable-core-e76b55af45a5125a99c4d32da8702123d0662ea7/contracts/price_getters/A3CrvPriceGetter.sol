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
