// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-API3/airnode-991af4d69e82c1954a5c6c8e247cde8eb76101de/packages/airnode-protocol/contracts/rrp/interfaces/IAuthorizationUtils.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

interface IAuthorizationUtils {
    function checkAuthorizationStatus(
        address[] calldata authorizers,
        address airnode,
        bytes32 requestId,
        bytes32 endpointId,
        address sponsor,
        address requester
    ) external view returns (bool status);

    function checkAuthorizationStatuses(
        address[] calldata authorizers,
        address airnode,
        bytes32[] calldata requestIds,
        bytes32[] calldata endpointIds,
        address[] calldata sponsors,
        address[] calldata requesters
    ) external view returns (bool[] memory statuses);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-API3/airnode-991af4d69e82c1954a5c6c8e247cde8eb76101de/packages/airnode-protocol/contracts/rrp/interfaces/ITemplateUtils.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

interface ITemplateUtils {
    event CreatedTemplate(
        bytes32 indexed templateId,
        address airnode,
        bytes32 endpointId,
        bytes parameters
    );

    function createTemplate(
        address airnode,
        bytes32 endpointId,
        bytes calldata parameters
    ) external returns (bytes32 templateId);

    function getTemplates(bytes32[] calldata templateIds)
        external
        view
        returns (
            address[] memory airnodes,
            bytes32[] memory endpointIds,
            bytes[] memory parameters
        );

    function templates(bytes32 templateId)
        external
        view
        returns (
            address airnode,
            bytes32 endpointId,
            bytes memory parameters
        );
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-API3/airnode-991af4d69e82c1954a5c6c8e247cde8eb76101de/packages/airnode-protocol/contracts/rrp/interfaces/IWithdrawalUtils.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

interface IWithdrawalUtils {
    event RequestedWithdrawal(
        address indexed airnode,
        address indexed sponsor,
        bytes32 indexed withdrawalRequestId,
        address sponsorWallet
    );

    event FulfilledWithdrawal(
        address indexed airnode,
        address indexed sponsor,
        bytes32 indexed withdrawalRequestId,
        address sponsorWallet,
        uint256 amount
    );

    function requestWithdrawal(address airnode, address sponsorWallet) external;

    function fulfillWithdrawal(
        bytes32 withdrawalRequestId,
        address airnode,
        address sponsor
    ) external payable;

    function sponsorToWithdrawalRequestCount(address sponsor)
        external
        view
        returns (uint256 withdrawalRequestCount);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-API3/airnode-991af4d69e82c1954a5c6c8e247cde8eb76101de/packages/airnode-protocol/contracts/rrp/interfaces/IAirnodeRrp.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;



interface IAirnodeRrp is IAuthorizationUtils, ITemplateUtils, IWithdrawalUtils {
    event SetSponsorshipStatus(
        address indexed sponsor,
        address indexed requester,
        bool sponsorshipStatus
    );

    event MadeTemplateRequest(
        address indexed airnode,
        bytes32 indexed requestId,
        uint256 requesterRequestCount,
        uint256 chainId,
        address requester,
        bytes32 templateId,
        address sponsor,
        address sponsorWallet,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes parameters
    );

    event MadeFullRequest(
        address indexed airnode,
        bytes32 indexed requestId,
        uint256 requesterRequestCount,
        uint256 chainId,
        address requester,
        bytes32 endpointId,
        address sponsor,
        address sponsorWallet,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes parameters
    );

    event FulfilledRequest(
        address indexed airnode,
        bytes32 indexed requestId,
        bytes data
    );

    event FailedRequest(
        address indexed airnode,
        bytes32 indexed requestId,
        string errorMessage
    );

    function setSponsorshipStatus(address requester, bool sponsorshipStatus)
        external;

    function makeTemplateRequest(
        bytes32 templateId,
        address sponsor,
        address sponsorWallet,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes calldata parameters
    ) external returns (bytes32 requestId);

    function makeFullRequest(
        address airnode,
        bytes32 endpointId,
        address sponsor,
        address sponsorWallet,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes calldata parameters
    ) external returns (bytes32 requestId);

    function fulfill(
        bytes32 requestId,
        address airnode,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes calldata data,
        bytes calldata signature
    ) external returns (bool callSuccess, bytes memory callData);

    function fail(
        bytes32 requestId,
        address airnode,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        string calldata errorMessage
    ) external;

    function sponsorToRequesterToSponsorshipStatus(
        address sponsor,
        address requester
    ) external view returns (bool sponsorshipStatus);

    function requesterToRequestCountPlusOne(address requester)
        external
        view
        returns (uint256 requestCountPlusOne);

    function requestIsAwaitingFulfillment(bytes32 requestId)
        external
        view
        returns (bool isAwaitingFulfillment);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-API3/airnode-991af4d69e82c1954a5c6c8e247cde8eb76101de/packages/airnode-protocol/contracts/rrp/requesters/RrpRequester.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

/// @title The contract to be inherited to make Airnode RRP requests
contract RrpRequester {
    IAirnodeRrp public immutable airnodeRrp;

    /// @dev Reverts if the caller is not the Airnode RRP contract.
    /// Use it as a modifier for fulfill and error callback methods, but also
    /// check `requestId`.
    modifier onlyAirnodeRrp() {
        require(msg.sender == address(airnodeRrp), "Caller not Airnode RRP");
        _;
    }

    /// @dev Airnode RRP address is set at deployment and is immutable.
    /// RrpRequester is made its own sponsor by default. RrpRequester can also
    /// be sponsored by others and use these sponsorships while making
    /// requests, i.e., using this default sponsorship is optional.
    /// @param _airnodeRrp Airnode RRP contract address
    constructor(address _airnodeRrp) {
        airnodeRrp = IAirnodeRrp(_airnodeRrp);
        IAirnodeRrp(_airnodeRrp).setSponsorshipStatus(address(this), true);
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-API3/airnode-991af4d69e82c1954a5c6c8e247cde8eb76101de/packages/airnode-protocol/contracts/rrp/requesters/mock/MockRrpRequester.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

/// @title A mock Airnode RRP requester contract
contract MockRrpRequester is RrpRequester {
    event FulfilledRequest(bytes32 indexed requestId, bytes data);

    mapping(bytes32 => bytes) public requestIdToData;

    mapping(bytes32 => bool) private expectingRequestWithIdToBeFulfilled;

    /// @param airnodeRrpAddress Airnode RRP contract address
    constructor(address airnodeRrpAddress) RrpRequester(airnodeRrpAddress) {}

    /// @notice A wrapper for the respective method at AirnodeRrp.sol for
    /// testing
    /// @param templateId Template ID
    /// @param sponsor Sponsor address
    /// @param sponsorWallet Sponsor wallet that is requested to fulfill
    /// the request
    /// @param fulfillAddress Address that will be called to fulfill
    /// @param fulfillFunctionId Signature of the function that will be called
    /// to fulfill
    /// @param parameters Parameters provided by the requester in addition to
    /// the parameters in the template
    function makeTemplateRequest(
        bytes32 templateId,
        address sponsor,
        address sponsorWallet,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes calldata parameters
    ) external {
        bytes32 requestId = airnodeRrp.makeTemplateRequest(
            templateId,
            sponsor,
            sponsorWallet,
            fulfillAddress,
            fulfillFunctionId,
            parameters
        );
        expectingRequestWithIdToBeFulfilled[requestId] = true;
    }

    /// @notice A wrapper for the respective method at AirnodeRrp.sol for
    /// testing
    /// @param airnode Airnode address
    /// @param endpointId Endpoint ID
    /// @param sponsor Sponsor address
    /// @param sponsorWallet Sponsor wallet that is requested to fulfill
    /// the request
    /// @param fulfillAddress Address that will be called to fulfill
    /// @param fulfillFunctionId Signature of the function that will be called
    /// to fulfill
    /// @param parameters All request parameters
    function makeFullRequest(
        address airnode,
        bytes32 endpointId,
        address sponsor,
        address sponsorWallet,
        address fulfillAddress,
        bytes4 fulfillFunctionId,
        bytes calldata parameters
    ) external {
        bytes32 requestId = airnodeRrp.makeFullRequest(
            airnode,
            endpointId,
            sponsor,
            sponsorWallet,
            fulfillAddress,
            fulfillFunctionId,
            parameters
        );
        expectingRequestWithIdToBeFulfilled[requestId] = true;
    }

    /// @notice A method to be called back by the respective method at
    /// AirnodeRrp.sol for testing
    /// @param requestId Request ID
    /// @param data Data returned by the Airnode
    function fulfill(bytes32 requestId, bytes calldata data)
        external
        onlyAirnodeRrp
    {
        require(
            expectingRequestWithIdToBeFulfilled[requestId],
            "No such request made"
        );
        delete expectingRequestWithIdToBeFulfilled[requestId];
        requestIdToData[requestId] = data;
        emit FulfilledRequest(requestId, data);
    }

    /// @notice A method to be called back by the respective method at
    /// AirnodeRrp.sol for testing fulfillment failure
    /// @param requestId Request ID
    /// @param data Data returned by the Airnode
    function fulfillAlwaysReverts(
        bytes32 requestId, // solhint-disable-line no-unused-vars
        bytes calldata data // solhint-disable-line no-unused-vars
    ) external view onlyAirnodeRrp {
        revert("Always reverts");
    }

    /// @notice A method to be called back by the respective method at
    /// AirnodeRrp.sol for testing fulfillment failure
    /// @param requestId Request ID
    /// @param data Data returned by the Airnode
    function fulfillAlwaysRevertsWithNoString(
        bytes32 requestId, // solhint-disable-line no-unused-vars
        bytes calldata data // solhint-disable-line no-unused-vars
    ) external view onlyAirnodeRrp {
        revert(); // solhint-disable-line reason-string
    }

    /// @notice A method to be called back by the respective method at
    /// AirnodeRrp.sol for testing fulfillment running out of gas
    /// @param requestId Request ID
    /// @param data Data returned by the Airnode
    function fulfillAlwaysRunsOutOfGas(
        bytes32 requestId, // solhint-disable-line no-unused-vars
        bytes calldata data // solhint-disable-line no-unused-vars
    ) external view onlyAirnodeRrp {
        while (true) {}
    }

    /// @notice A wrapper for the respective method at AirnodeRrp.sol for
    /// testing
    /// @dev The withdrawal requested by calling this will revert because this
    /// contract does not implement a default payable method
    /// @param airnode Airnode address
    /// @param sponsorWallet Sponsor wallet that the withdrawal is requested
    /// from
    function requestWithdrawal(address airnode, address sponsorWallet)
        external
    {
        airnodeRrp.requestWithdrawal(airnode, sponsorWallet);
    }
}
