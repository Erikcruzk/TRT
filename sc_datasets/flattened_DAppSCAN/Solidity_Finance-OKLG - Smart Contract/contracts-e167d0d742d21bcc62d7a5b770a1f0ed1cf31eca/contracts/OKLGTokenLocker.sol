// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

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
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
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

// File: @openzeppelin/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)

pragma solidity ^0.8.0;

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/interfaces/IERC721.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)

pragma solidity ^0.8.0;

// File: @openzeppelin/contracts/utils/math/SafeMath.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
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
        return a + b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
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
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Solidity_Finance-OKLG - Smart Contract/contracts-e167d0d742d21bcc62d7a5b770a1f0ed1cf31eca/contracts/interfaces/IOKLGSpend.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title IOKLGSpend
 * @dev Logic for spending OKLG on products in the product ecosystem.
 */
interface IOKLGSpend {
  function spendOnProduct(address _payor, uint8 _product) external payable;
}

// File: ../sc_datasets/DAppSCAN/Solidity_Finance-OKLG - Smart Contract/contracts-e167d0d742d21bcc62d7a5b770a1f0ed1cf31eca/contracts/OKLGWithdrawable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


/**
 * @title OKLGWithdrawable
 * @dev Supports being able to get tokens or ETH out of a contract with ease
 */
contract OKLGWithdrawable is Ownable {
  function withdrawTokens(address _tokenAddy, uint256 _amount)
    external
    onlyOwner
  {
    IERC20 _token = IERC20(_tokenAddy);
    _amount = _amount > 0 ? _amount : _token.balanceOf(address(this));
    require(_amount > 0, 'make sure there is a balance available to withdraw');
    _token.transfer(owner(), _amount);
  }

  function withdrawETH() external onlyOwner {
    payable(owner()).call{ value: address(this).balance }('');
  }
}

// File: ../sc_datasets/DAppSCAN/Solidity_Finance-OKLG - Smart Contract/contracts-e167d0d742d21bcc62d7a5b770a1f0ed1cf31eca/contracts/OKLGProduct.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;



/**
 * @title OKLGProduct
 * @dev Contract that every product developed in the OKLG ecosystem should implement
 */
contract OKLGProduct is OKLGWithdrawable {
  IERC20 private _token; // OKLG
  IOKLGSpend private _spend;

  uint8 public productID;

  constructor(
    uint8 _productID,
    address _tokenAddy,
    address _spendAddy
  ) {
    productID = _productID;
    _token = IERC20(_tokenAddy);
    _spend = IOKLGSpend(_spendAddy);
  }

  function setTokenAddy(address _tokenAddy) external onlyOwner {
    _token = IERC20(_tokenAddy);
  }

  function setSpendAddy(address _spendAddy) external onlyOwner {
    _spend = IOKLGSpend(_spendAddy);
  }

  function setProductID(uint8 _newId) external onlyOwner {
    productID = _newId;
  }

  function getTokenAddress() public view returns (address) {
    return address(_token);
  }

  function getSpendAddress() public view returns (address) {
    return address(_spend);
  }

  function _payForService(uint256 _weiToRemoveFromSpend) internal {
    _spend.spendOnProduct{ value: msg.value - _weiToRemoveFromSpend }(
      msg.sender,
      productID
    );
  }
}

// File: ../sc_datasets/DAppSCAN/Solidity_Finance-OKLG - Smart Contract/contracts-e167d0d742d21bcc62d7a5b770a1f0ed1cf31eca/contracts/OKLGTokenLocker.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;





/**
 * @title MTGYTokenLocker
 * @dev This is the main contract that supports locking/vesting tokens.
 */
contract MTGYTokenLocker is OKLGProduct {
  using SafeMath for uint48;
  using SafeMath for uint256;

  struct Locker {
    address owner;
    address token;
    bool isNft; // rewardToken is either ERC20 or ERC721
    uint256 amountSupply; // If ERC-721, will always be 1, otherwise is amount of tokens locked
    uint256 tokenId; // only populated if isNft is true
    uint48 start; // timestamp (uint256) of start lock time (block.timestamp at creation)
    uint48 end; // timestamp (uint256) of end lock time
    address[] withdrawable; // any additional addresses that can withdraw tokens from this locker
    uint256 amountWithdrawn;
    // numberVests:
    // 1 means can only withdraw tokens at end of lock period
    // any other number is evenly distributed throughout lock period
    uint8 numberVests;
  }

  mapping(address => uint16[]) public lockersByOwner;
  mapping(address => uint16[]) public lockersByToken;
  mapping(address => uint16[]) public lockersByWithdrawable;
  Locker[] public lockers;

  event CreateLocker(address indexed creator, uint256 idx);
  event WithdrawTokens(
    uint256 indexed idx,
    address withdrawer,
    uint256 numTokensOrTokenId
  );

  constructor(address _tokenAddress, address _spendAddress)
    OKLGProduct(uint8(5), _tokenAddress, _spendAddress)
  {}

  function getAllLockers() external view returns (Locker[] memory) {
    return lockers;
  }

  function createLocker(
    address _tokenAddress,
    uint256 _amountOrTokenId,
    uint48 _end,
    uint8 _numberVests,
    address[] memory _withdrawableAddresses,
    bool _isNft
  ) external payable {
    require(
      _end > block.timestamp,
      'Locker end date must be after current time.'
    );

    _payForService(0);

    if (_isNft) {
      IERC721 _token = IERC721(_tokenAddress);
      _token.transferFrom(msg.sender, address(this), _amountOrTokenId);
    } else {
      IERC20 _token = IERC20(_tokenAddress);
      _token.transferFrom(msg.sender, address(this), _amountOrTokenId);
    }

    lockers.push(
      Locker({
        owner: msg.sender,
        isNft: _isNft,
        token: _tokenAddress,
        amountSupply: _isNft ? 1 : _amountOrTokenId,
        tokenId: _isNft ? _amountOrTokenId : 0,
        start: uint48(block.timestamp),
        end: _end,
        withdrawable: _withdrawableAddresses,
        amountWithdrawn: 0,
        numberVests: _isNft ? 1 : (_numberVests == 0 ? 1 : _numberVests)
      })
    );
    uint16 _newIdx = uint16(lockers.length - 1);
    lockersByOwner[msg.sender].push(_newIdx);
    lockersByToken[_tokenAddress].push(_newIdx);
    if (_withdrawableAddresses.length > 0) {
      for (uint16 _i = 0; _i < _withdrawableAddresses.length; _i++) {
        lockersByWithdrawable[_withdrawableAddresses[_i]].push(_newIdx);
      }
    }
    emit CreateLocker(msg.sender, _newIdx);
  }

  function withdrawLockedTokens(uint16 _idx, uint256 _amountOrTokenId)
    external
  {
    Locker storage _locker = lockers[_idx];
    require(
      _locker.amountWithdrawn < _locker.amountSupply,
      'All tokens have been withdrawn from this locker.'
    );

    bool _isWithdrawableUser = msg.sender == _locker.owner;
    if (!_isWithdrawableUser) {
      for (uint256 _i = 0; _i < _locker.withdrawable.length; _i++) {
        if (_locker.withdrawable[_i] == msg.sender) {
          _isWithdrawableUser = true;
          break;
        }
      }
    }
    require(
      _isWithdrawableUser,
      'Must be locker owner or a withdrawable wallet.'
    );

    // SWC-Reentrancy: L126
    _locker.amountWithdrawn += _locker.isNft ? 1 : _amountOrTokenId;

    if (_locker.isNft) {
      require(
        block.timestamp > _locker.end,
        'Must wait until locker expires to withdraw.'
      );
      IERC721 _token = IERC721(_locker.token);
      _token.transferFrom(address(this), msg.sender, _amountOrTokenId);
    } else {
      uint256 _maxAmount = maxWithdrawableTokens(_idx);
      require(
        _amountOrTokenId > 0 && _amountOrTokenId <= _maxAmount,
        'Make sure you enter a valid withdrawable amount and not more than has vested.'
      );
      IERC20 _token = IERC20(_locker.token);
      _token.transferFrom(address(this), msg.sender, _amountOrTokenId);
    }
    emit WithdrawTokens(_idx, msg.sender, _amountOrTokenId);
  }

  function changeLockerOwner(uint16 _idx, address _newOwner) external {
    Locker storage _locker = lockers[_idx];
    require(
      _locker.owner == msg.sender,
      'Must be the locker owner to change owner.'
    );
    _locker.owner = _newOwner;
  }

  function changeLockerEndTime(uint16 _idx, uint48 _newEnd) external {
    Locker storage _locker = lockers[_idx];
    require(
      _locker.owner == msg.sender,
      'Must be the locker owner to change owner.'
    );
    require(_newEnd > _locker.end, 'Can only extend end time, not shorten it.');
    _locker.end = _newEnd;
  }

  function maxWithdrawableTokens(uint16 _idx) public view returns (uint256) {
    Locker memory _locker = lockers[_idx];
    uint256 _fullLockPeriodSec = _locker.end.sub(_locker.start);
    uint256 _secondsPerVest = _fullLockPeriodSec.div(_locker.numberVests);
    uint256 _tokensPerVest = _locker.amountSupply.div(_locker.numberVests);
    uint256 _numberWithdrawableVests = (block.timestamp.sub(_locker.start)).div(
      _secondsPerVest
    );
    if (_numberWithdrawableVests == 0) return 0;
    return
      _numberWithdrawableVests.mul(_tokensPerVest).sub(_locker.amountWithdrawn);
  }
}
