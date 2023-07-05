// File: ../sc_datasets/DAppSCAN/consensys-Growth_Defi_V1/growthdefi-v1-core-761f0a7af73a082ac64498061749db4466673542/contracts/interop/UniswapV2.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @dev Minimal set of declarations for Uniswap V2 interoperability.
 */
interface Router01
{
	function WETH() external pure returns (address _token);
	function swapExactTokensForTokens(uint256 _amountIn, uint256 _amountOutMin, address[] calldata _path, address _to, uint256 _deadline) external returns (uint256[] memory _amounts);
	function swapETHForExactTokens(uint256 _amountOut, address[] calldata _path, address _to, uint256 _deadline) external payable returns (uint256[] memory _amounts);
	function getAmountsOut(uint256 _amountIn, address[] calldata _path) external view returns (uint[] memory _amounts);
	function getAmountsIn(uint256 _amountOut, address[] calldata _path) external view returns (uint[] memory _amounts);
}

interface Router02 is Router01
{
}
