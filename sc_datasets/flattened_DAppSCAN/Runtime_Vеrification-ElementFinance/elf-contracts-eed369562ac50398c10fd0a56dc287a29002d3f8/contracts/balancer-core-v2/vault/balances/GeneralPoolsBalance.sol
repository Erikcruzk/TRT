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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/vault/balances/BalanceAllocation.sol

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
    // 'managed' part uses the following 112 bits. The remaining 32 bits are used to store the block number.

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
    // Because only cash is written to during a swap, we store the block number there. Typically Pools have a distinct
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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/lib/helpers/EnumerableMap.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

// Based on the EnumerableSet library from OpenZeppelin contracts, altered to include
// the following:
//  * a map from IERC20 to bytes32
//  * entries are stored in mappings instead of arrays, reducing implicit storage reads for out-of-bounds checks
//  * _unchecked_at and _unchecked_valueAt, which allow for more gas efficient data reads in some scenarios
//  * _indexOf and _unchecked_setAt, which allow for more gas efficient data writes in some scenarios

// We're using non-standard casing for the unchecked functions to differentiate them, so we need to turn off that rule
// solhint-disable func-name-mixedcase

/**
 * @dev Library for managing an enumerable variant of Solidity's
 * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
 * type.
 *
 * Maps have the following properties:
 *
 * - Entries are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Entries are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableMap for EnumerableMap.UintToAddressMap;
 *
 *     // Declare a set state variable
 *     EnumerableMap.UintToAddressMap private myMap;
 * }
 * ```
 */
library EnumerableMap {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Map type with
    // bytes32 keys and values.
    // The Map implementation uses private functions, and user-facing
    // implementations (such as Uint256ToAddressMap) are just wrappers around
    // the underlying Map.
    // This means that we can only create new EnumerableMaps for types that fit
    // in bytes32.

    struct MapEntry {
        bytes32 _key;
        bytes32 _value;
    }

    struct Map {
        // Number of entries in the map
        uint256 _length;
        // Storage of map keys and values
        mapping(uint256 => MapEntry) _entries;
        // Position of the entry defined by a key in the `entries` array, plus 1
        // because index 0 means a key is not in the map.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function _set(
        Map storage map,
        bytes32 key,
        bytes32 value
    ) private returns (bool) {
        // We read and store the key's index to prevent multiple reads from the same storage slot
        uint256 keyIndex = map._indexes[key];

        // Equivalent to !contains(map, key)
        if (keyIndex == 0) {
            uint256 previousLength = map._length;
            map._entries[previousLength] = MapEntry({ _key: key, _value: value });
            map._length = previousLength + 1;

            // The entry is stored at previousLength, but we add 1 to all indexes
            // and use 0 as a sentinel value
            map._indexes[key] = previousLength + 1;
            return true;
        } else {
            map._entries[keyIndex - 1]._value = value;
            return false;
        }
    }

    /**
     * @dev Returns the index for `key`, which can be used alongside the {at} family of functions, including critically
     * {unchecked_setAt}. O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function _indexOf(Map storage map, bytes32 key) private view returns (uint256) {
        return _indexOf(map, key, "OUT_OF_BOUNDS");
    }

    /**
     * @dev Same as {_indexOf}, with a custom error message when `key` is not in the map.
     */
    function _indexOf(
        Map storage map,
        bytes32 key,
        string memory notFoundErrorMessage
    ) private view returns (uint256) {
        uint256 index = map._indexes[key];
        require(index > 0, notFoundErrorMessage);
        return index - 1;
    }

    /**
     * @dev Updates the value for an entry, given its key's index. The key index can be retrieved via {indexOf}, and it
     * should be noted that key indices may change when calling {add} or {remove}. O(1).
     *
     * This function performs one less storage read than {set}, but it should only be used when `index` is known to be
     * within bounds.
     */
    function _unchecked_setAt(
        Map storage map,
        uint256 index,
        bytes32 value
    ) private {
        map._entries[index]._value = value;
    }

    /**
     * @dev Removes a key-value pair from a map. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function _remove(Map storage map, bytes32 key) private returns (bool) {
        // We read and store the key's index to prevent multiple reads from the same storage slot
        uint256 keyIndex = map._indexes[key];

        // Equivalent to contains(map, key)
        if (keyIndex != 0) {
            // To delete a key-value pair from the _entries pseudo-array in O(1), we swap the entry to delete with the
            // one at the highest index, and then remove this last entry (sometimes called as 'swap and pop').
            // This modifies the order of the pseudo-array, as noted in {at}.

            uint256 toDeleteIndex = keyIndex - 1;
            uint256 lastIndex = map._length - 1;

            // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            MapEntry storage lastEntry = map._entries[lastIndex];

            // Move the last entry to the index where the entry to delete is
            map._entries[toDeleteIndex] = lastEntry;
            // Update the index for the moved entry
            map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved entry was stored
            delete map._entries[lastIndex];
            map._length = lastIndex;

            // Delete the index for the deleted slot
            delete map._indexes[key];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function _contains(Map storage map, bytes32 key) private view returns (bool) {
        return map._indexes[key] != 0;
    }

    /**
     * @dev Returns the number of key-value pairs in the map. O(1).
     */
    function _length(Map storage map) private view returns (uint256) {
        return map._length;
    }

    /**
     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
     *
     * Note that there are no guarantees on the ordering of entries inside the
     * array, and it may change when more entries are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
        require(map._length > index, "OUT_OF_BOUNDS");

        MapEntry storage entry = map._entries[index];
        return (entry._key, entry._value);
    }

    /**
     * @dev Same as {at}, except this doesn't revert if `index` it outside of the map (i.e. if it is
     * equal or larger than {length}). O(1).
     *
     * This function performs one less storage read than {at}, but should only be used when `index` is known to be
     * within bounds.
     */
    function _unchecked_at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
        MapEntry storage entry = map._entries[index];
        return (entry._key, entry._value);
    }

    /**
     * @dev Same as {unchecked_valueAt}, except it only returns the value and not the key (performing one less storage
     * read). O(1).
     */
    function _unchecked_valueAt(Map storage map, uint256 index) private view returns (bytes32) {
        return map._entries[index]._value;
    }

    /**
     * @dev Returns the value associated with `key`. O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function _get(Map storage map, bytes32 key) private view returns (bytes32) {
        return _get(map, key, "OUT_OF_BOUNDS");
    }

    /**
     * @dev Same as {_get}, with a custom error message when `key` is not in the map.
     */
    function _get(
        Map storage map,
        bytes32 key,
        string memory notFoundErrorMessage
    ) private view returns (bytes32) {
        uint256 index = _indexOf(map, key, notFoundErrorMessage);
        return _unchecked_valueAt(map, index);
    }

    // UintToAddressMap

    struct UintToAddressMap {
        Map _inner;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        UintToAddressMap storage map,
        uint256 key,
        address value
    ) internal returns (bool) {
        return _set(map._inner, bytes32(key), bytes32(uint256(value)));
    }

    /**
     * @dev Returns the index for `key`, which can be used alongside the {at} family of functions, including critically
     * {unchecked_setAt}. O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function indexOf(UintToAddressMap storage map, uint256 key) internal view returns (uint256) {
        return _indexOf(map._inner, bytes32(uint256(address(key))));
    }

    /**
     * @dev Updates the value for an entry, given its key's index. The key index can be retrieved via {indexOf}, and it
     * should be noted that key indices may change when calling {add} or {remove}. O(1).
     *
     * This function performs one less storage read than {set}, but it should only be used when `index` is known to be
     * within bounds.
     */
    function unchecked_setAt(
        UintToAddressMap storage map,
        uint256 index,
        address value
    ) internal {
        _unchecked_setAt(map._inner, index, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
        return _remove(map._inner, bytes32(key));
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
        return _contains(map._inner, bytes32(key));
    }

    /**
     * @dev Returns the number of elements in the map. O(1).
     */
    function length(UintToAddressMap storage map) internal view returns (uint256) {
        return _length(map._inner);
    }

    /**
     * @dev Returns the element stored at position `index` in the set. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = _at(map._inner, index);
        return (uint256(key), address(uint256(value)));
    }

    /**
     * @dev Same as {at}, except this doesn't revert if `index` it outside of the map (i.e. if it is
     * equal or larger than {length}). O(1).
     *
     * This function performs one less storage read than {at}, but should only be used when `index` is known to be
     * within bounds.
     */
    function unchecked_at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = _unchecked_at(map._inner, index);
        return (uint256(key), address(uint256(value)));
    }

    /**
     * @dev Same as {unchecked_valueAt}, except it only returns the value and not the key (performing one less storage
     * read). O(1).
     */
    function unchecked_valueAt(UintToAddressMap storage map, uint256 index) internal view returns (address) {
        return address(uint256(_unchecked_valueAt(map._inner, index)));
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
        return address(uint256(_get(map._inner, bytes32(key))));
    }

    /**
     * @dev Same as {get}, with a custom error message when `key` is not in the map.
     */
    function get(
        UintToAddressMap storage map,
        uint256 key,
        string memory errorMessage
    ) internal view returns (address) {
        return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
    }

    // IERC20ToBytes32Map

    struct IERC20ToBytes32Map {
        Map _inner;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        IERC20ToBytes32Map storage map,
        IERC20 key,
        bytes32 value
    ) internal returns (bool) {
        return _set(map._inner, bytes32(uint256(address(key))), value);
    }

    /**
     * @dev Returns the index for `key`, which can be used alongside the {at} family of functions, including critically
     * {unchecked_setAt}. O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function indexOf(IERC20ToBytes32Map storage map, IERC20 key) internal view returns (uint256) {
        return _indexOf(map._inner, bytes32(uint256(address(key))));
    }

    /**
     * @dev Same as {indexOf}, with a custom error message when `key` is not in the map.
     */
    function indexOf(
        IERC20ToBytes32Map storage map,
        IERC20 key,
        string memory notFoundErrorMessage
    ) internal view returns (uint256) {
        return _indexOf(map._inner, bytes32(uint256(address(key))), notFoundErrorMessage);
    }

    /**
     * @dev Updates the value for an entry, given its key's index. The key index can be retrieved via {indexOf}, and it
     * should be noted that key indices may change when calling {add} or {remove}. O(1).
     *
     * This function performs one less storage read than {set}, but it should only be used when `index` is known to be
     * within bounds.
     */
    function unchecked_setAt(
        IERC20ToBytes32Map storage map,
        uint256 index,
        bytes32 value
    ) internal {
        _unchecked_setAt(map._inner, index, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(IERC20ToBytes32Map storage map, IERC20 key) internal returns (bool) {
        return _remove(map._inner, bytes32(uint256(address(key))));
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(IERC20ToBytes32Map storage map, IERC20 key) internal view returns (bool) {
        return _contains(map._inner, bytes32(uint256(address(key))));
    }

    /**
     * @dev Returns the number of elements in the map. O(1).
     */
    function length(IERC20ToBytes32Map storage map) internal view returns (uint256) {
        return _length(map._inner);
    }

    /**
     * @dev Returns the element stored at position `index` in the set. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(IERC20ToBytes32Map storage map, uint256 index) internal view returns (IERC20, bytes32) {
        (bytes32 key, bytes32 value) = _at(map._inner, index);
        return (IERC20(uint256(key)), value);
    }

    /**
     * @dev Same as {at}, except this doesn't revert if `index` it outside of the map (i.e. if it is
     * equal or larger than {length}). O(1).
     *
     * This function performs one less storage read than {at}, but should only be used when `index` is known to be
     * within bounds.
     */
    function unchecked_at(IERC20ToBytes32Map storage map, uint256 index) internal view returns (IERC20, bytes32) {
        (bytes32 key, bytes32 value) = _unchecked_at(map._inner, index);
        return (IERC20(uint256(key)), value);
    }

    /**
     * @dev Same as {unchecked_valueAt}, except it only returns the value and not the key (performing one less storage
     * read). O(1).
     */
    function unchecked_valueAt(IERC20ToBytes32Map storage map, uint256 index) internal view returns (bytes32) {
        return _unchecked_valueAt(map._inner, index);
    }

    /**
     * @dev Returns the value associated with `key`. O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(IERC20ToBytes32Map storage map, IERC20 key) internal view returns (bytes32) {
        return _get(map._inner, bytes32(uint256(address(key))));
    }

    /**
     * @dev Returns the value associated with `key`. O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(
        IERC20ToBytes32Map storage map,
        IERC20 key,
        string memory errorMessage
    ) internal view returns (bytes32) {
        return _get(map._inner, bytes32(uint256(address(key))), errorMessage);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-eed369562ac50398c10fd0a56dc287a29002d3f8/contracts/balancer-core-v2/vault/balances/GeneralPoolsBalance.sol

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


contract GeneralPoolsBalance {
    using BalanceAllocation for bytes32;
    using EnumerableMap for EnumerableMap.IERC20ToBytes32Map;

    // Data for Pools with General Pool Specialization setting
    //
    // These Pools use the IGeneralPool interface, which means the Vault must query the balance for *all* of their
    // tokens in every swap. If we kept a mapping of token to balance plus a set (array) of tokens, it'd be very gas
    // intensive to read all token addresses just to then do a lookup on the balance mapping.
    // Instead, we use our customized EnumerableMap, which lets us read the N balances in N+1 storage accesses (one for
    // the number of tokens in the Pool), as well as access the index of any token in a single read (required for the
    // IGeneralPool call) and update an entry's value given its index.

    mapping(bytes32 => EnumerableMap.IERC20ToBytes32Map) internal _generalPoolsBalances;

    /**
     * @dev Registers a list of tokens in a General Pool.
     *
     * Requirements:
     *
     * - Each token must not be the zero address.
     * - Each token must not be registered in the Pool.
     */
    function _registerGeneralPoolTokens(bytes32 poolId, IERC20[] memory tokens) internal {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];

        for (uint256 i = 0; i < tokens.length; ++i) {
            IERC20 token = tokens[i];
            require(token != IERC20(0), "ZERO_ADDRESS_TOKEN");
            bool added = poolBalances.set(token, 0);
            require(added, "TOKEN_ALREADY_REGISTERED");
        }
    }

    /**
     * @dev Deregisters a list of tokens in a General Pool.
     *
     * Requirements:
     *
     * - Each token must be registered in the Pool.
     * - Each token must have non balance in the Vault.
     */
    function _deregisterGeneralPoolTokens(bytes32 poolId, IERC20[] memory tokens) internal {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];

        for (uint256 i = 0; i < tokens.length; ++i) {
            IERC20 token = tokens[i];
            bytes32 currentBalance = _getGeneralPoolBalance(poolBalances, token);
            require(currentBalance.isZero(), "NONZERO_TOKEN_BALANCE");

            // We don't need to check remove's return value, since _getGeneralPoolBalance already checks that the token
            // was registered.
            poolBalances.remove(token);
        }
    }

    function _setGeneralPoolBalances(bytes32 poolId, bytes32[] memory balances) internal {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];
        for (uint256 i = 0; i < balances.length; ++i) {
            // Note we assume all balances are properly ordered.
            // Thus, we can use `unchecked_setAt` to avoid one less storage read per call.
            poolBalances.unchecked_setAt(i, balances[i]);
        }
    }

    function _generalPoolCashToManaged(
        bytes32 poolId,
        IERC20 token,
        uint256 amount
    ) internal {
        _updateGeneralPoolBalance(poolId, token, BalanceAllocation.cashToManaged, amount);
    }

    function _generalPoolManagedToCash(
        bytes32 poolId,
        IERC20 token,
        uint256 amount
    ) internal {
        _updateGeneralPoolBalance(poolId, token, BalanceAllocation.managedToCash, amount);
    }

    function _setGeneralPoolManagedBalance(
        bytes32 poolId,
        IERC20 token,
        uint256 amount
    ) internal {
        _updateGeneralPoolBalance(poolId, token, BalanceAllocation.setManaged, amount);
    }

    function _updateGeneralPoolBalance(
        bytes32 poolId,
        IERC20 token,
        function(bytes32, uint256) returns (bytes32) mutation,
        uint256 amount
    ) internal {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];
        bytes32 currentBalance = _getGeneralPoolBalance(poolBalances, token);
        poolBalances.set(token, mutation(currentBalance, amount));
    }

    /**
     * @dev Returns an array with all the tokens and balances in a General Pool.
     * This order may change when tokens are added to or removed from the Pool.
     */
    function _getGeneralPoolTokens(bytes32 poolId)
        internal
        view
        returns (IERC20[] memory tokens, bytes32[] memory balances)
    {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];
        tokens = new IERC20[](poolBalances.length());
        balances = new bytes32[](tokens.length);

        for (uint256 i = 0; i < tokens.length; ++i) {
            // Because the iteration is bounded by `tokens.length` already fetched from the enumerable map,
            // we can use `unchecked_at` as we know `i` is a valid token index, saving storage reads.
            (IERC20 token, bytes32 balance) = poolBalances.unchecked_at(i);
            tokens[i] = token;
            balances[i] = balance;
        }
    }

    function _getGeneralPoolBalance(bytes32 poolId, IERC20 token) internal view returns (bytes32) {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];
        return _getGeneralPoolBalance(poolBalances, token);
    }

    function _getGeneralPoolBalance(EnumerableMap.IERC20ToBytes32Map storage poolBalances, IERC20 token)
        internal
        view
        returns (bytes32)
    {
        return poolBalances.get(token, "TOKEN_NOT_REGISTERED");
    }

    function _isGeneralPoolTokenRegistered(bytes32 poolId, IERC20 token) internal view returns (bool) {
        EnumerableMap.IERC20ToBytes32Map storage poolBalances = _generalPoolsBalances[poolId];
        return poolBalances.contains(token);
    }
}
