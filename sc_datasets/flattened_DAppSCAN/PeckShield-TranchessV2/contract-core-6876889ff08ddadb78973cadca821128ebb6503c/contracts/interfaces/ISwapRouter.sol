// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/interfaces/IStableSwap.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;

interface IStableSwap {
    function baseAddress() external view returns (address);

    function quoteAddress() external view returns (address);

    function allBalances() external view returns (uint256, uint256);

    function getOraclePrice() external view returns (uint256);

    function getCurrentD() external view returns (uint256);

    function getCurrentPriceOverOracle() external view returns (uint256);

    function getCurrentPrice() external view returns (uint256);

    function getPriceOverOracleIntegral() external view returns (uint256);

    function getQuoteOut(uint256 baseIn) external view returns (uint256 quoteOut);

    function getQuoteIn(uint256 baseOut) external view returns (uint256 quoteIn);

    function getBaseOut(uint256 quoteIn) external view returns (uint256 baseOut);

    function getBaseIn(uint256 quoteOut) external view returns (uint256 baseIn);

    function buy(
        uint256 version,
        uint256 baseOut,
        address recipient,
        bytes calldata data
    ) external;

    function sell(
        uint256 version,
        uint256 quoteOut,
        address recipient,
        bytes calldata data
    ) external;

    function addLiquidity(uint256 version, address recipient) external returns (uint256);

    function removeLiquidity(
        uint256 version,
        uint256 lpIn,
        uint256 minBaseOut,
        uint256 minQuoteOut
    ) external returns (uint256 baseOut, uint256 quoteOut);

    function removeBaseLiquidity(
        uint256 version,
        uint256 lpIn,
        uint256 minBaseOut
    ) external returns (uint256 baseOut);

    function removeQuoteLiquidity(
        uint256 version,
        uint256 lpIn,
        uint256 minQuoteOut
    ) external returns (uint256 quoteOut);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/interfaces/ISwapRouter.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;

interface ISwapRouter {
    function getSwap(address baseToken, address quoteToken) external view returns (IStableSwap);

    function getAmountsOut(uint256 amount, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amount, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function addLiquidity(
        address baseToken,
        address quoteToken,
        uint256 baseDelta,
        uint256 quoteDelta,
        uint256 minMintAmount,
        uint256 version,
        uint256 deadline
    ) external;

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        address staking,
        uint256[] calldata versions,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        address staking,
        uint256[] calldata versions,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
