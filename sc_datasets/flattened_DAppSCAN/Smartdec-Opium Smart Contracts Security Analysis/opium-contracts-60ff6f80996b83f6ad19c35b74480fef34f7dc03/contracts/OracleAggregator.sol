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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/Errors/OracleAggregatorErrors.sol

pragma solidity ^0.5.4;

contract OracleAggregatorErrors {
    string constant internal ERROR_ORACLE_AGGREGATOR_NOT_ENOUGH_ETHER = "ORACLE_AGGREGATOR:NOT_ENOUGH_ETHER";

    string constant internal ERROR_ORACLE_AGGREGATOR_QUERY_WAS_ALREADY_MADE = "ORACLE_AGGREGATOR:QUERY_WAS_ALREADY_MADE";

    string constant internal ERROR_ORACLE_AGGREGATOR_DATA_DOESNT_EXIST = "ORACLE_AGGREGATOR:DATA_DOESNT_EXIST";

    string constant internal ERROR_ORACLE_AGGREGATOR_DATA_ALREADY_EXIST = "ORACLE_AGGREGATOR:DATA_ALREADY_EXIST";
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

// File: ../sc_datasets/DAppSCAN/Smartdec-Opium Smart Contracts Security Analysis/opium-contracts-60ff6f80996b83f6ad19c35b74480fef34f7dc03/contracts/OracleAggregator.sol

pragma solidity ^0.5.4;


/// @title Opium.OracleAggregator contract requests and caches the data from `oracleId`s and provides them to the Core for positions execution
contract OracleAggregator is OracleAggregatorErrors, ReentrancyGuard {
    using SafeMath for uint256;

    // Storage for the `oracleId` results
    // dataCache[oracleId][timestamp] => data
    mapping (address => mapping(uint256 => uint256)) public dataCache;

    // Flags whether data were provided
    // dataExist[oracleId][timestamp] => bool
    mapping (address => mapping(uint256 => bool)) public dataExist;

    // Flags whether data were requested
    // dataRequested[oracleId][timestamp] => bool
    mapping (address => mapping(uint256 => bool)) public dataRequested;

    // MODIFIERS

    /// @notice Checks whether enough ETH were provided withing data request to proceed
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @param times uint256 How many times the `oracleId` is being requested
    modifier enoughEtherProvided(address oracleId, uint256 times) {
        // Calling Opium.IOracleId function to get the data fetch price per one request
        uint256 oneTimePrice = calculateFetchPrice(oracleId);

        // Checking if enough ether was provided for `times` amount of requests
        require(msg.value >= oneTimePrice.mul(times), ERROR_ORACLE_AGGREGATOR_NOT_ENOUGH_ETHER);
        _;
    }

    // PUBLIC FUNCTIONS

    /// @notice Requests data from `oracleId` one time
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @param timestamp uint256 Timestamp at which data are needed
    function fetchData(address oracleId, uint256 timestamp) public payable nonReentrant enoughEtherProvided(oracleId, 1) {
        // Check if was not requested before and mark as requested
        _registerQuery(oracleId, timestamp);

        // Call the `oracleId` contract and transfer ETH
        IOracleId(oracleId).fetchData.value(msg.value)(timestamp);
    }

    /// @notice Requests data from `oracleId` multiple times
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @param timestamp uint256 Timestamp at which data are needed for the first time
    /// @param period uint256 Period in seconds between multiple timestamps
    /// @param times uint256 How many timestamps are requested
    function recursivelyFetchData(address oracleId, uint256 timestamp, uint256 period, uint256 times) public payable nonReentrant enoughEtherProvided(oracleId, times) {
        // Check if was not requested before and mark as requested in loop for each timestamp
        for (uint256 i = 0; i < times; i++) {	
            _registerQuery(oracleId, timestamp + period * i);
        }

        // Call the `oracleId` contract and transfer ETH
        IOracleId(oracleId).recursivelyFetchData.value(msg.value)(timestamp, period, times);
    }

    /// @notice Receives and caches data from `msg.sender`
    /// @param timestamp uint256 Timestamp of data
    /// @param data uint256 Data itself
    function __callback(uint256 timestamp, uint256 data) public {
        // Don't allow to push data twice
        require(!dataExist[msg.sender][timestamp], ERROR_ORACLE_AGGREGATOR_DATA_ALREADY_EXIST);

        // Saving data
        dataCache[msg.sender][timestamp] = data;

        // Flagging that data were received
        dataExist[msg.sender][timestamp] = true;
    }

    /// @notice Requests and returns price in ETH for one request. This function could be called as `view` function. Oraclize API for price calculations restricts making this function as view.
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @return fetchPrice uint256 Price of one data request in ETH
    function calculateFetchPrice(address oracleId) public returns(uint256 fetchPrice) {
        fetchPrice = IOracleId(oracleId).calculateFetchPrice();
    }

    // PRIVATE FUNCTIONS

    /// @notice Checks if data was not requested and provided before and marks as requested
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @param timestamp uint256 Timestamp at which data are requested
    function _registerQuery(address oracleId, uint256 timestamp) private {
        // Check if data was not requested and provided yet
        require(!dataRequested[oracleId][timestamp] && !dataExist[oracleId][timestamp], ERROR_ORACLE_AGGREGATOR_QUERY_WAS_ALREADY_MADE);

        // Mark as requested
        dataRequested[oracleId][timestamp] = true;	
    }

    // VIEW FUNCTIONS

    /// @notice Returns cached data if they exist, or reverts with an error
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @param timestamp uint256 Timestamp at which data were requested
    /// @return dataResult uint256 Cached data provided by `oracleId`
    function getData(address oracleId, uint256 timestamp) public view returns(uint256 dataResult) {
        // Check if Opium.OracleAggregator has data
        require(hasData(oracleId, timestamp), ERROR_ORACLE_AGGREGATOR_DATA_DOESNT_EXIST);

        // Return cached data
        dataResult = dataCache[oracleId][timestamp];
    }

    /// @notice Getter for dataExist mapping
    /// @param oracleId address Address of the `oracleId` smart contract
    /// @param timestamp uint256 Timestamp at which data were requested
    /// @param result bool Returns whether data were provided already
    function hasData(address oracleId, uint256 timestamp) public view returns(bool result) {
        return dataExist[oracleId][timestamp];
    }
}
