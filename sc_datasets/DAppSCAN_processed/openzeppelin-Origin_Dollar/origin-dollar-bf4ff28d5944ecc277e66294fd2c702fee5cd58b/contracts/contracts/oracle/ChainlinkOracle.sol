// File: ../sc_datasets/DAppSCAN/openzeppelin-Origin_Dollar/origin-dollar-bf4ff28d5944ecc277e66294fd2c702fee5cd58b/contracts/contracts/interfaces/chainlink/AggregatorV3Interface.sol

pragma solidity ^0.5.11;

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Origin_Dollar/origin-dollar-bf4ff28d5944ecc277e66294fd2c702fee5cd58b/contracts/contracts/interfaces/IPriceOracle.sol

pragma solidity 0.5.11;

interface IPriceOracle {
    /**
     * @dev returns the asset price in USD, 6 decimal digits.
     * Compatible with the Open Price Feed.
     */
    function price(string calldata symbol) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Origin_Dollar/origin-dollar-bf4ff28d5944ecc277e66294fd2c702fee5cd58b/contracts/contracts/interfaces/IEthUsdOracle.sol

pragma solidity 0.5.11;

interface IEthUsdOracle {
    /**
     * @notice Returns ETH price in USD.
     * @return Price in USD with 6 decimal digits.
     */
    function ethUsdPrice() external view returns (uint256);

    /**
     * @notice Returns token price in USD.
     * @param symbol. Asset symbol. For ex. "DAI".
     * @return Price in USD with 6 decimal digits.
     */
    function tokUsdPrice(string calldata symbol)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the asset price in ETH.
     * @param symbol. Asset symbol. For ex. "DAI".
     * @return Price in ETH with 8 decimal digits.
     */
    function tokEthPrice(string calldata symbol)
        external
        view
        returns (uint256);
}

interface IViewEthUsdOracle {
    /**
     * @notice Returns ETH price in USD.
     * @return Price in USD with 6 decimal digits.
     */
    function ethUsdPrice() external view returns (uint256);

    /**
     * @notice Returns token price in USD.
     * @param symbol. Asset symbol. For ex. "DAI".
     * @return Price in USD with 6 decimal digits.
     */
    function tokUsdPrice(string calldata symbol)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the asset price in ETH.
     * @param symbol. Asset symbol. For ex. "DAI".
     * @return Price in ETH with 8 decimal digits.
     */
    function tokEthPrice(string calldata symbol)
        external
        view
        returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Origin_Dollar/origin-dollar-bf4ff28d5944ecc277e66294fd2c702fee5cd58b/contracts/contracts/governance/Governable.sol

pragma solidity 0.5.11;

/**
 * @title OUSD Governable Contract
 * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
 *      from owner to governor and renounce methods removed. Does not use
 *      Context.sol like Ownable.sol does for simplification.
 * @author Origin Protocol Inc
 */
contract Governable {
    // Storage position of the owner and pendingOwner of the contract
    // keccak256("OUSD.governor");
    bytes32
        private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;

    // keccak256("OUSD.pending.governor");
    bytes32
        private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;

    // keccak256("OUSD.reentry.status");
    bytes32
        private constant reentryStatusPosition = 0x53bf423e48ed90e97d02ab0ebab13b2a235a6bfbe9c321847d5c175333ac4535;

    // See OpenZeppelin ReentrancyGuard implementation
    uint256 constant _NOT_ENTERED = 1;
    uint256 constant _ENTERED = 2;

    event PendingGovernorshipTransfer(
        address indexed previousGovernor,
        address indexed newGovernor
    );

    event GovernorshipTransferred(
        address indexed previousGovernor,
        address indexed newGovernor
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial Governor.
     */
    constructor() internal {
        _setGovernor(msg.sender);
        emit GovernorshipTransferred(address(0), _governor());
    }

    /**
     * @dev Returns the address of the current Governor.
     */
    function governor() public view returns (address) {
        return _governor();
    }

    /**
     * @dev Returns the address of the current Governor.
     */
    function _governor() internal view returns (address governorOut) {
        bytes32 position = governorPosition;
        assembly {
            governorOut := sload(position)
        }
    }

    /**
     * @dev Returns the address of the pending Governor.
     */
    function _pendingGovernor()
        internal
        view
        returns (address pendingGovernor)
    {
        bytes32 position = pendingGovernorPosition;
        assembly {
            pendingGovernor := sload(position)
        }
    }

    /**
     * @dev Throws if called by any account other than the Governor.
     */
    modifier onlyGovernor() {
        require(isGovernor(), "Caller is not the Governor");
        _;
    }

    /**
     * @dev Returns true if the caller is the current Governor.
     */
    function isGovernor() public view returns (bool) {
        return msg.sender == _governor();
    }

    function _setGovernor(address newGovernor) internal {
        bytes32 position = governorPosition;
        assembly {
            sstore(position, newGovernor)
        }
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        bytes32 position = reentryStatusPosition;
        uint256 _reentry_status;
        assembly {
            _reentry_status := sload(position)
        }

        // On the first call to nonReentrant, _notEntered will be true
        require(_reentry_status != _ENTERED, "Reentrant call");

        // Any calls to nonReentrant after this point will fail
        assembly {
            sstore(position, _ENTERED)
        }

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        assembly {
            sstore(position, _NOT_ENTERED)
        }
    }

    function _setPendingGovernor(address newGovernor) internal {
        bytes32 position = pendingGovernorPosition;
        assembly {
            sstore(position, newGovernor)
        }
    }

    /**
     * @dev Transfers Governance of the contract to a new account (`newGovernor`).
     * Can only be called by the current Governor. Must be claimed for this to complete
     * @param _newGovernor Address of the new Governor
     */
    function transferGovernance(address _newGovernor) external onlyGovernor {
        _setPendingGovernor(_newGovernor);
        emit PendingGovernorshipTransfer(_governor(), _newGovernor);
    }

    /**
     * @dev Claim Governance of the contract to a new account (`newGovernor`).
     * Can only be called by the new Governor.
     */
    function claimGovernance() external {
        require(
            msg.sender == _pendingGovernor(),
            "Only the pending Governor can complete the claim"
        );
        _changeGovernor(msg.sender);
    }

    /**
     * @dev Change Governance of the contract to a new account (`newGovernor`).
     * @param _newGovernor Address of the new Governor
     */
    function _changeGovernor(address _newGovernor) internal {
        require(_newGovernor != address(0), "New Governor is address(0)");
        emit GovernorshipTransferred(_governor(), _newGovernor);
        _setGovernor(_newGovernor);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Origin_Dollar/origin-dollar-bf4ff28d5944ecc277e66294fd2c702fee5cd58b/contracts/contracts/oracle/ChainlinkOracle.sol

// DEPRECATED - This contract is no longer used in production
pragma solidity 0.5.11;

/**
 * @title OUSD ChainlinkOracle Contract
 * @author Origin Protocol Inc
 */




contract ChainlinkOracle is IEthUsdOracle, IPriceOracle, Governable {
    event FeedRegistered(address _feed, string _symbol, bool _directToUsd);

    address ethFeed;

    struct FeedConfig {
        address feed;
        uint8 decimals;
        bool directToUsd;
    }

    mapping(bytes32 => FeedConfig) feeds;

    uint8 ethDecimals;

    string constant ethSymbol = "ETH";
    bytes32 constant ethHash = keccak256(abi.encodePacked(ethSymbol));

    constructor(address ethFeed_) public {
        ethFeed = ethFeed_;
        ethDecimals = AggregatorV3Interface(ethFeed_).decimals();
    }

    function registerFeed(
        address feed,
        string memory symbol,
        bool directToUsd
    ) public onlyGovernor {
        FeedConfig storage config = feeds[keccak256(abi.encodePacked(symbol))];

        config.feed = feed;
        config.decimals = AggregatorV3Interface(feed).decimals();
        config.directToUsd = directToUsd;

        emit FeedRegistered(feed, symbol, directToUsd);
    }

    function getLatestPrice(address feed) internal view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = AggregatorV3Interface(feed).latestRoundData();
        // silence
        roundID;
        startedAt;
        timeStamp;
        answeredInRound;
        return price;
    }

    function ethUsdPrice() external view returns (uint256) {
        return (uint256(getLatestPrice(ethFeed)) /
            (uint256(10)**(ethDecimals - 6)));
    }

    function tokUsdPrice(string calldata symbol)
        external
        view
        returns (uint256)
    {
        bytes32 tokenSymbolHash = keccak256(abi.encodePacked(symbol));
        FeedConfig storage config = feeds[tokenSymbolHash];
        int256 tPrice = getLatestPrice(config.feed);

        require(config.directToUsd, "Price is not direct to usd");
        require(tPrice > 0, "Price must be greater than zero");
        return uint256(tPrice);
    }

    function tokEthPrice(string calldata symbol)
        external
        view
        returns (uint256)
    {
        bytes32 tokenSymbolHash = keccak256(abi.encodePacked(symbol));
        FeedConfig storage config = feeds[tokenSymbolHash];
        int256 tPrice = getLatestPrice(config.feed);

        require(!config.directToUsd, "Price is not in terms of ETH");
        require(tPrice > 0, "Price must be greater than zero");
        //attempt to return 8 digit precision here
        return uint256(tPrice) / (uint256(10)**(config.decimals - 8));
    }

    // This actually calculate the latest price from outside oracles
    // It's a view but substantially more costly in terms of calculation
    function price(string calldata symbol) external view returns (uint256) {
        bytes32 tokenSymbolHash = keccak256(abi.encodePacked(symbol));

        if (ethHash == tokenSymbolHash) {
            return (uint256(getLatestPrice(ethFeed)) /
                (uint256(10)**(ethDecimals - 6)));
        } else {
            FeedConfig storage config = feeds[tokenSymbolHash];
            int256 tPrice = getLatestPrice(config.feed);

            if (config.directToUsd) {
                require(tPrice > 0, "Price must be greater than zero");
                return uint256(tPrice);
            } else {
                int256 ethPrice = getLatestPrice(ethFeed); // grab the eth price from the open oracle
                require(
                    tPrice > 0 && ethPrice > 0,
                    "Both eth and price must be greater than zero"
                );
                //not actually sure why it's 6 units here, this is just to match with openoracle for now
                return
                    mul(uint256(tPrice), uint256(ethPrice)) /
                    (uint256(10)**(ethDecimals + config.decimals - 6));
            }
        }
    }

    /// @dev Overflow proof multiplication
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "multiplication overflow");
        return c;
    }
}