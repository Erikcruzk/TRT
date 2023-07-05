// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/lib/math/Math.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow checks.
 * Adapted from OpenZeppelin's SafeMath library
 */
library Math {
    /**
     * @dev Returns the addition of two unsigned integers of 256 bits, reverting on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_OVERFLOW");
        return c;
    }

    /**
     * @dev Returns the addition of two signed integers, reverting on overflow.
     */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a), "ADD_OVERFLOW");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers of 256 bits, reverting on overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_OVERFLOW");
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Returns the subtraction of two signed integers, reverting on overflow.
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a), "SUB_OVERFLOW");
        return c;
    }

    /**
     * @dev Returns the largest of two numbers of 256 bits.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers of 256 bits.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b, "MUL_OVERFLOW");
        return c;
    }

    function divDown(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "ZERO_DIVISION");
        return a / b;
    }

    function divUp(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "ZERO_DIVISION");

        if (a == 0) {
            return 0;
        } else {
            return 1 + (a - 1) / b;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/lib/math/LogExpMath.sol

// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General internal License for more details.

// You should have received a copy of the GNU General internal License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;

// There's plenty of linter errors caused by this file, we'll eventually
// revisit it to make it more readable, verfiable and testable.
/* solhint-disable */

/**
 * @title Ethereum library for logarithm and exponential functions with 18 decimal precision.
 * @author Fernando Martinelli - @fernandomartinelli
 * @author Sergio Yuhjtman - @sergioyuhjtman
 * @author Daniel Fernandez - @dmf7z
 */
library LogExpMath {
    int256 constant DECIMALS = 1e18;
    int256 constant DOUBLE_DECIMALS = DECIMALS * DECIMALS;
    int256 constant PRECISION = 10**20;
    int256 constant DOUBLE_PRECISION = PRECISION * PRECISION;
    int256 constant PRECISION_LOG_UNDER_BOUND = DECIMALS - 10**17;
    int256 constant PRECISION_LOG_UPPER_BOUND = DECIMALS + 10**17;
    int256 constant EXPONENT_LB = -41446531673892822312;
    int256 constant EXPONENT_UB = 130700829182905140221;
    uint256 constant MILD_EXPONENT_BOUND = 2**254 / uint256(PRECISION);

    int256 constant x0 = 128000000000000000000; //2ˆ7
    int256 constant a0 = 38877084059945950922200000000000000000000000000000000000; //eˆ(x0)
    int256 constant x1 = 64000000000000000000; //2ˆ6
    int256 constant a1 = 6235149080811616882910000000; //eˆ(x1)
    int256 constant x2 = 3200000000000000000000; //2ˆ5
    int256 constant a2 = 7896296018268069516100000000000000; //eˆ(x2)
    int256 constant x3 = 1600000000000000000000; //2ˆ4
    int256 constant a3 = 888611052050787263676000000; //eˆ(x3)
    int256 constant x4 = 800000000000000000000; //2ˆ3
    int256 constant a4 = 298095798704172827474000; //eˆ(x4)
    int256 constant x5 = 400000000000000000000; //2ˆ2
    int256 constant a5 = 5459815003314423907810; //eˆ(x5)
    int256 constant x6 = 200000000000000000000; //2ˆ1
    int256 constant a6 = 738905609893065022723; //eˆ(x6)
    int256 constant x7 = 100000000000000000000; //2ˆ0
    int256 constant a7 = 271828182845904523536; //eˆ(x7)
    int256 constant x8 = 50000000000000000000; //2ˆ-1
    int256 constant a8 = 164872127070012814685; //eˆ(x8)
    int256 constant x9 = 25000000000000000000; //2ˆ-2
    int256 constant a9 = 128402541668774148407; //eˆ(x9)
    int256 constant x10 = 12500000000000000000; //2ˆ-3
    int256 constant a10 = 113314845306682631683; //eˆ(x10)
    int256 constant x11 = 6250000000000000000; //2ˆ-4
    int256 constant a11 = 106449445891785942956; //eˆ(x11)

    /**
     * Calculate the natural exponentiation of a number with 18 decimals precision.
     * @param x Exponent with 18 decimal places.
     * @notice Max x is log((2^255 - 1) / 10^20) = 130.700829182905140221
     * @notice Min x log(0.000000000000000001) = -41.446531673892822312
     * @return eˆx
     */
    function n_exp(int256 x) internal pure returns (int256) {
        require(x >= EXPONENT_LB && x <= EXPONENT_UB, "OUT_OF_BOUNDS");

        if (x < 0) return (DOUBLE_DECIMALS / n_exp(-x));
        int256 ans = PRECISION;
        int256 last = 1;
        if (x >= x0) {
            last = a0;
            x -= x0;
        }
        if (x >= x1) {
            last *= a1;
            x -= x1;
        }
        x *= 100;
        if (x >= x2) {
            ans = (ans * a2) / PRECISION;
            x -= x2;
        }
        if (x >= x3) {
            ans = (ans * a3) / PRECISION;
            x -= x3;
        }
        if (x >= x4) {
            ans = (ans * a4) / PRECISION;
            x -= x4;
        }
        if (x >= x5) {
            ans = (ans * a5) / PRECISION;
            x -= x5;
        }
        if (x >= x6) {
            ans = (ans * a6) / PRECISION;
            x -= x6;
        }
        if (x >= x7) {
            ans = (ans * a7) / PRECISION;
            x -= x7;
        }
        if (x >= x8) {
            ans = (ans * a8) / PRECISION;
            x -= x8;
        }
        if (x >= x9) {
            ans = (ans * a9) / PRECISION;
            x -= x9;
        }
        int256 s = PRECISION;
        int256 t = x;
        s += t;
        t = ((t * x) / 2) / PRECISION;
        s += t;
        t = ((t * x) / 3) / PRECISION;
        s += t;
        t = ((t * x) / 4) / PRECISION;
        s += t;
        t = ((t * x) / 5) / PRECISION;
        s += t;
        t = ((t * x) / 6) / PRECISION;
        s += t;
        t = ((t * x) / 7) / PRECISION;
        s += t;
        t = ((t * x) / 8) / PRECISION;
        s += t;
        t = ((t * x) / 9) / PRECISION;
        s += t;
        t = ((t * x) / 10) / PRECISION;
        s += t;
        t = ((t * x) / 11) / PRECISION;
        s += t;
        t = ((t * x) / 12) / PRECISION;
        s += t;
        return (((ans * s) / PRECISION) * last) / 100;
    }

    /**
     * Calculate the natural logarithm of a number with 18 decimals precision.
     * @param a Positive number with 18 decimal places.
     * @return ln(x)
     */
    function n_log(int256 a) internal pure returns (int256) {
        require(a > 0, "OUT_OF_BOUNDS");
        if (a < DECIMALS) return (-n_log(DOUBLE_DECIMALS / a));
        int256 ans = 0;
        if (a >= a0 * DECIMALS) {
            ans += x0;
            a /= a0;
        }
        if (a >= a1 * DECIMALS) {
            ans += x1;
            a /= a1;
        }
        a *= 100;
        ans *= 100;
        if (a >= a2) {
            ans += x2;
            a = (a * PRECISION) / a2;
        }
        if (a >= a3) {
            ans += x3;
            a = (a * PRECISION) / a3;
        }
        if (a >= a4) {
            ans += x4;
            a = (a * PRECISION) / a4;
        }
        if (a >= a5) {
            ans += x5;
            a = (a * PRECISION) / a5;
        }
        if (a >= a6) {
            ans += x6;
            a = (a * PRECISION) / a6;
        }
        if (a >= a7) {
            ans += x7;
            a = (a * PRECISION) / a7;
        }
        if (a >= a8) {
            ans += x8;
            a = (a * PRECISION) / a8;
        }
        if (a >= a9) {
            ans += x9;
            a = (a * PRECISION) / a9;
        }
        if (a >= a10) {
            ans += x10;
            a = (a * PRECISION) / a10;
        }
        if (a >= a11) {
            ans += x11;
            a = (a * PRECISION) / a11;
        }
        int256 z = (PRECISION * (a - PRECISION)) / (a + PRECISION);
        int256 s = z;
        int256 z_squared = (z * z) / PRECISION;
        int256 t = (z * z_squared) / PRECISION;
        s += t / 3;
        t = (t * z_squared) / PRECISION;
        s += t / 5;
        t = (t * z_squared) / PRECISION;
        s += t / 7;
        t = (t * z_squared) / PRECISION;
        s += t / 9;
        t = (t * z_squared) / PRECISION;
        s += t / 11;
        return (ans + 2 * s) / 100;
    }

    /**
     * Computes x to the power of y for numbers with 18 decimals precision.
     * @param x Base with 18 decimal places.
     * @param y Exponent with 18 decimal places.
     * @notice Must fulfil: -41.446531673892822312  < (log(x) * y) <  130.700829182905140221
     * @return xˆy
     */
    function pow(uint256 x, uint256 y) internal pure returns (uint256) {
        if (y == 0) {
            return uint256(DECIMALS);
        }

        if (x == 0) {
            return 0;
        }

        require(x < 2**255, "X_OUT_OF_BOUNDS"); // uint256 can be casted to a positive int256
        require(y < MILD_EXPONENT_BOUND, "Y_OUT_OF_BOUNDS");
        int256 x_int256 = int256(x);
        int256 y_int256 = int256(y);
        int256 logx_times_y;
        if (PRECISION_LOG_UNDER_BOUND < x_int256 && x_int256 < PRECISION_LOG_UPPER_BOUND) {
            int256 logbase = n_log_36(x_int256);
            logx_times_y = ((logbase / DECIMALS) * y_int256 + ((logbase % DECIMALS) * y_int256) / DECIMALS);
        } else {
            logx_times_y = n_log(x_int256) * y_int256;
        }
        require(
            EXPONENT_LB * DECIMALS <= logx_times_y && logx_times_y <= EXPONENT_UB * DECIMALS,
            "PRODUCT_OUT_OF_BOUNDS"
        );
        logx_times_y /= DECIMALS;
        return uint256(n_exp(logx_times_y));
    }

    /**
     * Computes log of a number in base of another number, both numbers with 18 decimals precision.
     * @param arg Argument with 18 decimal places.
     * @param base Base with 18 decimal places.
     * @notice Must fulfil: -41.446531673892822312  < (log(x) * y) <  130.700829182905140221
     * @return log[base](arg)
     */
    function log(int256 arg, int256 base) internal pure returns (int256) {
        int256 logbase;
        if (PRECISION_LOG_UNDER_BOUND < base && base < PRECISION_LOG_UPPER_BOUND) {
            logbase = n_log_36(base);
        } else {
            logbase = n_log(base) * DECIMALS;
        }
        int256 logarg;
        if (PRECISION_LOG_UNDER_BOUND < arg && arg < PRECISION_LOG_UPPER_BOUND) {
            logarg = n_log_36(arg);
        } else {
            logarg = n_log(arg) * DECIMALS;
        }
        return (logarg * DECIMALS) / logbase;
    }

    /**
     * Private function to calculate the natural logarithm of a number with 36 decimals precision.
     * @param a Positive number with 18 decimal places.
     * @return ln(x)
     */
    function n_log_36(int256 a) private pure returns (int256) {
        a *= DECIMALS;
        int256 z = (DOUBLE_DECIMALS * (a - DOUBLE_DECIMALS)) / (a + DOUBLE_DECIMALS);
        int256 s = z;
        int256 z_squared = (z * z) / DOUBLE_DECIMALS;
        int256 t = (z * z_squared) / DOUBLE_DECIMALS;
        s += t / 3;
        t = (t * z_squared) / DOUBLE_DECIMALS;
        s += t / 5;
        t = (t * z_squared) / DOUBLE_DECIMALS;
        s += t / 7;
        t = (t * z_squared) / DOUBLE_DECIMALS;
        s += t / 9;
        t = (t * z_squared) / DOUBLE_DECIMALS;
        s += t / 11;
        t = (t * z_squared) / DOUBLE_DECIMALS;
        s += t / 13;
        t = (t * z_squared) / DOUBLE_DECIMALS;
        s += t / 15;
        return 2 * s;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/lib/math/FixedPoint.sol

// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;

/* solhint-disable private-vars-leading-underscore */

library FixedPoint {
    uint256 internal constant ONE = 1e18; // 18 decimal places
    uint256 internal constant MAX_POW_RELATIVE_ERROR = 10000; // 10^(-14)

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        // Fixed Point addition is the same as regular checked addition

        uint256 c = a + b;
        require(c >= a, "ADD_OVERFLOW");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        // Fixed Point addition is the same as regular checked addition

        require(b <= a, "SUB_OVERFLOW");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c0 = a * b;
        require(a == 0 || c0 / a == b, "MUL_OVERFLOW");
        uint256 c1 = c0 + (ONE / 2);
        require(c1 >= c0, "MUL_OVERFLOW");
        uint256 c2 = c1 / ONE;
        return c2;
    }

    function mulDown(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 product = a * b;
        require(a == 0 || product / a == b, "MUL_OVERFLOW");

        return product / ONE;
    }

    function mulUp(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 product = a * b;
        require(a == 0 || product / a == b, "MUL_OVERFLOW");

        if (product == 0) {
            return 0;
        } else {
            // The traditional divUp formula is:
            // divUp(x, y) := (x + y - 1) / y
            // To avoid intermediate overflow in the addition, we distribute the division and get:
            // divUp(x, y) := (x - 1) / y + 1
            // Note that this requires x != 0, which we already tested for.

            return ((product - 1) / ONE) + 1;
        }
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "ZERO_DIVISION");
        uint256 c0 = a * ONE;
        require(a == 0 || c0 / a == ONE, "DIV_INTERNAL"); // mul overflow
        uint256 c1 = c0 + (b / 2);
        require(c1 >= c0, "DIV_INTERNAL"); // add require
        uint256 c2 = c1 / b;
        return c2;
    }

    function divDown(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "ZERO_DIVISION");

        if (a == 0) {
            return 0;
        } else {
            uint256 aInflated = a * ONE;
            require(aInflated / a == ONE, "DIV_INTERNAL"); // mul overflow

            return aInflated / b;
        }
    }

    function divUp(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "ZERO_DIVISION");

        if (a == 0) {
            return 0;
        } else {
            uint256 aInflated = a * ONE;
            require(aInflated / a == ONE, "DIV_INTERNAL"); // mul overflow

            // The traditional divUp formula is:
            // divUp(x, y) := (x + y - 1) / y
            // To avoid intermediate overflow in the addition, we distribute the division and get:
            // divUp(x, y) := (x - 1) / y + 1
            // Note that this requires x != 0, which we already tested for.

            return ((aInflated - 1) / b) + 1;
        }
    }

    function pow(uint256 x, uint256 y) internal pure returns (uint256) {
        return LogExpMath.pow(x, y);
    }

    function powDown(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 result = LogExpMath.pow(x, y);
        if (result == 0) {
            return 0;
        }
        return sub(sub(result, mulDown(result, MAX_POW_RELATIVE_ERROR)), 1);
    }

    function powUp(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 result = LogExpMath.pow(x, y);
        return add(add(result, mulUp(result, MAX_POW_RELATIVE_ERROR)), 1);
    }

    /**
     * @dev Tells the complement of a given value capped to zero to avoid overflow
     */
    function complement(uint256 x) internal pure returns (uint256) {
        return x >= ONE ? 0 : sub(ONE, x);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/pools/stable/StableMath.sol

// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;


// This is a contract to emulate file-level functions. Convert to a library
// after the migration to solc v0.7.1.

// solhint-disable private-vars-leading-underscore
// solhint-disable var-name-mixedcase

contract StableMath {
    using FixedPoint for uint256;

    uint256 internal constant _MIN_AMP = 1e18;
    uint256 internal constant _MAX_AMP = 5000 * (1e18);

    uint256 internal constant _MAX_STABLE_TOKENS = 5;

    // Computes the invariant given the current balances using Newton-Raphson approximation.
    // The amplification parameter equals to: A n^(n-1)
    function _calculateInvariant(uint256 amplificationParameter, uint256[] memory balances)
        internal
        pure
        returns (uint256)
    {
        /**********************************************************************************************
        // invariant                                                                                 //
        // D = invariant                                                  D^(n+1)                    //
        // A = amplification coefficient      A  n^n S + D = A D n^n + -----------                   //
        // S = sum of balances                                             n^n P                     //
        // P = product of balances                                                                   //
        // n = number of tokens                                                                      //
        *********x************************************************************************************/

        // We round up invariant.

        uint256 sum = 0;
        uint256 numTokens = balances.length;
        for (uint256 i = 0; i < numTokens; i++) {
            sum = sum.add(balances[i]);
        }
        if (sum == 0) {
            return 0;
        }
        uint256 prevInvariant = 0;
        uint256 invariant = sum;
        uint256 ampTimesTotal = Math.mul(amplificationParameter, numTokens);

        for (uint256 i = 0; i < 255; i++) {
            uint256 P_D = Math.mul(numTokens, balances[0]);
            for (uint256 j = 1; j < numTokens; j++) {
                P_D = Math.divUp(Math.mul(Math.mul(P_D, balances[j]), numTokens), invariant);
            }
            prevInvariant = invariant;
            invariant = Math.divUp(
                Math.mul(Math.mul(numTokens, invariant), invariant).add(Math.mul(Math.mul(ampTimesTotal, sum), P_D)),
                Math.mul(numTokens.add(1), invariant).add(Math.mul(ampTimesTotal.sub(1), P_D))
            );

            if (invariant > prevInvariant) {
                if (invariant.sub(prevInvariant) <= 1) {
                    break;
                }
            } else if (prevInvariant.sub(invariant) <= 1) {
                break;
            }
        }
        return invariant;
    }

    // Computes how many tokens can be taken out of a pool if `tokenAmountIn` are sent, given the
    // current balances.
    // The amplification parameter equals to: A n^(n-1)
    function _calcOutGivenIn(
        uint256 amplificationParameter,
        uint256[] memory balances,
        uint256 tokenIndexIn,
        uint256 tokenIndexOut,
        uint256 tokenAmountIn
    ) internal pure returns (uint256) {
        /**************************************************************************************************************
        // outGivenIn token x for y - polynomial equation to solve                                                   //
        // ay = amount out to calculate                                                                              //
        // by = balance token out                                                                                    //
        // y = by - ay (finalBalanceOut)                                                                             //
        // D = invariant                                               D                     D^(n+1)                 //
        // A = amplification coefficient               y^2 + ( S - ----------  - D) * y -  ------------- = 0         //
        // n = number of tokens                                    (A * n^n)               A * n^2n * P              //
        // S = sum of final balances but y                                                                           //
        // P = product of final balances but y                                                                       //
        **************************************************************************************************************/

        // Amount out, so we round down overall.

        uint256 invariant = _calculateInvariant(amplificationParameter, balances);

        balances[tokenIndexIn] = balances[tokenIndexIn].add(tokenAmountIn);

        uint256 finalBalanceOut = _getTokenBalanceGivenInvariantAndAllOtherBalances(
            amplificationParameter,
            balances,
            invariant,
            tokenIndexOut
        );

        balances[tokenIndexIn] = balances[tokenIndexIn].sub(tokenAmountIn);

        return balances[tokenIndexOut].sub(finalBalanceOut).sub(1);
    }

    // Computes how many tokens must be sent to a pool if `tokenAmountOut` are sent given the
    // current balances using Newton-Raphson approximation.
    // The amplification parameter equals to: A n^(n-1)
    function _calcInGivenOut(
        uint256 amplificationParameter,
        uint256[] memory balances,
        uint256 tokenIndexIn,
        uint256 tokenIndexOut,
        uint256 tokenAmountOut
    ) internal pure returns (uint256) {
        /**************************************************************************************************************
        // inGivenOut token x for y - polynomial equation to solve                                                   //
        // ax = amount in to calculate                                                                               //
        // bx = balance token in                                                                                     //
        // x = bx + ax (finalBalanceIn)                                                                              //
        // D = invariant                                                D                     D^(n+1)                //
        // A = amplification coefficient               x^2 + ( S - ----------  - D) * x -  ------------- = 0         //
        // n = number of tokens                                     (A * n^n)               A * n^2n * P             //
        // S = sum of final balances but x                                                                           //
        // P = product of final balances but x                                                                       //
        **************************************************************************************************************/

        // Amount in, so we round up overall.

        uint256 invariant = _calculateInvariant(amplificationParameter, balances);

        balances[tokenIndexOut] = balances[tokenIndexOut].sub(tokenAmountOut);

        uint256 finalBalanceIn = _getTokenBalanceGivenInvariantAndAllOtherBalances(
            amplificationParameter,
            balances,
            invariant,
            tokenIndexIn
        );

        balances[tokenIndexOut] = balances[tokenIndexOut].add(tokenAmountOut);

        return finalBalanceIn.sub(balances[tokenIndexIn]).add(1);
    }

    /* 
    TODO: document it correctly
    Flow of calculations:
    amountsTokenIn -> amountsInProportional ->
    amountsInPercentageExcess -> amountsInAfterFee -> newInvariant -> amountBPTOut
    TODO: remove equations below and save them to Notion documentation 
    amountInPercentageExcess = 1 - amountInProportional/amountIn (if amountIn>amountInProportional)
    amountInAfterFee = amountIn * (1 - swapFee * amountInPercentageExcess)
    amountInAfterFee = amountIn - fees 
    fees = (amountIn - amountInProportional) * swapFee
    amountInAfterFee = amountIn - (amountIn - amountInProportional) * swapFee
    amountInAfterFee = amountIn * (1 - (1 - amountInProportional/amountIn) * swapFee)
    amountInAfterFee = amountIn * (1 - amountInPercentageExcess * swapFee)
    */
    function _calcBptOutGivenExactTokensIn(
        uint256 amp,
        uint256[] memory balances,
        uint256[] memory amountsIn,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) internal pure returns (uint256) {
        // BPT out, so we round down overall.

        // Get current invariant
        uint256 currentInvariant = _calculateInvariant(amp, balances);

        // First calculate the sum of all token balances which will be used to calculate
        // the current weights of each token relative to the sum of all balances
        uint256 sumBalances = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            sumBalances = sumBalances.add(balances[i]);
        }

        // Calculate the weighted balance ratio without considering fees
        uint256[] memory tokenBalanceRatiosWithoutFee = new uint256[](amountsIn.length);
        // The weighted sum of token balance rations sans fee
        uint256 weightedBalanceRatio = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            uint256 currentWeight = balances[i].divDown(sumBalances);
            tokenBalanceRatiosWithoutFee[i] = balances[i].add(amountsIn[i]).divDown(balances[i]);
            weightedBalanceRatio = weightedBalanceRatio.add(tokenBalanceRatiosWithoutFee[i].mulDown(currentWeight));
        }

        // Second loop to calculate new amounts in taking into account the fee on the % excess
        uint256[] memory newBalances = new uint256[](balances.length);
        for (uint256 i = 0; i < balances.length; i++) {
            // Percentage of the amount supplied that will be implicitly swapped for other tokens in the pool
            uint256 tokenBalancePercentageExcess;
            // Some tokens might have amounts supplied in excess of a 'balanced' join: these are identified if
            // the token's balance ratio sans fee is larger than the weighted balance ratio, and swap fees charged
            // on the amount to swap
            if (weightedBalanceRatio >= tokenBalanceRatiosWithoutFee[i]) {
                tokenBalancePercentageExcess = 0;
            } else {
                tokenBalancePercentageExcess = tokenBalanceRatiosWithoutFee[i].sub(weightedBalanceRatio).divUp(
                    tokenBalanceRatiosWithoutFee[i].sub(FixedPoint.ONE)
                );
            }

            uint256 swapFeeExcess = swapFee.mulUp(tokenBalancePercentageExcess);

            uint256 amountInAfterFee = amountsIn[i].mulDown(swapFeeExcess.complement());

            newBalances[i] = balances[i].add(amountInAfterFee);
        }

        // get new invariant taking into account swap fees
        uint256 newInvariant = _calculateInvariant(amp, newBalances);

        // return amountBPTOut
        return bptTotalSupply.mulDown(newInvariant.divDown(currentInvariant).sub(FixedPoint.ONE));
    }

    /* 
    TODO: document it correctly
    Flow of calculations:
    amountBPTOut -> newInvariant -> (amountInProportional, amountInAfterFee) ->
    amountInPercentageExcess -> amountIn
    */
    function _calcTokenInGivenExactBptOut(
        uint256 amp,
        uint256[] memory balances,
        uint256 tokenIndex,
        uint256 bptAmountOut,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) internal pure returns (uint256) {
        // Token in, so we round up overall.

        // Get current invariant
        uint256 currentInvariant = _calculateInvariant(amp, balances);

        // Calculate new invariant
        uint256 newInvariant = bptTotalSupply.add(bptAmountOut).divUp(bptTotalSupply).mulUp(currentInvariant);

        // First calculate the sum of all token balances which will be used to calculate
        // the current weight of token
        uint256 sumBalances = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            sumBalances = sumBalances.add(balances[i]);
        }

        // get amountInAfterFee
        uint256 newBalanceTokenIndex = _getTokenBalanceGivenInvariantAndAllOtherBalances(
            amp,
            balances,
            newInvariant,
            tokenIndex
        );
        uint256 amountInAfterFee = newBalanceTokenIndex.sub(balances[tokenIndex]);

        // Get tokenBalancePercentageExcess
        uint256 currentWeight = balances[tokenIndex].divDown(sumBalances);
        uint256 tokenBalancePercentageExcess = currentWeight.complement();

        uint256 swapFeeExcess = swapFee.mulUp(tokenBalancePercentageExcess);

        return amountInAfterFee.divUp(swapFeeExcess.complement());
    }

    /* 
    Flow of calculations:
    amountsTokenOut -> amountsOutProportional ->
    amountOutPercentageExcess -> amountOutBeforeFee -> newInvariant -> amountBPTIn
    */
    function _calcBptInGivenExactTokensOut(
        uint256 amp,
        uint256[] memory balances,
        uint256[] memory amountsOut,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) internal pure returns (uint256) {
        // BPT in, so we round up overall.

        // Get current invariant
        uint256 currentInvariant = _calculateInvariant(amp, balances);

        // First calculate the sum of all token balances which will be used to calculate
        // the current weights of each token relative to the sum of all balances
        uint256 sumBalances = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            sumBalances = sumBalances.add(balances[i]);
        }

        // Calculate the weighted balance ratio without considering fees
        uint256[] memory tokenBalanceRatiosWithoutFee = new uint256[](amountsOut.length);
        uint256 weightedBalanceRatio = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            uint256 currentWeight = balances[i].divUp(sumBalances);
            tokenBalanceRatiosWithoutFee[i] = balances[i].sub(amountsOut[i]).divUp(balances[i]);
            weightedBalanceRatio = weightedBalanceRatio.add(tokenBalanceRatiosWithoutFee[i].mulUp(currentWeight));
        }

        // Second loop to calculate new amounts in taking into account the fee on the % excess
        uint256[] memory newBalances = new uint256[](balances.length);
        for (uint256 i = 0; i < balances.length; i++) {
            uint256 tokenBalancePercentageExcess;
            // For each ratioSansFee, compare with the total weighted ratio (weightedBalanceRatio) and
            // decrease the fee from what goes above it
            if (weightedBalanceRatio <= tokenBalanceRatiosWithoutFee[i]) {
                tokenBalancePercentageExcess = 0;
            } else {
                tokenBalancePercentageExcess = weightedBalanceRatio.sub(tokenBalanceRatiosWithoutFee[i]).divUp(
                    tokenBalanceRatiosWithoutFee[i].complement()
                );
            }

            uint256 swapFeeExcess = swapFee.mulUp(tokenBalancePercentageExcess);

            uint256 amountOutBeforeFee = amountsOut[i].divUp(swapFeeExcess.complement());

            newBalances[i] = balances[i].sub(amountOutBeforeFee);
        }

        // get new invariant taking into account swap fees
        uint256 newInvariant = _calculateInvariant(amp, newBalances);

        // return amountBPTIn
        return bptTotalSupply.mulUp(newInvariant.divUp(currentInvariant).complement());
    }

    /* 
    TODO: document it correctly
    Flow of calculations:
    amountBPTin -> newInvariant -> (amountOutProportional, amountOutBeforeFee) ->
    amountOutPercentageExcess -> amountOut
    */
    function _calcTokenOutGivenExactBptIn(
        uint256 amp,
        uint256[] memory balances,
        uint256 tokenIndex,
        uint256 bptAmountIn,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) internal pure returns (uint256) {
        // Get current invariant
        uint256 currentInvariant = _calculateInvariant(amp, balances);
        // Calculate new invariant
        uint256 newInvariant = bptTotalSupply.sub(bptAmountIn).divUp(bptTotalSupply).mulUp(currentInvariant);

        // First calculate the sum of all token balances which will be used to calculate
        // the current weight of token
        uint256 sumBalances = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            sumBalances = sumBalances.add(balances[i]);
        }

        // get amountOutBeforeFee
        uint256 newBalanceTokenIndex = _getTokenBalanceGivenInvariantAndAllOtherBalances(
            amp,
            balances,
            newInvariant,
            tokenIndex
        );
        uint256 amountOutBeforeFee = balances[tokenIndex].sub(newBalanceTokenIndex);

        // Calculate tokenBalancePercentageExcess
        uint256 currentWeight = balances[tokenIndex].divDown(sumBalances);
        uint256 tokenBalancePercentageExcess = currentWeight.complement();

        uint256 swapFeeExcess = swapFee.mulUp(tokenBalancePercentageExcess);

        return amountOutBeforeFee.mulDown(swapFeeExcess.complement());
    }

    function _calcTokensOutGivenExactBptIn(
        uint256[] memory balances,
        uint256 bptAmountIn,
        uint256 bptTotalSupply
    ) internal pure returns (uint256[] memory) {
        /**********************************************************************************************
        // exactBPTInForTokensOut                                                                    //
        // (per token)                                                                               //
        // aO = tokenAmountOut             /        bptIn         \                                  //
        // b = tokenBalance      a0 = b * | ---------------------  |                                 //
        // bptIn = bptAmountIn             \     bptTotalSupply    /                                 //
        // bpt = bptTotalSupply                                                                      //
        **********************************************************************************************/

        // Since we're computing an amount out, we round down overall. This means rounding down on both the
        // multiplication and division.

        uint256 bptRatio = bptAmountIn.divDown(bptTotalSupply);

        uint256[] memory amountsOut = new uint256[](balances.length);
        for (uint256 i = 0; i < balances.length; i++) {
            amountsOut[i] = balances[i].mulDown(bptRatio);
        }

        return amountsOut;
    }

    // The amplification parameter equals to: A n^(n-1)
    function _calcDueTokenProtocolSwapFee(
        uint256 amplificationParameter,
        uint256[] memory balances,
        uint256 lastInvariant,
        uint256 tokenIndex,
        uint256 protocolSwapFeePercentage
    ) internal pure returns (uint256) {
        /**************************************************************************************************************
        // oneTokenSwapFee - polynomial equation to solve                                                            //
        // af = fee amount to calculate in one token                                                                 //
        // bf = balance of fee token                                                                                 //
        // f = bf - af (finalBalanceFeeToken)                                                                        //
        // D = old invariant                                            D                     D^(n+1)                //
        // A = amplification coefficient               f^2 + ( S - ----------  - D) * f -  ------------- = 0         //
        // n = number of tokens                                    (A * n^n)               A * n^2n * P              //
        // S = sum of final balances but f                                                                           //
        // P = product of final balances but f                                                                       //
        **************************************************************************************************************/

        // Protocol swap fee, so we round down overall.

        uint256 finalBalanceFeeToken = _getTokenBalanceGivenInvariantAndAllOtherBalances(
            amplificationParameter,
            balances,
            lastInvariant,
            tokenIndex
        );

        //Result is rounded down
        uint256 accumulatedTokenSwapFees = balances[tokenIndex] > finalBalanceFeeToken
            ? balances[tokenIndex].sub(finalBalanceFeeToken)
            : 0;
        return accumulatedTokenSwapFees.mul(protocolSwapFeePercentage).divDown(FixedPoint.ONE);
    }

    //Private functions

    //This function calculates the balance of a given token (tokenIndex)
    // given all the other balances and the invariant
    function _getTokenBalanceGivenInvariantAndAllOtherBalances(
        uint256 amplificationParameter,
        uint256[] memory balances,
        uint256 invariant,
        uint256 tokenIndex
    ) private pure returns (uint256) {
        //Rounds result up overall

        uint256 ampTimesTotal = Math.mul(amplificationParameter, balances.length);
        uint256 sum = balances[0];
        uint256 P_D = Math.mul(balances.length, balances[0]);
        for (uint256 j = 1; j < balances.length; j++) {
            P_D = Math.divDown(Math.mul(Math.mul(P_D, balances[j]), balances.length), invariant);
            sum = sum.add(balances[j]);
        }
        sum = sum.sub(balances[tokenIndex]);

        uint256 c = Math.divUp(Math.mul(invariant, invariant), ampTimesTotal);
        //We remove the balance fromm c by multiplying it
        c = c.mul(balances[tokenIndex]).div(P_D);

        uint256 b = sum.mul(FixedPoint.ONE).add(invariant.div(ampTimesTotal));

        //We iterate to find the balance
        uint256 prevTokenBalance = 0;
        //We apply first iteration outside the loop with the invariant as the starting aproximation value.
        uint256 tokenBalance = invariant.mul(invariant).add(c).divUp(invariant.add(b));

        for (uint256 i = 0; i < 255; i++) {
            prevTokenBalance = tokenBalance;

            tokenBalance = tokenBalance.mul(tokenBalance).add(c).divUp(Math.mul(tokenBalance, 2).add(b).sub(invariant));

            if (tokenBalance > prevTokenBalance) {
                if (tokenBalance.sub(prevTokenBalance) <= 1) {
                    break;
                }
            } else if (prevTokenBalance.sub(tokenBalance) <= 1) {
                break;
            }
        }
        return tokenBalance;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/test/MockStableMath.sol

// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;

contract MockStableMath is StableMath {
    function invariant(uint256 amp, uint256[] calldata balances) external pure returns (uint256) {
        return _calculateInvariant(amp, balances);
    }

    function outGivenIn(
        uint256 amp,
        uint256[] memory balances,
        uint256 tokenIndexIn,
        uint256 tokenIndexOut,
        uint256 tokenAmountIn
    ) external pure returns (uint256) {
        return _calcOutGivenIn(amp, balances, tokenIndexIn, tokenIndexOut, tokenAmountIn);
    }

    function inGivenOut(
        uint256 amp,
        uint256[] memory balances,
        uint256 tokenIndexIn,
        uint256 tokenIndexOut,
        uint256 tokenAmountOut
    ) external pure returns (uint256) {
        return _calcInGivenOut(amp, balances, tokenIndexIn, tokenIndexOut, tokenAmountOut);
    }

    function exactTokensInForBPTOut(
        uint256 amp,
        uint256[] memory balances,
        uint256[] memory amountsIn,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) external pure returns (uint256) {
        return _calcBptOutGivenExactTokensIn(amp, balances, amountsIn, bptTotalSupply, swapFee);
    }

    function tokenInForExactBPTOut(
        uint256 amp,
        uint256[] memory balances,
        uint256 tokenIndex,
        uint256 bptAmountOut,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) external pure returns (uint256) {
        return _calcTokenInGivenExactBptOut(amp, balances, tokenIndex, bptAmountOut, bptTotalSupply, swapFee);
    }

    function exactBPTInForTokenOut(
        uint256 amp,
        uint256[] memory balances,
        uint256 tokenIndex,
        uint256 bptAmountIn,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) external pure returns (uint256) {
        return _calcTokenOutGivenExactBptIn(amp, balances, tokenIndex, bptAmountIn, bptTotalSupply, swapFee);
    }

    function exactBPTInForTokensOut(
        uint256[] memory balances,
        uint256 bptAmountIn,
        uint256 bptTotalSupply
    ) external pure returns (uint256[] memory) {
        return _calcTokensOutGivenExactBptIn(balances, bptAmountIn, bptTotalSupply);
    }

    function bptInForExactTokensOut(
        uint256 amp,
        uint256[] memory balances,
        uint256[] memory amountsOut,
        uint256 bptTotalSupply,
        uint256 swapFee
    ) external pure returns (uint256) {
        return _calcBptInGivenExactTokensOut(amp, balances, amountsOut, bptTotalSupply, swapFee);
    }

    function calculateDueTokenProtocolSwapFee(
        uint256 amp,
        uint256[] memory balances,
        uint256 lastInvariant,
        uint256 tokenIndex,
        uint256 protocolSwapFeePercentage
    ) external pure returns (uint256) {
        return _calcDueTokenProtocolSwapFee(amp, balances, lastInvariant, tokenIndex, protocolSwapFeePercentage);
    }
}
