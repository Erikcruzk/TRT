// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/interfaces/OracleInterface.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

interface OracleInterface {
    function isLockingPeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);

    function isDisputePeriodOver(address _asset, uint256 _expiryTimestamp) external view returns (bool);

    function getExpiryPrice(address _asset, uint256 _expiryTimestamp) external view returns (uint256, bool);

    function getPricer(address _asset) external view returns (address);

    function getPrice(address _asset) external view returns (uint256);

    function getPricerLockingPeriod(address _pricer) external view returns (uint256);

    function getPricerDisputePeriod(address _pricer) external view returns (uint256);

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
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/interfaces/OpynPricerInterface.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

interface OpynPricerInterface {
    function getPrice() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/pricers/USDCPricer.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;


/**
 * @notice A Pricer contract for USDC
 */
contract USDCPricer is OpynPricerInterface {
    /// @dev USDC address
    address public usdc;

    /// USDC price = 1, scaled by 1e8
    uint256 private constant PRICE = 1e8;

    /// @notice Opyn Oracle address
    OracleInterface public oracle;

    constructor(address _usdc, address _oracle) public {
        usdc = _usdc;
        oracle = OracleInterface(_oracle);
    }

    /**
     * @notice get the live price for USDC, which always returns 1
     * @dev overrides the getPrice function in OpynPricerInterface
     * @return price of USDC in USD, scaled by 1e8
     */
    function getPrice() external override view returns (uint256) {
        return PRICE;
    }

    /**
     * @notice set the expiry price in the oracle
     * @param _expiryTimestamp expiry to set a price for
     */
    function setExpiryPriceInOracle(uint256 _expiryTimestamp) external {
        oracle.setExpiryPrice(address(usdc), _expiryTimestamp, PRICE);
    }
}
