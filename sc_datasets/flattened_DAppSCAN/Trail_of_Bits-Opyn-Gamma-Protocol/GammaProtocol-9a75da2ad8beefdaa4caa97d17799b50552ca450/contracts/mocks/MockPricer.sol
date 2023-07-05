// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Opyn-Gamma-Protocol/GammaProtocol-9a75da2ad8beefdaa4caa97d17799b50552ca450/contracts/interfaces/OracleInterface.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

interface OracleInterface {
    function isLockingPeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);

    function isDisputePeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);

    function getExpiryPrice(address _asset, uint256 _expiryTimestamp) external view returns (uint256, bool);

    function getDisputer() external view returns (address);

    function getPricer(address _asset) external view returns (address);

    function getPrice(address _asset) external view returns (uint256);

    function getPricerLockingPeriod(address _pricer) external view returns (uint256);

    function getPricerDisputePeriod(address _pricer) external view returns (uint256);

    function getChainlinkRoundData(address _asset, uint80 _roundId) external view returns (uint256, uint256);

    // Non-view function

    function setAssetPricer(address _asset, address _pricer) external;

    function setLockingPeriod(address _pricer, uint256 _lockingPeriod) external;

    function setDisputePeriod(address _pricer, uint256 _disputePeriod) external;

    function setExpiryPrice(
        address _asset,
        uint256 _expiryTimestamp,
        uint256 _price
    ) external;

    function disputeExpiryPrice(
        address _asset,
        uint256 _expiryTimestamp,
        uint256 _price
    ) external;

    function setDisputer(address _disputer) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Opyn-Gamma-Protocol/GammaProtocol-9a75da2ad8beefdaa4caa97d17799b50552ca450/contracts/mocks/MockPricer.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

contract MockPricer {
    OracleInterface public oracle;

    uint256 internal price;
    address public asset;

    constructor(address _asset, address _oracle) public {
        asset = _asset;
        oracle = OracleInterface(_oracle);
    }

    function setPrice(uint256 _price) external {
        price = _price;
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    function setExpiryPriceInOracle(uint256 _expiryTimestamp, uint256 _price) external {
        oracle.setExpiryPrice(asset, _expiryTimestamp, _price);
    }

    function getHistoricalPrice(uint80 _roundId) external view returns (uint256, uint256) {
        return (price, now);
    }
}
