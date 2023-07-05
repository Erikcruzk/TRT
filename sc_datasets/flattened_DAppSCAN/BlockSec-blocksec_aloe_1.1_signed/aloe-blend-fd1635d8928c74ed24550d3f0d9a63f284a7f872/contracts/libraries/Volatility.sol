// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/libraries/FixedPoint96.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.4.0;

/// @title FixedPoint96
/// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
/// @dev Used in SqrtPriceMath.sol
library FixedPoint96 {
    uint8 internal constant RESOLUTION = 96;
    uint256 internal constant Q96 = 0x1000000000000000000000000;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/libraries/FullMath.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

/// @title Contains 512-bit math functions
/// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
/// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
library FullMath {
    /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    /// @param a The multiplicand
    /// @param b The multiplier
    /// @param denominator The divisor
    /// @return result The 256-bit result
    /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    function mulDiv(
        uint256 a,
        uint256 b,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        // Handle division by zero
        require(denominator != 0);

        // 512-bit multiply [prod1 prod0] = a * b
        // Compute the product mod 2**256 and mod 2**256 - 1
        // then use the Chinese Remainder Theorem to reconstruct
        // the 512 bit result. The result is stored in two 256
        // variables such that product = prod1 * 2**256 + prod0
        uint256 prod0; // Least significant 256 bits of the product
        uint256 prod1; // Most significant 256 bits of the product
        assembly {
            let mm := mulmod(a, b, not(0))
            prod0 := mul(a, b)
            prod1 := sub(sub(mm, prod0), lt(mm, prod0))
        }

        // Short circuit 256 by 256 division
        // This saves gas when a * b is small, at the cost of making the
        // large case a bit more expensive. Depending on your use case you
        // may want to remove this short circuit and always go through the
        // 512 bit path.
        if (prod1 == 0) {
            assembly {
                result := div(prod0, denominator)
            }
            return result;
        }

        ///////////////////////////////////////////////
        // 512 by 256 division.
        ///////////////////////////////////////////////

        // Handle overflow, the result must be < 2**256
        require(prod1 < denominator);

        // Make division exact by subtracting the remainder from [prod1 prod0]
        // Compute remainder using mulmod
        // Note mulmod(_, _, 0) == 0
        uint256 remainder;
        assembly {
            remainder := mulmod(a, b, denominator)
        }
        // Subtract 256 bit number from 512 bit number
        assembly {
            prod1 := sub(prod1, gt(remainder, prod0))
            prod0 := sub(prod0, remainder)
        }

        // Factor powers of two out of denominator
        // Compute largest power of two divisor of denominator.
        // Always >= 1.
        unchecked {
            // https://ethereum.stackexchange.com/a/96646
            uint256 twos = (type(uint256).max - denominator + 1) & denominator;
            // Divide denominator by power of two
            assembly {
                denominator := div(denominator, twos)
            }

            // Divide [prod1 prod0] by the factors of two
            assembly {
                prod0 := div(prod0, twos)
            }
            // Shift in bits from prod1 into prod0. For this we need
            // to flip `twos` such that it is 2**256 / twos.
            // If twos is zero, then it becomes one
            assembly {
                twos := add(div(sub(0, twos), twos), 1)
            }
            prod0 |= prod1 * twos;

            // Invert denominator mod 2**256
            // Now that denominator is an odd number, it has an inverse
            // modulo 2**256 such that denominator * inv = 1 mod 2**256.
            // Compute the inverse by starting with a seed that is correct
            // correct for four bits. That is, denominator * inv = 1 mod 2**4
            // If denominator is zero the inverse starts with 2
            uint256 inv = (3 * denominator) ^ 2;
            // Now use Newton-Raphson iteration to improve the precision.
            // Thanks to Hensel's lifting lemma, this also works in modular
            // arithmetic, doubling the correct bits in each step.
            inv *= 2 - denominator * inv; // inverse mod 2**8
            inv *= 2 - denominator * inv; // inverse mod 2**16
            inv *= 2 - denominator * inv; // inverse mod 2**32
            inv *= 2 - denominator * inv; // inverse mod 2**64
            inv *= 2 - denominator * inv; // inverse mod 2**128
            inv *= 2 - denominator * inv; // inverse mod 2**256
            // If denominator is zero, inv is now 128

            // Because the division is now exact we can divide by multiplying
            // with the modular inverse of denominator. This will give us the
            // correct result modulo 2**256. Since the precoditions guarantee
            // that the outcome is less than 2**256, this is the final result.
            // We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inv;
            return result;
        }
    }

    /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    /// @param a The multiplicand
    /// @param b The multiplier
    /// @param denominator The divisor
    /// @return result The 256-bit result
    function mulDivRoundingUp(
        uint256 a,
        uint256 b,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        result = mulDiv(a, b, denominator);
        if (mulmod(a, b, denominator) > 0) {
            require(result < type(uint256).max);
            result++;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/libraries/Math.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

library Math {
    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        unchecked {
            if (y > 3) {
                z = y;
                uint256 x = y / 2 + 1;
                while (x < z) {
                    z = x;
                    x = (y / x + x) / 2;
                }
            } else if (y != 0) {
                z = 1;
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/libraries/TickMath.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Math library for computing sqrt prices from ticks and vice versa
/// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
/// prices between 2**-128 and 2**128
library TickMath {
    /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
    int24 internal constant MIN_TICK = -887272;
    /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
    int24 internal constant MAX_TICK = -MIN_TICK;

    /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_SQRT_RATIO = 4295128739;
    /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

    /// @notice Calculates sqrt(1.0001^tick) * 2^96
    /// @dev Throws if |tick| > max tick
    /// @param tick The input tick for the above formula
    /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    /// at the given tick
    function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
        uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
        require(absTick <= uint256(uint24(MAX_TICK)), "T");

        uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
        unchecked {
            if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
            if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
            if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
            if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
            if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
            if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
            if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
            if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
            if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
            if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
            if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
            if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
            if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
            if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
            if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
            if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
            if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
            if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
            if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

            if (tick > 0) ratio = type(uint256).max / ratio;

            // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
            // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
            // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
            sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
        }
    }

    /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    /// ever return.
    /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
        // second inequality must be < because the price can never reach the price at the max tick
        require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, "R");
        uint256 ratio = uint256(sqrtPriceX96) << 32;

        uint256 r = ratio;
        uint256 msb = 0;

        assembly {
            let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(5, gt(r, 0xFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(4, gt(r, 0xFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(3, gt(r, 0xFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(2, gt(r, 0xF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(1, gt(r, 0x3))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := gt(r, 0x1)
            msb := or(msb, f)
        }

        if (msb >= 128) r = ratio >> (msb - 127);
        else r = ratio << (127 - msb);

        int256 log_2 = (int256(msb) - 128) << 64;

        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(63, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(62, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(61, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(60, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(59, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(58, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(57, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(56, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(55, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(54, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(53, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(52, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(51, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(50, f))
        }

        int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number

        int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
        int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

        tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
    }

    /// @notice Rounds down to the nearest tick where tick % tickSpacing == 0
    /// @param tick The tick to round
    /// @param tickSpacing The tick spacing to round to
    /// @return the floored tick
    function floor(int24 tick, int24 tickSpacing) internal pure returns (int24) {
        int24 mod = tick % tickSpacing;

        unchecked {
            if (mod >= 0) return tick - mod;
            return tick - mod - tickSpacing;
        }
    }

    /// @notice Rounds up to the nearest tick where tick % tickSpacing == 0
    /// @param tick The tick to round
    /// @param tickSpacing The tick spacing to round to
    /// @return the ceiled tick
    function ceil(int24 tick, int24 tickSpacing) internal pure returns (int24) {
        int24 mod = tick % tickSpacing;

        unchecked {
            if (mod > 0) return tick - mod + tickSpacing;
            return tick - mod;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/libraries/Volatility.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.10;




/// @title Volatility
/// @notice Provides functions that use Uniswap v3 to compute price volatility
library Volatility {
    struct PoolMetadata {
        // the oldest oracle observation that's been populated by the pool
        uint32 oldestObservation;
        // the overall fee minus the protocol fee for token0, times 1e6
        uint24 gamma0;
        // the overall fee minus the protocol fee for token1, times 1e6
        uint24 gamma1;
        // the pool tick spacing
        int24 tickSpacing;
    }

    struct PoolData {
        // the current price (from pool.slot0())
        uint160 sqrtPriceX96;
        // the current tick (from pool.slot0())
        int24 currentTick;
        // the mean tick over some period (from OracleLibrary.consult(...))
        int24 arithmeticMeanTick;
        // the mean liquidity over some period (from OracleLibrary.consult(...))
        uint160 secondsPerLiquidityX128;
        // the number of seconds to look back when getting mean tick & mean liquidity
        uint32 oracleLookback;
        // the liquidity depth at currentTick (from pool.liquidity())
        uint128 tickLiquidity;
    }

    struct FeeGrowthGlobals {
        // the fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
        uint256 feeGrowthGlobal0X128;
        // the fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
        uint256 feeGrowthGlobal1X128;
        // the block timestamp at which feeGrowthGlobal0X128 and feeGrowthGlobal1X128 were last updated
        uint32 timestamp;
    }

    /**
     * @notice Estimates implied volatility using https://lambert-guillaume.medium.com/on-chain-volatility-and-uniswap-v3-d031b98143d1
     * @param metadata The pool's metadata (may be cached)
     * @param data A summary of the pool's state from `pool.slot0` `pool.observe` and `pool.liquidity`
     * @param a The pool's cumulative feeGrowthGlobals some time in the past
     * @param b The pool's cumulative feeGrowthGlobals as of the current block
     * @return An estimate of the 24 hour implied volatility scaled by 1e18
     */
    function estimate24H(
        PoolMetadata memory metadata,
        PoolData memory data,
        FeeGrowthGlobals memory a,
        FeeGrowthGlobals memory b
    ) internal pure returns (uint256) {
        uint256 volumeGamma0Gamma1;
        {
            uint128 revenue0Gamma1 = computeRevenueGamma(
                a.feeGrowthGlobal0X128,
                b.feeGrowthGlobal0X128,
                data.secondsPerLiquidityX128,
                data.oracleLookback,
                metadata.gamma1
            );
            uint128 revenue1Gamma0 = computeRevenueGamma(
                a.feeGrowthGlobal1X128,
                b.feeGrowthGlobal1X128,
                data.secondsPerLiquidityX128,
                data.oracleLookback,
                metadata.gamma0
            );
            // This is an approximation. Ideally the fees earned during each swap would be multiplied by the price
            // *at that swap*. But for prices simulated with GBM and swap sizes either normally or uniformly distributed,
            // the error you get from using geometric mean price is <1% even with high drift and volatility.
            volumeGamma0Gamma1 = revenue1Gamma0 + amount0ToAmount1(revenue0Gamma1, data.arithmeticMeanTick);
        }

        uint128 sqrtTickTVLX32 = uint128(
            Math.sqrt(computeTickTVLX64(metadata.tickSpacing, data.currentTick, data.sqrtPriceX96, data.tickLiquidity))
        );
        uint48 timeAdjustmentX32 = uint48(Math.sqrt((uint256(1 days) << 64) / (b.timestamp - a.timestamp)));

        if (sqrtTickTVLX32 == 0) return 0;
        unchecked {
            return (uint256(2e18) * uint256(timeAdjustmentX32) * Math.sqrt(volumeGamma0Gamma1)) / sqrtTickTVLX32;
        }
    }

    /**
     * @notice Computes an `amount1` that (at `tick`) is equivalent in worth to the provided `amount0`
     * @param amount0 The amount of token0 to convert
     * @param tick The tick at which the conversion should hold true
     * @return amount1 An equivalent amount of token1
     */
    function amount0ToAmount1(uint128 amount0, int24 tick) internal pure returns (uint256 amount1) {
        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(tick);
        uint224 geometricMeanPriceX96 = uint224(FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, FixedPoint96.Q96));

        amount1 = FullMath.mulDiv(amount0, geometricMeanPriceX96, FixedPoint96.Q96);
    }

    /**
     * @notice Computes pool revenue using feeGrowthGlobal accumulators, then scales it down by a factor of gamma
     * @param feeGrowthGlobalAX128 The value of feeGrowthGlobal (either 0 or 1) at time A
     * @param feeGrowthGlobalBX128 The value of feeGrowthGlobal (either 0 or 1, but matching) at time B (B > A)
     * @param secondsPerLiquidityX128 The difference in the secondsPerLiquidity accumulator from `secondsAgo` seconds ago until now
     * @param secondsAgo The oracle lookback period that was used to find `secondsPerLiquidityX128`
     * @param gamma The fee factor to scale by
     * @return Revenue over the period from `block.timestamp - secondsAgo` to `block.timestamp`, scaled down by a factor of gamma
     */
    function computeRevenueGamma(
        uint256 feeGrowthGlobalAX128,
        uint256 feeGrowthGlobalBX128,
        uint160 secondsPerLiquidityX128,
        uint32 secondsAgo,
        uint24 gamma
    ) internal pure returns (uint128) {
        unchecked {
            uint256 temp;

            if (feeGrowthGlobalBX128 >= feeGrowthGlobalAX128) {
                // feeGrowthGlobal has increased from time A to time B
                temp = feeGrowthGlobalBX128 - feeGrowthGlobalAX128;
            } else {
                // feeGrowthGlobal has overflowed between time A and time B
                temp = type(uint256).max - feeGrowthGlobalAX128 + feeGrowthGlobalBX128;
            }

            temp = FullMath.mulDiv(temp, secondsAgo * gamma, secondsPerLiquidityX128 * 1e6);
            return temp > type(uint128).max ? type(uint128).max : uint128(temp);
        }
    }

    /**
     * @notice Computes the value of liquidity available at the current tick, denominated in token1
     * @param tickSpacing The pool tick spacing (from pool.tickSpacing())
     * @param tick The current tick (from pool.slot0())
     * @param sqrtPriceX96 The current price (from pool.slot0())
     * @param liquidity The liquidity depth at currentTick (from pool.liquidity())
     */
    function computeTickTVLX64(
        int24 tickSpacing,
        int24 tick,
        uint160 sqrtPriceX96,
        uint128 liquidity
    ) internal pure returns (uint256 tickTVL) {
        tick = TickMath.floor(tick, tickSpacing);

        // both value0 and value1 fit in uint192
        (uint256 value0, uint256 value1) = _getValuesOfLiquidity(
            sqrtPriceX96,
            TickMath.getSqrtRatioAtTick(tick),
            TickMath.getSqrtRatioAtTick(tick + tickSpacing),
            liquidity
        );
        tickTVL = (value0 + value1) << 64;
    }

    /**
     * @notice Computes the value of the liquidity in terms of token1
     * @dev Each return value can fit in a uint192 if necessary
     * @param sqrtRatioX96 A sqrt price representing the current pool prices
     * @param sqrtRatioAX96 A sqrt price representing the lower tick boundary
     * @param sqrtRatioBX96 A sqrt price representing the upper tick boundary
     * @param liquidity The liquidity being valued
     * @return value0 The value of amount0 underlying `liquidity`, in terms of token1
     * @return value1 The amount of token1
     */
    function _getValuesOfLiquidity(
        uint160 sqrtRatioX96,
        uint160 sqrtRatioAX96,
        uint160 sqrtRatioBX96,
        uint128 liquidity
    ) private pure returns (uint256 value0, uint256 value1) {
        assert(sqrtRatioAX96 <= sqrtRatioX96 && sqrtRatioX96 <= sqrtRatioBX96);

        unchecked {
            uint224 numerator = uint224(FullMath.mulDiv(sqrtRatioX96, sqrtRatioBX96 - sqrtRatioX96, FixedPoint96.Q96));

            value0 = FullMath.mulDiv(liquidity, numerator, sqrtRatioBX96);
            value1 = FullMath.mulDiv(liquidity, sqrtRatioX96 - sqrtRatioAX96, FixedPoint96.Q96);
        }
    }
}
