// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/lib/helpers/BalancerErrors.sol

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

// solhint-disable

function _require(bool condition, uint256 errorCode) pure {
    if (!condition) _revert(errorCode);
}

function _revert(uint256 errorCode) pure {
    revert(Errors._toReason(errorCode));
}

library Errors {
    // Math
    uint256 internal constant ADD_OVERFLOW                                  = 0;
    uint256 internal constant SUB_OVERFLOW                                  = 1;
    uint256 internal constant SUB_UNDERFLOW                                 = 2;
    uint256 internal constant MUL_OVERFLOW                                  = 3;
    uint256 internal constant ZERO_DIVISION                                 = 4;
    uint256 internal constant ZERO_MOD                                      = 5;
    uint256 internal constant DIV_INTERNAL                                  = 6;
    uint256 internal constant X_OUT_OF_BOUNDS                               = 7;
    uint256 internal constant Y_OUT_OF_BOUNDS                               = 8;
    uint256 internal constant PRODUCT_OUT_OF_BOUNDS                         = 9;

    // Input
    uint256 internal constant OUT_OF_BOUNDS                                 = 100;
    uint256 internal constant UNSORTED_ARRAY                                = 101;
    uint256 internal constant UNSORTED_TOKENS                               = 102;
    uint256 internal constant INPUT_LENGTH_MISMATCH                         = 103;
    uint256 internal constant TOKEN_NOT_CONTRACT                            = 104;

    // Shared pools
    uint256 internal constant MIN_TOKENS                                    = 200;
    uint256 internal constant MAX_TOKENS                                    = 201;
    uint256 internal constant MAX_SWAP_FEE                                  = 202;
    uint256 internal constant MINIMUM_BPT                                   = 203;
    uint256 internal constant CALLER_NOT_VAULT                              = 204;
    uint256 internal constant UNINITIALIZED                                 = 205;
    uint256 internal constant BPT_IN_MAX_AMOUNT                             = 206;
    uint256 internal constant BPT_OUT_MIN_AMOUNT                            = 207;
    uint256 internal constant ERR_AMOUNTS_IN_LENGTH                         = 208;
    uint256 internal constant UNHANDLED_JOIN_KIND                           = 209;
    uint256 internal constant UNHANDLED_EXIT_KIND                           = 210;

    // Stable pool
    uint256 internal constant MIN_AMP                                       = 300;
    uint256 internal constant MAX_AMP                                       = 301;
    uint256 internal constant MIN_WEIGHT                                    = 302;
    uint256 internal constant MAX_STABLE_TOKENS                             = 303;

    // Weighted pool
    uint256 internal constant MAX_IN_RATIO                                  = 400;
    uint256 internal constant MAX_OUT_RATIO                                 = 401;
    uint256 internal constant MIN_BPT_IN_FOR_TOKEN_OUT                      = 402;
    uint256 internal constant MAX_OUT_BPT_FOR_TOKEN_IN                      = 403;

    // Lib
    uint256 internal constant REENTRANCY                                    = 500;
    uint256 internal constant SENDER_NOT_ALLOWED                            = 501;
    uint256 internal constant EMERGENCY_PERIOD_ON                           = 502;
    uint256 internal constant EMERGENCY_PERIOD_FINISHED                     = 503;
    uint256 internal constant MAX_EMERGENCY_PERIOD                          = 504;
    uint256 internal constant MAX_EMERGENCY_PERIOD_CHECK_EXT                = 505;
    uint256 internal constant INSUFFICIENT_BALANCE                          = 506;
    uint256 internal constant INSUFFICIENT_ALLOWANCE                        = 507;
    uint256 internal constant ERC20_TRANSFER_FROM_ZERO_ADDRESS              = 508;
    uint256 internal constant ERC20_TRANSFER_TO_ZERO_ADDRESS                = 509;
    uint256 internal constant ERC20_MINT_TO_ZERO_ADDRESS                    = 510;
    uint256 internal constant ERC20_BURN_FROM_ZERO_ADDRESS                  = 511;
    uint256 internal constant ERC20_APPROVE_FROM_ZERO_ADDRESS               = 512;
    uint256 internal constant ERC20_APPROVE_TO_ZERO_ADDRESS                 = 513;
    uint256 internal constant ERC20_TRANSFER_EXCEEDS_ALLOWANCE              = 514;
    uint256 internal constant ERC20_DECREASED_ALLOWANCE_BELOW_ZERO          = 515;
    uint256 internal constant ERC20_TRANSFER_EXCEEDS_BALANCE                = 516;
    uint256 internal constant ERC20_BURN_EXCEEDS_ALLOWANCE                  = 517;
    uint256 internal constant SAFE_ERC20_OP_DIDNT_SUCCEED                   = 518;
    uint256 internal constant SAFE_ERC20_CALL_FAILED                        = 519;
    uint256 internal constant SAFE_ERC20_APPROVE_NON_ZERO_ALLOWANCE         = 520;
    uint256 internal constant SAFE_ERC20_DECREASED_ALLOWANCE_BELOW_ZERO     = 521;
    uint256 internal constant ADDRESS_INSUFFICIENT_BALANCE                  = 522;
    uint256 internal constant ADDRESS_CANNOT_SEND_VALUE                     = 523;
    uint256 internal constant ADDRESS_INSUFFICIENT_BALANCE_CALL             = 524;
    uint256 internal constant ADDRESS_CALL_TO_NON_CONTRACT                  = 525;
    uint256 internal constant ADDRESS_STATIC_CALL_NOT_CONTRACT              = 526;
    uint256 internal constant ADDRESS_CALL_FAILED                           = 527;
    uint256 internal constant ADDRESS_STATIC_CALL_FAILED                    = 528;
    uint256 internal constant ADDRESS_STATIC_CALL_VALUE_FAILED              = 529;
    uint256 internal constant CREATE2_INSUFFICIENT_BALANCE                  = 530;
    uint256 internal constant CREATE2_BYTECODE_ZERO                         = 531;
    uint256 internal constant CREATE2_DEPLOY_FAILED                         = 532;
    uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_128                  = 533;
    uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_64                   = 534;
    uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_32                   = 535;
    uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_16                   = 536;
    uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_8                    = 537;
    uint256 internal constant SAFE_CAST_VALUE_CANT_FIT_INT256               = 538;
    uint256 internal constant SAFE_CAST_VALUE_NOT_POSITIVE                  = 539;
    uint256 internal constant GRANT_SENDER_NOT_ADMIN                        = 540;
    uint256 internal constant REVOKE_SENDER_NOT_ADMIN                       = 541;
    uint256 internal constant RENOUNCE_SENDER_NOT_ALLOWED                   = 542;
    uint256 internal constant ENUMERABLE_NON_EXISTENT_KEY                   = 543;

    // Vault
    uint256 internal constant INVALID_POOL_ID                               = 600;
    uint256 internal constant CALLER_NOT_POOL                               = 601;
    uint256 internal constant EXIT_BELOW_MIN                                = 602;
    uint256 internal constant SENDER_NOT_ASSET_MANAGER                      = 603;
    uint256 internal constant INVALID_POST_LOAN_BALANCE                     = 604;
    uint256 internal constant USER_DOESNT_ALLOW_RELAYER                     = 605;
    uint256 internal constant JOIN_ABOVE_MAX                                = 606;
    uint256 internal constant SWAP_LIMIT 			                        = 607;
    uint256 internal constant SWAP_DEADLINE 			                    = 608;
    uint256 internal constant CANNOT_SWAP_SAME_TOKEN 			            = 609;
    uint256 internal constant UNKNOWN_AMOUNT_IN_FIRST_SWAP 		            = 610;
    uint256 internal constant MALCONSTRUCTED_MULTIHOP_SWAP 		            = 611;
    uint256 internal constant INTERNAL_BALANCE_OVERFLOW 		            = 612;
    uint256 internal constant INSUFFICIENT_INTERNAL_BALANCE 	            = 613;
    uint256 internal constant INVALID_ETH_INTERNAL_BALANCE 		            = 614;
    uint256 internal constant INSUFFICIENT_ETH 			                    = 615;
    uint256 internal constant UNALLOCATED_ETH 			                    = 616;
    uint256 internal constant ETH_TRANSFER 			                        = 617;
    uint256 internal constant INVALID_TOKEN 			                    = 618;
    uint256 internal constant TOKENS_MISMATCH 			                    = 619;
    uint256 internal constant TOKEN_NOT_REGISTERED 			                = 620;
    uint256 internal constant TOKEN_ALREADY_REGISTERED 			            = 621;
    uint256 internal constant TOKENS_ALREADY_SET 			                = 622;
    uint256 internal constant NONZERO_TOKEN_BALANCE 			            = 623;
    uint256 internal constant BALANCE_TOTAL_OVERFLOW 			            = 624;
    uint256 internal constant TOKENS_LENGTH_MUST_BE_2 			            = 625;

    // Fees
    uint256 internal constant SWAP_FEE_TOO_HIGH 			                = 700;
    uint256 internal constant FLASH_LOAN_FEE_TOO_HIGH 			            = 701;
    uint256 internal constant INSUFFICIENT_COLLECTED_FEES 		            = 702;

    function _toReason(uint256 code) internal pure returns (string memory) {
        // log10(MAX_UINT256) ≈ 78, considering 4 more chars for the identifier, it makes a maximum of 82 length strings
        uint256 CODE_MAX_LENGTH = 82;
        bytes memory reversed = new bytes(CODE_MAX_LENGTH);

        // Encode given error code to ascii
        uint256 i;
        for (i = 0; code != 0; i++) {
            uint256 remainder = code % 10;
            code = code / 10;
            reversed[i] = byte(uint8(48 + remainder));
        }

        // Store identifier: "BAL#"
        reversed[i++] = byte(uint8(35)); // #
        reversed[i++] = byte(uint8(76)); // L
        reversed[i++] = byte(uint8(65)); // A
        reversed[i] = byte(uint8(66));   // B

        // Reverse the bytes array
        bytes memory reason = new bytes(i + 1);
        for (uint256 j = 0; j <= i; j++) {
            reason[j] = reversed[i - j];
        }

        return string(reason);
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/lib/math/Math.sol

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
        _require(c >= a, Errors.ADD_OVERFLOW);
        return c;
    }

    /**
     * @dev Returns the addition of two signed integers, reverting on overflow.
     */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        _require((b >= 0 && c >= a) || (b < 0 && c < a), Errors.ADD_OVERFLOW);
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers of 256 bits, reverting on overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        _require(b <= a, Errors.SUB_OVERFLOW);
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Returns the subtraction of two signed integers, reverting on overflow.
     */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        _require((b >= 0 && c <= a) || (b < 0 && c > a), Errors.SUB_OVERFLOW);
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
        _require(a == 0 || c / a == b, Errors.MUL_OVERFLOW);
        return c;
    }

    function divDown(uint256 a, uint256 b) internal pure returns (uint256) {
        _require(b != 0, Errors.ZERO_DIVISION);
        return a / b;
    }

    function divUp(uint256 a, uint256 b) internal pure returns (uint256) {
        _require(b != 0, Errors.ZERO_DIVISION);

        if (a == 0) {
            return 0;
        } else {
            return 1 + (a - 1) / b;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/vault/balances/BalanceAllocation.sol

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
// One of the goals of this library is to store the entire token balance in a single storage slot, which is why we use
// 112 bit unsigned integers for 'cash' and 'managed'. Since 'total' is also a 112 bit unsigned value, any combination
// of 'cash' and 'managed' that yields a 'total' that doesn't fit in that range is disallowed.
//
// The remaining 32 bits of each storage slot are used to store the most recent block number when a balance was
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
     * @dev Returns the managed delta between two balances
     */
    function managedDelta(bytes32 balance, bytes32 otherBalance) internal pure returns (int256) {
        // Due to how balances are packed we know the delta between two managed values will always fit in an int256
        return int256(managed(balance)) - int256(managed(otherBalance));
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
     * Critically, this also checks that the sum of cash and external doesn't overflow, that is, that `total()`
     * can be computed.
     */
    function toBalance(
        uint256 _cash,
        uint256 _managed,
        uint256 _blockNumber
    ) internal pure returns (bytes32) {
        uint256 balance = _cash + _managed;
        // We assume the block number will fit in a uint32 - this is expected to hold for at least a few decades.
        _require(balance >= _cash && balance < 2**112, Errors.BALANCE_TOTAL_OVERFLOW);
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

    // Alternative mode for Pools with the two token specialization setting

    // Instead of storing cash and external for each token in a single storage slot, two token pools store the cash for
    // both tokens in the same slot, and the external for both in another one. This reduces the gas cost for swaps,
    // because the only slot that needs to be updated is the one with the cash. However, it also means that managing
    // balances is more cumbersome, as both tokens need to be read/written at the same time.
    //
    // The field with both cash balances packed is called sharedCash, and the one with external amounts is called
    // sharedManaged. These two are collectively called the 'shared' balance fields. In both of these, the portion
    // that corresponds to token A is stored in the least significant 112 bits of a 256 bit word, while token B's part
    // uses the most significant 112 bits.
    //
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
        // Both balances have the block number. Since both balances are always updated at the same time,
        // it does not matter where we pick it from.
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
