// File: ../sc_datasets/DAppSCAN/PeckShield-ShibaNova/Contracts-b6b1ce1fcaff83d360df8944309f49958842b7b8/shibanova/contracts/interfaces/IShibaFactory.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IShibaFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function owner() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}