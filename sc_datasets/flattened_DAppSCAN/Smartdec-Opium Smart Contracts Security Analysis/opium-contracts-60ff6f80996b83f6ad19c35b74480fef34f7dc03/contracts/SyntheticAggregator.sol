// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/Lib/LibDerivative.sol

pragma solidity ^0.5.4;
pragma experimental ABIEncoderV2;

/// @title Opium.Lib.LibDerivative contract should be inherited by contracts that use Derivative structure and calculate derivativeHash
contract LibDerivative {
    // Opium derivative structure (ticker) definition
    struct Derivative {
        // Margin parameter for syntheticId
        uint256 margin;
        // Maturity of derivative
        uint256 endTime;
        // Additional parameters for syntheticId
        uint256[] params;
        // oracleId of derivative
        address oracleId;
        // Margin token address of derivative
        address token;
        // syntheticId of derivative
        address syntheticId;
    }

    /// @notice Calculates hash of provided Derivative
    /// @param _derivative Derivative Instance of derivative to hash
    /// @return derivativeHash bytes32 Derivative hash
    function getDerivativeHash(Derivative memory _derivative) public pure returns (bytes32 derivativeHash) {
        derivativeHash = keccak256(abi.encodePacked(
            _derivative.margin,
            _derivative.endTime,
            _derivative.params,
            _derivative.oracleId,
            _derivative.token,
            _derivative.syntheticId
        ));
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/Lib/LibCommission.sol

pragma solidity ^0.5.4;

/// @title Opium.Lib.LibCommission contract defines constants for Opium commissions
contract LibCommission {
    // Represents 100% base for commissions calculation
    uint256 constant COMMISSION_BASE = 10000;

    // Represents 100% base for Opium commission
    uint256 constant OPIUM_COMMISSION_BASE = 10;

    // Represents which part of `syntheticId` author commissions goes to opium
    uint256 constant OPIUM_COMMISSION_PART = 1;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/Errors/SyntheticAggregatorErrors.sol

pragma solidity ^0.5.4;

contract SyntheticAggregatorErrors {
    string constant internal ERROR_SYNTHETIC_AGGREGATOR_DERIVATIVE_HASH_NOT_MATCH = "SYNTHETIC_AGGREGATOR:DERIVATIVE_HASH_NOT_MATCH";
    string constant internal ERROR_SYNTHETIC_AGGREGATOR_WRONG_MARGIN = "SYNTHETIC_AGGREGATOR:WRONG_MARGIN";
    string constant internal ERROR_SYNTHETIC_AGGREGATOR_COMMISSION_TOO_BIG = "SYNTHETIC_AGGREGATOR:COMMISSION_TOO_BIG";
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/Interface/IOracleId.sol

pragma solidity ^0.5.4;

/// @title Opium.Interface.IOracleId contract is an interface that every oracleId should implement
interface IOracleId {
    /// @notice Requests data from `oracleId` one time
    /// @param timestamp uint256 Timestamp at which data are needed
    function fetchData(uint256 timestamp) external payable;

    /// @notice Requests data from `oracleId` multiple times
    /// @param timestamp uint256 Timestamp at which data are needed for the first time
    /// @param period uint256 Period in seconds between multiple timestamps
    /// @param times uint256 How many timestamps are requested
    function recursivelyFetchData(uint256 timestamp, uint256 period, uint256 times) external payable;

    /// @notice Requests and returns price in ETH for one request. This function could be called as `view` function. Oraclize API for price calculations restricts making this function as view.
    /// @return fetchPrice uint256 Price of one data request in ETH
    function calculateFetchPrice() external returns (uint256 fetchPrice);

    // Event with oracleId metadata JSON string (for DIB.ONE derivative explorer)
    event MetadataSet(string metadata);
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/Interface/IDerivativeLogic.sol

pragma solidity ^0.5.4;
pragma experimental ABIEncoderV2;

/// @title Opium.Interface.IDerivativeLogic contract is an interface that every syntheticId should implement
contract IDerivativeLogic is LibDerivative {
    /// @notice Validates ticker
    /// @param _derivative Derivative Instance of derivative to validate
    /// @return Returns boolean whether ticker is valid
    function validateInput(Derivative memory _derivative) public view returns (bool);

    /// @notice Calculates margin required for derivative creation
    /// @param _derivative Derivative Instance of derivative
    /// @return buyerMargin uint256 Margin needed from buyer (LONG position)
    /// @return sellerMargin uint256 Margin needed from seller (SHORT position)
    function getMargin(Derivative memory _derivative) public view returns (uint256 buyerMargin, uint256 sellerMargin);

    /// @notice Calculates payout for derivative execution
    /// @param _derivative Derivative Instance of derivative
    /// @param _result uint256 Data retrieved from oracleId on the maturity
    /// @return buyerPayout uint256 Payout in ratio for buyer (LONG position holder)
    /// @return sellerPayout uint256 Payout in ratio for seller (SHORT position holder)
    function getExecutionPayout(Derivative memory _derivative, uint256 _result)	public view returns (uint256 buyerPayout, uint256 sellerPayout);

    /// @notice Returns syntheticId author address for Opium commissions
    /// @return authorAddress address The address of syntheticId address
    function getAuthorAddress() public view returns (address authorAddress);

    /// @notice Returns syntheticId author commission in base of COMMISSION_BASE
    /// @return commission uint256 Author commission
    function getAuthorCommission() public view returns (uint256 commission);

    /// @notice Returns whether thirdparty could execute on derivative's owner's behalf
    /// @param _derivativeOwner address Derivative owner address
    /// @return Returns boolean whether _derivativeOwner allowed third party execution
    function thirdpartyExecutionAllowed(address _derivativeOwner) public view returns (bool);

    /// @notice Returns whether syntheticId implements pool logic
    /// @return Returns whether syntheticId implements pool logic
    function isPool() public view returns (bool);

    /// @notice Sets whether thirds parties are allowed or not to execute derivative's on msg.sender's behalf
    /// @param _allow bool Flag for execution allowance
    function allowThirdpartyExecution(bool _allow) public;

    // Event with syntheticId metadata JSON string (for DIB.ONE derivative explorer)
    event MetadataSet(string metadata);
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/SyntheticAggregator.sol

pragma solidity ^0.5.4;
pragma experimental ABIEncoderV2;



/// @notice Opium.SyntheticAggregator contract initialized, identifies and caches syntheticId sensitive data
contract SyntheticAggregator is SyntheticAggregatorErrors, LibDerivative, LibCommission, ReentrancyGuard {
    // Emitted when new ticker is initialized
    event Create(Derivative derivative, bytes32 derivativeHash);

    // Enum for types of syntheticId
    // Invalid - syntheticId is not initialized yet
    // NotPool - syntheticId with p2p logic
    // Pool - syntheticId with pooled logic
    enum SyntheticTypes { Invalid, NotPool, Pool }

    // Cache of buyer margin by ticker
    // buyerMarginByHash[derivativeHash] = buyerMargin
    mapping (bytes32 => uint256) public buyerMarginByHash;

    // Cache of seller margin by ticker
    // sellerMarginByHash[derivativeHash] = sellerMargin
    mapping (bytes32 => uint256) public sellerMarginByHash;

    // Cache of type by ticker
    // typeByHash[derivativeHash] = type
    mapping (bytes32 => SyntheticTypes) public typeByHash;

    // Cache of commission by ticker
    // commissionByHash[derivativeHash] = commission
    mapping (bytes32 => uint256) public commissionByHash;

    // Cache of author addresses by ticker
    // authorAddressByHash[derivativeHash] = authorAddress
    mapping (bytes32 => address) public authorAddressByHash;

    // PUBLIC FUNCTIONS

    /// @notice Initializes ticker, if was not initialized and returns `syntheticId` author commission from cache
    /// @param _derivativeHash bytes32 Hash of derivative
    /// @param _derivative Derivative Derivative itself
    /// @return commission uint256 Synthetic author commission
    function getAuthorCommission(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (uint256 commission) {
        // Initialize derivative if wasn't initialized before
        _initDerivative(_derivativeHash, _derivative);
        commission = commissionByHash[_derivativeHash];
    }

    /// @notice Initializes ticker, if was not initialized and returns `syntheticId` author address from cache
    /// @param _derivativeHash bytes32 Hash of derivative
    /// @param _derivative Derivative Derivative itself
    /// @return authorAddress address Synthetic author address
    function getAuthorAddress(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (address authorAddress) {
        // Initialize derivative if wasn't initialized before
        _initDerivative(_derivativeHash, _derivative);
        authorAddress = authorAddressByHash[_derivativeHash];
    }

    /// @notice Initializes ticker, if was not initialized and returns buyer and seller margin from cache
    /// @param _derivativeHash bytes32 Hash of derivative
    /// @param _derivative Derivative Derivative itself
    /// @return buyerMargin uint256 Margin of buyer
    /// @return sellerMargin uint256 Margin of seller
    function getMargin(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (uint256 buyerMargin, uint256 sellerMargin) {
        // If it's a pool, just return margin from syntheticId contract
        if (_isPool(_derivativeHash, _derivative)) {
            return IDerivativeLogic(_derivative.syntheticId).getMargin(_derivative); 
        }

        // Initialize derivative if wasn't initialized before
        _initDerivative(_derivativeHash, _derivative);

        // Check if margins for _derivativeHash were already cached
        buyerMargin = buyerMarginByHash[_derivativeHash];
        sellerMargin = sellerMarginByHash[_derivativeHash];
    }

    /// @notice Checks whether `syntheticId` implements pooled logic
    /// @param _derivativeHash bytes32 Hash of derivative
    /// @param _derivative Derivative Derivative itself
    /// @return result bool Returns whether synthetic implements pooled logic
    function isPool(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (bool result) {
        result = _isPool(_derivativeHash, _derivative);
    }

    // PRIVATE FUNCTIONS

    /// @notice Initializes ticker, if was not initialized and returns whether `syntheticId` implements pooled logic
    /// @param _derivativeHash bytes32 Hash of derivative
    /// @param _derivative Derivative Derivative itself
    /// @return result bool Returns whether synthetic implements pooled logic
    function _isPool(bytes32 _derivativeHash, Derivative memory _derivative) private returns (bool result) {
        // Initialize derivative if wasn't initialized before
        _initDerivative(_derivativeHash, _derivative);
        result = typeByHash[_derivativeHash] == SyntheticTypes.Pool;
    }

    /// @notice Initializes ticker: caches syntheticId type, margin, author address and commission
    /// @param _derivativeHash bytes32 Hash of derivative
    /// @param _derivative Derivative Derivative itself
    function _initDerivative(bytes32 _derivativeHash, Derivative memory _derivative) private {
        // Check if type for _derivativeHash was already cached
        SyntheticTypes syntheticType = typeByHash[_derivativeHash];

        // Type could not be Invalid, thus this condition says us that type was not cached before
        if (syntheticType != SyntheticTypes.Invalid) {
            return;
        }

        // For security reasons we calculate hash of provided _derivative
        bytes32 derivativeHash = getDerivativeHash(_derivative);
        require(derivativeHash == _derivativeHash, ERROR_SYNTHETIC_AGGREGATOR_DERIVATIVE_HASH_NOT_MATCH);

        // POOL
        // Get isPool from SyntheticId
        bool result = IDerivativeLogic(_derivative.syntheticId).isPool();
        // Cache type returned from synthetic
        typeByHash[derivativeHash] = result ? SyntheticTypes.Pool : SyntheticTypes.NotPool;

        // MARGIN
        // Get margin from SyntheticId
        (uint256 buyerMargin, uint256 sellerMargin) = IDerivativeLogic(_derivative.syntheticId).getMargin(_derivative);
        // We are not allowing both margins to be equal to 0
        require(buyerMargin != 0 || sellerMargin != 0, ERROR_SYNTHETIC_AGGREGATOR_WRONG_MARGIN);
        // Cache margins returned from synthetic
        buyerMarginByHash[derivativeHash] = buyerMargin;
        sellerMarginByHash[derivativeHash] = sellerMargin;

        // AUTHOR ADDRESS
        // Cache author address returned from synthetic
        authorAddressByHash[derivativeHash] = IDerivativeLogic(_derivative.syntheticId).getAuthorAddress();

        // AUTHOR COMMISSION
        // Get commission from syntheticId
        uint256 commission = IDerivativeLogic(_derivative.syntheticId).getAuthorCommission();
        // Check if commission is not set > 100%
        require(commission <= COMMISSION_BASE, ERROR_SYNTHETIC_AGGREGATOR_COMMISSION_TOO_BIG);
        // Cache commission
        commissionByHash[derivativeHash] = commission;

        // If we are here, this basically means this ticker was not used before, so we emit an event for Dapps developers about new ticker (derivative) and it's hash
        emit Create(_derivative, derivativeHash);
    }
}
