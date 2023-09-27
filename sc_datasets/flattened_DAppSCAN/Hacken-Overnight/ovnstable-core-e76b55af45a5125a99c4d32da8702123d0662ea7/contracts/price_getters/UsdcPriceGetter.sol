// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/interfaces/IPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IPriceGetter {
    /**
     * Token buy price at USDC. Amount of USDC we should spend to buy one token.
     * Returned value is [USDC/token]
     * Usage: tokenAmount = usdcAmount * denominator() / getUsdcBuyPrice()
     * Normilized to 10**18
     */
    function getUsdcBuyPrice() external view returns (uint256);

    /**
     * Token sell price at USDC. Amount of USDC we got if sell one token.
     * Returned value is [USDC/token]
     * Usage: usdcAmount = tokenAmount * getUsdcSellPrice() / denominator()
     * Normilized to 10**18
     */
    function getUsdcSellPrice() external view returns (uint256);

    /**
     * Denominator for normalization. Default 10**18.
     */
    function denominator() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/price_getters/AbstractPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract AbstractPriceGetter is IPriceGetter {
    uint256 public constant DENOMINATOR = 10**18;

    function getUsdcBuyPrice() external view virtual override returns (uint256) {
        return DENOMINATOR;
    }

    function getUsdcSellPrice() external view virtual override returns (uint256) {
        return DENOMINATOR;
    }

    function denominator() external view virtual override returns (uint256) {
        return DENOMINATOR;
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Overnight/ovnstable-core-e76b55af45a5125a99c4d32da8702123d0662ea7/contracts/price_getters/UsdcPriceGetter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract UsdcPriceGetter is AbstractPriceGetter {
    function getUsdcBuyPrice() external pure override returns (uint256) {
        return DENOMINATOR;
    }

    function getUsdcSellPrice() external pure override returns (uint256) {
        return DENOMINATOR;
    }
}