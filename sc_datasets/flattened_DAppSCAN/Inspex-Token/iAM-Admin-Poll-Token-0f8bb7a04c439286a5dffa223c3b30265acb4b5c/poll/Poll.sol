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

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
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
}

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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
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
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
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
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
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
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
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
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
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
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
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

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
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
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/interfaces/IERC20Burnable.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IERC20Burnable {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function burn(uint256 amount) external;

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function adminTransfer(
    address,
    address,
    uint256
  ) external returns (bool);

  function transferOwnership(address) external;
}

// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/interfaces/IAdminManage.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IAdminManage {
  function isSuperAdmin(address _address) external view returns (bool);

  function getSuperAdminList() external view returns (address[] memory);

  function addSuperAdmin(address _address) external;

  function removeSuperAdmin(address _address) external;

  function isAdmin(address _address) external view returns (bool);

  function getAdminList() external view returns (address[] memory);

  function addAdmin(address _address) external;

  function removeAdmin(address _address) external;
}

// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/access/Adminnable.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

abstract contract Adminnable {
  IAdminManage internal adminManage;

  constructor(IAdminManage _adminManage) {
    adminManage = _adminManage;
  }

  modifier onlyAdmin() {
    bool isAdmin = adminManage.isAdmin(msg.sender);
    require(isAdmin, 'Adminnable: caller is not the admin');
    _;
  }

  function getAdminManage() public view returns (address) {
    return address(adminManage);
  }

  function admin(address _address) public view returns (bool) {
    return adminManage.isAdmin(_address);
  }
}

// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/poll/Poll.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;




contract Poll is Adminnable, ReentrancyGuard {
  IERC20Burnable public voteToken;
  address public factory;
  string public question;
  string public name;
  string public desc; // string | ipfs url

  uint256 public startBlock; // start block
  uint256 public endBlock; // end block
  bool public emergencyClose; // emergency close poll
  bool public init;

  uint256 public minimumToken;
  uint256 public maximumToken;
  bool public burnType;
  bool public multiType;

  uint256 public highestVotedIndex;
  uint256 public highestVotedAmount;

  mapping(address => VoteReceive[]) public voterReceive;
  mapping(address => uint256) public lockAmountOf;
  uint256 public voterCount;

  Proposal[] public proposals;

  struct VoteReceive {
    uint256 vote; // index of the voted proposal
    uint256 amount;
  }

  struct Proposal {
    string desc;
    uint256 voteAmount;
    bool valid;
  }

  modifier onlyVoteTime() {
    require(init == true, 'poll: poll is not ready!');
    require(block.number > startBlock, 'poll: not in vote time!');
    require(block.number < endBlock, 'poll: poll is finished!');
    require(!emergencyClose, 'poll: poll is close!');
    _;
  }

  modifier onlyBeforeStart() {
    require(block.number < startBlock, 'poll: poll is started!');
    _;
  }

  modifier onlyFinished() {
    require(block.number > endBlock || emergencyClose, 'poll is not finished!');
    _;
  }

  event Initialize(
    uint256 _timeStart,
    uint256 _timeEnd,
    uint256 _min,
    uint256 _max,
    bool indexed _burnType,
    bool indexed _multiType,
    string[] _proposals
  );
  event Voted(address indexed _voter, uint256 _amount, uint256 indexed _proposal);
  event Proposals(string[] _proposals);
  event Transfer(address indexed _to, uint256 _amount);

  constructor(
    IAdminManage _admin,
    IERC20Burnable _voteToken,
    string memory _question,
    string memory _desc,
    string memory _name
  ) Adminnable(_admin) {
    factory = msg.sender;
    voteToken = _voteToken;
    question = _question;
    desc = _desc;
    name = _name;
  }

  function initialize(
    uint256 _startBlock,
    uint256 _endBlock,
    uint256 _minimumToken,
    uint256 _maximumToken,
    bool _burnType,
    bool _multiType,
    string[] memory _proposals
  ) public {
    require(msg.sender == factory, 'Poll [initialize]: only factory can init poll.');
    require(init == false, 'Poll [initialize]: you can init Poll only 1 time.');
    require(_endBlock > _startBlock, 'Poll [initialize]: endBlock should more then startBlock.');

    init = true;
    startBlock = _startBlock;
    endBlock = _endBlock;
    minimumToken = _minimumToken;
    maximumToken = _maximumToken;
    burnType = _burnType;
    multiType = _multiType;

    // initital genesis at index 0
    proposals.push(Proposal({desc: 'Genesis', voteAmount: 0, valid: true}));
    _addProposals(_proposals);

    emit Initialize(startBlock, endBlock, minimumToken, maximumToken, burnType, multiType, _proposals);
  }

  function editPollVoteTime(uint256 _startBlock, uint256 _endBlock) external onlyAdmin onlyBeforeStart {
    require(endBlock > _startBlock, 'Poll [editPollVoteTime]: endBlock should more then startBlock.');

    startBlock = _startBlock;
    endBlock = _endBlock;
  }

  function directClosePoll() external onlyAdmin {
    emergencyClose = true;
  }

  function isFinished() public view returns (bool) {
    return init && (block.number > endBlock || emergencyClose);
  }

  function burnToken() external onlyAdmin onlyFinished returns (bool) {
    require(burnType, 'Poll [burnToken]: require Poll of burn type.');

    voteToken.burn(voteToken.balanceOf(address(this)));

    return true;
  }

  function getProposalList() external view returns (Proposal[] memory) {
    return proposals;
  }

  function getVoter(address _voter) external view returns (VoteReceive[] memory) {
    return voterReceive[_voter];
  }

  function addProposalNames(string[] memory _proposalNames) public onlyAdmin onlyBeforeStart returns (bool) {
    _addProposals(_proposalNames);
    return true;
  }

  function editProposalDesc(uint256 _index, string memory _desc) public onlyAdmin onlyBeforeStart returns (bool) {
    require(proposals[_index].valid, 'Poll [editProposalDesc]: editProposal is invalid.');
    proposals[_index].desc = _desc;

    return true;
  }

  function withdrawFor(address _toaddress) external onlyFinished nonReentrant returns (bool) {
    // when emergency close poll is call by admin voter can withdown thier token at any time

    if (burnType == false) {
      _withdrawFor(_toaddress);

      return true;
    }

    require(emergencyClose, 'Poll [withdrawFor]: cannot withdraw from Poll of Burn type.');
    _withdrawFor(_toaddress);

    return true;
  }

  function unsafeLoopWithdraw(address[] memory _addressList) external onlyFinished nonReentrant returns (bool) {
    if (burnType == false) {
      for (uint256 i = 0; i < _addressList.length; i++) {
        _withdrawFor(_addressList[i]);
      }

      return true;
    }

    require(emergencyClose, 'Poll [withdrawFor]: cannot withdraw from Poll of Burn type.');
    for (uint256 i = 0; i < _addressList.length; i++) {
      _withdrawFor(_addressList[i]);
    }

    return true;
  }

  function vote(uint256 _proposal, uint256 _amount) external onlyVoteTime nonReentrant returns (bool) {
    require(_proposal != 0 && _proposal < proposals.length, 'Poll [vote]: incorrect proposal to vote');

    // check voter
    if (multiType) {
      require(lockAmountOf[msg.sender] + _amount <= maximumToken, 'Poll [vote]: can not vote more then max limit.');
    } else {
      require(lockAmountOf[msg.sender] == 0, 'Poll [vote]: already voted.');
    }

    require(voteToken.balanceOf(msg.sender) >= _amount, 'Poll [vote]: require balanceOf token to vote');

    require(_amount >= minimumToken && _amount <= maximumToken, 'Poll [vote]: amount not in require range.');
    _vote(msg.sender, _proposal, _amount);

    return true;
  }

  function _addProposals(string[] memory _proposalNames) private {
    for (uint256 i = 0; i < _proposalNames.length; i++) {
      proposals.push(Proposal({desc: _proposalNames[i], voteAmount: 0, valid: true}));
    }

    emit Proposals(_proposalNames);
  }

  function _vote(
    address _voter,
    uint256 _proposal,
    uint256 _amount
  ) private {
    assert(voteToken.transferFrom(_voter, address(this), _amount));

    // if frist vote save to count
    if (voterReceive[_voter].length == 0) {
      voterCount++;
    }

    // save vote data
    VoteReceive memory voteReceive = VoteReceive({vote: _proposal, amount: _amount});
    voterReceive[_voter].push(voteReceive);
    lockAmountOf[_voter] += _amount;

    // add vote point
    proposals[_proposal].voteAmount += _amount;

    // check highest
    if (proposals[_proposal].voteAmount > highestVotedAmount) {
      highestVotedAmount = proposals[_proposal].voteAmount;
      highestVotedIndex = _proposal;
    } else if (proposals[_proposal].voteAmount == highestVotedAmount) {
      highestVotedIndex = 0;
    }

    emit Voted(_voter, _amount, _proposal);
  }

  function _withdrawFor(address _toaddress) private {
    uint256 lockAmount = lockAmountOf[_toaddress];

    lockAmountOf[_toaddress] = 0;
    assert(voteToken.transfer(_toaddress, lockAmount));

    // transfer to owner of locked token
    emit Transfer(_toaddress, lockAmount);
  }
}
