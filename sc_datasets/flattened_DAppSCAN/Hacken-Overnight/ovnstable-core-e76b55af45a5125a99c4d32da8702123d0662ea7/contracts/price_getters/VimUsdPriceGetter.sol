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

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/connectors/mstable/MassetStructs.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0 <0.9.0;

    struct BassetPersonal {
        // Address of the bAsset
        address addr;
        // Address of the bAsset
        address integrator;
        // An ERC20 can charge transfer fee, for example USDT, DGX tokens.
        bool hasTxFee; // takes a byte in storage
        // Status of the bAsset
        BassetStatus status;
    }

    struct BassetData {
        // 1 Basset * ratio / ratioScale == x Masset (relative value)
        // If ratio == 10e8 then 1 bAsset = 10 mAssets
        // A ratio is divised as 10^(18-tokenDecimals) * measurementMultiple(relative value of 1 base unit)
        uint128 ratio;
        // Amount of the Basset that is held in Collateral
        uint128 vaultBalance;
    }

// Status of the Basset - has it broken its peg?
    enum BassetStatus {
        Default,
        Normal,
        BrokenBelowPeg,
        BrokenAbovePeg,
        Blacklisted,
        Liquidating,
        Liquidated,
        Failed
    }

    struct BasketState {
        bool undergoingRecol;
        bool failed;
    }

    struct FeederConfig {
        uint256 supply;
        uint256 a;
        WeightLimits limits;
    }

    struct InvariantConfig {
        uint256 supply;
        uint256 a;
        WeightLimits limits;
        uint256 recolFee;
    }

    struct BasicConfig {
        uint256 a;
        WeightLimits limits;
    }

    struct WeightLimits {
        uint128 min;
        uint128 max;
    }

    struct AmpData {
        uint64 initialA;
        uint64 targetA;
        uint64 rampStartTime;
        uint64 rampEndTime;
    }

    struct FeederData {
        uint256 swapFee;
        uint256 redemptionFee;
        uint256 govFee;
        uint256 pendingFees;
        uint256 cacheSize;
        BassetPersonal[] bAssetPersonal;
        BassetData[] bAssetData;
        AmpData ampData;
        WeightLimits weightLimits;
    }

    struct MassetData {
        uint256 swapFee;
        uint256 redemptionFee;
        uint256 cacheSize;
        uint256 surplus;
        BassetPersonal[] bAssetPersonal;
        BassetData[] bAssetData;
        BasketState basket;
        AmpData ampData;
        WeightLimits weightLimits;
    }

    struct AssetData {
        uint8 idx;
        uint256 amt;
        BassetPersonal personal;
    }

    struct Asset {
        uint8 idx;
        address addr;
        bool exists;
    }

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

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/connectors/mstable/interfaces/IMasset.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0 <0.9.0;
pragma abicoder v2;


abstract contract IMasset is IERC20 {
    // Mint
    function mint(
        address _input,
        uint256 _inputQuantity,
        uint256 _minOutputQuantity,
        address _recipient
    ) external virtual returns (uint256 mintOutput);

    function mintMulti(
        address[] calldata _inputs,
        uint256[] calldata _inputQuantities,
        uint256 _minOutputQuantity,
        address _recipient
    ) external virtual returns (uint256 mintOutput);

    function getMintOutput(address _input, uint256 _inputQuantity)
    external
    view
    virtual
    returns (uint256 mintOutput);

    function getMintMultiOutput(address[] calldata _inputs, uint256[] calldata _inputQuantities)
    external
    view
    virtual
    returns (uint256 mintOutput);

    // Swaps
    function swap(
        address _input,
        address _output,
        uint256 _inputQuantity,
        uint256 _minOutputQuantity,
        address _recipient
    ) external virtual returns (uint256 swapOutput);

    function getSwapOutput(
        address _input,
        address _output,
        uint256 _inputQuantity
    ) external view virtual returns (uint256 swapOutput);

    // Redemption
    function redeem(
        address _output,
        uint256 _mAssetQuantity,
        uint256 _minOutputQuantity,
        address _recipient
    ) external virtual returns (uint256 outputQuantity);

    function redeemMasset(
        uint256 _mAssetQuantity,
        uint256[] calldata _minOutputQuantities,
        address _recipient
    ) external virtual returns (uint256[] memory outputQuantities);

    function redeemExactBassets(
        address[] calldata _outputs,
        uint256[] calldata _outputQuantities,
        uint256 _maxMassetQuantity,
        address _recipient
    ) external virtual returns (uint256 mAssetRedeemed);

    function getRedeemOutput(address _output, uint256 _mAssetQuantity)
    external
    view
    virtual
    returns (uint256 bAssetOutput);

    function getRedeemExactBassetsOutput(
        address[] calldata _outputs,
        uint256[] calldata _outputQuantities
    ) external view virtual returns (uint256 mAssetAmount);

    // Views
    function getBasket() external view virtual returns (bool, bool);

    function getBasset(address _token)
    external
    view
    virtual
    returns (BassetPersonal memory personal, BassetData memory data);

    function getBassets()
    external
    view
    virtual
    returns (BassetPersonal[] memory personal, BassetData[] memory data);

    function bAssetIndexes(address) external view virtual returns (uint8);

    function getPrice() external view virtual returns (uint256 price, uint256 k);

    // SavingsManager
    function collectInterest() external virtual returns (uint256 swapFeesGained, uint256 newSupply);

    function collectPlatformInterest()
    external
    virtual
    returns (uint256 mintAmount, uint256 newSupply);

    // Admin
    function setCacheSize(uint256 _cacheSize) external virtual;

    function setFees(uint256 _swapFee, uint256 _redemptionFee) external virtual;

    function setTransferFeesFlag(address _bAsset, bool _flag) external virtual;

    function migrateBassets(address[] calldata _bAssets, address _newIntegration) external virtual;
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/connectors/mstable/interfaces/ISavingsContract.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0 <0.9.0;

interface ISavingsContractV1 is IERC20 {
    function depositInterest(uint256 _amount) external;

    function depositSavings(uint256 _amount) external returns (uint256 creditsIssued);

    function redeem(uint256 _amount) external returns (uint256 massetReturned);

    function exchangeRate() external view returns (uint256);

    function creditBalances(address) external view returns (uint256);
}

interface ISavingsContractV2 is IERC20 {
    // DEPRECATED but still backwards compatible
    function redeem(uint256 _amount) external returns (uint256 massetReturned);

    function creditBalances(address) external view returns (uint256); // V1 & V2 (use balanceOf)

    // --------------------------------------------

    function depositInterest(uint256 _amount) external; // V1 & V2

    function depositSavings(uint256 _amount) external returns (uint256 creditsIssued); // V1 & V2

    function depositSavings(uint256 _amount, address _beneficiary)
        external
        returns (uint256 creditsIssued); // V2

    function redeemCredits(uint256 _amount) external returns (uint256 underlyingReturned); // V2

    function redeemUnderlying(uint256 _amount) external returns (uint256 creditsBurned); // V2

    function exchangeRate() external view returns (uint256); // V1 & V2

    function balanceOfUnderlying(address _user) external view returns (uint256 underlying); // V2

    function underlyingToCredits(uint256 _underlying) external view returns (uint256 credits); // V2

    function creditsToUnderlying(uint256 _credits) external view returns (uint256 underlying); // V2

    function underlying() external view returns (IERC20 underlyingMasset); // V2
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/price_getters/VimUsdPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;




contract VimUsdPriceGetter is AbstractPriceGetter, Ownable {

    address public usdcToken;
    IMasset public mUsdToken;
    ISavingsContractV2 public imUsdToken;

    constructor(
        address _usdcToken,
        address _mUsdToken,
        address _imUsdToken
    ) {
        require(_usdcToken != address(0), "Zero address not allowed");
        require(_mUsdToken != address(0), "Zero address not allowed");
        require(_imUsdToken != address(0), "Zero address not allowed");

        usdcToken = _usdcToken;
        mUsdToken = IMasset(_mUsdToken);
        imUsdToken = ISavingsContractV2(_imUsdToken);
    }

    function getUsdcBuyPrice() external view override returns (uint256) {
        uint256 mintOutput = mUsdToken.getMintOutput(usdcToken, (10 ** 6));
        return (10 ** 36) / imUsdToken.underlyingToCredits(mintOutput);
    }

    function getUsdcSellPrice() external view override returns (uint256) {
        uint256 underlying = imUsdToken.creditsToUnderlying(10 ** 18);
        return mUsdToken.getRedeemOutput(usdcToken, underlying) * (10 ** 12);
    }
}
