// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-OriginDollar/origin-dollar-81431fd3b2aa4c518ffc389844f9708c00b516f0/contracts/contracts/oracle/AggregatorV3Interface.sol

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

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-OriginDollar/origin-dollar-81431fd3b2aa4c518ffc389844f9708c00b516f0/contracts/contracts/mocks/MockChainlinkOracleFeed.sol

pragma solidity 0.5.11;

contract MockChainlinkOracleFeed is AggregatorV3Interface {
    int256 price;
    uint8 numDecimals;

    constructor(int256 _price, uint8 _decimals) public {
        price = _price;
        numDecimals = _decimals;
    }

    function decimals() external view returns (uint8) {
        return numDecimals;
    }

    function description() external view returns (string memory) {
        return "MockOracleEthFeed";
    }

    function version() external view returns (uint256) {
        return 1;
    }

    function setPrice(int256 _price) public {
        price = _price;
    }

    function setDecimals(uint8 _decimals) public {
        numDecimals = _decimals;
    }

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
        )
    {
        roundId = _roundId;
        answer = price;
        startedAt = 0;
        updatedAt = 0;
        answeredInRound = 0;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = 0;
        answer = price;
        startedAt = 0;
        updatedAt = 0;
        answeredInRound = 0;
    }
}
