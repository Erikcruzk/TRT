// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/tests/lib/hevm.sol

pragma solidity ^0.6.0;

interface Hevm {
    function warp(uint256) external;
    function roll(uint x) external;
    function store(address c, bytes32 loc, bytes32 val) external;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/tests/lib/user.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

// Contract account to simulate another user
contract User {
    function execute(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data
    ) public payable returns (bytes memory) {
        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(
                bytes4(keccak256(bytes(signature))),
                data
            );
        }

        (bool success, bytes memory returnData) = target.call{value: value}(
            callData
        );
        require(success, "!user-execute");

        return returnData;
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/tests/lib/test.sol

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

pragma solidity >=0.4.23;

contract DSTest {
    event eventListener          (address target, bool exact);
    event logs                   (bytes);
    event log_bytes32            (bytes32);
    event log_named_address      (bytes32 key, address val);
    event log_named_bytes32      (bytes32 key, bytes32 val);
    event log_named_decimal_int  (bytes32 key, int val, uint decimals);
    event log_named_decimal_uint (bytes32 key, uint val, uint decimals);
    event log_named_int          (bytes32 key, int val);
    event log_named_uint         (bytes32 key, uint val);
    event log_named_string       (bytes32 key, string val);

    bool public IS_TEST;
    bool public failed;

    constructor() internal {
        IS_TEST = true;
    }

    function fail() internal {
        failed = true;
    }

    function expectEventsExact(address target) internal {
        emit eventListener(target, true);
    }

    modifier logs_gas() {
        uint startGas = gasleft();
        _;
        uint endGas = gasleft();
        emit log_named_uint("gas", startGas - endGas);
    }

    function assertTrue(bool condition) internal {
        if (!condition) {
            emit log_bytes32("Assertion failed");
            fail();
        }
    }

    function assertEq(address a, address b) internal {
        if (a != b) {
            emit log_bytes32("Error: Wrong `address' value");
            emit log_named_address("  Expected", b);
            emit log_named_address("    Actual", a);
            fail();
        }
    }

    function assertEq32(bytes32 a, bytes32 b) internal {
        assertEq(a, b);
    }

    function assertEq(bytes32 a, bytes32 b) internal {
        if (a != b) {
            emit log_bytes32("Error: Wrong `bytes32' value");
            emit log_named_bytes32("  Expected", b);
            emit log_named_bytes32("    Actual", a);
            fail();
        }
    }

    function assertEqDecimal(int a, int b, uint decimals) internal {
        if (a != b) {
            emit log_bytes32("Error: Wrong fixed-point decimal");
            emit log_named_decimal_int("  Expected", b, decimals);
            emit log_named_decimal_int("    Actual", a, decimals);
            fail();
        }
    }

    function assertEqDecimal(uint a, uint b, uint decimals) internal {
        if (a != b) {
            emit log_bytes32("Error: Wrong fixed-point decimal");
            emit log_named_decimal_uint("  Expected", b, decimals);
            emit log_named_decimal_uint("    Actual", a, decimals);
            fail();
        }
    }

    function assertEq(int a, int b) internal {
        if (a != b) {
            emit log_bytes32("Error: Wrong `int' value");
            emit log_named_int("  Expected", b);
            emit log_named_int("    Actual", a);
            fail();
        }
    }

    function assertEq(uint a, uint b) internal {
        if (a != b) {
            emit log_bytes32("Error: Wrong `uint' value");
            emit log_named_uint("  Expected", b);
            emit log_named_uint("    Actual", a);
            fail();
        }
    }

    function assertEq(string memory a, string memory b) internal {
        if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
            emit log_bytes32("Error: Wrong `string' value");
            emit log_named_string("  Expected", b);
            emit log_named_string("    Actual", a);
            fail();
        }
    }

    function assertEq0(bytes memory a, bytes memory b) internal {
        bool ok = true;

        if (a.length == b.length) {
            for (uint i = 0; i < a.length; i++) {
                if (a[i] != b[i]) {
                    ok = false;
                }
            }
        } else {
            ok = false;
        }

        if (!ok) {
            emit log_bytes32("Error: Wrong `bytes' value");
            emit log_named_bytes32("  Expected", "[cannot show `bytes' value]");
            emit log_named_bytes32("  Actual", "[cannot show `bytes' value]");
            fail();
        }
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/tests/lib/test-approx.sol

pragma solidity ^0.6.7;

contract DSTestApprox is DSTest {
    function assertEqApprox(uint256 a, uint256 b) internal {
        if (a == 0 && b == 0) {
            return;    
        }

        // +/- 5%
        uint256 bMax = (b * 105) / 100;
        uint256 bMin = (b * 95) / 100;

        if (!(a > bMin && a < bMax)) {
            emit log_bytes32("Error: Wrong `a-uint` value!");
            emit log_named_uint("  Expected", b);
            emit log_named_uint("    Actual", a);
            fail();
        }
    }

    function assertEqVerbose(bool a, bytes memory b) internal {
        if (!a) {
            emit log_bytes32("Error: assertion error!");
            emit logs(b);
            fail();
        }
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/lib/safe-math.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/lib/context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/lib/erc20.sol

// File: contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


// File: contracts/token/ERC20/IERC20.sol


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
}

// File: contracts/utils/Address.sol


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: contracts/token/ERC20/ERC20.sol

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/usdt.sol

// SPDX-License-Identifier: MIT
// https://forum.openzeppelin.com/t/can-not-call-the-function-approve-of-the-usdt-contract/2130/2
// USDT is gay and should be ashamed

pragma solidity ^0.6.0;

interface USDT {
    function approve(address guy, uint256 wad) external;

    function transfer(address _to, uint256 _value) external;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/weth.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface WETH {
    function name() external view returns (string memory);

    function approve(address guy, uint256 wad) external returns (bool);

    function totalSupply() external view returns (uint256);

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) external returns (bool);

    function withdraw(uint256 wad) external;

    function decimals() external view returns (uint8);

    function balanceOf(address) external view returns (uint256);

    function symbol() external view returns (string memory);

    function transfer(address dst, uint256 wad) external returns (bool);

    function deposit() external payable;

    function allowance(address, address) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/strategy.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface IStrategy {
    function rewards() external view returns (address);

    function gauge() external view returns (address);

    function want() external view returns (address);

    function timelock() external view returns (address);

    function deposit() external;

    function withdraw(address) external;

    function withdraw(uint256) external;

    function skim() external;

    function withdrawAll() external returns (uint256);

    function balanceOf() external view returns (uint256);

    function harvest() external;

    function setTimelock(address) external;

    function setController(address _controller) external;

    function execute(address _target, bytes calldata _data)
        external
        payable
        returns (bytes memory response);

    function execute(bytes calldata _data)
        external
        payable
        returns (bytes memory response);
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/curve.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;

interface ICurveFi_2 {
    function get_virtual_price() external view returns (uint256);

    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
        external;

    function remove_liquidity_imbalance(
        uint256[2] calldata amounts,
        uint256 max_burn_amount
    ) external;

    function remove_liquidity(uint256 _amount, uint256[2] calldata amounts)
        external;

    function exchange(
        int128 from,
        int128 to,
        uint256 _from_amount,
        uint256 _min_to_amount
    ) external;

    function balances(int128) external view returns (uint256);
}


interface ICurveFi_3 {
    function get_virtual_price() external view returns (uint256);

    function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount)
        external;

    function remove_liquidity_imbalance(
        uint256[3] calldata amounts,
        uint256 max_burn_amount
    ) external;

    function remove_liquidity(uint256 _amount, uint256[3] calldata amounts)
        external;

    function exchange(
        int128 from,
        int128 to,
        uint256 _from_amount,
        uint256 _min_to_amount
    ) external;

    function balances(uint256) external view returns (uint256);
}

interface ICurveFi_4 {
    function get_virtual_price() external view returns (uint256);

    function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount)
        external;

    function remove_liquidity_imbalance(
        uint256[4] calldata amounts,
        uint256 max_burn_amount
    ) external;

    function remove_liquidity(uint256 _amount, uint256[4] calldata amounts)
        external;

    function exchange(
        int128 from,
        int128 to,
        uint256 _from_amount,
        uint256 _min_to_amount
    ) external;

    function balances(int128) external view returns (uint256);
}

interface ICurveZap_4 {
    function add_liquidity(
        uint256[4] calldata uamounts,
        uint256 min_mint_amount
    ) external;

    function remove_liquidity(uint256 _amount, uint256[4] calldata min_uamounts)
        external;

    function remove_liquidity_imbalance(
        uint256[4] calldata uamounts,
        uint256 max_burn_amount
    ) external;

    function calc_withdraw_one_coin(uint256 _token_amount, int128 i)
        external
        returns (uint256);

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 min_uamount
    ) external;

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 min_uamount,
        bool donate_dust
    ) external;

    function withdraw_donated_dust() external;

    function coins(int128 arg0) external returns (address);

    function underlying_coins(int128 arg0) external returns (address);

    function curve() external returns (address);

    function token() external returns (address);
}

interface ICurveGauge {
    function deposit(uint256 _value) external;

    function deposit(uint256 _value, address addr) external;

    function balanceOf(address arg0) external view returns (uint256);

    function withdraw(uint256 _value) external;

    function withdraw(uint256 _value, bool claim_rewards) external;

    function claim_rewards() external;

    function claim_rewards(address addr) external;

    function claimable_tokens(address addr) external returns (uint256);

    function claimable_reward(address addr) external view returns (uint256);

    function integrate_fraction(address arg0) external view returns (uint256);
}

interface ICurveMintr {
    function mint(address) external;

    function minted(address arg0, address arg1) external view returns (uint256);
}

interface ICurveVotingEscrow {
    function locked(address arg0)
        external
        view
        returns (int128 amount, uint256 end);

    function locked__end(address _addr) external view returns (uint256);

    function create_lock(uint256, uint256) external;

    function increase_amount(uint256) external;

    function increase_unlock_time(uint256 _unlock_time) external;

    function withdraw() external;

    function smart_wallet_checker() external returns (address);
}

interface ICurveSmartContractChecker {
    function wallets(address) external returns (bool);

    function approveWallet(address _wallet) external;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/uniswapv2.sol

// SPDX-License-Identifier: MIT

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface UniswapRouterV2 {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

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

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/tests/lib/test-defi-base.sol

pragma solidity ^0.6.7;








contract DSTestDefiBase is DSTestApprox {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address pickle = 0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5;
    address burn = 0x000000000000000000000000000000000000dEaD;

    address susdv2_pool = 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD;
    address three_pool = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    address ren_pool = 0x93054188d876f558f4a66B2EF1d97d16eDf0895B;

    address scrv = 0xC25a3A3b969415c80451098fa907EC722572917F;
    address three_crv = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
    address ren_crv = 0x49849C98ae39Fff122806C06791Fa73784FB3675;

    address eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address crv = 0xD533a949740bb3306d119CC777fa900bA034cd52;
    address snx = 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F;
    address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    address uni = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;

    address wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address renbtc = 0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D;

    Hevm hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    UniswapRouterV2 univ2 = UniswapRouterV2(
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    );

    IUniswapV2Factory univ2Factory = IUniswapV2Factory(
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
    );

    ICurveFi_4 curveSusdV2 = ICurveFi_4(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);

    uint256 startTime = block.timestamp;

    function _swap(
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        address[] memory path;

        if (_from == eth || _from == weth) {
            path = new address[](2);
            path[0] = weth;
            path[1] = _to;

            univ2.swapExactETHForTokens{value: _amount}(
                0,
                path,
                address(this),
                now + 60
            );
        } else {
            path = new address[](3);
            path[0] = _from;
            path[1] = weth;
            path[2] = _to;

            IERC20(_from).safeApprove(address(univ2), 0);
            IERC20(_from).safeApprove(address(univ2), _amount);

            univ2.swapExactTokensForTokens(
                _amount,
                0,
                path,
                address(this),
                now + 60
            );
        }
    }

    function _getERC20(address token, uint256 _amount) internal {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = token;

        uint256[] memory ins = univ2.getAmountsIn(_amount, path);
        uint256 ethAmount = ins[0];

        univ2.swapETHForExactTokens{value: ethAmount}(
            _amount,
            path,
            address(this),
            now + 60
        );
    }

    function _getERC20WithETH(address token, uint256 _ethAmount) internal {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = token;

        univ2.swapExactETHForTokens{value: _ethAmount}(
            0,
            path,
            address(this),
            now + 60
        );
    }

    function _getUniV2LPToken(address lpToken, uint256 _ethAmount) internal {
        address token0 = IUniswapV2Pair(lpToken).token0();
        address token1 = IUniswapV2Pair(lpToken).token1();

        if (token0 != weth) {
            _getERC20WithETH(token0, _ethAmount.div(2));
        } else {
            WETH(weth).deposit{value: _ethAmount.div(2)}();
        }

        if (token1 != weth) {
            _getERC20WithETH(token1, _ethAmount.div(2));
        } else {
            WETH(weth).deposit{value: _ethAmount.div(2)}();
        }

        IERC20(token0).safeApprove(address(univ2), uint256(0));
        IERC20(token0).safeApprove(address(univ2), uint256(-1));

        IERC20(token1).safeApprove(address(univ2), uint256(0));
        IERC20(token1).safeApprove(address(univ2), uint256(-1));
        univ2.addLiquidity(
            token0,
            token1,
            IERC20(token0).balanceOf(address(this)),
            IERC20(token1).balanceOf(address(this)),
            0,
            0,
            address(this),
            now + 60
        );
    }

    function _getUniV2LPToken(
        address token0,
        address token1,
        uint256 _ethAmount
    ) internal {
        _getUniV2LPToken(univ2Factory.getPair(token0, token1), _ethAmount);
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/compound.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface ICToken {
    function totalSupply() external view returns (uint256);

    function totalBorrows() external returns (uint256);

    function borrowIndex() external returns (uint256);

    function repayBorrow(uint256 repayAmount) external returns (uint256);

    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

    function mint(uint256 mintAmount) external returns (uint256);

    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);

    function getAccountSnapshot(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        );

    function borrowRatePerBlock() external view returns (uint256);

    function supplyRatePerBlock() external view returns (uint256);

    function totalBorrowsCurrent() external returns (uint256);

    function borrowBalanceCurrent(address account) external returns (uint256);

    function borrowBalanceStored(address account)
        external
        view
        returns (uint256);

    function exchangeRateCurrent() external returns (uint256);

    function exchangeRateStored() external view returns (uint256);

    function getCash() external view returns (uint256);

    function accrueInterest() external returns (uint256);

    function seize(
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);
}

interface ICEther {
    function mint() external payable;

    /**
     * @notice Sender redeems cTokens in exchange for the underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemTokens The number of cTokens to redeem into underlying
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeem(uint256 redeemTokens) external returns (uint256);

    /**
     * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemAmount The amount of underlying to redeem
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    /**
     * @notice Sender borrows assets from the protocol to their own address
     * @param borrowAmount The amount of the underlying asset to borrow
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function borrow(uint256 borrowAmount) external returns (uint256);

    /**
     * @notice Sender repays their own borrow
     * @dev Reverts upon any failure
     */
    function repayBorrow() external payable;

    /**
     * @notice Sender repays a borrow belonging to borrower
     * @dev Reverts upon any failure
     * @param borrower the account with the debt being payed off
     */
    function repayBorrowBehalf(address borrower) external payable;

    /**
     * @notice The sender liquidates the borrowers collateral.
     *  The collateral seized is transferred to the liquidator.
     * @dev Reverts upon any failure
     * @param borrower The borrower of this cToken to be liquidated
     * @param cTokenCollateral The market in which to seize collateral from the borrower
     */
    function liquidateBorrow(address borrower, address cTokenCollateral)
        external
        payable;
}

interface IComptroller {
    function compAccrued(address) external view returns (uint256);

    function compSupplierIndex(address, address)
        external
        view
        returns (uint256);

    function compBorrowerIndex(address, address)
        external
        view
        returns (uint256);

    function compSpeeds(address) external view returns (uint256);

    function compBorrowState(address) external view returns (uint224, uint32);

    function compSupplyState(address) external view returns (uint224, uint32);

    /*** Assets You Are In ***/

    function enterMarkets(address[] calldata cTokens)
        external
        returns (uint256[] memory);

    function exitMarket(address cToken) external returns (uint256);

    /*** Policy Hooks ***/

    function mintAllowed(
        address cToken,
        address minter,
        uint256 mintAmount
    ) external returns (uint256);

    function mintVerify(
        address cToken,
        address minter,
        uint256 mintAmount,
        uint256 mintTokens
    ) external;

    function redeemAllowed(
        address cToken,
        address redeemer,
        uint256 redeemTokens
    ) external returns (uint256);

    function redeemVerify(
        address cToken,
        address redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    ) external;

    function borrowAllowed(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external returns (uint256);

    function borrowVerify(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external;

    function repayBorrowAllowed(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function repayBorrowVerify(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount,
        uint256 borrowerIndex
    ) external;

    function liquidateBorrowAllowed(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function liquidateBorrowVerify(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount,
        uint256 seizeTokens
    ) external;

    function seizeAllowed(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function seizeVerify(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function transferAllowed(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external returns (uint256);

    function transferVerify(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external;

    /*** Liquidity/Liquidation Calculations ***/

    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint256 repayAmount
    ) external view returns (uint256, uint256);

    // Claim all the COMP accrued by holder in all markets
    function claimComp(address holder) external;

    // Claim all the COMP accrued by holder in specific markets
    function claimComp(address holder, address[] calldata cTokens) external;

    // Claim all the COMP accrued by specific holders in specific markets for their supplies and/or borrows
    function claimComp(
        address[] calldata holders,
        address[] calldata cTokens,
        bool borrowers,
        bool suppliers
    ) external;

    function markets(address cTokenAddress)
        external
        view
        returns (bool, uint256);
}

interface ICompoundLens {
    function getCompBalanceMetadataExt(
        address comp,
        address comptroller,
        address account
    )
        external
        returns (
            uint256 balance,
            uint256 votes,
            address delegate,
            uint256 allocated
        );
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/controller.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IController {
    function jars(address) external view returns (address);

    function rewards() external view returns (address);

    function devfund() external view returns (address);

    function treasury() external view returns (address);

    function balanceOf(address) external view returns (uint256);

    function withdraw(address, uint256) external;

    function earn(address, uint256) external;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/pickle-jar.sol

// https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol

pragma solidity ^0.6.7;


contract PickleJar is ERC20 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    IERC20 public token;

    uint256 public min = 9500;
    uint256 public constant max = 10000;

    address public governance;
    address public timelock;
    address public controller;

    constructor(address _token, address _governance, address _timelock, address _controller)
        public
        ERC20(
            string(abi.encodePacked("pickling ", ERC20(_token).name())),
            string(abi.encodePacked("p", ERC20(_token).symbol()))
        )
    {
        _setupDecimals(ERC20(_token).decimals());
        token = IERC20(_token);
        governance = _governance;
        timelock = _timelock;
        controller = _controller;
    }

    function balance() public view returns (uint256) {
        return
            token.balanceOf(address(this)).add(
                IController(controller).balanceOf(address(token))
            );
    }

    function setMin(uint256 _min) external {
        require(msg.sender == governance, "!governance");
        min = _min;
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function setTimelock(address _timelock) public {
        require(msg.sender == timelock, "!timelock");
        timelock = _timelock;
    }

    function setController(address _controller) public {
        require(msg.sender == timelock, "!timelock");
        controller = _controller;
    }

    // Custom logic in here for how much the jars allows to be borrowed
    // Sets minimum required on-hand to keep small withdrawals cheap
    function available() public view returns (uint256) {
        return token.balanceOf(address(this)).mul(min).div(max);
    }

    function earn() public {
        uint256 _bal = available();
        token.safeTransfer(controller, _bal);
        IController(controller).earn(address(token), _bal);
    }

    function depositAll() external {
        deposit(token.balanceOf(msg.sender));
    }

    function deposit(uint256 _amount) public {
        uint256 _pool = balance();
        uint256 _before = token.balanceOf(address(this));
        token.safeTransferFrom(msg.sender, address(this), _amount);
        uint256 _after = token.balanceOf(address(this));
        _amount = _after.sub(_before); // Additional check for deflationary tokens
        uint256 shares = 0;
        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = (_amount.mul(totalSupply())).div(_pool);
        }
        _mint(msg.sender, shares);
    }

    function withdrawAll() external {
        withdraw(balanceOf(msg.sender));
    }

    // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
    function harvest(address reserve, uint256 amount) external {
        require(msg.sender == controller, "!controller");
        require(reserve != address(token), "token");
        IERC20(reserve).safeTransfer(controller, amount);
    }

    // No rebalance implementation for lower fees and faster swaps
    function withdraw(uint256 _shares) public {
        uint256 r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);

        // Check balance
        uint256 b = token.balanceOf(address(this));
        if (b < r) {
            uint256 _withdraw = r.sub(b);
            IController(controller).withdraw(address(token), _withdraw);
            uint256 _after = token.balanceOf(address(this));
            uint256 _diff = _after.sub(b);
            if (_diff < _withdraw) {
                r = b.add(_diff);
            }
        }

        token.safeTransfer(msg.sender, r);
    }

    function getRatio() public view returns (uint256) {
        return balance().mul(1e18).div(totalSupply());
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/jar.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface IJar is IERC20 {
    function token() external view returns (address);

    function claimInsurance() external; // NOTE: Only yDelegatedVault implements this

    function getRatio() external view returns (uint256);

    function deposit(uint256) external;

    function withdraw(uint256) external;

    function earn() external;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/onesplit.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface OneSplitAudit {
    function getExpectedReturn(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 parts,
        uint256 featureFlags
    )
        external
        view
        returns (uint256 returnAmount, uint256[] memory distribution);

    function swap(
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution,
        uint256 featureFlags
    ) external payable;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/converter.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface Converter {
    function convert(address) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/strategy-converter.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface IStrategyConverter {
    function convert(
        address _refundExcess, // address to send the excess amount when adding liquidity
        address _fromWant,
        address _toWant,
        uint256 _wantAmount
    ) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/controller-v3.sol

// https://github.com/iearn-finance/jars/blob/master/contracts/controllers/StrategyControllerV1.sol

pragma solidity ^0.6.7;






contract ControllerV3 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address public constant burn = 0x000000000000000000000000000000000000dEaD;
    address public onesplit = 0xC586BeF4a0992C495Cf22e1aeEE4E446CECDee0E;

    address public governance;
    address public strategist;
    address public devfund;
    address public treasury;
    address public timelock;

    mapping(address => address) public jars;
    mapping(address => address) public strategies;
    mapping(address => mapping(address => address)) public converters;
    // SWC-Presence of unused variables: L34
    mapping(address => mapping(address => address)) public strategyConverters;

    mapping(address => mapping(address => bool)) public approvedStrategies;

    uint256 public split = 500;
    uint256 public constant max = 10000;

    constructor(
        address _governance,
        address _strategist,
        address _timelock,
        address _devfund,
        address _treasury
    ) public {
        governance = _governance;
        strategist = _strategist;
        timelock = _timelock;
        devfund = _devfund;
        treasury = _treasury;
    }

    function setDevFund(address _devfund) public {
        require(msg.sender == governance, "!governance");
        devfund = _devfund;
    }

    function setTreasury(address _treasury) public {
        require(msg.sender == governance, "!governance");
        treasury = _treasury;
    }

    function setStrategist(address _strategist) public {
        require(msg.sender == governance, "!governance");
        strategist = _strategist;
    }

    function setSplit(uint256 _split) public {
        require(msg.sender == governance, "!governance");
        split = _split;
    }

    function setOneSplit(address _onesplit) public {
        require(msg.sender == governance, "!governance");
        onesplit = _onesplit;
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function setTimelock(address _timelock) public {
        require(msg.sender == timelock, "!timelock");
        timelock = _timelock;
    }

    function setJar(address _token, address _jar) public {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!strategist"
        );
        require(jars[_token] == address(0), "jar");
        jars[_token] = _jar;
    }

    function approveStrategy(address _token, address _strategy) public {
        require(msg.sender == timelock, "!timelock");
        approvedStrategies[_token][_strategy] = true;
    }

    function revokeStrategy(address _token, address _strategy) public {
        require(msg.sender == governance, "!governance");
        approvedStrategies[_token][_strategy] = false;
    }

    function setConverter(
        address _input,
        address _output,
        address _converter
    ) public {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!strategist"
        );
        converters[_input][_output] = _converter;
    }

    function setStrategy(address _token, address _strategy) public {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!strategist"
        );
        require(approvedStrategies[_token][_strategy] == true, "!approved");

        address _current = strategies[_token];
        if (_current != address(0)) {
            IStrategy(_current).withdrawAll();
        }
        strategies[_token] = _strategy;
    }

    function earn(address _token, uint256 _amount) public {
        address _strategy = strategies[_token];
        address _want = IStrategy(_strategy).want();
        if (_want != _token) {
            address converter = converters[_token][_want];
            IERC20(_token).safeTransfer(converter, _amount);
            _amount = Converter(converter).convert(_strategy);
            IERC20(_want).safeTransfer(_strategy, _amount);
        } else {
            IERC20(_token).safeTransfer(_strategy, _amount);
        }
        IStrategy(_strategy).deposit();
    }

    function balanceOf(address _token) external view returns (uint256) {
        return IStrategy(strategies[_token]).balanceOf();
    }

    function withdrawAll(address _token) public {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!strategist"
        );
        IStrategy(strategies[_token]).withdrawAll();
    }

    function inCaseTokensGetStuck(address _token, uint256 _amount) public {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!governance"
        );
        IERC20(_token).safeTransfer(msg.sender, _amount);
    }

    function inCaseStrategyTokenGetStuck(address _strategy, address _token)
        public
    {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!governance"
        );
        IStrategy(_strategy).withdraw(_token);
    }

    function getExpectedReturn(
        address _strategy,
        address _token,
        uint256 parts
    ) public view returns (uint256 expected) {
        uint256 _balance = IERC20(_token).balanceOf(_strategy);
        address _want = IStrategy(_strategy).want();
        (expected, ) = OneSplitAudit(onesplit).getExpectedReturn(
            _token,
            _want,
            _balance,
            parts,
            0
        );
    }

    // Only allows to withdraw non-core strategy tokens ~ this is over and above normal yield
    function yearn(
        address _strategy,
        address _token,
        uint256 parts
    ) public {
        require(
            msg.sender == strategist || msg.sender == governance,
            "!governance"
        );
        // This contract should never have value in it, but just incase since this is a public call
        uint256 _before = IERC20(_token).balanceOf(address(this));
        IStrategy(_strategy).withdraw(_token);
        uint256 _after = IERC20(_token).balanceOf(address(this));
        if (_after > _before) {
            uint256 _amount = _after.sub(_before);
            address _want = IStrategy(_strategy).want();
            uint256[] memory _distribution;
            uint256 _expected;
            _before = IERC20(_want).balanceOf(address(this));
            IERC20(_token).safeApprove(onesplit, 0);
            IERC20(_token).safeApprove(onesplit, _amount);
            (_expected, _distribution) = OneSplitAudit(onesplit)
                .getExpectedReturn(_token, _want, _amount, parts, 0);
            OneSplitAudit(onesplit).swap(
                _token,
                _want,
                _amount,
                _expected,
                _distribution,
                0
            );
            _after = IERC20(_want).balanceOf(address(this));
            if (_after > _before) {
                _amount = _after.sub(_before);
                uint256 _treasury = _amount.mul(split).div(max);
                earn(_want, _amount.sub(_treasury));
                IERC20(_want).safeTransfer(treasury, _treasury);
            }
        }
    }

    function withdraw(address _token, uint256 _amount) public {
        require(msg.sender == jars[_token], "!jar");
        IStrategy(strategies[_token]).withdraw(_amount);
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/lib/careful-math.sol

pragma solidity ^0.6.0;

/**
  * @title Careful Math
  * @author Compound
  * @notice Derived from OpenZeppelin's SafeMath library
  *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
  */
contract CarefulMath {

    /**
     * @dev Possible error codes that we can return
     */
    enum MathError {
        NO_ERROR,
        DIVISION_BY_ZERO,
        INTEGER_OVERFLOW,
        INTEGER_UNDERFLOW
    }

    /**
    * @dev Multiplies two numbers, returns an error on overflow.
    */
    function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (a == 0) {
            return (MathError.NO_ERROR, 0);
        }

        uint c = a * b;

        if (c / a != b) {
            return (MathError.INTEGER_OVERFLOW, 0);
        } else {
            return (MathError.NO_ERROR, c);
        }
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (b == 0) {
            return (MathError.DIVISION_BY_ZERO, 0);
        }

        return (MathError.NO_ERROR, a / b);
    }

    /**
    * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
    */
    function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (b <= a) {
            return (MathError.NO_ERROR, a - b);
        } else {
            return (MathError.INTEGER_UNDERFLOW, 0);
        }
    }

    /**
    * @dev Adds two numbers, returns an error on overflow.
    */
    function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
        uint c = a + b;

        if (c >= a) {
            return (MathError.NO_ERROR, c);
        } else {
            return (MathError.INTEGER_OVERFLOW, 0);
        }
    }

    /**
    * @dev add a and b and then subtract c
    */
    function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
        (MathError err0, uint sum) = addUInt(a, b);

        if (err0 != MathError.NO_ERROR) {
            return (err0, 0);
        }

        return subUInt(sum, c);
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/lib/exponential.sol

pragma solidity ^0.6.0;

/**
 * @title Exponential module for storing fixed-precision decimals
 * @author Compound
 * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
 *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
 *         `Exp({mantissa: 5100000000000000000})`.
 */
contract Exponential is CarefulMath {
    uint constant expScale = 1e18;
    uint constant doubleScale = 1e36;
    uint constant halfExpScale = expScale/2;
    uint constant mantissaOne = expScale;

    struct Exp {
        uint mantissa;
    }

    struct Double {
        uint mantissa;
    }

    /**
     * @dev Creates an exponential from numerator and denominator values.
     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
     *            or if `denom` is zero.
     */
    function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: rational}));
    }

    /**
     * @dev Adds two exponentials, returning a new exponential.
     */
    function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
        (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);

        return (error, Exp({mantissa: result}));
    }

    /**
     * @dev Subtracts two exponentials, returning a new exponential.
     */
    function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
        (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);

        return (error, Exp({mantissa: result}));
    }

    /**
     * @dev Multiply an Exp by a scalar, returning a new Exp.
     */
    function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
    }

    /**
     * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
     */
    function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(product));
    }

    /**
     * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
     */
    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return addUInt(truncate(product), addend);
    }

    /**
     * @dev Divide an Exp by a scalar, returning a new Exp.
     */
    function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
    }

    /**
     * @dev Divide a scalar by an Exp, returning a new Exp.
     */
    function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
        /*
          We are doing this as:
          getExp(mulUInt(expScale, scalar), divisor.mantissa)
          How it works:
          Exp = a / b;
          Scalar = s;
          `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
        */
        (MathError err0, uint numerator) = mulUInt(expScale, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return getExp(numerator, divisor.mantissa);
    }

    /**
     * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
     */
    function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(fraction));
    }

    /**
     * @dev Multiplies two exponentials, returning a new exponential.
     */
    function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {

        (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        // We add half the scale before dividing so that we get rounding instead of truncation.
        //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
        // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
        (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }

        (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
        // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
        assert(err2 == MathError.NO_ERROR);

        return (MathError.NO_ERROR, Exp({mantissa: product}));
    }

    /**
     * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
     */
    function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
        return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
    }

    /**
     * @dev Multiplies three exponentials, returning a new exponential.
     */
    function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
        (MathError err, Exp memory ab) = mulExp(a, b);
        if (err != MathError.NO_ERROR) {
            return (err, ab);
        }
        return mulExp(ab, c);
    }

    /**
     * @dev Divides two exponentials, returning a new exponential.
     *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
     *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
     */
    function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
        return getExp(a.mantissa, b.mantissa);
    }

    /**
     * @dev Truncates the given exp to a whole number value.
     *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
     */
    function truncate(Exp memory exp) pure internal returns (uint) {
        // Note: We are not using careful math here as we're performing a division that cannot fail
        return exp.mantissa / expScale;
    }

    /**
     * @dev Checks if first Exp is less than second Exp.
     */
    function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
        return left.mantissa < right.mantissa;
    }

    /**
     * @dev Checks if left Exp <= right Exp.
     */
    function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
        return left.mantissa <= right.mantissa;
    }

    /**
     * @dev Checks if left Exp > right Exp.
     */
    function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
        return left.mantissa > right.mantissa;
    }

    /**
     * @dev returns true if Exp is exactly zero
     */
    function isZeroExp(Exp memory value) pure internal returns (bool) {
        return value.mantissa == 0;
    }

    function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
        require(n < 2**224, errorMessage);
        return uint224(n);
    }

    function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(uint a, uint b) pure internal returns (uint) {
        return add_(a, b, "addition overflow");
    }

    function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        uint c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(uint a, uint b) pure internal returns (uint) {
        return sub_(a, b, "subtraction underflow");
    }

    function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
    }

    function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Exp memory b) pure internal returns (uint) {
        return mul_(a, b.mantissa) / expScale;
    }

    function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
    }

    function mul_(Double memory a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Double memory b) pure internal returns (uint) {
        return mul_(a, b.mantissa) / doubleScale;
    }

    function mul_(uint a, uint b) pure internal returns (uint) {
        return mul_(a, b, "multiplication overflow");
    }

    function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        if (a == 0 || b == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, errorMessage);
        return c;
    }

    function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
    }

    function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
        return Exp({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Exp memory b) pure internal returns (uint) {
        return div_(mul_(a, expScale), b.mantissa);
    }

    function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
    }

    function div_(Double memory a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Double memory b) pure internal returns (uint) {
        return div_(mul_(a, doubleScale), b.mantissa);
    }

    function div_(uint a, uint b) pure internal returns (uint) {
        return div_(a, b, "divide by zero");
    }

    function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function fraction(uint a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: div_(mul_(a, doubleScale), b)});
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/interfaces/staking-rewards.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

interface IStakingRewards {
    function balanceOf(address account) external view returns (uint256);

    function earned(address account) external view returns (uint256);

    function exit() external;

    function getReward() external;

    function getRewardForDuration() external view returns (uint256);

    function lastTimeRewardApplicable() external view returns (uint256);

    function lastUpdateTime() external view returns (uint256);

    function notifyRewardAmount(uint256 reward) external;

    function periodFinish() external view returns (uint256);

    function rewardPerToken() external view returns (uint256);

    function rewardPerTokenStored() external view returns (uint256);

    function rewardRate() external view returns (uint256);

    function rewards(address) external view returns (uint256);

    function rewardsDistribution() external view returns (address);

    function rewardsDuration() external view returns (uint256);

    function rewardsToken() external view returns (address);

    function stake(uint256 amount) external;

    function stakeWithPermit(
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function stakingToken() external view returns (address);

    function totalSupply() external view returns (uint256);

    function userRewardPerTokenPaid(address) external view returns (uint256);

    function withdraw(uint256 amount) external;
}

interface IStakingRewardsFactory {
    function deploy(address stakingToken, uint256 rewardAmount) external;

    function isOwner() external view returns (bool);

    function notifyRewardAmount(address stakingToken) external;

    function notifyRewardAmounts() external;

    function owner() external view returns (address);

    function renounceOwnership() external;

    function rewardsToken() external view returns (address);

    function stakingRewardsGenesis() external view returns (uint256);

    function stakingRewardsInfoByStakingToken(address)
        external
        view
        returns (address stakingRewards, uint256 rewardAmount);

    function stakingTokens(uint256) external view returns (address);

    function transferOwnership(address newOwner) external;
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/strategies/strategy-base.sol

pragma solidity ^0.6.7;





// Strategy Contract Basics

abstract contract StrategyBase {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    // Perfomance fee 4.5%
    uint256 public performanceFee = 450;
    uint256 public constant performanceMax = 10000;

    // Withdrawal fee 0.5%
    // - 0.325% to treasury
    // - 0.175% to dev fund
    uint256 public treasuryFee = 325;
    uint256 public constant treasuryMax = 100000;

    uint256 public devFundFee = 175;
    uint256 public constant devFundMax = 100000;

    // Tokens
    address public want;
    address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    // User accounts
    address public governance;
    address public controller;
    address public strategist;
    address public timelock;

    // Dex
    address public univ2Router2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    constructor(
        address _want,
        address _governance,
        address _strategist,
        address _controller,
        address _timelock
    ) public {
        require(_want != address(0));
        require(_governance != address(0));
        require(_strategist != address(0));
        require(_controller != address(0));
        require(_timelock != address(0));

        want = _want;
        governance = _governance;
        strategist = _strategist;
        controller = _controller;
        timelock = _timelock;
    }

    // **** Modifiers **** //

    modifier onlyBenevolent {
        require(
            msg.sender == tx.origin ||
                msg.sender == governance ||
                msg.sender == strategist
        );
        _;
    }

    // **** Views **** //

    function balanceOfWant() public view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }

    function balanceOfPool() public virtual view returns (uint256);

    function balanceOf() public view returns (uint256) {
        return balanceOfWant().add(balanceOfPool());
    }

    function getName() external virtual pure returns (string memory);

    // **** Setters **** //

    function setDevFundFee(uint256 _devFundFee) external {
        require(msg.sender == timelock, "!timelock");
        devFundFee = _devFundFee;
    }

    function setTreasuryFee(uint256 _treasuryFee) external {
        require(msg.sender == timelock, "!timelock");
        treasuryFee = _treasuryFee;
    }

    function setPerformanceFee(uint256 _performanceFee) external {
        require(msg.sender == timelock, "!timelock");
        performanceFee = _performanceFee;
    }

    function setStrategist(address _strategist) external {
        require(msg.sender == governance, "!governance");
        strategist = _strategist;
    }

    function setGovernance(address _governance) external {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function setTimelock(address _timelock) external {
        require(msg.sender == timelock, "!timelock");
        timelock = _timelock;
    }

    function setController(address _controller) external {
        require(msg.sender == timelock, "!timelock");
        controller = _controller;
    }

    // **** State mutations **** //
    function deposit() public virtual;

    // Controller only function for creating additional rewards from dust
    function withdraw(IERC20 _asset) external returns (uint256 balance) {
        require(msg.sender == controller, "!controller");
        require(want != address(_asset), "want");
        balance = _asset.balanceOf(address(this));
        _asset.safeTransfer(controller, balance);
    }

    // Withdraw partial funds, normally used with a jar withdrawal
    function withdraw(uint256 _amount) external {
        require(msg.sender == controller, "!controller");
        uint256 _balance = IERC20(want).balanceOf(address(this));
        if (_balance < _amount) {
            _amount = _withdrawSome(_amount.sub(_balance));
            _amount = _amount.add(_balance);
        }

        uint256 _feeDev = _amount.mul(devFundFee).div(devFundMax);
        IERC20(want).safeTransfer(IController(controller).devfund(), _feeDev);

        uint256 _feeTreasury = _amount.mul(treasuryFee).div(treasuryMax);
        IERC20(want).safeTransfer(
            IController(controller).treasury(),
            _feeTreasury
        );

        address _jar = IController(controller).jars(address(want));
        require(_jar != address(0), "!jar"); // additional protection so we don't burn the funds

        IERC20(want).safeTransfer(_jar, _amount.sub(_feeDev).sub(_feeTreasury));
    }

    // Withdraw all funds, normally used when migrating strategies
    function withdrawAll() external returns (uint256 balance) {
        require(msg.sender == controller, "!controller");
        _withdrawAll();

        balance = IERC20(want).balanceOf(address(this));

        address _jar = IController(controller).jars(address(want));
        require(_jar != address(0), "!jar"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(_jar, balance);
    }

    function _withdrawAll() internal {
        _withdrawSome(balanceOfPool());
    }

    function _withdrawSome(uint256 _amount) internal virtual returns (uint256);

    function harvest() public virtual;

    // **** Emergency functions ****

    function execute(address _target, bytes memory _data)
        public
        payable
        returns (bytes memory response)
    {
        require(msg.sender == timelock, "!timelock");
        require(_target != address(0), "!target");

        // call contract in current context
        assembly {
            let succeeded := delegatecall(
                sub(gas(), 5000),
                _target,
                add(_data, 0x20),
                mload(_data),
                0,
                0
            )
            let size := returndatasize()

            response := mload(0x40)
            mstore(
                0x40,
                add(response, and(add(add(size, 0x20), 0x1f), not(0x1f)))
            )
            mstore(response, size)
            returndatacopy(add(response, 0x20), 0, size)

            switch iszero(succeeded)
                case 1 {
                    // throw if delegatecall failed
                    revert(add(response, 0x20), size)
                }
        }
    }

    // **** Internal functions ****
    function _swapUniswap(
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        require(_to != address(0));

        // Swap with uniswap
        IERC20(_from).safeApprove(univ2Router2, 0);
        IERC20(_from).safeApprove(univ2Router2, _amount);

        address[] memory path;

        if (_from == weth || _to == weth) {
            path = new address[](2);
            path[0] = _from;
            path[1] = _to;
        } else {
            path = new address[](3);
            path[0] = _from;
            path[1] = weth;
            path[2] = _to;
        }

        UniswapRouterV2(univ2Router2).swapExactTokensForTokens(
            _amount,
            0,
            path,
            address(this),
            now.add(60)
        );
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/strategies/compound/strategy-cmpd-dai-v1.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;






contract StrategyCmpdDaiV1 is StrategyBase, Exponential {
    address
        public constant comptroller = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    address public constant lens = 0xd513d22422a3062Bd342Ae374b4b9c20E0a9a074;
    address public constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant comp = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    address public constant cdai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address public constant cether = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;

    // Require a 0.1 buffer between
    // market collateral factor and strategy's collateral factor
    // when leveraging
    uint256 colFactorLeverageBuffer = 100;
    uint256 colFactorLeverageBufferMax = 1000;

    // Allow a 0.05 buffer
    // between market collateral factor and strategy's collateral factor
    // until we have to deleverage
    // This is so we can hit max leverage and keep accruing interest
    uint256 colFactorSyncBuffer = 50;
    uint256 colFactorSyncBufferMax = 1000;

    // Keeper bots
    // Maintain leverage within buffer
    mapping(address => bool) keepers;

    constructor(
        address _governance,
        address _strategist,
        address _controller,
        address _timelock
    )
        public
        StrategyBase(dai, _governance, _strategist, _controller, _timelock)
    {
        // Enter cDAI Market
        address[] memory ctokens = new address[](1);
        ctokens[0] = cdai;
        IComptroller(comptroller).enterMarkets(ctokens);
    }

    // **** Modifiers **** //

    modifier onlyKeepers {
        require(
            keepers[msg.sender] ||
                msg.sender == address(this) ||
                msg.sender == strategist ||
                msg.sender == governance,
            "!keepers"
        );
        _;
    }

    // **** Views **** //

    function getName() external override pure returns (string memory) {
        return "StrategyCompoundDaiV1";
    }

    function getSuppliedView() public view returns (uint256) {
        (, uint256 cTokenBal, , uint256 exchangeRate) = ICToken(cdai)
            .getAccountSnapshot(address(this));

        (, uint256 bal) = mulScalarTruncate(
            Exp({mantissa: exchangeRate}),
            cTokenBal
        );

        return bal;
    }

    function getBorrowedView() public view returns (uint256) {
        return ICToken(cdai).borrowBalanceStored(address(this));
    }

    function balanceOfPool() public override view returns (uint256) {
        uint256 supplied = getSuppliedView();
        uint256 borrowed = getBorrowedView();
        return supplied.sub(borrowed);
    }

    // Given an unleveraged supply balance, return the target
    // leveraged supply balance which is still within the safety buffer
    function getLeveragedSupplyTarget(uint256 supplyBalance)
        public
        view
        returns (uint256)
    {
        uint256 leverage = getMaxLeverage();
        return supplyBalance.mul(leverage).div(1e18);
    }

    function getSafeLeverageColFactor() public view returns (uint256) {
        uint256 colFactor = getMarketColFactor();

        // Collateral factor within the buffer
        uint256 safeColFactor = colFactor.sub(
            colFactorLeverageBuffer.mul(1e18).div(colFactorLeverageBufferMax)
        );

        return safeColFactor;
    }

    function getSafeSyncColFactor() public view returns (uint256) {
        uint256 colFactor = getMarketColFactor();

        // Collateral factor within the buffer
        uint256 safeColFactor = colFactor.sub(
            colFactorSyncBuffer.mul(1e18).div(colFactorSyncBufferMax)
        );

        return safeColFactor;
    }

    function getMarketColFactor() public view returns (uint256) {
        (, uint256 colFactor) = IComptroller(comptroller).markets(cdai);

        return colFactor;
    }

    // Max leverage we can go up to, w.r.t safe buffer
    function getMaxLeverage() public view returns (uint256) {
        uint256 safeLeverageColFactor = getSafeLeverageColFactor();

        // Infinite geometric series
        uint256 leverage = uint256(1e36).div(1e18 - safeLeverageColFactor);
        return leverage;
    }

    // **** Pseudo-view functions (use `callStatic` on these) **** //
    /* The reason why these exists is because of the nature of the
       interest accruing supply + borrow balance. The "view" methods
       are technically snapshots and don't represent the real value.
       As such there are pseudo view methods where you can retrieve the
       results by calling `callStatic`.
    */

    function getCompAccrued() public returns (uint256) {
        (, , , uint256 accrued) = ICompoundLens(lens).getCompBalanceMetadataExt(
            comp,
            comptroller,
            address(this)
        );

        return accrued;
    }

    function getColFactor() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        return borrowed.mul(1e18).div(supplied);
    }

    function getSuppliedUnleveraged() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        return supplied.sub(borrowed);
    }

    function getSupplied() public returns (uint256) {
        return ICToken(cdai).balanceOfUnderlying(address(this));
    }

    function getBorrowed() public returns (uint256) {
        return ICToken(cdai).borrowBalanceCurrent(address(this));
    }

    function getBorrowable() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        (, uint256 colFactor) = IComptroller(comptroller).markets(cdai);

        // 99.99% just in case some dust accumulates
        return
            supplied.mul(colFactor).div(1e18).sub(borrowed).mul(9999).div(
                10000
            );
    }

    function getCurrentLeverage() public returns (uint256) {
        uint256 supplied = getSupplied();
        uint256 borrowed = getBorrowed();

        return supplied.mul(1e18).div(supplied.sub(borrowed));
    }

    // **** Setters **** //

    function addKeeper(address _keeper) public {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!governance"
        );
        keepers[_keeper] = true;
    }

    function removeKeeper(address _keeper) public {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!governance"
        );
        keepers[_keeper] = false;
    }

    function setColFactorLeverageBuffer(uint256 _colFactorLeverageBuffer)
        public
    {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!governance"
        );
        colFactorLeverageBuffer = _colFactorLeverageBuffer;
    }

    function setColFactorSyncBuffer(uint256 _colFactorSyncBuffer) public {
        require(
            msg.sender == governance || msg.sender == strategist,
            "!governance"
        );
        colFactorSyncBuffer = _colFactorSyncBuffer;
    }

    // **** State mutations **** //

    // Do a `callStatic` on this.
    // If it returns true then run it for realz. (i.e. eth_signedTx, not eth_call)
    function sync() public returns (bool) {
        uint256 colFactor = getColFactor();
        uint256 safeSyncColFactor = getSafeSyncColFactor();

        // If we're not safe
        if (colFactor > safeSyncColFactor) {
            uint256 unleveragedSupply = getSuppliedUnleveraged();
            uint256 idealSupply = getLeveragedSupplyTarget(unleveragedSupply);

            deleverageUntil(idealSupply);

            return true;
        }

        return false;
    }

    function leverageToMax() public {
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        uint256 idealSupply = getLeveragedSupplyTarget(unleveragedSupply);
        leverageUntil(idealSupply);
    }

    // Leverages until we're supplying <x> amount
    // 1. Redeem <x> DAI
    // 2. Repay <x> DAI
    function leverageUntil(uint256 _supplyAmount) public onlyKeepers {
        // 1. Borrow out <X> DAI
        // 2. Supply <X> DAI

        uint256 leverage = getMaxLeverage();
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        require(
            _supplyAmount >= unleveragedSupply &&
                _supplyAmount <= unleveragedSupply.mul(leverage).div(1e18),
            "!leverage"
        );

        // Since we're only leveraging one asset
        // Supplied = borrowed
        uint256 _borrowAndSupply;
        uint256 supplied = getSupplied();
        while (supplied < _supplyAmount) {
            _borrowAndSupply = getBorrowable();

            if (supplied.add(_borrowAndSupply) > _supplyAmount) {
                _borrowAndSupply = _supplyAmount.sub(supplied);
            }

            ICToken(cdai).borrow(_borrowAndSupply);
            deposit();

            supplied = supplied.add(_borrowAndSupply);
        }
    }

    function deleverageToMin() public {
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        deleverageUntil(unleveragedSupply);
    }

    // Deleverages until we're supplying <x> amount
    // 1. Redeem <x> DAI
    // 2. Repay <x> DAI
    function deleverageUntil(uint256 _supplyAmount) public onlyKeepers {
        uint256 unleveragedSupply = getSuppliedUnleveraged();
        uint256 supplied = getSupplied();
        require(
            _supplyAmount >= unleveragedSupply && _supplyAmount <= supplied,
            "!deleverage"
        );

        // Since we're only leveraging on 1 asset
        // redeemable = borrowable
        uint256 _redeemAndRepay = getBorrowable();
        do {
            if (supplied.sub(_redeemAndRepay) < _supplyAmount) {
                _redeemAndRepay = supplied.sub(_supplyAmount);
            }

            require(
                ICToken(cdai).redeemUnderlying(_redeemAndRepay) == 0,
                "!redeem"
            );
            IERC20(dai).safeApprove(cdai, 0);
            IERC20(dai).safeApprove(cdai, _redeemAndRepay);
            require(ICToken(cdai).repayBorrow(_redeemAndRepay) == 0, "!repay");

            supplied = supplied.sub(_redeemAndRepay);
        } while (supplied > _supplyAmount);
    }

    function harvest() public override onlyBenevolent {
        address[] memory ctokens = new address[](1);
        ctokens[0] = cdai;

        IComptroller(comptroller).claimComp(address(this), ctokens);
        uint256 _comp = IERC20(comp).balanceOf(address(this));
        if (_comp > 0) {
            _swapUniswap(comp, want, _comp);
        }

        uint256 _want = IERC20(want).balanceOf(address(this));
        if (_want > 0) {
            // Fees 4.5% goes to treasury
            IERC20(want).safeTransfer(
                IController(controller).treasury(),
                _want.mul(performanceFee).div(performanceMax)
            );

            deposit();
        }
    }

    function deposit() public override {
        uint256 _want = IERC20(want).balanceOf(address(this));
        if (_want > 0) {
            IERC20(want).safeApprove(cdai, 0);
            IERC20(want).safeApprove(cdai, _want);
            require(ICToken(cdai).mint(_want) == 0, "!deposit");
        }
    }

    function _withdrawSome(uint256 _amount)
        internal
        override
        returns (uint256)
    {
        uint256 _want = balanceOfWant();
        if (_want < _amount) {
            uint256 _redeem = _amount.sub(_want);

            // Make sure market can cover liquidity
            require(ICToken(cdai).getCash() >= _redeem, "!cash-liquidity");

            // How much borrowed amount do we need to free?
            uint256 borrowed = getBorrowed();
            uint256 supplied = getSupplied();
            uint256 curLeverage = getCurrentLeverage();
            uint256 borrowedToBeFree = _redeem.mul(curLeverage).div(1e18);

            // If the amount we need to free is > borrowed
            // Just free up all the borrowed amount
            if (borrowedToBeFree > borrowed) {
                this.deleverageToMin();
            } else {
                // Otherwise just keep freeing up borrowed amounts until
                // we hit a safe number to redeem our underlying
                this.deleverageUntil(supplied.sub(borrowedToBeFree));
            }

            // Redeems underlying
            require(ICToken(cdai).redeemUnderlying(_redeem) == 0, "!redeem");
        }

        return _amount;
    }
}

// File: ../sc_datasets/DAppSCAN/HAECHI_AUDIT-Pickle_Finance/protocol-9b0f330a16bc35c964211feae3b335ab398c01b6/src/tests/strategies/compound/strategy-cmpnd-dai-v1.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;





contract StrategyCmpndDaiV1 is DSTestDefiBase {
    StrategyCmpdDaiV1 strategy;
    ControllerV3 controller;
    PickleJar pickleJar;

    address governance;
    address strategist;
    address timelock;
    address devfund;
    address treasury;

    address want;

    function setUp() public {
        want = dai;

        governance = address(this);
        strategist = address(new User());
        timelock = address(this);
        devfund = address(new User());
        treasury = address(new User());

        controller = new ControllerV3(
            governance,
            strategist,
            timelock,
            devfund,
            treasury
        );

        strategy = new StrategyCmpdDaiV1(
            governance,
            strategist,
            address(controller),
            timelock
        );

        pickleJar = new PickleJar(
            strategy.want(),
            governance,
            timelock,
            address(controller)
        );

        controller.setJar(strategy.want(), address(pickleJar));
        controller.approveStrategy(strategy.want(), address(strategy));
        controller.setStrategy(strategy.want(), address(strategy));
    }

    function testFail_cmpnd_dai_v1_onlyKeeper_leverage() public {
        _getERC20(want, 100e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);

        User randomUser = new User();
        randomUser.execute(address(strategy), 0, "leverageToMax()", "");
    }

    function testFail_cmpnd_dai_v1_onlyKeeper_deleverage() public {
        _getERC20(want, 100e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        strategy.leverageToMax();

        User randomUser = new User();
        randomUser.execute(address(strategy), 0, "deleverageToMin()", "");
    }

    function test_cmpnd_dai_v1_comp_accrued() public {
        _getERC20(want, 1000000e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();

        strategy.leverageToMax();

        uint256 compAccrued = strategy.getCompAccrued();

        assertEq(compAccrued, 0);

        hevm.warp(block.timestamp + 1 days);
        hevm.roll(block.number + 6171); // Roughly number of blocks per day

        compAccrued = strategy.getCompAccrued();
        assertTrue(compAccrued > 0);
    }

    function test_cmpnd_dai_v1_comp_sync() public {
        _getERC20(want, 1000000e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();

        // Sets colFactor Buffer to be 3% (safeSync is 5%)
        strategy.setColFactorLeverageBuffer(30);
        strategy.leverageToMax();
        // Back to 10%
        strategy.setColFactorLeverageBuffer(100);

        uint256 colFactor = strategy.getColFactor();
        uint256 safeColFactor = strategy.getSafeLeverageColFactor();
        assertTrue(colFactor > safeColFactor);

        // Sync automatically fixes the colFactor for us
        bool shouldSync = strategy.sync();
        assertTrue(shouldSync);

        colFactor = strategy.getColFactor();
        assertEqApprox(colFactor, safeColFactor);

        shouldSync = strategy.sync();
        assertTrue(!shouldSync);
    }

    function test_cmpnd_dai_v1_leverage() public {
        _getERC20(want, 100e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();

        uint256 _stratInitialBal = strategy.balanceOf();

        uint256 _beforeCR = strategy.getColFactor();
        uint256 _beforeLev = strategy.getCurrentLeverage();
        strategy.leverageToMax();
        uint256 _afterCR = strategy.getColFactor();
        uint256 _afterLev = strategy.getCurrentLeverage();
        uint256 _safeLeverageColFactor = strategy.getSafeLeverageColFactor();

        assertTrue(_afterCR > _beforeCR);
        assertTrue(_afterLev > _beforeLev);
        assertEqApprox(_safeLeverageColFactor, _afterCR);

        uint256 _maxLeverage = strategy.getMaxLeverage();
        assertTrue(_maxLeverage > 2e18); // Should be ~2.6, depending on colFactorLeverageBuffer

        uint256 leverageTarget = strategy.getLeveragedSupplyTarget(
            _stratInitialBal
        );
        uint256 leverageSupplied = strategy.getSupplied();
        assertEqApprox(
            leverageSupplied,
            _stratInitialBal.mul(_maxLeverage).div(1e18)
        );
        assertEqApprox(leverageSupplied, leverageTarget);

        uint256 unleveragedSupplied = strategy.getSuppliedUnleveraged();
        assertEqApprox(unleveragedSupplied, _stratInitialBal);
    }

    function test_cmpnd_dai_v1_deleverage() public {
        _getERC20(want, 100e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();
        strategy.leverageToMax();

        uint256 _beforeCR = strategy.getColFactor();
        uint256 _beforeLev = strategy.getCurrentLeverage();
        strategy.deleverageToMin();
        uint256 _afterCR = strategy.getColFactor();
        uint256 _afterLev = strategy.getCurrentLeverage();

        assertTrue(_afterCR < _beforeCR);
        assertTrue(_afterLev < _beforeLev);
        assertEq(0, _afterCR); // 0 since we're not borrowing anything

        uint256 unleveragedSupplied = strategy.getSuppliedUnleveraged();
        uint256 supplied = strategy.getSupplied();
        assertEqApprox(unleveragedSupplied, supplied);
    }

    function test_cmpnd_dai_v1_withdrawSome() public {
        _getERC20(want, 100e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();
        strategy.leverageToMax();

        uint256 _before = IERC20(want).balanceOf(address(this));
        pickleJar.withdraw(25e18);
        uint256 _after = IERC20(want).balanceOf(address(this));

        assertTrue(_after > _before);
        assertEqApprox(_after.sub(_before), 25e18);

        _before = IERC20(want).balanceOf(address(this));
        pickleJar.withdraw(10e18);
        _after = IERC20(want).balanceOf(address(this));

        assertTrue(_after > _before);
        assertEqApprox(_after.sub(_before), 10e18);

        _before = IERC20(want).balanceOf(address(this));
        pickleJar.withdraw(30e18);
        _after = IERC20(want).balanceOf(address(this));

        assertTrue(_after > _before);
        assertEqApprox(_after.sub(_before), 30e18);

        // Make sure we're still leveraging
        uint256 _leverage = strategy.getCurrentLeverage();
        assertTrue(_leverage > 1e18);
    }

    function test_cmpnd_dai_v1_withdrawAll() public {
        _getERC20(want, 100e18);

        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();

        strategy.leverageToMax();

        hevm.warp(block.timestamp + 1 days);
        hevm.roll(block.number + 6171); // Roughly number of blocks per day

        strategy.harvest();

        // Withdraws back to pickleJar
        uint256 _before = IERC20(want).balanceOf(address(pickleJar));
        controller.withdrawAll(want);
        uint256 _after = IERC20(want).balanceOf(address(pickleJar));

        assertTrue(_after > _before);

        _before = IERC20(want).balanceOf(address(this));
        pickleJar.withdrawAll();
        _after = IERC20(want).balanceOf(address(this));

        assertTrue(_after > _before);

        // Gained some interest
        assertTrue(_after > _want);
    }

    function test_cmpnd_dai_v1_earn_harvest_rewards() public {
        _getERC20(want, 100e18);

        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();

        // Fast forward one week
        hevm.warp(block.timestamp + 1 days);
        hevm.roll(block.number + 6171); // Roughly number of blocks per day

        // Call the harvest function
        uint256 _before = strategy.getSupplied();
        uint256 _treasuryBefore = IERC20(want).balanceOf(treasury);
        strategy.harvest();
        uint256 _after = strategy.getSupplied();
        uint256 _treasuryAfter = IERC20(want).balanceOf(treasury);

        uint256 earned = _after.sub(_before).mul(1000).div(955);
        uint256 earnedRewards = earned.mul(45).div(1000); // 4.5%
        uint256 actualRewardsEarned = _treasuryAfter.sub(_treasuryBefore);

        // 4.5% performance fee is given
        assertEqApprox(earnedRewards, actualRewardsEarned);

        // Withdraw
        uint256 _devBefore = IERC20(want).balanceOf(devfund);
        _treasuryBefore = IERC20(want).balanceOf(treasury);
        uint256 _stratBal = strategy.balanceOf();
        pickleJar.withdrawAll();
        uint256 _devAfter = IERC20(want).balanceOf(devfund);
        _treasuryAfter = IERC20(want).balanceOf(treasury);

        // 0.175% goes to dev
        uint256 _devFund = _devAfter.sub(_devBefore);
        assertEq(_devFund, _stratBal.mul(175).div(100000));

        // 0.325% goes to treasury
        uint256 _treasuryFund = _treasuryAfter.sub(_treasuryBefore);
        assertEq(_treasuryFund, _stratBal.mul(325).div(100000));
    }

    function test_cmpnd_dai_v1_functions() public {
        _getERC20(want, 100e18);

        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();

        uint256 initialSupplied = strategy.getSupplied();
        uint256 initialBorrowed = strategy.getBorrowed();
        uint256 initialBorrowable = strategy.getBorrowable();
        uint256 marketColFactor = strategy.getMarketColFactor();
        uint256 maxLeverage = strategy.getMaxLeverage();

        // Earn deposits 95% into strategy
        assertEqApprox(initialSupplied, 95e18);
        assertEqApprox(
            initialBorrowable,
            initialSupplied.mul(marketColFactor).div(1e18)
        );
        assertEqApprox(initialBorrowed, 0);

        // Leverage to Max
        strategy.leverageToMax();

        uint256 supplied = strategy.getSupplied();
        uint256 borrowed = strategy.getBorrowed();
        uint256 borrowable = strategy.getBorrowable();
        uint256 currentColFactor = strategy.getColFactor();
        uint256 safeLeverageColFactor = strategy.getSafeLeverageColFactor();

        assertEqApprox(supplied, initialSupplied.mul(maxLeverage).div(1e18));
        assertEqApprox(borrowed, supplied.mul(safeLeverageColFactor).div(1e18));
        assertEqApprox(
            borrowable,
            supplied.mul(marketColFactor.sub(currentColFactor)).div(1e18)
        );
        assertEqApprox(currentColFactor, safeLeverageColFactor);
        assertTrue(marketColFactor > currentColFactor);
        assertTrue(marketColFactor > safeLeverageColFactor);

        // Deleverage
        strategy.deleverageToMin();

        uint256 deleverageSupplied = strategy.getSupplied();
        uint256 deleverageBorrowed = strategy.getBorrowed();
        uint256 deleverageBorrowable = strategy.getBorrowable();

        assertEqApprox(deleverageSupplied, initialSupplied);
        assertEqApprox(deleverageBorrowed, initialBorrowed);
        assertEqApprox(deleverageBorrowable, initialBorrowable);
    }

    function test_cmpnd_dai_v1_deleverage_stepping() public {
        _getERC20(want, 100e18);
        uint256 _want = IERC20(want).balanceOf(address(this));
        IERC20(want).approve(address(pickleJar), _want);
        pickleJar.deposit(_want);
        pickleJar.earn();
        strategy.leverageToMax();

        strategy.deleverageUntil(200e18);
        uint256 supplied = strategy.getSupplied();
        assertEqApprox(supplied, 200e18);

        strategy.deleverageUntil(180e18);
        supplied = strategy.getSupplied();
        assertEqApprox(supplied, 180e18);

        strategy.deleverageUntil(120e18);
        supplied = strategy.getSupplied();
        assertEqApprox(supplied, 120e18);
    }
}
