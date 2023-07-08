// File: openzeppelin-solidity/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;



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
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
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
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
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
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
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
     * Requirements:
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
     * Requirements:
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
    function _setupDecimals(uint8 decimals_) internal virtual {
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

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/interfaces/IAZTEC.sol

pragma solidity >=0.5.0 <0.6.0;

contract IAZTEC {
    enum ProofCategory {
        NULL,
        BALANCED,
        MINT,
        BURN,
        UTILITY
    }

    enum NoteStatus {
        DOES_NOT_EXIST,
        UNSPENT,
        SPENT
    }
    // proofEpoch = 1 | proofCategory = 1 | proofId = 1
    // 1 * 256**(2) + 1 * 256**(1) ++ 1 * 256**(0)
    uint24 public constant JOIN_SPLIT_PROOF = 65793;

    // proofEpoch = 1 | proofCategory = 2 | proofId = 1
    // (1 * 256**(2)) + (2 * 256**(1)) + (1 * 256**(0))
    uint24 public constant MINT_PROOF = 66049;

    // proofEpoch = 1 | proofCategory = 3 | proofId = 1
    // (1 * 256**(2)) + (3 * 256**(1)) + (1 * 256**(0))
    uint24 public constant BURN_PROOF = 66305;

    // Hash of a dummy AZTEC note with k = 0 and a = 1
    bytes32 public constant ZERO_VALUE_NOTE_HASH = 0xcbc417524e52b95c42a4c42d357938497e3d199eb9b4a0139c92551d4000bc3c;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/libs/NoteUtils.sol

pragma solidity >=0.5.0 <0.6.0;

/**
 * @title NoteUtils
 * @author AZTEC
 * @dev NoteUtils is a utility library that extracts user-readable information from AZTEC proof outputs.
 *      Specifically, `bytes proofOutput` objects can be extracted from `bytes proofOutputs`,
 *      `bytes proofOutput` and `bytes note` can be extracted into their constituent components,
 **/
library NoteUtils {

    /**
    * @dev Get the number of entries in an AZTEC-ABI array (bytes proofOutputs, bytes inputNotes, bytes outputNotes)
    *      All 3 are rolled into a single function to eliminate 'wet' code - the implementations are identical
    * @param _proofOutputsOrNotes `proofOutputs`, `inputNotes` or `outputNotes`
    * @return number of entries in the pseudo dynamic array
    */
    function getLength(bytes memory _proofOutputsOrNotes) internal pure returns (
        uint len
    ) {
        assembly {
            // first word = the raw byte length
            // second word = the actual number of entries (hence the 0x20 offset)
            len := mload(add(_proofOutputsOrNotes, 0x20))
        }
    }

    /**
    * @dev Get a bytes object out of a dynamic AZTEC-ABI array
    * @param _proofOutputsOrNotes `proofOutputs`, `inputNotes` or `outputNotes`
    * @param _i the desired entry
    * @return number of entries in the pseudo dynamic array
    */
    function get(bytes memory _proofOutputsOrNotes, uint _i) internal pure returns (
        bytes memory out
    ) {
        bool valid;
        assembly {
            // check that i < the number of entries
            valid := lt(
                _i,
                mload(add(_proofOutputsOrNotes, 0x20))
            )
            // memory map of the array is as follows:
            // 0x00 - 0x20 : byte length of array
            // 0x20 - 0x40 : n, the number of entries
            // 0x40 - 0x40 + (0x20 * i) : relative memory offset to start of i'th entry (i <= n)

            // Step 1: compute location of relative memory offset: _proofOutputsOrNotes + 0x40 + (0x20 * i) 
            // Step 2: loaded relative offset and add to _proofOutputsOrNotes to get absolute memory location
            out := add(
                mload(
                    add(
                        add(_proofOutputsOrNotes, 0x40),
                        mul(_i, 0x20)
                    )
                ),
                _proofOutputsOrNotes
            )
        }
        require(valid, "AZTEC array index is out of bounds");
    }

    /**
    * @dev Extract constituent elements of a `bytes _proofOutput` object
    * @param _proofOutput an AZTEC proof output
    * @return inputNotes, AZTEC-ABI dynamic array of input AZTEC notes
    * @return outputNotes, AZTEC-ABI dynamic array of output AZTEC notes
    * @return publicOwner, the Ethereum address of the owner of any public tokens involved in the proof
    * @return publicValue, the amount of public tokens involved in the proof
    *         if (publicValue > 0), this represents a transfer of tokens from ACE to publicOwner
    *         if (publicValue < 0), this represents a transfer of tokens from publicOwner to ACE
    */
    function extractProofOutput(bytes memory _proofOutput) internal pure returns (
        bytes memory inputNotes,
        bytes memory outputNotes,
        address publicOwner,
        int256 publicValue
    ) {
        assembly {
            // memory map of a proofOutput:
            // 0x00 - 0x20 : byte length of proofOutput
            // 0x20 - 0x40 : relative offset to inputNotes
            // 0x40 - 0x60 : relative offset to outputNotes
            // 0x60 - 0x80 : publicOwner
            // 0x80 - 0xa0 : publicValue
            // 0xa0 - 0xc0 : challenge
            inputNotes := add(_proofOutput, mload(add(_proofOutput, 0x20)))
            outputNotes := add(_proofOutput, mload(add(_proofOutput, 0x40)))
            publicOwner := and(
                mload(add(_proofOutput, 0x60)),
                0xffffffffffffffffffffffffffffffffffffffff
            )
            publicValue := mload(add(_proofOutput, 0x80))
        }
    }

    /**
    * @dev Extract the challenge from a bytes proofOutput variable
    * @param _proofOutput bytes proofOutput, outputted from a proof validation smart contract
    * @return bytes32 challenge - cryptographic variable that is part of the sigma protocol
    */
    function extractChallenge(bytes memory _proofOutput) internal pure returns (
        bytes32 challenge
    ) {
        assembly {
            challenge := mload(add(_proofOutput, 0xa0))
        }
    }

    /**
    * @dev Extract constituent elements of an AZTEC note
    * @param _note an AZTEC note
    * @return owner, Ethereum address of note owner
    * @return noteHash, the hash of the note's public key
    * @return metadata, note-specific metadata (contains public key and any extra data needed by note owner)
    */
    function extractNote(bytes memory _note) internal pure returns (
            address owner,
            bytes32 noteHash,
            bytes memory metadata
    ) {
        assembly {
            // memory map of a note:
            // 0x00 - 0x20 : byte length of note
            // 0x20 - 0x40 : note type
            // 0x40 - 0x60 : owner
            // 0x60 - 0x80 : noteHash
            // 0x80 - 0xa0 : start of metadata byte array
            owner := and(
                mload(add(_note, 0x40)),
                0xffffffffffffffffffffffffffffffffffffffff
            )
            noteHash := mload(add(_note, 0x60))
            metadata := add(_note, 0x80)
        }
    }
    
    /**
    * @dev Get the note type
    * @param _note an AZTEC note
    * @return noteType
    */
    function getNoteType(bytes memory _note) internal pure returns (
        uint256 noteType
    ) {
        assembly {
            noteType := mload(add(_note, 0x20))
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/libs/ProofUtils.sol

pragma solidity >= 0.5.0 <0.6.0;

/**
 * @title Library of proof utility functions
 * @author AZTEC
 * Copyright Spilbury Holdings Ltd 2019. All rights reserved.
 **/
library ProofUtils {

    /**
     * @dev We compress three uint8 numbers into only one uint24 to save gas.
     * Reverts if the category is not one of [1, 2, 3, 4].
     * @param proof The compressed uint24 number.
     * @return A tuple (uint8, uint8, uint8) representing the epoch, category and proofId.
     */
    function getProofComponents(uint24 proof) internal pure returns (uint8 epoch, uint8 category, uint8 id) {
        assembly {
            id := and(proof, 0xff)
            category := and(div(proof, 0x100), 0xff)
            epoch := and(div(proof, 0x10000), 0xff)
        }
        return (epoch, category, id);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/ACE/NoteRegistry.sol

pragma solidity >=0.5.0 <0.6.0;




/**
 * @title NoteRegistry contract which contains the storage variables that define the set of valid
 * AZTEC notes for a particular address
 * @author AZTEC
 * @dev The NoteRegistry defines the state of valid AZTEC notes. It enacts instructions to update the 
 * state, given to it by the ACE and only the note registry owner can enact a state update.  
 * Copyright Spilbury Holdings Ltd 2019. All rights reserved.
 **/
contract NoteRegistry is IAZTEC {
    using NoteUtils for bytes;
    using SafeMath for uint256;
    using ProofUtils for uint24;

    /**
    * Note struct. This is the data that we store when we log AZTEC notes inside a NoteRegistry
    *
    * Data structured so that the entire struct fits in 1 storage word.
    *
    * @notice Yul is used to pack and unpack Note structs in storage for efficiency reasons,
    *   see `NoteRegistry.updateInputNotes` and `NoteRegistry.updateOutputNotes` for more details
    **/
    struct Note {
        // `status` uses the IAZTEC.NoteStatus enum to track the lifecycle of a note.
        uint8 status;

        // `createdOn` logs the timestamp of the block that created this note. There are a few
        // use cases that require measuring the age of a note, (e.g. interest rate computations).
        // These lifetime are relevant on timescales of days/months, the 900-ish seconds that a miner
        // can manipulate a timestamp has little effect, but should be considered when utilizing this parameter.
        // We store `createdOn` in 5 bytes of data - just in case this contract is still around in 2038 :)
        // This kicks the 'year 2038' problem down the road by about 400 years
        uint40 createdOn;

        // `destroyedOn` logs the timestamp of the block that destroys this note in a transaction.
        // Default value is 0x0000000000 for notes that have not been spent.
        uint40 destroyedOn;

        // The owner of the note
        address owner;
    }

    struct Flags {
        bool active;
        bool canAdjustSupply;
        bool canConvert;
    }

    struct Registry {
        IERC20 linkedToken;
        uint256 scalingFactor;
        uint256 totalSupply;
        bytes32 confidentialTotalMinted;
        bytes32 confidentialTotalBurned;
        uint256 supplementTotal;
        Flags flags;
        mapping(bytes32 => Note) notes;
        mapping(address => mapping(bytes32 => uint256)) publicApprovals;
    }

    // Every user has their own note registry
    mapping(address => Registry) internal registries;

    mapping(bytes32 => bool) public validatedProofs;

    /**
    * @dev Call transferFrom on a linked ERC20 token. Used in cases where the ACE's mint
    * function is called but the token balance of the note registry in question is
    * insufficient
    *
    * @param _value the value to be transferred
    */
    function supplementTokens(uint256 _value) external {
        Registry storage registry = registries[msg.sender];
        require(registry.flags.active == true, "note registry does not exist for the given address");
        require(registry.flags.canConvert == true, "note registry does not have conversion rights");
        
        // Only scenario where supplementTokens() should be called is when a mint/burn operation has been executed
        require(registry.flags.canAdjustSupply == true, "note registry does not have mint and burn rights");
        
        registry.linkedToken.transferFrom(msg.sender, address(this), _value.mul(registry.scalingFactor));

        registry.totalSupply = registry.totalSupply.add(_value);
    }

    /**
    * @dev Query the ACE for a previously validated proof
    * @notice This is a virtual function, that must be overwritten by the contract that inherits from NoteRegistr
    *
    * @param _proof - unique identifier for the proof in question and being validated
    * @param _proofHash - keccak256 hash of a bytes proofOutput argument. Used to identify the proof in question
    * @param _sender - address of the entity that originally validated the proof
    * @return boolean - true if the proof has previously been validated, false if not
    */
    function validateProofByHash(uint24 _proof, bytes32 _proofHash, address _sender) public view returns (bool);

    function createNoteRegistry(
        address _linkedTokenAddress,
        uint256 _scalingFactor,
        bool _canAdjustSupply,
        bool _canConvert
    ) public {
        require(registries[msg.sender].flags.active == false, "address already has a linked note registry");
        if (_canConvert) {
            require(_linkedTokenAddress != address(0x0), "expected the linked token address to exist");
        }
        Registry memory registry = Registry({
            linkedToken: IERC20(_linkedTokenAddress),
            scalingFactor: _scalingFactor,
            totalSupply: 0,
            confidentialTotalMinted: ZERO_VALUE_NOTE_HASH,
            confidentialTotalBurned: ZERO_VALUE_NOTE_HASH,
            supplementTotal: 0,
            flags: Flags({
                active: true,
                canAdjustSupply: _canAdjustSupply,
                canConvert: _canConvert
            })
        });
        registries[msg.sender] = registry;
    }

    /**
    * @dev Update the state of the note registry according to transfer instructions issued by a 
    * zero-knowledge proof
    *
    * @param _proof - unique identifier for a proof
    * @param _proofOutput - transfer instructions issued by a zero-knowledge proof
    * @param _proofSender - address of the entity sending the proof
    */
    function updateNoteRegistry(
        uint24 _proof,
        bytes memory _proofOutput,
        address _proofSender
    ) public {
        Registry storage registry = registries[msg.sender];
        Flags memory flags = registry.flags;
        require(flags.active == true, "note registry does not exist for the given address");
        bytes32 proofHash = keccak256(_proofOutput);
        require(
            validateProofByHash(_proof, proofHash, _proofSender) == true,
            "ACE has not validated a matching proof"
        );
        
        // clear record of valid proof - stops re-entrancy attacks and saves some gas
        validatedProofs[proofHash] = false;
        
        (bytes memory inputNotes,
        bytes memory outputNotes,
        address publicOwner,
        int256 publicValue) = _proofOutput.extractProofOutput();

        updateInputNotes(inputNotes);
        updateOutputNotes(outputNotes);

        // If publicValue != 0, enact a token transfer
        // (publicValue < 0) => transfer from publicOwner to ACE
        // (publicValue > 0) => transfer from ACE to publicOwner
        if (publicValue != 0) {
            require(flags.canConvert == true, "asset cannot be converted into public tokens");

            if (publicValue < 0) {
                uint256 publicApprovals = registry.publicApprovals[publicOwner][proofHash];
                registry.totalSupply = registry.totalSupply.add(uint256(-publicValue));
                require(
                    publicApprovals >= uint256(-publicValue),
                    "public owner has not validated a transfer of tokens"
                );
                // TODO: redundant step
                registry.publicApprovals[publicOwner][proofHash] = publicApprovals.sub(uint256(-publicValue));
                registry.linkedToken.transferFrom(
                    publicOwner,
                    address(this),
                    uint256(-publicValue).mul(registry.scalingFactor));
            } else {
                registry.totalSupply = registry.totalSupply.sub(uint256(publicValue));
                registry.linkedToken.transfer(publicOwner, uint256(publicValue).mul(registry.scalingFactor));
            }
        }
    }

    /** 
    * @dev This should be called from an asset contract.
    */
    function publicApprove(address _registryOwner, bytes32 _proofHash, uint256 _value) public {
        Registry storage registry = registries[_registryOwner];
        require(registry.flags.active == true, "note registry does not exist");
        registry.publicApprovals[msg.sender][_proofHash] = _value;
    }

    /**
     * @dev Returns the registry for a given address.
     *
     * @param _owner - address of the registry owner in question
     * @return linkedTokenAddress - public ERC20 token that is linked to the NoteRegistry. This is used to
     * transfer public value into and out of the system     
     * @return scalingFactor - defines how many ERC20 tokens are represented by one AZTEC note
     * @return totalSupply - TODO
     * @return confidentialTotalMinted - keccak256 hash of the note representing the total minted supply
     * @return confidentialTotalBurned - keccak256 hash of the note representing the total burned supply
     * @return canConvert - flag set by the owner to decide whether the registry has public to private, and 
     * vice versa, conversion privilege
     * @return canAdjustSupply - determines whether the registry has minting and burning privileges 
     */
    function getRegistry(address _owner) public view returns (
        address linkedToken,
        uint256 scalingFactor,
        uint256 totalSupply,
        bytes32 confidentialTotalMinted,
        bytes32 confidentialTotalBurned,
        bool canConvert,
        bool canAdjustSupply
    ) {
        require(registries[_owner].flags.active == true, "expected registry to be created");
        Registry memory registry = registries[_owner];
        return (
            address(registry.linkedToken),
            registry.scalingFactor,
            registry.totalSupply,
            registry.confidentialTotalMinted,
            registry.confidentialTotalBurned,
            registry.flags.canConvert,
            registry.flags.canAdjustSupply
        );
    }

    /**
     * @dev Returns the note for a given address and note hash.
     *
     * @param _registryOwner - address of the registry owner
     * @param _noteHash - keccak256 hash of the note coordiantes (gamma and sigma)
     * @return status - status of the note, details whether the note is in a note registry
     * or has been destroyed
     * @return createdOn - time the note was created
     * @return destroyedOn - time the note was destroyed
     * @return noteOwner - address of the note owner
     */
    function getNote(address _registryOwner, bytes32 _noteHash) public view returns (
        uint8 status,
        uint40 createdOn,
        uint40 destroyedOn,
        address noteOwner
    ) {
        require(
            registries[_registryOwner].notes[_noteHash].status != uint8(NoteStatus.DOES_NOT_EXIST), 
            "expected note to exist"
        );
        // Load out a note for a given registry owner. Struct unpacking is done in Yul to improve efficiency
        // solhint-disable-next-line no-unused-vars
        Note storage notePtr = registries[_registryOwner].notes[_noteHash];
        assembly {
            let note := sload(notePtr_slot)
            status := and(note, 0xff)
            createdOn := and(shr(8, note), 0xffffffffff)
            destroyedOn := and(shr(48, note), 0xffffffffff)
            noteOwner := and(shr(88, note), 0xffffffffffffffffffffffffffffffffffffffff)
        }
    }

    /**
     * @dev Removes input notes from the note registry
     *
     * @param inputNotes - an array of input notes from a zero-knowledge proof, that are to be
     * removed and destroyed from a note registry
     */
    function updateInputNotes(bytes memory inputNotes) internal {
        // set up some temporary variables we'll need
        // N.B. the status flags are NoteStatus enums, but written as uint8's.
        // We represent them as uint256 vars because it is the enum values that enforce type safety.
        // i.e. if we include enums that range beyond 256,
        // casting to uint8 won't help because we'll still be writing/reading the wrong note status
        // To summarise the summary - validate enum bounds in tests, use uint256 to save some gas vs uint8
        uint256 inputNoteStatusNew = uint256(NoteStatus.SPENT);
        uint256 inputNoteStatusOld;
        address inputNoteOwner;

        // Update the status of each `note` `inputNotes` to the following:
        // 1. set the note status to SPENT
        // 2. update the `destroyedOn` timestamp to the current timestamp
        // We also must check the following:
        // 1. the note has an existing status of UNSPENT
        // 2. the note owner matches the provided input
        uint256 length = inputNotes.getLength();
        for (uint256 i = 0; i < length; i += 1) {
            (address noteOwner, bytes32 noteHash,) = inputNotes.get(i).extractNote();

            // Get the storage location of the input note
            // solhint-disable-next-line no-unused-vars
            Note storage inputNotePtr = registries[msg.sender].notes[noteHash];

            // We update the note using Yul, as Solidity can be a bit inefficient when performing struct packing.
            // The compiler also invokes redundant sload opcodes that we can remove in Yul
            assembly {
                // load up our note from storage
                let note := sload(inputNotePtr_slot)

                // extract the status of this note (we'll check that it is UNSPENT outside the asm block)
                inputNoteStatusOld := and(note, 0xff)

                // extract the owner of this note (we'll check that it is _owner outside the asm block)
                inputNoteOwner := and(shr(88, note), 0xffffffffffffffffffffffffffffffffffffffff)

                // update the input note and write it into storage.
                // We need to change its `status` from UNSPENT to SPENT, and update `destroyedOn`
                sstore(
                    inputNotePtr_slot,
                    or(
                        // zero out the bits used to store `status` and `destroyedOn`
                        // `status` occupies byte index 1, `destroyedOn` occupies byte indices 6 - 11.
                        // We create bit mask with a NOT opcode to reduce contract bytecode size.
                        // We then perform logical AND with the bit mask to zero out relevant bits
                        and(
                            note,
                            not(0xffffffffff0000000000ff)
                        ),
                        // Now that we have zeroed out storage locations of `status` and `destroyedOn`, update them
                        or(
                            // Create 5-byte timestamp and shift into byte positions 6-11 with a bit shift
                            shl(48, and(timestamp, 0xffffffffff)),
                            // Combine with the new note status (masked to a uint8)
                            and(inputNoteStatusNew, 0xff)
                        )
                    )
                )
            }
            // Check that the note status is UNSPENT
            require(inputNoteStatusOld == uint256(NoteStatus.UNSPENT), "input note status is not UNSPENT");
            // Check that the note owner is the expected owner
            require(inputNoteOwner == noteOwner, "input note owner does not match");
        }
    }

    /**
     * @dev Adds output notes to the note registry
     *
     * @param outputNotes - an array of output notes from a zero-knowledge proof, that are to be
     * added to the note registry
     */
    function updateOutputNotes(bytes memory outputNotes) internal {
        // set up some temporary variables we'll need
        uint256 outputNoteStatusNew = uint256(NoteStatus.UNSPENT);
        uint256 outputNoteStatusOld;
        uint256 length = outputNotes.getLength();

        for (uint256 i = 0; i < length; i += 1) {
            (address noteOwner, bytes32 noteHash,) = outputNotes.get(i).extractNote();
            require(noteOwner != address(0x0), "output note owner cannot be address(0x0)");

            // Create a record in the note registry for this output note
            // solhint-disable-next-line no-unused-vars
            Note storage outputNotePtr = registries[msg.sender].notes[noteHash];

            // We manually pack our note struct in Yul, because Solidity can be a bit liberal with gas when doing this
            assembly {
                // Load the status flag for this note - we check this equals DOES_NOT_EXIST outside asm block
                outputNoteStatusOld := and(sload(outputNotePtr_slot), 0xff)

                // Write a new note into storage
                sstore(
                    outputNotePtr_slot,
                    // combine `status`, `createdOn` and `owner` via logical OR opcodes
                    or(
                        or(
                            // `status` occupies byte position 0
                            and(outputNoteStatusNew, 0xff), // mask to 1 byte (uint8)
                            // `createdOn` occupies byte positions 1-5 => shift by 8 bits
                            shl(8, and(timestamp, 0xffffffffff)) // mask timestamp to 40 bits
                        ),
                        // `owner` occupies byte positions 11-31 => shift by 88 bits
                        shl(88, noteOwner) // noteOwner already of address type, no need to mask
                    )
                )
            }
            require(outputNoteStatusOld == uint256(NoteStatus.DOES_NOT_EXIST), "output note exists");
        }
    }
}
