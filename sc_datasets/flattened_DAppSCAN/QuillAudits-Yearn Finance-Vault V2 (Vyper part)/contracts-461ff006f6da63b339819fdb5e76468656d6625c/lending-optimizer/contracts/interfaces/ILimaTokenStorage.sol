// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/ILimaSwap.sol

pragma solidity ^0.6.6;

interface ILimaSwap {
    function getGovernanceToken(address token) external view returns (address);

    function getExpectedReturn(
        address fromToken,
        address toToken,
        uint256 amount
    ) external view returns (uint256 returnAmount);

    function swap(
        address recipient,
        address from,
        address to,
        uint256 amount,
        uint256 minReturnAmount
    ) external returns (uint256 returnAmount);

    function unwrap(
        address interestBearingToken,
        uint256 amount,
        address recipient
    ) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/ILimaOracle.sol

pragma solidity ^0.6.6;

interface ILimaOracle {
    function fetchBestTokenAPR()
        external
        view
        returns (
            uint8,
            address,
            address
        );

    function requestDeliveryStatus(address _receiver)
        external 
        returns  (
            bytes32 requestId
        );
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/ILimaTokenStorage.sol

pragma solidity ^0.6.2;


/**
 * @title LimaToken
 * @author Lima Protocol
 *
 * Standard LimaToken.
 */
interface ILimaTokenStorage {
    function MAX_UINT256() external view returns (uint256);

    function WETH() external view returns (address);

    function LINK() external view returns (address);

    function currentUnderlyingToken() external view returns (address);

    // address external owner;
    function limaSwap() external view returns (ILimaSwap);

    function rebalanceBonus() external view returns (uint256);

    function rebalanceGas() external view returns (uint256);

    //Fees
    function feeWallet() external view returns (address);

    function burnFee() external view returns (uint256);

    function mintFee() external view returns (uint256);

    function performanceFee() external view returns (uint256);

    function requestId() external view returns (bytes32);

    //Rebalance
    function lastUnderlyingBalancePer1000() external view returns (uint256);

    function lastRebalance() external view returns (uint256);

    function rebalanceInterval() external view returns (uint256);

    function limaManager() external view returns (address);

    function owner() external view returns (address);

    function oracle() external view returns (ILimaOracle);

    function oracleData() external view returns (bytes32);

    function isRebalancing() external view returns (bool);

    function isOracleDataReturned() external view returns (bool);

    function shouldRebalance(
        uint256 _newToken,
        uint256 _minimumReturnGov,
        uint256 _amountToSellForLink
    ) external view returns (bool);

    function governanceToken(uint256 _protocoll)
        external
        view
        returns (address);

    function minimumReturnLink() external view returns (uint256);

    /* ============ Setter ============ */

    function addUnderlyingToken(address _underlyingToken) external;

    function removeUnderlyingToken(address _underlyingToken) external;

    function setCurrentUnderlyingToken(address _currentUnderlyingToken)
        external;

    function setFeeWallet(address _feeWallet) external;

    function setBurnFee(uint256 _burnFee) external;

    function setMintFee(uint256 _mintFee) external;

    function setRequestId(bytes32 _requestId) external;

    function setLimaToken(address _limaToken) external;

    function setPerformanceFee(uint256 _performanceFee) external;

    function setLastUnderlyingBalancePer1000(
        uint256 _lastUnderlyingBalancePer1000
    ) external;

    function setLastRebalance(uint256 _lastRebalance) external;

    function setLimaSwap(address _limaSwap) external;

    function setRebalanceInterval(uint256 _rebalanceInterval) external;

    function setOracleData(bytes32 _data) external;

    function setRebalanceGas(uint256 _rebalanceGas) external;

    function setRebalanceBonus(uint256 _rebalanceBonus) external;

    function setIsRebalancing(bool _isRebalancing) external;

    function setIsOracleDataReturned(bool _isOracleDataReturned) external;

    function setRebalanceData(
        uint256 bestToken,
        uint256 minimumReturn,
        uint256 minimumReturnGov,
        uint256 amountToSellForLink
    ) external;

    function getRebalancingData()
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            address
        );

    /* ============ View ============ */

    function isUnderlyingTokens(address _underlyingToken)
        external
        view
        returns (bool);
}
