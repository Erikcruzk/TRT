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
