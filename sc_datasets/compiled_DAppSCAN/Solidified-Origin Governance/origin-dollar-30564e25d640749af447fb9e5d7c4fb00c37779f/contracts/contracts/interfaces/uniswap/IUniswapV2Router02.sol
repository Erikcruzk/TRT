// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/interfaces/uniswap/IUniswapV2Router02.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IUniswapV2Router {
    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}
