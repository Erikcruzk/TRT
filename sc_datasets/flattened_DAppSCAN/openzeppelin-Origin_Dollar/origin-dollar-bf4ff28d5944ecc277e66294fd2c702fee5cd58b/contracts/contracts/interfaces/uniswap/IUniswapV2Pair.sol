// File: ../sc_datasets/DAppSCAN/openzeppelin-Origin_Dollar/origin-dollar-bf4ff28d5944ecc277e66294fd2c702fee5cd58b/contracts/contracts/interfaces/uniswap/IUniswapV2Pair.sol

pragma solidity 0.5.11;

interface IUniswapV2Pair {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function sync() external;
}