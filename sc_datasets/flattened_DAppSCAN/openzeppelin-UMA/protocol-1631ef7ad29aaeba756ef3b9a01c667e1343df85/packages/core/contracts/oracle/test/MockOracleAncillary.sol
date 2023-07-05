// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/common/implementation/Timer.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @title Universal store of current contract time for testing environments.
 */
contract Timer {
    uint256 private currentTime;

    constructor() public {
        currentTime = now; // solhint-disable-line not-rely-on-time
    }

    /**
     * @notice Sets the current time.
     * @dev Will revert if not running in test mode.
     * @param time timestamp to set `currentTime` to.
     */
    function setCurrentTime(uint256 time) external {
        currentTime = time;
    }

    /**
     * @notice Gets the current time. Will return the last time set in `setCurrentTime` if running in test mode.
     * Otherwise, it will return the block timestamp.
     * @return uint256 for the current Testable timestamp.
     */
    function getCurrentTime() public view returns (uint256) {
        return currentTime;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/common/implementation/Testable.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @title Base class that provides time overrides, but only if being run in test mode.
 */
abstract contract Testable {
    // If the contract is being run on the test network, then `timerAddress` will be the 0x0 address.
    // Note: this variable should be set on construction and never modified.
    address public timerAddress;

    /**
     * @notice Constructs the Testable contract. Called by child contracts.
     * @param _timerAddress Contract that stores the current time in a testing environment.
     * Must be set to 0x0 for production environments that use live time.
     */
    constructor(address _timerAddress) internal {
        timerAddress = _timerAddress;
    }

    /**
     * @notice Reverts if not running in test mode.
     */
    modifier onlyIfTest {
        require(timerAddress != address(0x0));
        _;
    }

    /**
     * @notice Sets the current time.
     * @dev Will revert if not running in test mode.
     * @param time timestamp to set current Testable time to.
     */
    function setCurrentTime(uint256 time) external onlyIfTest {
        Timer(timerAddress).setCurrentTime(time);
    }

    /**
     * @notice Gets the current time. Will return the last time set in `setCurrentTime` if running in test mode.
     * Otherwise, it will return the block timestamp.
     * @return uint for the current Testable timestamp.
     */
    function getCurrentTime() public view returns (uint256) {
        if (timerAddress != address(0x0)) {
            return Timer(timerAddress).getCurrentTime();
        } else {
            return now; // solhint-disable-line not-rely-on-time
        }
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/oracle/interfaces/OracleAncillaryInterface.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @title Financial contract facing Oracle interface.
 * @dev Interface used by financial contracts to interact with the Oracle. Voters will use a different interface.
 */
abstract contract OracleAncillaryInterface {
    /**
     * @notice Enqueues a request (if a request isn't already present) for the given `identifier`, `time` pair.
     * @dev Time must be in the past and the identifier must be supported.
     * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.
     * @param time unix timestamp for the price request.
     */

    function requestPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData
    ) public virtual;

    /**
     * @notice Whether the price for `identifier` and `time` is available.
     * @dev Time must be in the past and the identifier must be supported.
     * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.
     * @param time unix timestamp for the price request.
     * @return bool if the DVM has resolved to a price for the given identifier and timestamp.
     */
    function hasPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData
    ) public view virtual returns (bool);

    /**
     * @notice Gets the price for `identifier` and `time` if it has already been requested and resolved.
     * @dev If the price is not available, the method reverts.
     * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.
     * @param time unix timestamp for the price request.
     * @return int256 representing the resolved price for the given identifier and timestamp.
     */

    function getPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData
    ) public view virtual returns (int256);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/oracle/interfaces/IdentifierWhitelistInterface.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;

/**
 * @title Interface for whitelists of supported identifiers that the oracle can provide prices for.
 */
interface IdentifierWhitelistInterface {
    /**
     * @notice Adds the provided identifier as a supported identifier.
     * @dev Price requests using this identifier will succeed after this call.
     * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
     */
    function addSupportedIdentifier(bytes32 identifier) external;

    /**
     * @notice Removes the identifier from the whitelist.
     * @dev Price requests using this identifier will no longer succeed after this call.
     * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
     */
    function removeSupportedIdentifier(bytes32 identifier) external;

    /**
     * @notice Checks whether an identifier is on the whitelist.
     * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
     * @return bool if the identifier is supported (or not).
     */
    function isIdentifierSupported(bytes32 identifier) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/oracle/interfaces/FinderInterface.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @title Provides addresses of the live contracts implementing certain interfaces.
 * @dev Examples are the Oracle or Store interfaces.
 */
interface FinderInterface {
    /**
     * @notice Updates the address of the contract that implements `interfaceName`.
     * @param interfaceName bytes32 encoding of the interface name that is either changed or registered.
     * @param implementationAddress address of the deployed contract that implements the interface.
     */
    function changeImplementationAddress(bytes32 interfaceName, address implementationAddress) external;

    /**
     * @notice Gets the address of the contract that implements the given `interfaceName`.
     * @param interfaceName queried interface.
     * @return implementationAddress address of the deployed contract that implements the interface.
     */
    function getImplementationAddress(bytes32 interfaceName) external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/oracle/implementation/Constants.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @title Stores common interface names used throughout the DVM by registration in the Finder.
 */
library OracleInterfaces {
    bytes32 public constant Oracle = "Oracle";
    bytes32 public constant IdentifierWhitelist = "IdentifierWhitelist";
    bytes32 public constant Store = "Store";
    bytes32 public constant FinancialContractsAdmin = "FinancialContractsAdmin";
    bytes32 public constant Registry = "Registry";
    bytes32 public constant CollateralWhitelist = "CollateralWhitelist";
    bytes32 public constant OptimisticOracle = "OptimisticOracle";
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/oracle/test/MockOracleAncillary.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;





// A mock oracle used for testing.
contract MockOracleAncillary is OracleAncillaryInterface, Testable {
    // Represents an available price. Have to keep a separate bool to allow for price=0.
    struct Price {
        bool isAvailable;
        int256 price;
        // Time the verified price became available.
        uint256 verifiedTime;
    }

    // The two structs below are used in an array and mapping to keep track of prices that have been requested but are
    // not yet available.
    struct QueryIndex {
        bool isValid;
        uint256 index;
    }

    // Represents a (identifier, time) point that has been queried.
    struct QueryPoint {
        bytes32 identifier;
        uint256 time;
        bytes ancillaryData;
    }

    // Reference to the Finder.
    FinderInterface private finder;

    // Conceptually we want a (time, identifier) -> price map.
    mapping(bytes32 => mapping(uint256 => mapping(bytes => Price))) private verifiedPrices;

    // The mapping and array allow retrieving all the elements in a mapping and finding/deleting elements.
    // Can we generalize this data structure?
    mapping(bytes32 => mapping(uint256 => mapping(bytes => QueryIndex))) private queryIndices;
    QueryPoint[] private requestedPrices;

    constructor(address _finderAddress, address _timerAddress) public Testable(_timerAddress) {
        finder = FinderInterface(_finderAddress);
    }

    // Enqueues a request (if a request isn't already present) for the given (identifier, time) pair.

    function requestPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData
    ) public override {
        require(_getIdentifierWhitelist().isIdentifierSupported(identifier));
        Price storage lookup = verifiedPrices[identifier][time][ancillaryData];
        if (!lookup.isAvailable && !queryIndices[identifier][time][ancillaryData].isValid) {
            // New query, enqueue it for review.
            queryIndices[identifier][time][ancillaryData] = QueryIndex(true, requestedPrices.length);
            requestedPrices.push(QueryPoint(identifier, time, ancillaryData));
        }
    }

    // Pushes the verified price for a requested query.
    function pushPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData,
        int256 price
    ) external {
        verifiedPrices[identifier][time][ancillaryData] = Price(true, price, getCurrentTime());

        QueryIndex storage queryIndex = queryIndices[identifier][time][ancillaryData];
        require(queryIndex.isValid, "Can't push prices that haven't been requested");
        // Delete from the array. Instead of shifting the queries over, replace the contents of `indexToReplace` with
        // the contents of the last index (unless it is the last index).
        uint256 indexToReplace = queryIndex.index;
        delete queryIndices[identifier][time][ancillaryData];
        uint256 lastIndex = requestedPrices.length - 1;
        if (lastIndex != indexToReplace) {
            QueryPoint storage queryToCopy = requestedPrices[lastIndex];
            queryIndices[queryToCopy.identifier][queryToCopy.time][queryToCopy.ancillaryData].index = indexToReplace;
            requestedPrices[indexToReplace] = queryToCopy;
        }
    }

    // Checks whether a price has been resolved.
    function hasPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData
    ) public view override returns (bool) {
        require(_getIdentifierWhitelist().isIdentifierSupported(identifier));
        Price storage lookup = verifiedPrices[identifier][time][ancillaryData];
        return lookup.isAvailable;
    }

    // Gets a price that has already been resolved.
    function getPrice(
        bytes32 identifier,
        uint256 time,
        bytes memory ancillaryData
    ) public view override returns (int256) {
        require(_getIdentifierWhitelist().isIdentifierSupported(identifier));
        Price storage lookup = verifiedPrices[identifier][time][ancillaryData];
        require(lookup.isAvailable);
        return lookup.price;
    }

    // Gets the queries that still need verified prices.
    function getPendingQueries() external view returns (QueryPoint[] memory) {
        return requestedPrices;
    }

    function _getIdentifierWhitelist() private view returns (IdentifierWhitelistInterface supportedIdentifiers) {
        return IdentifierWhitelistInterface(finder.getImplementationAddress(OracleInterfaces.IdentifierWhitelist));
    }
}
