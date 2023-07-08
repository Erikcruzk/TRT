// File: ../sc_datasets/DAppSCAN/Hacken-Valhalla/Solidity-70de7d9daccb6d812b2ab96f20fb4aa2605e2601/erc20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);


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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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

// File: ../sc_datasets/DAppSCAN/Hacken-Valhalla/Solidity-70de7d9daccb6d812b2ab96f20fb4aa2605e2601/erc20/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Valhalla/Solidity-70de7d9daccb6d812b2ab96f20fb4aa2605e2601/erc20/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

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
        assembly {
            size := extcodesize(account)
        }
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

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
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
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

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

// File: ../sc_datasets/DAppSCAN/Hacken-Valhalla/Solidity-70de7d9daccb6d812b2ab96f20fb4aa2605e2601/erc20/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        require(initialOwner != address(0), "Owner cannot be a zero address");
        _setOwner(initialOwner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Valhalla/Solidity-70de7d9daccb6d812b2ab96f20fb4aa2605e2601/erc20/IMyNFT.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface MyNFT  {
    function createFromERC20(address sender, uint256 category) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Hacken-Valhalla/Solidity-70de7d9daccb6d812b2ab96f20fb4aa2605e2601/erc20/ERC20.sol

// SPDX-License-Identifier: MIT
// SWC-Floating Pragma: L4
// SWC-Outdated Compiler Version: L4
pragma solidity ^0.8.0;





contract ERC20 is Context, IERC20, Ownable {
    using Address for address;

    struct Vesting {
        uint256 amount;
        uint256 deadline;
    }

    mapping (address => Vesting) public vestings;
    mapping (address => Vesting[]) public vestingsLock;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(uint256 => bool) private usedNonces;

    uint256 private _totalSupply;
    uint8 private _decimals = 18;
    string private _name;
    string private _symbol;

    MyNFT private _mainContract;

    address private _verifier;

    uint256 public _totalTreasuryBalance;
    Vesting[] public treasuryBalanceLock;
    uint8 public indexTreasuryLock;
    bool private _isInitTreasure = false;

    uint256 public _totalLiquidityBalance;
    Vesting[] public liquidityBalanceLock;
    uint8 public indexLiquidityLock;

    address public _marketingWallet = 0xE72E3D8017064934F054290E8eDb2E321cE62Da5;
    address public _teamWallet = 0x3fD8B95f2dB23B17C4c2275E04A73803390f1482;
    address public _seedWallet = 0x2991CD5c95B089dFb09B44D2f8687C9dEA2C4aDd;
    address public _privateWallet = 0xAA58939a62ACb293e152E59F21Ce3b7aAADa9707;
    uint256 private _IDOAmount;
    uint256 public _treasuryBalance;
    uint256 public _liquidityBalance;
    uint256 public _vestingBalance;

    bool private _enableTransfer = false;

    event ItemBought(address indexed buyer, uint256 _nftID, uint256 _amount, string args);
    event ClaimTokens(address indexed to, uint256 _amount, uint256 _mode, uint256 _nonce);

    constructor(address cOwner, address verifier) Ownable (cOwner) {
        _name = "Valhalla Land Testnet Token";
        _symbol = "tVALH";
        _verifier = verifier;
        _totalSupply = 100000000 * 10 ** _decimals;
        _totalLiquidityBalance = 9000000 * 10 ** _decimals;
        _liquidityBalance = 3000000 * 10 ** _decimals;
        _totalTreasuryBalance = 36000000 * 10 ** _decimals;
        _treasuryBalance = 0;

        _balances[_marketingWallet] = 0;
        _balances[_teamWallet] = 0;
        _balances[_seedWallet] = 0;
        _balances[_privateWallet] = 3600000 * 10 ** _decimals;
        emit Transfer(address(0), _privateWallet, _balances[_privateWallet]);
        _balances[address(this)] = _totalSupply - _balances[_privateWallet];

        _IDOAmount = 500000 * 10 ** _decimals;        

        emit Transfer(address(0), address(this), _totalSupply - _balances[_privateWallet]);        
        _vestingBalance = _balances[_privateWallet];

        //IDO
        _balances[0xCCc1921491c55B7321d384b0CF2F504F94b81EF9] = _IDOAmount;
        emit Transfer(address(0), 0xCCc1921491c55B7321d384b0CF2F504F94b81EF9, _IDOAmount);
        _balances[address(this)] = _balances[address(this)] -_IDOAmount;
        emit Transfer(address(0), address(this), _balances[address(this)]);        
        _vestingBalance = _vestingBalance + _IDOAmount;
        addVestingLock(0xCCc1921491c55B7321d384b0CF2F504F94b81EF9, _IDOAmount, block.timestamp + 3 * 30 days);
        addVestingLock(0xCCc1921491c55B7321d384b0CF2F504F94b81EF9, _IDOAmount, block.timestamp + 6 * 30 days);
        addVestingLock(0xCCc1921491c55B7321d384b0CF2F504F94b81EF9, _IDOAmount, block.timestamp + 9 * 30 days);

        _balances[0xf86A54fEe000f8A2F521F83202e1056A0486DE09] = _IDOAmount;
        emit Transfer(address(0), 0xf86A54fEe000f8A2F521F83202e1056A0486DE09, _IDOAmount);
        _balances[address(this)] = _balances[address(this)] -_IDOAmount;
        emit Transfer(address(0), address(this), _balances[address(this)]);        
        _vestingBalance = _vestingBalance + _IDOAmount;
        addVestingLock(0xf86A54fEe000f8A2F521F83202e1056A0486DE09, _IDOAmount, block.timestamp + 3 * 30 days);
        addVestingLock(0xf86A54fEe000f8A2F521F83202e1056A0486DE09, _IDOAmount, block.timestamp + 6 * 30 days);
        addVestingLock(0xf86A54fEe000f8A2F521F83202e1056A0486DE09, _IDOAmount, block.timestamp + 9 * 30 days);

        _balances[0x1644A35e915F4dDbfE088E7A7C1c77595CF77067] = _IDOAmount;
        emit Transfer(address(0), 0x1644A35e915F4dDbfE088E7A7C1c77595CF77067, _IDOAmount);
        _balances[address(this)] = _balances[address(this)] -_IDOAmount;
        emit Transfer(address(0), address(this), _balances[address(this)]);        
        _vestingBalance = _vestingBalance + _IDOAmount;
        addVestingLock(0x1644A35e915F4dDbfE088E7A7C1c77595CF77067, _IDOAmount, block.timestamp + 3 * 30 days);
        addVestingLock(0x1644A35e915F4dDbfE088E7A7C1c77595CF77067, _IDOAmount, block.timestamp + 6 * 30 days);
        addVestingLock(0x1644A35e915F4dDbfE088E7A7C1c77595CF77067, _IDOAmount, block.timestamp + 9 * 30 days);

        _balances[0xf8056e8286D78b286e85Ff73532F7c0C590D7913] = _IDOAmount;
        emit Transfer(address(0), 0xf8056e8286D78b286e85Ff73532F7c0C590D7913, _IDOAmount);
        _balances[address(this)] = _balances[address(this)] -_IDOAmount;
        emit Transfer(address(0), address(this), _balances[address(this)]);        
        _vestingBalance = _vestingBalance + _IDOAmount;
        addVestingLock(0xf8056e8286D78b286e85Ff73532F7c0C590D7913, _IDOAmount, block.timestamp + 3 * 30 days);
        addVestingLock(0xf8056e8286D78b286e85Ff73532F7c0C590D7913, _IDOAmount, block.timestamp + 6 * 30 days);
        addVestingLock(0xf8056e8286D78b286e85Ff73532F7c0C590D7913, _IDOAmount, block.timestamp + 9 * 30 days);        
        //

        addVestingLock(_marketingWallet, 1000000 * 10 ** _decimals, block.timestamp + 4 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 5 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 6 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 7 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 8 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 9 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 10 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 11 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 12 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 13 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 14 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 15 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 16 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 17 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 18 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 19 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 20 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 21 * 30 days);
        addVestingLock(_marketingWallet, 500000 * 10 ** _decimals, block.timestamp + 22 * 30 days);
        
        addVestingLock(_teamWallet, 1200000 * 10 ** _decimals, block.timestamp + 12 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 15 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 18 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 21 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 24 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 27 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 30 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 33 * 30 days);
        addVestingLock(_teamWallet, 600000 * 10 ** _decimals, block.timestamp + 36 * 30 days);
        
        addVestingLock(_seedWallet, 750000 * 10 ** _decimals, block.timestamp + 3 * 30 days);
        addVestingLock(_seedWallet, 750000 * 10 ** _decimals, block.timestamp + 6 * 30 days);
        addVestingLock(_seedWallet, 750000 * 10 ** _decimals, block.timestamp + 9 * 30 days);
        addVestingLock(_seedWallet, 750000 * 10 ** _decimals, block.timestamp + 12 * 30 days);
        addVestingLock(_seedWallet, 750000 * 10 ** _decimals, block.timestamp + 15 * 30 days);
        addVestingLock(_seedWallet, 750000 * 10 ** _decimals, block.timestamp + 18 * 30 days);
        addVestingLock(_seedWallet, 500000 * 10 ** _decimals, block.timestamp + 21 * 30 days);

        addVestingLock(_privateWallet, 3600000 * 10 ** _decimals, block.timestamp + 3 * 30 days);
        addVestingLock(_privateWallet, 3600000 * 10 ** _decimals, block.timestamp + 6 * 30 days);
        addVestingLock(_privateWallet, 3600000 * 10 ** _decimals, block.timestamp + 9 * 30 days);
        addVestingLock(_privateWallet, 3600000 * 10 ** _decimals, block.timestamp + 12 * 30 days);
        addVestingLock(_privateWallet, 3600000 * 10 ** _decimals, block.timestamp + 15 * 30 days);
        addVestingLock(_privateWallet, 2400000 * 10 ** _decimals, block.timestamp + 18 * 30 days);

        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 1 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 2 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 3 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 4 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 5 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 6 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 7 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 8 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 9 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 10 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 11 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 12 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 13 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 14 * 30 days);
        addLiquidityLock(600000 * 10 ** _decimals, block.timestamp + 15 * 30 days);


    }

    modifier isTransfer() {
         require(_enableTransfer, 'Can not transfer');
         _;
    }

    function enableTransfer() external onlyOwner {
        _enableTransfer = true;
    }

    function setMainNFT(address _contract) external onlyOwner {
        require(_contract != address(0), "Zero address for NFT contract is not acceptable");
        _mainContract = MyNFT(_contract);

    }

    function addLiquidityLock(uint _amount, uint256 deadline) internal {
        Vesting memory vst = Vesting({
                                    amount: _amount,
                                    deadline: deadline
                                });
        liquidityBalanceLock.push(vst);
    }

    function addVestingLock(address _wallet, uint256 _ammount, uint256 _deadline) internal {
        Vesting memory vst = Vesting({
                                    amount: _ammount,
                                    deadline: _deadline
                                });
                                
        vestingsLock[_wallet].push(vst);
    }

    function releaseVesting(address _wallet) private {
        if (vestingsLock[_wallet][0].deadline <= block.timestamp && vestingsLock[_wallet][0].amount > 0) {            
            vestings[_wallet].amount += vestingsLock[_wallet][0].amount;
            _vestingBalance += vestingsLock[_wallet][0].amount;
            emit Transfer(address(0), _wallet, vestingsLock[_wallet][0].amount);
            for (uint i = 0; i < vestingsLock[_wallet].length - 1; i++) {
                vestingsLock[_wallet][i] = vestingsLock[_wallet][i+1];
            }
            delete vestingsLock[_wallet][vestingsLock[_wallet].length - 1];
        }
    }

    function initTreasure() external onlyOwner {
        require(!_isInitTreasure, "Treasury initialized");     

        
        uint256 partAmmount = 1000000 * 10 ** _decimals;

        for (uint256 i = 1; i <= 36; i++) {
            Vesting memory vst = Vesting({
                                    amount: partAmmount,
                                    deadline: block.timestamp + i * 30 days
                                });
            treasuryBalanceLock.push(vst);
        }
        
      
        _isInitTreasure = true;
    }

    function releaseTreasure() internal {
        if (_isInitTreasure && indexTreasuryLock < treasuryBalanceLock.length && block.timestamp > treasuryBalanceLock[indexTreasuryLock].deadline) { 
            _treasuryBalance += treasuryBalanceLock[indexTreasuryLock].amount;
            _totalTreasuryBalance -= treasuryBalanceLock[indexTreasuryLock].amount;
            treasuryBalanceLock[indexTreasuryLock].amount = 0;
            indexTreasuryLock++;
        }
    }

    function releaseLiquidity() internal {
        if (indexLiquidityLock < liquidityBalanceLock.length && block.timestamp > liquidityBalanceLock[indexLiquidityLock].deadline) { 
            _liquidityBalance += liquidityBalanceLock[indexLiquidityLock].amount;
            _totalLiquidityBalance -= liquidityBalanceLock[indexLiquidityLock].amount;
            liquidityBalanceLock[indexLiquidityLock].amount = 0;
            indexLiquidityLock++;
        }
    }

    function claimVesting() external {
        releaseVesting(_msgSender());
        require(vestings[_msgSender()].amount > 0, "Insufficient token amount to claim");
                
        _balances[address(this)] = _balances[address(this)] - vestings[_msgSender()].amount;
        _balances[_msgSender()] = _balances[_msgSender()] + vestings[_msgSender()].amount;
        _vestingBalance -= vestings[_msgSender()].amount;
        emit Transfer(address(this), _msgSender(), vestings[_msgSender()].amount);
        vestings[_msgSender()].amount = 0;
    }

    function claim(uint256 _amount, uint8 _mode, uint256 nonce, bytes memory sig) external {
        require((_mode == 1 || _mode == 2), "Invalid mode. Use '1' for treasury claim and '2' for liquidity claim");
        require(!usedNonces[nonce]);
        bytes32 message = prefixed(keccak256(abi.encodePacked(nonce, address(this))));
        address signer = recoverSigner(message, sig);
        require(signer ==_verifier, "Unauthorized transaction");
        usedNonces[nonce] = true;
        if (_mode == 1 ) {
            releaseTreasure();
            require(_treasuryBalance >= _amount, "Insufficient amount to claim");
            _balances[address(this)] = _balances[address(this)] - _amount;
            _balances[_msgSender()] = _balances[_msgSender()] + _amount;
            _treasuryBalance -= _amount;
            emit Transfer(address(this), _msgSender(), _amount);
            emit ClaimTokens(_msgSender(), _amount, _mode, nonce);
        } else {
            releaseLiquidity();
            require(_liquidityBalance >= _amount, "Insufficient amount to claim");
            _balances[address(this)] = _balances[address(this)] - _amount;
            _balances[_msgSender()] = _balances[_msgSender()] + _amount;
            _liquidityBalance -= _amount;
            emit Transfer(address(this), _msgSender(), _amount);
            emit ClaimTokens(_msgSender(), _amount, _mode, nonce);
        }
    }
    
    function buyItem(uint256 _amount, uint256 _category, bool  _mode, string memory args, uint256 nonce, bytes memory sig) external {
        require(_amount > 0, "Token amount cannot be zero");
        require(_balances[_msgSender()] >= _amount, "Insufficient token balance to buy item");

        require(!usedNonces[nonce]);
        bytes32 message = prefixed(keccak256(abi.encodePacked(_category, _mode, _amount, nonce, address(this), args)));
        address signer = recoverSigner(message, sig);
        require(signer ==_verifier, "Unauthorized transaction");
        usedNonces[nonce] = true;

        _balances[_msgSender()] = _balances[_msgSender()] - _amount;
        _balances[address(this)] = _balances[address(this)] + _amount;
        _treasuryBalance += _amount;
        emit Transfer(_msgSender(), address(this), _amount);
        if (!_mode) {
            uint256 result = _mainContract.createFromERC20(_msgSender(), _category);
            emit ItemBought(_msgSender(), result, _amount, args);
        } else {
            emit ItemBought(_msgSender(), 0, _amount, args);

        }

    }



    function recoverSigner(bytes32 message, bytes memory sig) public pure
    returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    function splitSignature(bytes memory sig)
    public
    pure
    returns (uint8, bytes32, bytes32)
    {
        require(sig.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    // Builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }



    function name() public view virtual override returns (string memory) {
        return _name;
    }


    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }


    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }



    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }


    function transfer(address recipient, uint256 amount) public virtual override isTransfer returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }


    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
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
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");


        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

    }


    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

}
