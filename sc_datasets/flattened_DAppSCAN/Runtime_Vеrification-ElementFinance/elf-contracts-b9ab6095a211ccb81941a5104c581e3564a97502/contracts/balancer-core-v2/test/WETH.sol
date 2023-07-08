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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/lib/openzeppelin/EnumerableSet.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        _require(set._values.length > index, Errors.OUT_OF_BOUNDS);
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/lib/openzeppelin/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/lib/openzeppelin/AccessControl.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        _require(hasRole(_roles[role].adminRole, _msgSender()), Errors.GRANT_SENDER_NOT_ADMIN);

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        _require(hasRole(_roles[role].adminRole, _msgSender()), Errors.REVOKE_SENDER_NOT_ADMIN);

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        _require(account == _msgSender(), Errors.RENOUNCE_SENDER_NOT_ALLOWED);

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/vault/interfaces/IWETH.sol

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

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-ElementFinance/elf-contracts-b9ab6095a211ccb81941a5104c581e3564a97502/contracts/balancer-core-v2/test/WETH.sol

// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2015, 2016, 2017 Dapphub

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

contract WETH is AccessControl, IWETH {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    constructor(address minter) {
        _setupRole(MINTER_ROLE, minter);
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable override {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) public override {
        require(balanceOf[msg.sender] >= wad, "INSUFFICIENT_BALANCE");
        balanceOf[msg.sender] -= wad;
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    // For testing purposes - this creates WETH that cannot be redeemed for ETH via 'withdraw'
    function mint(address destinatary, uint256 amount) external {
        require(hasRole(MINTER_ROLE, msg.sender), "NOT_MINTER");
        balanceOf[destinatary] += amount;
        emit Deposit(destinatary, amount);
    }

    function totalSupply() public view override returns (uint256) {
        return address(this).balance;
    }

    function approve(address guy, uint256 wad) public override returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) public override returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) public override returns (bool) {
        require(balanceOf[src] >= wad, "INSUFFICIENT_BALANCE");

        if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
            require(allowance[src][msg.sender] >= wad, "INSUFFICIENT_ALLOWANCE");
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}
