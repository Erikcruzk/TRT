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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/balances/BalanceAllocation.sol

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

// This library is used to create a data structure that represents a token's balance for a Pool. 'cash' is how many
// tokens the Pool has sitting inside of the Vault. 'managed' is how many tokens were withdrawn from the Vault by the
// Pool's Asset Manager. 'total' is the sum of these two, and represents the Pool's total token balance, including
// tokens that are *not* inside of the Vault.
//
// 'cash' is updated whenever tokens enter and exit the Vault, while 'managed' is only updated if the reason tokens are
// moving is due to an Asset Manager action. This is reflected in the different methods available: 'increaseCash'
// and 'decreaseCash' for swaps and add/remove liquidity events, and 'cashToManaged' and 'managedToCash' for
// events transferring funds to and from the asset manager.
//
// The Vault disallows the Pool's 'cash' ever becoming negative, in other words, it can never use any tokens that
// are not inside of the Vault.
//
// One of the goals of this library is to store the entire token balance in a single storage slot, which is we we use
// 112 bit unsigned integers for 'cash' and 'managed'. Since 'total' is also a 112 bit unsigned value, any combination
// of 'cash' and 'managed' that yields a 'total' that doesn't fit in that range is disallowed.
//
// The remaining 32 bits of each storage slot are used to store the most recent block number where a balance was
// updated. This can be used to implement price oracles that are resilient to 'sandwich' attacks.
//
// We could use a Solidity struct to pack these two values together in a single storage slot, but unfortunately Solidity
// only allows for structs to live in either storage, calldata or memory. Because a memory struct still takes up a
// slot in the stack (to store its memory location), and because the entire balance fits in a single stack slot (two
// 112 bit values), using memory is strictly less gas performant. Therefore, we do manual packing and unpacking. The
// type we use to represent these values is bytes32, as it doesn't have any arithmetic operations and therefore reduces
// the chance of misuse.
library BalanceAllocation {
    using Math for uint256;

    // The 'cash' portion of the balance is stored in the least significant 112 bits of a 256 bit word, while the
    // 'managed' part uses the most significant 112 bits.

    /**
     * @dev Returns the total amount of Pool tokens, including those that are not currently in the Vault ('managed').
     */
    function total(bytes32 balance) internal pure returns (uint256) {
        return cash(balance).add(managed(balance));
    }

    /**
     * @dev Returns the amount of Pool tokens currently in the Vault.
     */
    function cash(bytes32 balance) internal pure returns (uint256) {
        uint256 mask = 2**(112) - 1;
        return uint256(balance) & mask;
    }

    /**
     * @dev Returns the amount of Pool tokens that have been withdrawn (or reported) by its Asset Manager.
     */
    function managed(bytes32 balance) internal pure returns (uint256) {
        uint256 mask = 2**(112) - 1;
        return uint256(balance >> 112) & mask;
    }

    /**
     * @dev Returns the last block number when a balance was updated.
     */
    function blockNumber(bytes32 balance) internal pure returns (uint256) {
        uint256 mask = 2**(32) - 1;
        return uint256(balance >> 224) & mask;
    }

    /**
     * @dev Returns the total balance for each entry in `balances`.
     */
    function totals(bytes32[] memory balances) internal pure returns (uint256[] memory results) {
        results = new uint256[](balances.length);
        for (uint256 i = 0; i < results.length; i++) {
            results[i] = total(balances[i]);
        }
    }

    /**
     * @dev Returns the total balance for each entry in `balances`, as well as the latest block number when any of them
     * was last updated.
     */
    function totalsAndMaxBlockNumber(bytes32[] memory balances)
        internal
        pure
        returns (uint256[] memory results, uint256 maxBlockNumber)
    {
        maxBlockNumber = 0;
        results = new uint256[](balances.length);

        for (uint256 i = 0; i < results.length; i++) {
            bytes32 balance = balances[i];
            results[i] = total(balance);
            maxBlockNumber = Math.max(maxBlockNumber, blockNumber(balance));
        }
    }

    /**
     * @dev Returns true if `balance`'s total balance is zero. Costs less gas than computing the total.
     */
    function isZero(bytes32 balance) internal pure returns (bool) {
        // We simply need to check the least significant 224 bytes of the word, the block number does not affect this.
        uint256 mask = 2**(224) - 1;
        return (uint256(balance) & mask) == 0;
    }

    /**
     * @dev Returns true if `balance`'s total balance is not zero. Costs less gas than computing the total.
     */
    function isNotZero(bytes32 balance) internal pure returns (bool) {
        return !isZero(balance);
    }

    /**
     * @dev Packs together cash and managed amounts with a block number to create a balance value.
     *
     * Critically, this also checks the sum of cash and external doesn't overflow, that is, that `total()` can be
     * computed.
     */
    function toBalance(
        uint256 _cash,
        uint256 _managed,
        uint256 _blockNumber
    ) internal pure returns (bytes32) {
        uint256 balance = _cash + _managed;
        require(balance >= _cash && balance < 2**112, "BALANCE_TOTAL_OVERFLOW");
        // We assume the block number will fits in an uint32 - this is expected to hold for at least a few decades.
        return _pack(_cash, _managed, _blockNumber);
    }

    /**
     * @dev Increases a Pool's 'cash' (and therefore its 'total'). Called when Pool tokens are sent to the Vault (except
     * when an Asset Manager action decreases the managed balance).
     */
    function increaseCash(bytes32 balance, uint256 amount) internal view returns (bytes32) {
        uint256 newCash = cash(balance).add(amount);
        uint256 currentManaged = managed(balance);
        uint256 newBlockNumber = block.number;

        return toBalance(newCash, currentManaged, newBlockNumber);
    }

    /**
     * @dev Decreases a Pool's 'cash' (and therefore its 'total'). Called when Pool tokens are sent from the Vault
     * (except as an Asset Manager action that increases the managed balance).
     */
    function decreaseCash(bytes32 balance, uint256 amount) internal view returns (bytes32) {
        uint256 newCash = cash(balance).sub(amount);
        uint256 currentManaged = managed(balance);
        uint256 newBlockNumber = block.number;

        return toBalance(newCash, currentManaged, newBlockNumber);
    }

    /**
     * @dev Moves 'cash' into 'managed', leaving 'total' unchanged. Called when Pool tokens are sent from the Vault
     * when an Asset Manager action increases the managed balance.
     */
    function cashToManaged(bytes32 balance, uint256 amount) internal pure returns (bytes32) {
        uint256 newCash = cash(balance).sub(amount);
        uint256 newManaged = managed(balance).add(amount);
        uint256 currentBlockNumber = blockNumber(balance);

        return toBalance(newCash, newManaged, currentBlockNumber);
    }

    /**
     * @dev Moves 'managed' into 'cash', leaving 'total' unchanged. Called when Pool tokens are sent to the Vault when
     * an Asset Manager action decreases the managed balance.
     */
    function managedToCash(bytes32 balance, uint256 amount) internal pure returns (bytes32) {
        uint256 newCash = cash(balance).add(amount);
        uint256 newManaged = managed(balance).sub(amount);
        uint256 currentBlockNumber = blockNumber(balance);

        return toBalance(newCash, newManaged, currentBlockNumber);
    }

    /**
     * @dev Sets 'managed' balance to an arbitrary value, changing 'total'. Called when the Asset Manager reports
     * profits or losses. It's the Manager's responsibility to provide a meaningful value.
     */
    function setManaged(bytes32 balance, uint256 newManaged) internal view returns (bytes32) {
        uint256 currentCash = cash(balance);
        uint256 newBlockNumber = block.number;
        return toBalance(currentCash, newManaged, newBlockNumber);
    }

    // Alternative mode for Pools with the token token specialization setting

    // Instead of storing cash and external for each token in a single storage slot, two token pools store the cash for
    // both tokens in the same slot, and the external for both in another one. This reduces the gas cost for swaps,
    // because the only slot that needs to be updated is the one with the cash. However, it also means that managing
    // balances is more cumbersome, as both tokens need to be read/written at the same time.
    // The field with both cash balances packed is called sharedCash, and the one with external amounts is called
    // sharedManaged. These two are collectively called the 'shared' balance fields. In both of these, the portion
    // that corresponds to token A is stored in the least significant 112 bits of a 256 bit word, while token B's part
    // uses the most significant 112 bits.
    // Becase only cash is written to during a swap, we store the block number there. Typically Pools have a distinct
    // block number per token: in the case of two token Pools this is not necessary, as both values will be the same.

    /**
     * @dev Unpacks the shared token A and token B cash and managed balances into the balance for token A.
     */
    function fromSharedToBalanceA(bytes32 sharedCash, bytes32 sharedManaged) internal pure returns (bytes32) {
        return toBalance(_decodeBalanceA(sharedCash), _decodeBalanceA(sharedManaged), blockNumber(sharedCash));
    }

    /**
     * @dev Unpacks the shared token A and token B cash and managed balances into the balance for token B.
     */
    function fromSharedToBalanceB(bytes32 sharedCash, bytes32 sharedManaged) internal pure returns (bytes32) {
        return toBalance(_decodeBalanceB(sharedCash), _decodeBalanceB(sharedManaged), blockNumber(sharedCash));
    }

    /**
     * @dev Returns the sharedCash shared field, given the current balances for tokenA and tokenB.
     */
    function toSharedCash(bytes32 tokenABalance, bytes32 tokenBBalance) internal pure returns (bytes32) {
        // Both balances have the block number, since both balances are always updated at the same time it does not
        // mater where we pick it from.
        return _pack(cash(tokenABalance), cash(tokenBBalance), blockNumber(tokenABalance));
    }

    /**
     * @dev Returns the sharedManaged shared field, given the current balances for tokenA and tokenB.
     */
    function toSharedManaged(bytes32 tokenABalance, bytes32 tokenBBalance) internal pure returns (bytes32) {
        return _pack(managed(tokenABalance), managed(tokenBBalance), 0);
    }

    /**
     * @dev Unpacks the balance corresponding to token A for a shared balance
     * Note that this function can be used to decode both cash and managed balances.
     */
    function _decodeBalanceA(bytes32 sharedBalance) private pure returns (uint256) {
        uint256 mask = 2**(112) - 1;
        return uint256(sharedBalance) & mask;
    }

    /**
     * @dev Unpacks the balance corresponding to token B for a shared balance
     * Note that this function can be used to decode both cash and managed balances.
     */
    function _decodeBalanceB(bytes32 sharedBalance) private pure returns (uint256) {
        uint256 mask = 2**(112) - 1;
        return uint256(sharedBalance >> 112) & mask;
    }

    // Shared functions

    /**
     * @dev Packs together two uint112 and one uint32 into a bytes32
     */
    function _pack(
        uint256 _leastSignificant,
        uint256 _midSignificant,
        uint256 _mostSignificant
    ) private pure returns (bytes32) {
        return bytes32((_mostSignificant << 224) + (_midSignificant << 112) + _leastSignificant);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-637c6f959315cbb11a164555e588520c7d89122b/contracts/balancer-core-v2/vault/balances/TwoTokenPoolsBalance.sol

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

contract TwoTokenPoolsBalance {
    using BalanceAllocation for bytes32;

    // Data for Pools with Two Tokens
    //
    // These are similar to the Minimal Swap Info Pool case (because the Pool only has two tokens, and therefore there
    // are only two balances to read), but there's a key difference in how data is stored. Keeping a set makes little
    // sense, as it will only ever hold two tokens, so we can just store those two directly.
    // The gas savings associated with using these Pools come from how token balances are stored: cash for token A and
    // token B is packed together, as are external amounts. Because only cash changes in a swap, there's no need to
    // write to this second storage slot.
    // This however makes Vault code that interacts with these Pools cumbersome: both balances must be accessed at the
    // same time by using both token addresses, and some logic is needed to differentiate token A from token B. In this
    // case, token A is always the token with the lowest numerical address value. The token X and token Y names are used
    // in functions when it is unknown which one is A and which one is B.

    struct TwoTokenPoolBalances {
        bytes32 sharedCash;
        bytes32 sharedManaged;
    }

    struct TwoTokenPoolTokens {
        IERC20 tokenA;
        IERC20 tokenB;
        mapping(bytes32 => TwoTokenPoolBalances) balances;
    }

    // We could just keep a mapping from Pool ID to TwoTokenSharedBalances, but there's an issue: we wouldn't know to
    // which tokens those balances correspond. This would mean having to also check the tokens struct in a swap, to make
    // sure the tokens being swapped are the ones in the Pool.
    // What we do instead to save those storage reads is keep a nested mapping from token pair hash to the balances
    // struct. The Pool only has two tokens, so only a single entry of this mapping is set (the one that corresponds to
    // that pair's hash). This means queries for token pairs where any of the tokens is not in the Pool will generate a
    // hash for a mapping entry that was not set, containing zero balances. Non-zero balances are only possible if both
    // tokens in the pair are the Pool's tokens, which means we don't have to check the TwoTokensTokens struct and save
    // storage reads.
    mapping(bytes32 => TwoTokenPoolTokens) private _twoTokenPoolTokens;

    /**
     * @dev Registers the tokens of a Two Token Pool.
     *
     * Requirements:
     *
     * - `tokenX` and `tokenY` cannot be the same.
     * - Both tokens must not be the zero address.
     * - Both tokens must not be registered in the Pool.
     */
    function _registerTwoTokenPoolTokens(
        bytes32 poolId,
        IERC20 tokenX,
        IERC20 tokenY
    ) internal {
        require(tokenX != IERC20(0) && tokenY != IERC20(0), "ZERO_ADDRESS_TOKEN");

        // Not technically true since we didn't register yet, but this is consistent with the error messages of other
        // specialization settings.
        require(tokenX != tokenY, "TOKEN_ALREADY_REGISTERED");

        TwoTokenPoolTokens storage poolTokens = _twoTokenPoolTokens[poolId];
        require(poolTokens.tokenA == IERC20(0) && poolTokens.tokenB == IERC20(0), "TOKENS_ALREADY_SET");

        (IERC20 tokenA, IERC20 tokenB) = _sortTwoTokens(tokenX, tokenY);
        poolTokens.tokenA = tokenA;
        poolTokens.tokenB = tokenB;
    }

    /**
     * @dev Deregisters the tokens of a Two Token Pool.
     *
     * Requirements:
     *
     * - `tokenX` and `tokenY` must be the Pool's tokens.
     * - Both tokens must have non balance in the Vault.
     */
    function _deregisterTwoTokenPoolTokens(
        bytes32 poolId,
        IERC20 tokenX,
        IERC20 tokenY
    ) internal {
        (bytes32 balanceA, bytes32 balanceB, ) = _getTwoTokenPoolSharedBalances(poolId, tokenX, tokenY);
        require(balanceA.isZero() && balanceB.isZero(), "NONZERO_TOKEN_BALANCE");

        delete _twoTokenPoolTokens[poolId];
        // No need to delete the balance entries, since they already are zero
    }

    /**
     * @dev This setter is only used when adding/removing liquidity, where tokens are guaranteed to be ordered and
     * registered. These methods actually fetch the tokens from `_getTwoTokenPoolTokens` first.
     */
    function _setTwoTokenPoolCashBalances(
        bytes32 poolId,
        IERC20 tokenA,
        bytes32 balanceA,
        IERC20 tokenB,
        bytes32 balanceB
    ) internal {
        bytes32 hash = _getTwoTokenPairHash(tokenA, tokenB);
        TwoTokenPoolBalances storage poolBalances = _twoTokenPoolTokens[poolId].balances[hash];
        poolBalances.sharedCash = BalanceAllocation.toSharedCash(balanceA, balanceB);
    }

    function _twoTokenPoolCashToManaged(
        bytes32 poolId,
        IERC20 token,
        uint256 amount
    ) internal {
        _updateTwoTokenPoolSharedBalance(poolId, token, BalanceAllocation.cashToManaged, amount);
    }

    function _twoTokenPoolManagedToCash(
        bytes32 poolId,
        IERC20 token,
        uint256 amount
    ) internal {
        _updateTwoTokenPoolSharedBalance(poolId, token, BalanceAllocation.managedToCash, amount);
    }

    function _setTwoTokenPoolManagedBalance(
        bytes32 poolId,
        IERC20 token,
        uint256 amount
    ) internal {
        _updateTwoTokenPoolSharedBalance(poolId, token, BalanceAllocation.setManaged, amount);
    }

    function _updateTwoTokenPoolSharedBalance(
        bytes32 poolId,
        IERC20 token,
        function(bytes32, uint256) returns (bytes32) mutation,
        uint256 amount
    ) private {
        (
            TwoTokenPoolBalances storage balances,
            IERC20 tokenA,
            bytes32 balanceA,
            IERC20 tokenB,
            bytes32 balanceB
        ) = _getTwoTokenPoolBalances(poolId);

        if (token == tokenA) {
            balanceA = mutation(balanceA, amount);
        } else if (token == tokenB) {
            balanceB = mutation(balanceB, amount);
        } else {
            revert("TOKEN_NOT_REGISTERED");
        }

        balances.sharedCash = BalanceAllocation.toSharedCash(balanceA, balanceB);
        balances.sharedManaged = BalanceAllocation.toSharedManaged(balanceA, balanceB);
    }

    /**
     * @dev Returns the balance for a token pair in a Two Token Pool, reverting if either of the tokens is
     * not registered by the Pool.
     *
     * The returned balances are those of token A and token B, where token A is the lowest of token X and token Y, and
     * token B the other.
     *
     * This function also returns a storage pointer to the TwoTokenSharedBalances entry associated with the token pair,
     * which can be used to update this entry without having to recompute the pair hash and storage slot.
     */
    function _getTwoTokenPoolSharedBalances(
        bytes32 poolId,
        IERC20 tokenX,
        IERC20 tokenY
    )
        internal
        view
        returns (
            bytes32 balanceA,
            bytes32 balanceB,
            TwoTokenPoolBalances storage poolBalances
        )
    {
        (IERC20 tokenA, IERC20 tokenB) = _sortTwoTokens(tokenX, tokenY);
        bytes32 pairHash = _getTwoTokenPairHash(tokenA, tokenB);
        poolBalances = _twoTokenPoolTokens[poolId].balances[pairHash];

        bytes32 sharedCash = poolBalances.sharedCash;
        bytes32 sharedManaged = poolBalances.sharedManaged;

        // Only registered tokens can have non-zero balances, so we can use this as a shortcut to avoid the
        // expensive _hasPoolTwoTokens check.
        bool exists = sharedCash.isNotZero() || sharedManaged.isNotZero() || _hasPoolTwoTokens(poolId, tokenA, tokenB);
        require(exists, "TOKEN_NOT_REGISTERED");

        balanceA = BalanceAllocation.fromSharedToBalanceA(sharedCash, sharedManaged);
        balanceB = BalanceAllocation.fromSharedToBalanceB(sharedCash, sharedManaged);
    }

    /**
     * @dev Returns an array with all the tokens and balances in a Two Token Pool.
     * This array will have either two or zero entries (if the Pool doesn't have any tokens).
     */
    function _getTwoTokenPoolTokens(bytes32 poolId)
        internal
        view
        returns (IERC20[] memory tokens, bytes32[] memory balances)
    {
        (, IERC20 tokenA, bytes32 balanceA, IERC20 tokenB, bytes32 balanceB) = _getTwoTokenPoolBalances(poolId);

        // Both tokens will either be zero or non-zero, but we keep the full check for clarity
        if (tokenA == IERC20(0) || tokenB == IERC20(0)) {
            return (new IERC20[](0), new bytes32[](0));
        }

        // Note that functions relying on this getter expect tokens to be properly ordered, so it's extremely important
        // to always return (A,B)

        tokens = new IERC20[](2);
        tokens[0] = tokenA;
        tokens[1] = tokenB;

        balances = new bytes32[](2);
        balances[0] = balanceA;
        balances[1] = balanceB;
    }

    /**
     * @dev Returns the balance for a token in a Two Token Pool.
     *
     * This function is convenient but not particularly gas efficient, and should be avoided during gas-sensitive
     * operations, such as swaps. For those, _getTwoTokenPoolSharedBalances provides a more flexible interface.
     *
     * Requirements:
     *
     * - `token` must be in the Pool.
     */
    function _getTwoTokenPoolBalance(bytes32 poolId, IERC20 token) internal view returns (bytes32 balance) {
        // We can't just read the balance of token, because we need to know the full pair in order to compute the pair
        // hash and access the balance mapping. We therefore also read the TwoTokenPoolTokens struct.
        (, IERC20 tokenA, bytes32 balanceA, IERC20 tokenB, bytes32 balanceB) = _getTwoTokenPoolBalances(poolId);

        if (token == tokenA) {
            return balanceA;
        } else if (token == tokenB) {
            return balanceB;
        } else {
            revert("TOKEN_NOT_REGISTERED");
        }
    }

    function _hasPoolTwoTokens(
        bytes32 poolId,
        IERC20 tokenA,
        IERC20 tokenB
    ) internal view returns (bool) {
        TwoTokenPoolTokens storage poolTokens = _twoTokenPoolTokens[poolId];
        return poolTokens.tokenA == tokenA && tokenB == poolTokens.tokenB;
    }

    function _isTwoTokenPoolTokenRegistered(bytes32 poolId, IERC20 token) internal view returns (bool) {
        TwoTokenPoolTokens storage poolTokens = _twoTokenPoolTokens[poolId];
        return (token == poolTokens.tokenA || token == poolTokens.tokenB) && token != IERC20(0);
    }

    function _getTwoTokenPoolBalances(bytes32 poolId)
        private
        view
        returns (
            TwoTokenPoolBalances storage poolBalances,
            IERC20 tokenA,
            bytes32 balanceA,
            IERC20 tokenB,
            bytes32 balanceB
        )
    {
        TwoTokenPoolTokens storage poolTokens = _twoTokenPoolTokens[poolId];
        tokenA = poolTokens.tokenA;
        tokenB = poolTokens.tokenB;

        bytes32 pairHash = _getTwoTokenPairHash(tokenA, tokenB);
        poolBalances = poolTokens.balances[pairHash];

        bytes32 sharedCash = poolBalances.sharedCash;
        bytes32 sharedManaged = poolBalances.sharedManaged;

        balanceA = BalanceAllocation.fromSharedToBalanceA(sharedCash, sharedManaged);
        balanceB = BalanceAllocation.fromSharedToBalanceB(sharedCash, sharedManaged);
    }

    /**
     * @dev Returns a hash associated with a given token pair.
     */
    function _getTwoTokenPairHash(IERC20 tokenA, IERC20 tokenB) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(tokenA, tokenB));
    }

    /**
     * @dev Sorts two tokens ascendingly, returning them as a (tokenA, tokenB) tuple.
     */
    function _sortTwoTokens(IERC20 tokenX, IERC20 tokenY) private pure returns (IERC20, IERC20) {
        return tokenX < tokenY ? (tokenX, tokenY) : (tokenY, tokenX);
    }
}
