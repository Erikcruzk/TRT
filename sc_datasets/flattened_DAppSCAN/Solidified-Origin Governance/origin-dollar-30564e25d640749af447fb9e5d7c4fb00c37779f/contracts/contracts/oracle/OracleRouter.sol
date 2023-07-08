// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/interfaces/chainlink/AggregatorV3Interface.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

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

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IOracle {
    /**
     * @dev returns the asset price in USD, 8 decimal digits.
     */
    function price(address asset) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/interfaces/IBasicToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IBasicToken {
    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/utils/Helpers.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

library Helpers {
    /**
     * @notice Fetch the `symbol()` from an ERC20 token
     * @dev Grabs the `symbol()` from a contract
     * @param _token Address of the ERC20 token
     * @return string Symbol of the ERC20 token
     */
    function getSymbol(address _token) internal view returns (string memory) {
        string memory symbol = IBasicToken(_token).symbol();
        return symbol;
    }

    /**
     * @notice Fetch the `decimals()` from an ERC20 token
     * @dev Grabs the `decimals()` from a contract and fails if
     *      the decimal value does not live within a certain range
     * @param _token Address of the ERC20 token
     * @return uint256 Decimals of the ERC20 token
     */
    function getDecimals(address _token) internal view returns (uint256) {
        uint256 decimals = IBasicToken(_token).decimals();
        require(
            decimals >= 4 && decimals <= 18,
            "Token must have sufficient decimal places"
        );

        return decimals;
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/oracle/OracleRouter.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;



abstract contract OracleRouterBase is IOracle {
    uint256 constant MIN_DRIFT = uint256(70000000);
    uint256 constant MAX_DRIFT = uint256(130000000);

    /**
     * @dev The price feed contract to use for a particular asset.
     * @param asset address of the asset
     * @return address address of the price feed for the asset
     */
    function feed(address asset) internal view virtual returns (address);

    /**
     * @notice Returns the total price in 8 digit USD for a given asset.
     * @param asset address of the asset
     * @return uint256 USD price of 1 of the asset, in 8 decimal fixed
     */
    function price(address asset) external view override returns (uint256) {
        address _feed = feed(asset);
        require(_feed != address(0), "Asset not available");
        (, int256 _iprice, , , ) = AggregatorV3Interface(_feed)
            .latestRoundData();
        uint256 _price = uint256(_iprice);
        if (isStablecoin(asset)) {
            require(_price <= MAX_DRIFT, "Oracle: Price exceeds max");
            require(_price >= MIN_DRIFT, "Oracle: Price under min");
        }
        return uint256(_price);
    }

    function isStablecoin(address _asset) internal view returns (bool) {
        string memory symbol = Helpers.getSymbol(_asset);
        bytes32 symbolHash = keccak256(abi.encodePacked(symbol));
        return
            symbolHash == keccak256(abi.encodePacked("DAI")) ||
            symbolHash == keccak256(abi.encodePacked("USDC")) ||
            symbolHash == keccak256(abi.encodePacked("USDT"));
    }
}

contract OracleRouter is OracleRouterBase {
    /**
     * @dev The price feed contract to use for a particular asset.
     * @param asset address of the asset
     */
    function feed(address asset) internal pure override returns (address) {
        if (asset == address(0x6B175474E89094C44Da98b954EedeAC495271d0F)) {
            // Chainlink: DAI/USD
            return address(0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9);
        } else if (
            asset == address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)
        ) {
            // Chainlink: USDC/USD
            return address(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);
        } else if (
            asset == address(0xdAC17F958D2ee523a2206206994597C13D831ec7)
        ) {
            // Chainlink: USDT/USD
            return address(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D);
        } else if (
            asset == address(0xc00e94Cb662C3520282E6f5717214004A7f26888)
        ) {
            // Chainlink: COMP/USD
            return address(0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5);
        } else if (
            asset == address(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9)
        ) {
            // Chainlink: AAVE/USD
            return address(0x547a514d5e3769680Ce22B2361c10Ea13619e8a9);
        } else if (
            asset == address(0xD533a949740bb3306d119CC777fa900bA034cd52)
        ) {
            // Chainlink: CRV/USD
            return address(0xCd627aA160A6fA45Eb793D19Ef54f5062F20f33f);
        } else if (
            asset == address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B)
        ) {
            // Chainlink: CVX/USD
            return address(0xd962fC30A72A84cE50161031391756Bf2876Af5D);
        } else {
            revert("Asset not available");
        }
    }
}

contract OracleRouterDev is OracleRouterBase {
    mapping(address => address) public assetToFeed;

    function setFeed(address _asset, address _feed) external {
        assetToFeed[_asset] = _feed;
    }

    /**
     * @dev The price feed contract to use for a particular asset.
     * @param asset address of the asset
     */
    function feed(address asset) internal view override returns (address) {
        return assetToFeed[asset];
    }
}
