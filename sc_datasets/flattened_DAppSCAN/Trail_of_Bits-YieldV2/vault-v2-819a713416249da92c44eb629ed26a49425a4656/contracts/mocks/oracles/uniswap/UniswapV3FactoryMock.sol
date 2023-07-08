// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/ISourceMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

interface ISourceMock {
    function set(uint) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/oracles/uniswap/IUniswapV3PoolImmutables.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Pool state that never changes
/// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
interface IUniswapV3PoolImmutables {
    /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
    /// @return The contract address
    function factory() external view returns (address);

    /// @notice The first of the two tokens of the pool, sorted by address
    /// @return The token contract address
    function token0() external view returns (address);

    /// @notice The second of the two tokens of the pool, sorted by address
    /// @return The token contract address
    function token1() external view returns (address);

    /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
    /// @return The fee
    function fee() external view returns (uint24);

    /// @notice The pool tick spacing
    /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
    /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
    /// This value is an int24 to avoid casting even though it is always positive.
    /// @return The tick spacing
    function tickSpacing() external view returns (int24);

    /// @notice The maximum amount of position liquidity that can use any tick in the range
    /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
    /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
    /// @return The max amount of liquidity per tick
    function maxLiquidityPerTick() external view returns (uint128);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/uniswap/UniswapV3PoolMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;


contract UniswapV3PoolMock is ISourceMock, IUniswapV3PoolImmutables {

    uint public price;
    address public immutable override factory;
    address public immutable override token0;
    address public immutable override token1;
    uint24 public immutable override fee;

    constructor(address factory_, address token0_, address token1_, uint24 fee_) {
        (factory, token0, token1, fee) = (factory_, token0_, token1_, fee_);
    }

    function set(uint price_) external override {
        price = price_;
    }

    function tickSpacing() public pure override returns (int24) {
        return 0;
    }

    function maxLiquidityPerTick() public pure override returns (uint128) {
        return 0;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/uniswap/UniswapV3FactoryMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

contract UniswapV3FactoryMock {

    mapping(address => mapping(address => mapping(uint24 => address))) public getPool;

    /// @notice Creates a pool for the given two tokens and fee
    /// @param tokenA One of the two tokens in the desired pool
    /// @param tokenB The other of the two tokens in the desired pool
    /// @param fee The desired fee for the pool
    /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
    /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
    /// are invalid.
    /// @return pool The address of the newly created pool
    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool) {
        require(tokenA != tokenB, "Cannot create pool of same tokens");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "No nil token address");
        require(getPool[token0][token1][fee] == address(0), "Pool already exists");
        pool = address(new UniswapV3PoolMock(address(this), token0, token1, fee));
        getPool[token0][token1][fee] = pool;
        // populate mapping in the reverse direction, deliberate choice to avoid the cost of comparing addresses
        getPool[token1][token0][fee] = pool;
    }
}
