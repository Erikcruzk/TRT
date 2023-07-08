// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/interfaces/IERC20Decimals.sol

pragma solidity >=0.7.0;

interface IERC20Decimals is IERC20 {
    // Non standard but almost all erc20 have this
    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/lib/math/LogExpMath.sol

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
    int256 constant DECIMALS = 10**18;
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

    function powDown(uint256 x, uint256 y) internal pure returns (uint256) {
        return pow(x, y);
    }

    function powUp(uint256 x, uint256 y) internal pure returns (uint256) {
        return pow(x, y);
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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/lib/math/FixedPoint.sol

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
    uint256 internal constant ONE = 10**18; // 18 decimal places
    uint256 internal constant MIN_POW_BASE = 1 wei;
    uint256 internal constant MAX_POW_BASE = (2 * ONE) - 1 wei;
    uint256 internal constant POW_PRECISION = ONE / 10**10;

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

        uint256 aInflated = a * ONE;
        require(aInflated / a == ONE, "DIV_INTERNAL"); // mul overflow

        return aInflated / b;
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
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/interfaces/IAuthorizer.sol

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

interface IAuthorizer {
    function hasRole(bytes32 role, address account) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/interfaces/IFlashLoanReceiver.sol

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

// Inspired by Aave Protocol's IFlashLoanReceiver

interface IFlashLoanReceiver {
    function receiveFlashLoan(
        IERC20[] calldata tokens,
        uint256[] calldata amounts,
        uint256[] calldata feeAmounts,
        bytes calldata receiverData
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/interfaces/IVault.sol

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

pragma experimental ABIEncoderV2;


pragma solidity ^0.7.0;

/**
 * @dev Full external interface for the Vault core contract - no external or public methods exist in the contract that
 * don't override one of these declarations.
 */
interface IVault {
    // Generalities about the Vault:
    //
    // - Whenever documentation refers to 'tokens', it strictly refers to ERC20-compliant token contracts. Tokens are
    // transferred out of the Vault by calling the `IERC20.transfer` function, and transferred in by calling
    // `IERC20.transferFrom`. In these cases, the sender must have previously allowed the Vault to use their tokens by
    // calling `IERC20.approve`. The only deviation from the ERC20 standard that is supported is functions not returning
    // a boolean value: in these scenarios, a non-reverting call is assumed to be successful.
    //
    // - All non-view functions in the Vault are non-reentrant: calling them while another one is mid-execution (e.g.
    // while execution control is transferred to a token contract during a swap) will result in a revert. View
    // functions can be called in a re-reentrant way, but doing so might cause them to return inconsistent results.
    // Contracts calling view functions in the Vault must make sure the Vault has not already been entered.
    //
    // - View functions revert if referring to either unregistered Pools, or unregistered tokens for registered Pools.

    // Authorizer
    //
    // Some system actions are permissioned, like setting and collecting protocol fees. This permissioning system exists
    // outside of the Vault in the Authorizer contract: the Vault simply calls the Authorizer to check if the caller
    // can perform a given action.
    // The only exception to this are relayers. A relayer is an account (typically a contract) that can use the Internal
    // Balance and Vault allowance of other accounts. For an account to be able to wield this power, two things must
    // happen:
    //  - it must be allowed by the Authorizer to call the functions where it intends to use this permission
    //  - it must be allowed by each individual user to act in their stead
    // This combined requirements means users cannot be tricked into allowing malicious relayers (because they will not
    // have been allowed by the Authorizer), nor can a malicious Authorizer allow malicious relayers to drain user funds
    // (unless the user then allows this malicious relayer).

    /**
     * @dev Returns the Vault's Authorizer.
     */
    function getAuthorizer() external view returns (IAuthorizer);

    /**
     * @dev Sets a new Authorizer for the Vault. The caller must be allowed by the current Authorizer to do this.
     */
    function changeAuthorizer(IAuthorizer newAuthorizer) external;

    /**
     * @dev Returns true if `user` has allowed `relayer` as a relayer for them.
     */
    function hasAllowedRelayer(address user, address relayer) external view returns (bool);

    /**
     * @dev Allows `relayer` to act as a relayer for the caller if `allowed` is true, and disallows it otherwise.
     */
    function changeRelayerAllowance(address relayer, bool allowed) external;

    // Internal Balance
    //
    // Users can deposit tokens into the Vault, where it is known as Internal Balance. This Internal Balance can be
    // withdrawn or transferred, and it can also be used when joining Pools or performing swaps, with greatly reduced
    // gas costs. Swaps and Pool exits can also be made to deposit to Internal Balance.
    //
    // Internal Balance functions feature batching, which means each call can be used to perform multiple operations of
    // the same kind (deposit, withdraw or transfer) at once.

    /**
     * @dev Data for internal balance transfers - encompassing deposits, withdrawals, and transfers between accounts.
     *
     * This gives aggregators maximum flexibility, and makes it possible for an asset manager to manage multiple tokens
     * and pools with less gas and fewer calls to the vault.
     */

    struct BalanceTransfer {
        IERC20 token;
        uint256 amount;
        address sender;
        address recipient;
    }

    /**
     * @dev Returns `user`'s Internal Balance for a set of tokens.
     */
    function getInternalBalance(address user, IERC20[] memory tokens) external view returns (uint256[] memory);

    /**
     * @dev Deposits tokens from each `sender` address into Internal Balances of the corresponding `recipient`
     * accounts specified in the struct. The sources must have allowed the Vault to use their tokens
     * via `IERC20.approve()`.
     * Allows aggregators to settle multiple accounts in a single transaction.
     */
    function depositToInternalBalance(BalanceTransfer[] memory transfers) external;

    /**
     * @dev Withdraws tokens from each the internal balance of each `sender` address into the `recipient` accounts
     * specified in the struct. Allows aggregators to settle multiple accounts in a single transaction.
     *
     * This charges protocol withdrawal fees.
     */
    function withdrawFromInternalBalance(BalanceTransfer[] memory transfers) external;

    /**
     * @dev Transfers tokens from the internal balance of each `sender` address to Internal Balances
     * of each `recipient`. Allows aggregators to settle multiple accounts in a single transaction.
     *
     * This does not charge protocol withdrawal fees.
     */
    function transferInternalBalance(BalanceTransfer[] memory transfers) external;

    /**
     * @dev Emitted when a user's Internal Balance changes, either due to calls to the Internal Balance functions, or
     * due to interacting with Pools using Internal Balance.
     */
    event InternalBalanceChanged(address indexed user, IERC20 indexed token, uint256 balance);

    // Pools
    //
    // There are three specialization settings for Pools, which allow for lower swap gas costs at the cost of reduced
    // functionality:
    //
    //  - general: no specialization, suited for all Pools. IGeneralPool is used for swap request callbacks, passing the
    // balance of all tokens in the Pool. These Pools have the largest swap costs (because of the extra storage reads),
    // and these increase with the number of registered tokens.
    //
    //  - minimal swap info: IMinimalSwapInfoPool is used instead of IGeneeralPool, which saves gas by only passing the
    // balance of the two tokens involved in the swap. This is suitable for some pricing algorithms, like the weighted
    // constant product one popularized by Balancer v1. Swap costs are smaller compared to general Pools, and are
    // independent of the number of registered tokens.
    //
    //  - two tokens: only allows two tokens to be registered. This achieves the lowest possible swap gas costs. Like
    // minimal swap info Pools, these are called via IMinimalSwapInfoPool.

    enum PoolSpecialization { GENERAL, MINIMAL_SWAP_INFO, TWO_TOKEN }

    /**
     * @dev Registers a the caller as a Pool with a chosen specialization setting. Returns the Pool's ID, which is used
     * in all Pool-related functions. Pools cannot be deregistered, nor can the Pool's specialization be changed.
     *
     * The caller is expected to be a smart contract that implements one of `IGeneralPool` or `IMinimalSwapInfoPool`.
     * This contract is known as the Pool's contract. Note that the same caller may register itself as multiple Pools
     * with unique Pool IDs, or in other words, multiple Pools may have the same contract.
     *
     * Emits a `PoolCreated` event.
     */
    function registerPool(PoolSpecialization specialization) external returns (bytes32);

    /**
     * @dev Emitted when a Pool is registered by calling `registerPool`.
     */
    event PoolCreated(bytes32 poolId);

    /**
     * @dev Returns a Pool's contract address and specialization setting.
     */
    function getPool(bytes32 poolId) external view returns (address, PoolSpecialization);

    /**
     * @dev Registers `tokens` for the `poolId` Pool. Must be called by the Pool's contract.
     *
     * Pools can only interact with tokens they have registered. Users join a Pool by transferring registered tokens,
     * exit by receiving registered tokens, and can only swap registered tokens.
     *
     * Each token can only be registered once. For Pools with the Two Token specialization, `tokens` must have a length
     * of two, that is, both tokens must be registered in the same `registerTokens` call.
     *
     * The `tokens` and `assetManagers` arrays must have the same length, and each entry in these indicates the Asset
     * Manager for each token. Asset Managers can manage a Pool's tokens by withdrawing and depositing them directly
     * (via `withdrawFromPoolBalance` and `depositToPoolBalance`), and even set them to arbitrary amounts
     * (`updateManagedBalance`). They are therefore expected to be highly secured smart contracts with sound design
     * principles, and the decision to add an Asset Mananager should not be made lightly.
     *
     * Pools can not set an Asset Manager by setting them to the zero address. Once an Asset Manager is set, it cannot
     * be changed, except by deregistering the associated token and registering again with a different Manager.
     *
     * Emits `TokensRegistered` events.
     */
    function registerTokens(
        bytes32 poolId,
        IERC20[] calldata tokens,
        address[] calldata assetManagers
    ) external;

    /**
     * @dev Emitted when a Pool registers tokens by calling `registerTokens`.
     */
    event TokensRegistered(bytes32 poolId, IERC20[] tokens, address[] assetManagers);

    /**
     * @dev Deregisters `tokens` for the `poolId` Pool. Must be called by the Pool's contract.
     *
     * Only registered tokens (via `registerTokens`) can be deregistered. Additionally, they must have zero total
     * balance. For Pools with the Two Token specialization, `tokens` must have a length of two, that is, both tokens
     * must be deregistered in the same `deregisterTokens` call.
     *
     * A deregistered token can be re-registered later on, possibly with a different Asset Manager.
     *
     * Emits a `TokensDeregistered` event.
     */
    function deregisterTokens(bytes32 poolId, IERC20[] calldata tokens) external;

    /**
     * @dev Emitted when a Pool deregisters tokens by calling `deregisterTokens`.
     */
    event TokensDeregistered(bytes32 poolId, IERC20[] tokens);

    /**
     * @dev Returns a Pool's registered tokens and total balance for each.
     *
     * The order of the `tokens` array is the same order that will be used in `joinPool`, `exitPool`, as well as in all
     * Pool hooks (where applicable). Calls to `registerTokens` and `deregisterTokens` may change this order. If a Pool
     * only registers tokens once, and these are sorted in ascending order, they will be stored in the same order as
     * passed to `registerTokens`.
     *
     * Total balances include both tokens held by the Vault and those withdrawn by the Pool's Asset Managers. These are
     * the amounts used by joins, exits and swaps.
     */
    function getPoolTokens(bytes32 poolId) external view returns (IERC20[] memory tokens, uint256[] memory balances);

    /**
     * @dev Returns detailed information for a Pool's registered token.
     *
     * `cash` is the number of tokens the Vault currently holds for the Pool. `managed` is the number of tokens
     * withdrawn and reported by the Pool's token Asset Manager. The Pool's total balance for `token` equals the sum of
     * `cash` and `managed`.
     *
     * `blockNumber` is the number of the block in which `token`'s balance was last modified (via either a join, exit,
     * swap, or Asset Management interactions). This value is useful to avoid so-called 'sandwich attacks', for example
     * when developing price oracles.
     *
     * `assetManager` is the Pool's token Asset Manager.
     */
    function getPoolTokenInfo(bytes32 poolId, IERC20 token)
        external
        view
        returns (
            uint256 cash,
            uint256 managed,
            uint256 blockNumber,
            address assetManager
        );

    /**
     * @dev Called by users to join a Pool, which transfers tokens from `sender` into the Pool's balance. This will
     * trigger custom Pool behavior, which will typically grant something in return to `recipient` - often tokenized
     * Pool shares.
     *
     * If the caller is not `sender`, it must be an authorized relayer for them.
     *
     * The `tokens` and `maxAmountsIn` arrays must have the same length, and each entry in these indicates the maximum
     * token amount to send for each token contract. The amounts to send are decided by the Pool and not the Vault: it
     * just enforces these maximums.
     *
     * `tokens` must have the same length and order as the one returned by `getPoolTokens`. This prevents issues when
     * interacting with Pools that register and deregister tokens frequently.
     *
     * If `fromInternalBalance` is true, the caller's Internal Balance will be preferred: ERC20 transfers will only
     * be made for the difference between the requested amount and Internal Balance (if any).
     *
     * This causes the Vault to call the `IBasePool.onJoinPool` hook on the Pool's contract, where Pools implements
     * their own custom logic. This typically requires additional information from the user (such as the expected number
     * of Pool shares to obtain). This can be encoded in the `userData` argument, which is ignored by the Vault and
     * passed directly to the Pool's contract, as is `recipient`.
     *
     * Emits a `PoolJoined` event.
     */
    function joinPool(
        bytes32 poolId,
        address sender,
        address recipient,
        IERC20[] memory tokens,
        uint256[] memory maxAmountsIn,
        bool fromInternalBalance,
        bytes memory userData
    ) external;

    /**
     * @dev Emitted when a user joins a Pool by calling `joinPool`.
     */
    event PoolJoined(
        bytes32 indexed poolId,
        address indexed liquidityProvider,
        uint256[] amountsIn,
        uint256[] protocolFees
    );

    /**
     * @dev Called by users to exit a Pool, which transfers tokens from the Pool's balance to `recipient`. This will
     * trigger custom Pool behavior, which will typically ask for something in return from `sender` - often tokenized
     * Pool shares. The amount of tokens that can be withdraw is limited by the Pool's `cash` balance (see
     * `getPoolTokenInfo`).
     *
     * If the caller is not `sender`, it must be an authorized relayer for them.
     *
     * The `tokens` and `minAmountsOut` arrays must have the same length, and each entry in these indicates the minimum
     * token amount to receive for each token contract. The amounts to send are decided by the Pool and not the Vault:
     * it just enforces these minimums.
     *
     * `tokens` must have the same length and order as the one returned by `getPoolTokens`. This prevents issues when
     * interacting with Pools that register and deregister tokens frequently.
     *
     * If `toInternalBalance` is true, the tokens will be deposited to `recipient`'s Internal Balance. Otherwise,
     * an ERC20 transfer will be performed, charging protocol withdraw fees.
     *
     * `minAmountsOut` is the minimum amount of tokens the user expects to get out of the Pool, for each token in the
     * `tokens` array. This array must match the Pool's registered tokens.
     *
     * Pools are free to implement any arbitrary logic in the `IPool.onExitPool` hook, and may require additional
     * information (such as the number of Pool shares to provide). This can be encoded in the `userData` argument, which
     * is ignored by the Vault and passed directly to the Pool.
     *
     * This causes the Vault to call the `IBasePool.onExitPool` hook on the Pool's contract, where Pools implements
     * their own custom logic. This typically requires additional information from the user (such as the expected number
     * of Pool shares to return). This can be encoded in the `userData` argument, which is ignored by the Vault and
     * passed directly to the Pool's contract.
     *
     * Emits a `PoolExited` event.
     */
    function exitPool(
        bytes32 poolId,
        address sender,
        address recipient,
        IERC20[] memory tokens,
        uint256[] memory minAmountsOut,
        bool toInternalBalance,
        bytes memory userData
    ) external;

    /**
     * @dev Emitted when a Pool deregisters tokens by calling `deregisterTokens`.
     */
    event PoolExited(
        bytes32 indexed poolId,
        address indexed liquidityProvider,
        uint256[] amountsOut,
        uint256[] protocolFees
    );

    // Swaps
    //
    // Users can swap tokens with Pools by calling the `batchSwapGivenIn` and `batchSwapGivenOut` functions. To do this,
    // they need not trust Pool contracts in any way: all security checks are made by the Vault. They must however be
    // aware of the Pools' pricing algorithms in order to estimate the prices Pools will quote.
    //
    // Both swap functions are batched, meaning they perform multiple of swaps in sequence. In each individual swap,
    // tokens of one kind are sent from the sender to the Pool (this is the 'token in'), and tokens of one
    // other kind are sent from the Pool to the sender in exchange (this is the 'token out'). More complex swaps, such
    // as one token in to multiple tokens out can be achieved by batching together individual swaps.
    //
    // Additionally, it is possible to chain swaps by using the output of one of them as the input for the other, as
    // well as the opposite. This extended swap is known as a 'multihop' swap, since it 'hops' through a number of
    // intermediate tokens before arriving at the final intended token.
    //
    // In all cases, tokens are only transferred in and out of the Vault (or withdrawn from and deposited into Internal
    // Balance) after all individual swaps have been completed, and the net token balance change computed. This makes
    // certain swap patterns, such as multihops, or swaps that interact with the same token pair in multiple Pools, cost
    // much less gas than they would otherwise.
    //
    // It also means that it is possible to e.g. under certain conditions perform arbitrage by swapping with multiple
    // Pools in a way that results in net token movement out of the Vault (profit), with no tokens being sent in (but
    // updating the Pool's internal balances).
    //
    // To protect users from front-running or the market changing rapidly, they supply a list of 'limits' for each token
    // involved in the swap, where either the maximum number of tokens to send (by passing a positive value) or minimum
    // amount of tokens to receive (by passing a negative value) is specified.
    //
    // Additionally, a 'deadline' timestamp can also be provided, forcing the swap to fail if it occurs after
    // this point in time (e.g. if the transaction failed to be included in a block promptly).
    //
    // Finally, Internal Balance can be used both when sending and receiving tokens.

    /**
     * @dev Performs a series of swaps with one or multiple Pools. In individual each swap, the amount of tokens sent to
     * the Pool is determined by the caller. For swaps where the amount of tokens received from the Pool is instead
     * determined, see `batchSwapGivenOut`.
     *
     * Returns an array with the net Vault token balance deltas. Positive amounts represent tokens sent to the Vault,
     * and negative amounts tokens sent by the Vault. Each delta corresponds to the token at the same index in the
     * `tokens` array.
     *
     * Swaps are executed sequentially, in the order specified by the `swaps` array. Each array element describes a
     * Pool, the token and amount to send to this Pool, and the token to receive from it (but not the amount). This will
     * be determined by the Pool's pricing algorithm once the Vault calls the `onSwapGivenIn` hook on it.
     *
     * Multihop swaps can be executed by passing an `amountIn` value of zero for a swap. This will cause the amount out
     * of the previous swap to be used as the amount in of the current one. In such a scenario, `tokenIn` must equal the
     * previous swap's `tokenOut`.
     *
     * The `tokens` array contains the addresses of all tokens involved in the swaps. Each entry in the `swaps` array
     * specifies tokens in and out by referencing an index in `tokens`.
     *
     * Internal Balance usage and recipient are determined by the `funds` struct.
     *
     * Emits `Swap` events.
     */
    function batchSwapGivenIn(
        SwapIn[] calldata swaps,
        IERC20[] memory tokens,
        FundManagement calldata funds,
        int256[] memory limits,
        uint256 deadline
    ) external returns (int256[] memory);

    /**
     * @dev Data for each individual swap executed by `batchSwapGivenIn`. The tokens in and out are indexed in the
     * `tokens` array passed to that function.
     *
     * If `amountIn` is zero, the multihop mechanism is used to determine the actual amount based on the amout out from
     * the previous swap.
     *
     * The `userData` field is ignored by the Vault, but forwarded to the Pool in the `onSwapGivenIn` hook, and may be
     * used to extend swap behavior.
     */
    struct SwapIn {
        bytes32 poolId;
        uint256 tokenInIndex;
        uint256 tokenOutIndex;
        uint256 amountIn;
        bytes userData;
    }

    /**
     * @dev Performs a series of swaps with one or multiple Pools. In individual each swap, the amount of tokens
     * received from the Pool is determined by the caller. For swaps where the amount of tokens sent to the Pool is
     * instead determined, see `batchSwapGivenIn`.
     *
     * Returns an array with the net Vault token balance deltas. Positive amounts represent tokens sent to the Vault,
     * and negative amounts tokens sent by the Vault. Each delta corresponds to the token at the same index in the
     * `tokens` array.
     *
     * Swaps are executed sequentially, in the order specified by the `swaps` array. Each array element describes a
     * Pool, the token and amount to receive from this Pool, and the token to send to it (but not the amount). This will
     * be determined by the Pool's pricing algorithm once the Vault calls the `onSwapGivenOut` hook on it.
     *
     * Multihop swaps can be executed by passing an `amountOut` value of zero for a swap. This will cause the amount in
     * of the previous swap to be used as the amount out of the current one. In such a scenario, `tokenOut` must equal
     * the previous swap's `tokenIn`.
     *
     * The `tokens` array contains the addresses of all tokens involved in the swaps. Each entry in the `swaps` array
     * specifies tokens in and out by referencing an index in `tokens`.
     *
     * Internal Balance usage and recipient are determined by the `funds` struct.
     *
     * Emits `Swap` events.
     */
    function batchSwapGivenOut(
        SwapOut[] calldata swaps,
        IERC20[] memory tokens,
        FundManagement calldata funds,
        int256[] memory limits,
        uint256 deadline
    ) external returns (int256[] memory);

    /**
     * @dev Data for each individual swap executed by `batchSwapGivenOut`. The tokens in and out are indexed in the
     * `tokens` array passed to that function.
     *
     * If `amountOut` is zero, the multihop mechanism is used to determine the actual amount based on the amout in from
     * the previous swap.
     *
     * The `userData` field is ignored by the Vault, but forwarded to the Pool in the `onSwapGivenOut` hook, and may be
     * used to extend swap behavior.
     */
    struct SwapOut {
        bytes32 poolId;
        uint256 tokenInIndex;
        uint256 tokenOutIndex;
        uint256 amountOut;
        bytes userData;
    }

    /**
     * @dev Emitted for each individual swap performed by `batchSwapGivenIn` and `batchSwapGivenOut`.
     */
    event Swap(
        bytes32 indexed poolId,
        IERC20 indexed tokenIn,
        IERC20 indexed tokenOut,
        uint256 tokensIn,
        uint256 tokensOut
    );

    /**
     * @dev All tokens in a swap are sent to the Vault from the `sender`'s account, and sent to `recipient`.
     *
     * If the caller is not `sender`, it must be an authorized relayer for them.
     *
     * If `fromInternalBalance` is true, the `sender`'s Internal Balance will be preferred, performing an ERC20
     * transfer for the difference between the requested amount and the User's Internal Balance (if any). The `sender`
     * must have allowed the Vault to use their tokens via `IERC20.approve()`. This matches the behavior of
     * `joinPool`.
     *     * If `tointernalBalance` is true, tokens will be deposited to `recipient`'s internal balance instead of
     * transferred. This matches the behavior of `exitPool`.
     */
    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address recipient;
        bool toInternalBalance;
    }

    /**
     * @dev Simulates a call to `batchSwapGivenIn` or `batchSwapGivenOut`, returning an array of Vault token deltas.
     * Each element in the array corresponds to the token at the same index, and indicates the number of tokens the
     * Vault would take from the sender (if positive) or send to the recipient (if negative). The arguments it receives
     * are the same that an equivalent `batchSwapGivenOut` or `batchSwapGivenOut` call would receive, except the
     * `SwapRequest` struct is used instead, and the `kind` argument specifies whether the swap is given in or given
     * out.
     *
     * Unlike `batchSwapGivenIn` and `batchSwapGivenOut`, this function performs no checks on the sender nor recipient
     * field in the `funds` struct. This makes it suitable to be called by off-chain applications via eth_call without
     * needing to hold tokens, approve them for the Vault, or even know a user's address.
     *
     * Note that this function is not 'view' (due to implementation details): the client code must explicitly execute
     * eth_call instead of eth_sendTransaction.
     */
    function queryBatchSwap(
        SwapKind kind,
        SwapRequest[] memory swaps,
        IERC20[] memory tokens,
        FundManagement memory funds
    ) external returns (int256[] memory tokenDeltas);

    enum SwapKind { GIVEN_IN, GIVEN_OUT }

    // This struct is identical in layout to SwapIn and SwapOut, except the 'amountIn/Out' field is named 'amount'.
    struct SwapRequest {
        bytes32 poolId;
        uint256 tokenInIndex;
        uint256 tokenOutIndex;
        uint256 amount;
        bytes userData;
    }

    // Flash Loans

    /**
     * @dev Performs a 'flash loan', sending tokens to `receiver` and executing the `receiveFlashLoan` hook on it,
     * and then reverting unless the tokens plus a protocol fee have been returned.
     *
     * The `tokens` and `amounts` arrays must have the same length, and each entry in these indicates the amount to
     * loan for each token contract. `tokens` must be sorted in ascending order.
     *
     * The 'receiverData' field is ignored by the Vault, and forwarded as-is to `receiver` as part of the
     * `receiveFlashLoan` call.
     */
    function flashLoan(
        IFlashLoanReceiver receiver,
        IERC20[] calldata tokens,
        uint256[] calldata amounts,
        bytes calldata receiverData
    ) external;

    // Asset Management
    //
    // Each token registered for a Pool can be assigned an Asset Manager, which is able to freely withdraw the Pool's
    // tokens from the Vault, deposit them, or assign arbitrary values to its `managed` balance (see
    // `getPoolTokenInfo`). This makes them extremely powerful and dangerous, as they can not only steal a Pool's tokens
    // but also manipulate its prices. However, a properly designed Asset Manager smart contract can be used to the
    // Pool's benefit, for example by lending unused tokens at an interest, or using them to participate in voting
    // protocols.

    struct AssetManagerTransfer {
        IERC20 token;
        uint256 amount;
    }

    /**
     * @dev Returns the Pool's Asset Managers for the given `tokens`. Asset Managers can manage a Pool's assets
     * by taking them out of the Vault via `withdrawFromPoolBalance`, `depositToPoolBalance` and `updateManagedBalance`.
     */
    function getPoolAssetManagers(bytes32 poolId, IERC20[] memory tokens)
        external
        view
        returns (address[] memory assetManagers);

    /**
     * @dev Emitted when a Pool's token Asset manager withdraws or deposits token balance via `withdrawFromPoolBalance`
     * or `depositToPoolBalance`.
     */
    event PoolBalanceChanged(bytes32 indexed poolId, address indexed assetManager, IERC20 indexed token, int256 amount);

    /**
     * @dev Called by a Pool's Asset Manager to withdraw tokens from the Vault. This decreases
     * the Pool's cash but increases its managed balance, leaving the total balance unchanged.
     * Array input allows asset managers to manage multiple tokens for a pool in a single transaction.
     */
    function withdrawFromPoolBalance(bytes32 poolId, AssetManagerTransfer[] memory transfers) external;

    /**
     * @dev Called by a Pool's Asset Manager to deposit tokens into the Vault. This increases the Pool's cash,
     * but decreases its managed balance, leaving the total balance unchanged. The Asset Manager must have approved
     * the Vault to use each token. Array input allows asset managers to manage multiple tokens for a pool in a
     * single transaction.
     */
    function depositToPoolBalance(bytes32 poolId, AssetManagerTransfer[] memory transfers) external;

    /**
     * @dev Called by a Pool's Asset Manager for to update the amount held outside the vault. This does not affect
     * the Pool's cash balance, but because the managed balance changes, it does alter the total. The external
     * amount can be either increased or decreased by this call (i.e., reporting a gain or a loss).
     * Array input allows asset managers to manage multiple tokens for a pool in a single transaction.
     */
    function updateManagedBalance(bytes32 poolId, AssetManagerTransfer[] memory transfers) external;

    // Protocol Fees
    //
    // Some operations cause the Vault to collect tokens in the form of protocol fees, which can then be withdrawn by
    // permissioned accounts.
    //
    // There are three kinds of protocol fees:
    //
    //  - flash loan fees: charged on all flash loans, as a percentage of the amounts lent.
    //
    //  - withdraw fees: charged when users take tokens out of the Vault, by either calling
    // `withdrawFromInternalBalance` or calling `exitPool` without depositing to Internal Balance. The fee is a
    // percentage of the amount withdrawn. Swaps are unaffected by withdraw fees.
    //
    //  - swap fees: a percentage of the fees charged by Pools when performing swaps. For a number of reasons, including
    // swap gas costs and interface simplicity, protocol swap fees are not charged on each individual swap. Rather,
    // Pools are expected to keep track of how many swap fees they have charged, and pay any outstanding debts to the
    // Vault when they are joined or exited. This prevents users from joining a Pool with unpaid debt, as well as
    // exiting a Pool in debt without first paying their share.

    /**
     * @dev Returns the current protocol fee percentages. These are 18 decimals fixed point numbers, which means that
     * e.g. a value of 0.1e18 stands for a 10% fee.
     */
    function getProtocolFees()
        external
        view
        returns (
            uint256 swapFee,
            uint256 withdrawFee,
            uint256 flashLoanFee
        );

    /**
     * @dev Sets new Protocol fees. The caller must be allowed by the Authorizer to do this, and the new fee values must
     * not be above the absolute maximum amounts.
     */
    function setProtocolFees(
        uint256 swapFee,
        uint256 withdrawFee,
        uint256 flashLoanFee
    ) external;

    /**
     * @dev Returns the amount of protocol fees collected by the Vault for each token in the `tokens` array.
     */
    function getCollectedFees(IERC20[] memory tokens) external view returns (uint256[] memory);

    /**
     * @dev Withdraws collected protocol fees, transferring them to `recipient`. The caller must be allowed by the
     * Authorizer to do this.
     */
    function withdrawCollectedFees(
        IERC20[] calldata tokens,
        uint256[] calldata amounts,
        address recipient
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/interfaces/IBasePool.sol

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
pragma experimental ABIEncoderV2;

/**
 * @dev Interface all Pool contracts should implement. Note that this is not the complete Pool contract interface, as it
 * is missing the swap hooks: Pool contracts should instead inherit from either IGeneralPool or IMinimalSwapInfoPool.
 */
interface IBasePool {
    /**
     * @dev Called by the Vault when a user calls `IVault.joinPool` to join this Pool. Returns how many tokens the user
     * should provide for each registered token, as well as how many protocol fees the Pool owes to the Vault. After
     * returning, the Vault will take tokens from the `sender` and add it to the Pool's balance, as well as collect
     * reported protocol fees. The current protocol swap fee percentage is provided to help compute this value.
     *
     * Due protocol fees are reported and charged on join events so that new users join the Pool free of debt.
     *
     * `sender` is the account performing the join (from whom tokens will be withdrawn), and `recipient` an account
     * designated to receive any benefits (typically pool shares). `currentBalances` contains the total token balances
     * for each token the Pool registered in the Vault, in the same order as `IVault.getPoolTokens` would return.
     *
     * `latestBlockNumberUsed` is the last block number in which any of the Pool's registered tokens last changed its
     * balance. This can be used to implement price oracles that are resilient to 'sandwich' attacks.
     *
     * Contracts implementing this function should check that the caller is indeed the Vault before performing any
     * state-changing operations, such as minting pool shares.
     */
    function onJoinPool(
        bytes32 poolId,
        address sender,
        address recipient,
        uint256[] calldata currentBalances,
        uint256 latestBlockNumberUsed,
        uint256 protocolSwapFee,
        bytes calldata userData
    ) external returns (uint256[] memory amountsIn, uint256[] memory dueProtocolFeeAmounts);

    /**
     * @dev Called by the Vault when a user calls `IVault.exitPool` to exit this Pool. Returns how many tokens the Vault
     * should deduct from the Pool, as well as how many protocol fees the Pool owes to the Vault. After returning, the
     * Vault will take tokens from the Pool's balance and add grant them to `recipient`, as well as collect reported
     * protocol fees. The current protocol swap fee percentage is provided to help compute this value.
     *
     * Due protocol fees are reported and charged on exit events so that users exit the Pool having paid all debt.
     *
     * `sender` is the account performing the exit (typically the holder of pool shares), and `recipient` the account to
     * which the Vault will grant tokens. `currentBalances` contains the total token balances for each token the Pool
     * registered in the Vault, in the same order as `IVault.getPoolTokens` would return.
     *
     * `latestBlockNumberUsed` is the last block number in which any of the Pool's registered tokens last changed its
     * balance. This can be used to implement price oracles that are resilient to 'sandwich' attacks.
     *
     * Contracts implementing this function should check that the caller is indeed the Vault before performing any
     * state-changing operations, such as burning pool shares.
     */
    function onExitPool(
        bytes32 poolId,
        address sender,
        address recipient,
        uint256[] calldata currentBalances,
        uint256 latestBlockNumberUsed,
        uint256 protocolSwapFee,
        bytes calldata userData
    ) external returns (uint256[] memory amountsOut, uint256[] memory dueProtocolFeeAmounts);

    // Optional methods - these are not required by the Vault as they are not called, but Pool contracts are encouraged
    // to implement these or similar getters.

    /**
     * @dev Returns the address of the Vault.
     */
    function getVault() external view returns (IVault);

    /**
     * @dev Returns the Pool ID of the Pool. Note that this may not be feasible for Pool contracts that register
     * multiple Pools.
     */
    function getPoolId() external view returns (bytes32);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/interfaces/IPoolSwapStructs.sol

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

interface IPoolSwapStructs {
    // This is not really an interface - it just defines common structs used by other interfaces: IGeneralPool and
    // IMinimalSwapInfoPool.

    // This data structure represents a request for a token swap, where the amount received by the Pool is known.
    //
    // `tokenIn` and `tokenOut` are the tokens the Pool will receive and send, respectively. `amountIn` is the number of
    // `tokenIn` tokens that the Pool will receive.
    //
    // All other fields are not strictly necessary for most swaps, but are provided to support advanced scenarios in
    // some Pools.
    // `poolId` is the ID of the Pool involved in the swap - this is useful for Pool contracts that implement more than
    // one Pool.
    // `from` is the origin address where funds the Pool receives are coming from, and `to` is the destination address
    // where the funds the Pool sends are going to.
    // `userData` is extra data provided by the caller - typically a signature from a trusted party.
    struct SwapRequestGivenIn {
        IERC20 tokenIn;
        IERC20 tokenOut;
        uint256 amountIn;
        // Misc data
        bytes32 poolId;
        uint256 latestBlockNumberUsed;
        address from;
        address to;
        bytes userData;
    }

    // This data structure represents a request for a token swap, where the amount sent by the Pool is known.
    //
    // `tokenIn` and `tokenOut` are the tokens the Pool will receive and send, respectively. `amountOut` is the number
    // of `tokenOut` tokens that the Pool will send.
    //
    // All other fields are not strictly necessary for most swaps, but are provided to support advanced scenarios in
    // some Pools.
    // `poolId` is the ID of the Pool involved in the swap - this is useful for Pool contracts that implement more than
    // one Pool.
    // `from` is the origin address where funds the Pool receives are coming from, and `to` is the destination address
    // where the funds the Pool sends are going to.
    // `userData` is extra data provided by the caller - typically a signature from a trusted party.
    struct SwapRequestGivenOut {
        IERC20 tokenIn;
        IERC20 tokenOut;
        uint256 amountOut;
        // Misc data
        bytes32 poolId;
        uint256 latestBlockNumberUsed;
        address from;
        address to;
        bytes userData;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/interfaces/IMinimalSwapInfoPool.sol

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
pragma experimental ABIEncoderV2;


/**
 * @dev Interface contracts for Pools with the minimal swap info or two token specialization settings should implement.
 */
interface IMinimalSwapInfoPool is IBasePool {
    /**
     * @dev Called by the Vault when a user calls `IVault.batchSwapGivenIn` to swap with this Pool. Returns the number
     * of tokens the Pool will grant to the user as part of the swap.
     *
     * This can be often implemented by a `view` function, since many pricing algorithms don't need to track state
     * changes in swaps. However, contracts implementing this in non-view functions should check that the caller is
     * indeed the Vault.
     */
    function onSwapGivenIn(
        IPoolSwapStructs.SwapRequestGivenIn calldata swapRequest,
        uint256 currentBalanceTokenIn,
        uint256 currentBalanceTokenOut
    ) external returns (uint256 amountOut);

    /**
     * @dev Called by the Vault when a user calls `IVault.batchSwapGivenOut` to swap with this Pool. Returns the number
     * of tokens the user must grant to the Pool as part of the swap.
     *
     * This can be often implemented by a `view` function, since many pricing algorithms don't need to track state
     * changes in swaps. However, contracts implementing this in non-view functions should check that the caller is
     * indeed the Vault.
     */
    function onSwapGivenOut(
        IPoolSwapStructs.SwapRequestGivenOut calldata swapRequest,
        uint256 currentBalanceTokenIn,
        uint256 currentBalanceTokenOut
    ) external returns (uint256 amountIn);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/lib/math/Math.sol

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

    function sqrtUp(uint256 x) internal pure returns (uint256) {
        //TODO: implement rounding in sqrt function
        return sqrt(x);
    }

    function sqrtDown(uint256 x) internal pure returns (uint256) {
        //TODO: implement rounding in sqrt function
        return sqrt(x);
    }

    // credit for this implementation goes to
    // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
    function sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
        // however that code costs significantly more gas
        uint256 xx = x;
        uint256 r = 1;
        if (xx >= 0x100000000000000000000000000000000) {
            xx >>= 128;
            r <<= 64;
        }
        if (xx >= 0x10000000000000000) {
            xx >>= 64;
            r <<= 32;
        }
        if (xx >= 0x100000000) {
            xx >>= 32;
            r <<= 16;
        }
        if (xx >= 0x10000) {
            xx >>= 16;
            r <<= 8;
        }
        if (xx >= 0x100) {
            xx >>= 8;
            r <<= 4;
        }
        if (xx >= 0x10) {
            xx >>= 4;
            r <<= 2;
        }
        if (xx >= 0x8) {
            r <<= 1;
        }
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1;
        r = (r + x / r) >> 1; // Seven iterations should be enough
        uint256 r1 = x / r;
        return (r < r1 ? r : r1);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/pools/BalancerPoolToken.sol

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

/**
 * @title Highly opinionated token implementation
 * @author Balancer Labs
 * @dev
 * - Includes functions to increase and decrease allowance as a workaround
 *   for the well-known issue with `approve`:
 *   https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
 * - Allows for 'infinite allowance', where an allowance of 0xff..ff is not
 *   decreased by calls to transferFrom
 * - Lets a token holder use `transferFrom` to send their own tokens,
 *   without first setting allowance
 * - Emits 'Approval' events whenever allowance is changed by `transferFrom`
 */
contract BalancerPoolToken is IERC20 {
    using Math for uint256;

    // State variables

    uint8 private constant _DECIMALS = 18;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowance;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    // Function declarations

    constructor(string memory tokenName, string memory tokenSymbol) {
        _name = tokenName;
        _symbol = tokenSymbol;
    }

    // External functions

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowance[owner][spender];
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balance[account];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _setAllowance(msg.sender, spender, amount);

        return true;
    }

    function increaseApproval(address spender, uint256 amount) external returns (bool) {
        _setAllowance(msg.sender, spender, _allowance[msg.sender][spender].add(amount));

        return true;
    }

    function decreaseApproval(address spender, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _allowance[msg.sender][spender];

        if (amount >= currentAllowance) {
            _setAllowance(msg.sender, spender, 0);
        } else {
            _setAllowance(msg.sender, spender, currentAllowance.sub(amount));
        }

        return true;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _move(msg.sender, recipient, amount);

        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        uint256 currentAllowance = _allowance[sender][msg.sender];
        require(msg.sender == sender || currentAllowance >= amount, "BPT_BAD_CALLER");

        _move(sender, recipient, amount);

        if (msg.sender != sender && currentAllowance != uint256(-1)) {
            require(currentAllowance >= amount, "INSUFFICIENT_ALLOWANCE");
            _setAllowance(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    // Public functions

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _DECIMALS;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Internal functions

    function _mintPoolTokens(address recipient, uint256 amount) internal {
        _balance[address(this)] = _balance[address(this)].add(amount);
        _totalSupply = _totalSupply.add(amount);

        _move(address(this), recipient, amount);

        emit Transfer(address(0), recipient, amount);
    }

    function _burnPoolTokens(address sender, uint256 amount) internal {
        _move(sender, address(this), amount);

        uint256 currentBalance = _balance[address(this)];
        require(currentBalance >= amount, "INSUFFICIENT_BALANCE");

        _balance[address(this)] = currentBalance - amount;
        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(sender, address(0), amount);
    }

    function _move(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        uint256 currentBalance = _balance[sender];
        require(currentBalance >= amount, "INSUFFICIENT_BALANCE");

        _balance[sender] = currentBalance - amount;
        _balance[recipient] = _balance[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }

    // Private functions

    function _setAllowance(
        address owner,
        address spender,
        uint256 amount
    ) private {
        _allowance[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/ConvergentCurvePool.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;







contract ConvergentCurvePool is IMinimalSwapInfoPool, BalancerPoolToken {
    using LogExpMath for uint256;
    using FixedPoint for uint256;

    // The token we expect to stay constant in value
    IERC20 public immutable underlying;
    uint8 public immutable underlyingDecimals;
    // The token we expect to appreciate to match underlying
    IERC20 public immutable bond;
    uint8 public immutable bondDecimals;
    // The expiration time
    uint256 public immutable expiration;
    // The number of seconds in our timescale
    uint256 public immutable unitSeconds;
    // The Balancer pool data
    // Note we change style to match Balancer's custom getter
    IVault private immutable _vault;
    bytes32 private immutable _poolId;

    // The fees recorded during swaps
    uint128 public feesUnderlying;
    uint128 public feesBond;
    // Stored records of governance tokens
    address public governance;
    // The percent of each trade's implied yield to collect as LP fee
    uint256 public immutable percentFee;
    // The percent of LP fees that is payed to governance
    uint256 public immutable percentFeeGov;

    /// @dev We need need to set the immutables on contract creation
    ///      Note - We expect both 'bond' and 'underlying' to have 'decimals()'
    /// @param _underlying The asset which the second asset should appreciate to match
    /// @param _bond The asset which should be appreciating
    /// @param _expiration The time in unix seconds when the bond asset should equal the underlying asset
    /// @param _unitSeconds The number of seconds in a unit of time, for example 1 year in seconds
    /// @param vault The balancer vault
    /// @param _percentFee The percent each trade's yield to collect as fees
    /// @param _percentFeeGov The percent of collected that go to governance
    /// @param _governance The address which gets minted reward lp
    /// @param name The balancer pool token name
    /// @param symbol The balancer pool token symbol
    constructor(
        IERC20 _underlying,
        IERC20 _bond,
        uint256 _expiration,
        uint256 _unitSeconds,
        IVault vault,
        uint256 _percentFee,
        uint256 _percentFeeGov,
        address _governance,
        string memory name,
        string memory symbol
    ) BalancerPoolToken(name, symbol) {
        // Initialization on the vault
        bytes32 poolId = vault.registerPool(
            IVault.PoolSpecialization.TWO_TOKEN
        );

        // Pass in zero addresses for Asset Managers
        // Solidity really needs inline declaration of dynamic arrays
        // Note - functions below assume this token order
        IERC20[] memory tokens = new IERC20[](2);
        tokens[0] = _underlying;
        tokens[1] = _bond;
        vault.registerTokens(poolId, tokens, new address[](2));

        // Set immutable state variables
        _vault = vault;
        _poolId = poolId;
        percentFee = _percentFee;
        percentFeeGov = _percentFeeGov;
        underlying = _underlying;
        underlyingDecimals = IERC20Decimals(address(_underlying)).decimals();
        bond = _bond;
        bondDecimals = IERC20Decimals(address(_bond)).decimals();
        expiration = _expiration;
        unitSeconds = _unitSeconds;
        governance = _governance;
    }

    // Balancer Interface required Getters

    /// @dev Returns the vault for this pool
    /// @return The vault for this pool
    function getVault() external override view returns (IVault) {
        return _vault;
    }

    /// @dev Returns the poolId for this pool
    /// @return The poolId for this pool
    function getPoolId() external override view returns (bytes32) {
        return _poolId;
    }

    // Trade Functionality

    /// @dev Returns the amount of 'tokenOut' to give for an input of 'tokenIn'
    /// @param request Balancer encoded structure with request details
    /// @param currentBalanceTokenIn The reserve of the input token
    /// @param currentBalanceTokenOut The reserve of the output token
    /// @return The amount of output token to send for the input token
    function onSwapGivenIn(
        IPoolSwapStructs.SwapRequestGivenIn calldata request,
        uint256 currentBalanceTokenIn,
        uint256 currentBalanceTokenOut
    ) public override returns (uint256) {
        // Tokens amounts are passed to us in decimal form of the tokens
        uint256 amountTokenIn = request.amountIn;

        // We apply the trick which is used in the paper and
        // double count the reserves because the curve provisions liquidity
        // for prices above one underlying per bond, which we don't want to be accessible
        (uint256 tokenInReserve, uint256 tokenOutReserve) = _adjustedReserve(
            currentBalanceTokenIn,
            request.tokenIn,
            currentBalanceTokenOut,
            request.tokenOut
        );
        // Solve the invariant
        uint256 quote = solveTradeInvariant(
            amountTokenIn,
            tokenInReserve,
            tokenOutReserve,
            true
        );

        // Assign trade fees
        quote = _assignTradeFee(amountTokenIn, quote, request.tokenOut, false);
        return quote;
    }

    /// @dev Returns the amount of 'tokenIn' need to receive a specified amount
    ///      of 'tokenOut'
    /// @param request Balancer encoded structure with request details
    /// @param currentBalanceTokenIn The reserve of the input token
    /// @param currentBalanceTokenOut The reserve of the output token
    /// @return The amount of input token to receive the requested output
    function onSwapGivenOut(
        IPoolSwapStructs.SwapRequestGivenOut calldata request,
        uint256 currentBalanceTokenIn,
        uint256 currentBalanceTokenOut
    ) public override returns (uint256) {
        // Tokens amounts are passed to us in decimal form of the tokens
        // However we want them to be in 18 decimal fixed point form
        uint256 amountTokenOut = request.amountOut;
        // We apply the trick which is used in the paper and
        // double count the reserves because the curve provisions liquidity
        // for prices above one underlying per bond, which we don't want to be accessible
        (uint256 tokenInReserve, uint256 tokenOutReserve) = _adjustedReserve(
            currentBalanceTokenIn,
            request.tokenIn,
            currentBalanceTokenOut,
            request.tokenOut
        );
        // Solve the invariant
        uint256 quote = solveTradeInvariant(
            amountTokenOut,
            tokenOutReserve,
            tokenInReserve,
            false
        );
        // Assign trade fees
        quote = _assignTradeFee(quote, amountTokenOut, request.tokenOut, true);
        return quote;
    }

    // Liquidity provider functionality

    /// @dev Hook for joining the pool that must be called from the vault.
    ///      It mints a proportional number of new tokens compared to current LP pool
    // @param poolId Unused by this pool but in interface
    // @param sender Unused by this pool but in interface
    /// @param recipient The address which will receive lp tokens.
    /// @param currentBalances The current pool balances, will be length 2
    // @param latestBlockNumberUsed Last block number, but not used in this pool
    /// @param protocolSwapFee The percent of pool fees to be paid to the Balancer Protocol
    /// @param userData Abi encoded fixed length 2 uint array containing:
    ///                 [max amount of underlying in, max amount of bond in]
    /// @return amountsIn The actual amounts of token the vault should move to this pool
    /// @return dueProtocolFeeAmounts The amounts of each token to pay as protocol fees
    function onJoinPool(
        bytes32, // poolId
        address, // sender
        address recipient,
        uint256[] calldata currentBalances,
        uint256,
        uint256 protocolSwapFee,
        bytes calldata userData
    )
        external
        override
        returns (
            uint256[] memory amountsIn,
            uint256[] memory dueProtocolFeeAmounts
        )
    {
        // Default checks
        require(msg.sender == address(_vault), "Non Vault caller");
        uint256[2] memory maxAmountsIn = abi.decode(userData, (uint256[2]));
        require(
            currentBalances.length == 2 && maxAmountsIn.length == 2,
            "Invalid format"
        );
        // Mint LP to the governance address.
        // The {} zoning here helps solidity figure out the stack
        {
            (
                uint256 localFeeUnderlying,
                uint256 localFeeBond
            ) = _mintGovernanceLP(currentBalances);
            dueProtocolFeeAmounts = new uint256[](2);
            dueProtocolFeeAmounts[0] = localFeeUnderlying.mul(protocolSwapFee);
            dueProtocolFeeAmounts[1] = localFeeBond.mul(protocolSwapFee);
        }
        // Mint for the user
        {
            (uint256 callerUsedUnderlying, uint256 callerUsedBond) = _mintLP(
                maxAmountsIn[0],
                maxAmountsIn[1],
                currentBalances,
                recipient
            );
            // Assign to variable memory arrays in return
            amountsIn = new uint256[](2);
            amountsIn[0] = callerUsedUnderlying;
            amountsIn[1] = callerUsedBond;
        }
    }

    /// @dev Hook for leaving the pool that must be called from the vault.
    ///      It burns a proportional number of tokens compared to current LP pool,
    ///      based on the minium output the user wants.
    // @param poolId Unused by this pool but in interface
    // @param sender Unused by this pool but in interface
    /// @param recipient The address which will receive lp tokens.
    /// @param currentBalances The current pool balances, will be length 2
    // @param latestBlockNumberUsed last block number unused in this pool
    /// @param protocolSwapFee The percent of pool fees to be paid to the Balancer Protocol
    /// @param userData Abi encoded fixed length 2 array containing
    ///                 [min output of underlying, min output of bond]
    /// @return amountsOut The number of each token to send to the caller
    /// @return dueProtocolFeeAmounts The amounts of each token to pay as protocol fees
    function onExitPool(
        bytes32,
        address,
        address recipient,
        uint256[] calldata currentBalances,
        uint256,
        uint256 protocolSwapFee,
        bytes calldata userData
    )
        external
        override
        returns (
            uint256[] memory amountsOut,
            uint256[] memory dueProtocolFeeAmounts
        )
    {
        // Default checks
        require(msg.sender == address(_vault), "Non Vault caller");
        uint256[2] memory minAmountsOut = abi.decode(userData, (uint256[2]));
        require(
            currentBalances.length == 2 && minAmountsOut.length == 2,
            "Invalid format"
        );
        // Mint LP to the governance address.
        // {} zones to help solidity figure out the stack
        {
            (
                uint256 localFeeUnderlying,
                uint256 localFeeBond
            ) = _mintGovernanceLP(currentBalances);

            dueProtocolFeeAmounts = new uint256[](2);
            dueProtocolFeeAmounts[0] = localFeeUnderlying.mul(protocolSwapFee);
            dueProtocolFeeAmounts[1] = localFeeBond.mul(protocolSwapFee);
        }
        // Burn for the user
        {
            (uint256 releasedUnderlying, uint256 releasedBond) = _burnLP(
                minAmountsOut[0],
                minAmountsOut[1],
                currentBalances,
                recipient
            );
            // Assign to variable memory arrays in return
            amountsOut = new uint256[](2);
            amountsOut[0] = releasedUnderlying;
            amountsOut[1] = releasedBond;
        }
    }

    // Math libraries and internal routing

    /// @dev Calculates how many tokens should be outputted given an input plus reserve variables
    ///      Assumes all inputs are in 18 point fixed compatible with the balancer fixed math lib.
    ///      Since solving for an input is almost exactly the same as an output you can indicate
    ///      if this is an input or output calculation in the call.
    /// @param amountX The amount of token x sent in normalized to have 18 decimals
    /// @param reserveX The amount of the token x currently held by the pool normalized to 18 decimals
    /// @param reserveY The amount of the token y currently held by the pool normalized to 18 decimals
    /// @param out Is true if the pool will receive amountX and false if it is expected to produce it.
    /// @return Either if 'out' is true the amount of Y token to send to the user or
    ///         if 'out' is false the amount of Y Token to take from the user
    function solveTradeInvariant(
        uint256 amountX,
        uint256 reserveX,
        uint256 reserveY,
        bool out
    ) public view returns (uint256) {
        // Gets 1 - t
        uint256 a = _getYieldExponent();
        // calculate x before ^ a
        uint256 xBeforePowA = LogExpMath.pow(reserveX, a);
        // calculate y before ^ a
        uint256 yBeforePowA = LogExpMath.pow(reserveY, a);
        // calculate x after ^ a
        uint256 xAfterPowA = out
            ? LogExpMath.pow(reserveX + amountX, a)
            : LogExpMath.pow(reserveX.sub(amountX), a);
        // Calculate y_after = ( x_before ^a + y_ before ^a -  x_after^a)^(1/a)
        // Will revert with underflow here if the liquidity isn't enough for the trade
        uint256 yAfter = (xBeforePowA + yBeforePowA).sub(xAfterPowA);
        // Note that this call is to FixedPoint Div so works as intended
        yAfter = LogExpMath.pow(yAfter, uint256(FixedPoint.ONE).div(a));
        // The amount of Y token to send is (reserveY_before - reserveY_after)
        return out ? reserveY.sub(yAfter) : yAfter.sub(reserveY);
    }

    /// @dev Adds a fee equal to to 'feePercent' of remaining interest to each trade
    ///      This function accepts both input and output trades, amd expects that all
    ///      inputs are in fixed 18 point
    /// @param amountIn The trade's amountIn in fixed 18 point
    /// @param amountOut The trade's amountOut in fixed 18 point
    /// @param outputToken The output token
    /// @param isInputTrade True if the trader is requesting a quote for the amount of input
    ///                     they need to provide to get 'amountOut' false otherwise
    /// @return The updated output quote
    //  Note - The safe math in this function implicitly prevents the price of 'bond' in underlying
    //         from being higher than 1.
    function _assignTradeFee(
        uint256 amountIn,
        uint256 amountOut,
        IERC20 outputToken,
        bool isInputTrade
    ) internal returns (uint256) {
        // The math splits on if this is input or output
        if (isInputTrade) {
            // Then it splits again on which token is the bond
            if (outputToken == bond) {
                // If the output is bond the implied yield is out - in
                uint256 impliedYieldFee = percentFee.mul(
                    amountOut.sub(amountIn)
                );
                // we record that fee collected from the underlying
                feesUnderlying += uint128(impliedYieldFee);
                // and return the adjusted input quote
                return amountIn.add(impliedYieldFee);
            } else {
                // If the input token is bond the implied yield is in - out
                uint256 impliedYieldFee = percentFee.mul(
                    amountIn.sub(amountOut)
                );
                // we record that collected fee from the input bond
                feesBond += uint128(impliedYieldFee);
                // and return the updated input quote
                return amountIn.add(impliedYieldFee);
            }
        } else {
            if (outputToken == bond) {
                // If the output is bond the implied yield is out - in
                uint256 impliedYieldFee = percentFee.mul(
                    amountOut.sub(amountIn)
                );
                // we record that fee collected from the bond output
                feesBond += uint128(impliedYieldFee);
                // and then return the updated output
                return amountOut.sub(impliedYieldFee);
            } else {
                // If the output is underlying the implied yield is in - out
                uint256 impliedYieldFee = percentFee.mul(
                    amountIn.sub(amountOut)
                );
                // we record the collected underlying fee
                feesUnderlying += uint128(impliedYieldFee);
                // and then return the updated output quote
                return amountOut.sub(impliedYieldFee);
            }
        }
        revert("Called with non pool token");
    }

    /// @dev Mints the maximum possible LP given a set of max inputs
    /// @param inputUnderlying The max underlying to deposit
    /// @param inputBond The max bond to deposit
    /// @param currentBalances The current balances encoded in a memory array
    /// @param recipient The person who receives the lp funds
    /// @return The actual amounts of token deposited layed out as (underlying, bond)
    function _mintLP(
        uint256 inputUnderlying,
        uint256 inputBond,
        uint256[] memory currentBalances,
        address recipient
    ) internal returns (uint256, uint256) {
        // Passing in in memory array helps stack but we use locals for better names
        uint256 reserveUnderlying = currentBalances[0];
        uint256 reserveBond = currentBalances[1];
        uint256 localTotalSupply = totalSupply();
        // Check if the pool is initialized
        if (localTotalSupply == 0) {
            // When uninitialized we mint exactly the underlying input
            // in LP tokens
            _mintPoolTokens(recipient, inputUnderlying);
            return (inputUnderlying, 0);
        }

        // Get the reserve ratio, the say how many underlying per bond in the reserve
        // (input underlying / reserve underlying) is the percent increase caused by deposit
        uint256 underlyingPerBond = reserveUnderlying.div(reserveBond);
        // Use the underlying per bond to get the needed number of input underlying
        uint256 neededUnderlying = underlyingPerBond.mul(inputBond);

        // If the user can't provide enough underlying
        if (neededUnderlying > inputUnderlying) {
            // The increase in total supply is the input underlying
            // as a ratio to reserve
            uint256 mintAmount = (inputUnderlying.mul(localTotalSupply)).div(
                reserveUnderlying
            );
            // We mint a new amount of as the the percent increase given
            // by the ratio of the input underlying to the reserve underlying
            _mintPoolTokens(recipient, mintAmount);
            // In this case we use the whole input of underlying
            // and consume (inputUnderlying/underlyingPerBond) bonds
            return (inputUnderlying, inputUnderlying.div(underlyingPerBond));
        } else {
            // We calculate the percent increase in the reserves from contributing
            // all of the bond
            uint256 mintAmount = (neededUnderlying.mul(localTotalSupply)).div(
                reserveUnderlying
            );
            // We then mint an amount of pool token which corresponds to that increase
            _mintPoolTokens(recipient, mintAmount);
            // The indicate we consumed the input bond and (inputBond*underlyingPerBond)
            return (neededUnderlying, inputBond);
        }
    }

    /// @dev Burns at least enough LP tokens from the sender to produce
    ///      as set of minium outputs.
    /// @param minOutputUnderlying The minimum output in underlying
    /// @param minOutputBond The minimum output in the bond
    /// @param currentBalances The current balances encoded in a memory array
    /// @param source The address to burn from.
    /// @return Tuple (output in underlying, output in bond)
    function _burnLP(
        uint256 minOutputUnderlying,
        uint256 minOutputBond,
        uint256[] memory currentBalances,
        address source
    ) internal returns (uint256, uint256) {
        // Passing in in memory array helps stack but we use locals for better names
        uint256 reserveUnderlying = currentBalances[0];
        uint256 reserveBond = currentBalances[1];
        uint256 localTotalSupply = totalSupply();
        // Calculate the ratio of the minOutputUnderlying to reserve
        uint256 underlyingPerBond = reserveUnderlying.div(reserveBond);
        // If the ratio won't produce enough bond
        if (minOutputUnderlying > minOutputBond.mul(underlyingPerBond)) {
            // In this case we burn enough tokens to output 'minOutputUnderlying'
            // which will be the total supply times the percent of the underlying
            // reserve which this amount of underlying is.
            uint256 burned = (minOutputUnderlying.mul(localTotalSupply)).div(
                reserveUnderlying
            );
            _burnPoolTokens(source, burned);
            // We return that we released 'minOutputUnderlying' and the number of bonds that
            // preserves the reserve ratio
            return (
                minOutputUnderlying,
                minOutputUnderlying.div(underlyingPerBond)
            );
        } else {
            // Then the amount burned is the ratio of the minOutputBond
            // to the reserve of bond times the total supply
            uint256 burned = (minOutputBond.mul(localTotalSupply)).div(
                reserveBond
            );
            _burnPoolTokens(source, burned);
            // We return that we released all of the minOutputBond
            // and the number of underlying which preserves the reserve ratio
            return (minOutputBond.mul(underlyingPerBond), minOutputBond);
        }
    }

    /// @dev Mints LP tokens from a percentage of the stored fees and then updates them
    /// @param currentBalances The reserve balances as [underlyingBalance, bondBalance]
    /// @return Returns the fee amounts as (feeUnderlying, feeBond) to avoid other sloads
    function _mintGovernanceLP(uint256[] memory currentBalances)
        internal
        returns (uint256, uint256)
    {
        // Load and cast the stored fees
        // Note - Because of sizes should only be one sload
        uint256 localFeeUnderlying = uint256(feesUnderlying);
        uint256 localFeeBond = uint256(feesBond);
        (uint256 feesUsedUnderlying, uint256 feesUsedBond) = _mintLP(
            localFeeUnderlying.mul(percentFeeGov),
            localFeeBond.mul(percentFeeGov),
            currentBalances,
            governance
        );
        // Safe math sanity checks
        require(
            localFeeUnderlying >= (feesUsedUnderlying).div(percentFeeGov),
            "Underflow"
        );
        require(localFeeBond >= (feesUsedBond).div(percentFeeGov), "Underflow");
        // Store the remaining fees should only be one sstore
        (feesUnderlying, feesBond) = (
            uint128(
                localFeeUnderlying - (feesUsedUnderlying).div(percentFeeGov)
            ),
            uint128(localFeeBond - (feesUsedBond).div(percentFeeGov))
        );
        // We return the sload-ed values so that they do not need to be loaded again.
        return (localFeeUnderlying, localFeeBond);
    }

    /// @dev Calculates 1 - t
    /// @return Returns 1 - t, encoded as a fraction in 18 decimal fixed point
    function _getYieldExponent() internal virtual view returns (uint256) {
        // The fractional time
        uint256 timeTillExpiry = block.timestamp < expiration
            ? expiration - block.timestamp
            : 0;
        timeTillExpiry *= 1e18;
        // timeTillExpiry now contains the a fixed point of the years remaining
        timeTillExpiry = timeTillExpiry.div(unitSeconds * 1e18);
        uint256 result = uint256(FixedPoint.ONE).sub(timeTillExpiry);
        return result;
    }

    /// @dev Applies the reserve adjustment from the paper and returns the reserves
    /// @param reserveTokenIn The reserve of the input token
    /// @param tokenIn The address of the input token
    /// @param reserveTokenOut The reserve of the output token
    /// @return Returns (adjustedReserveIn, adjustedReserveOut)
    function _adjustedReserve(
        uint256 reserveTokenIn,
        IERC20 tokenIn,
        uint256 reserveTokenOut,
        IERC20 tokenOut
    ) internal view returns (uint256, uint256) {
        // We need to identify the bond asset and the underlying
        // This check is slightly redundant in most cases but more secure
        if (tokenIn == underlying && tokenOut == bond) {
            // We return (underlyingReserve, bondReserve + totalLP)
            return (reserveTokenIn, reserveTokenOut + totalSupply());
        } else if (tokenIn == bond && tokenOut == underlying) {
            // We return (bondReserve + totalLP, underlyingReserve)
            return (reserveTokenIn + totalSupply(), reserveTokenOut);
        }
        // This should never be hit
        revert("Token request doesn't match stored");
    }
}
