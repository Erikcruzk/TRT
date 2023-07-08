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

// File: ../sc_datasets/DAppSCAN/Solidity_Finance-OKLG - Smart Contract/contracts-e167d0d742d21bcc62d7a5b770a1f0ed1cf31eca/contracts/OKLGAffiliate.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title OKLGAffiliate
 * @dev Support affiliate logic
 */
contract OKLGAffiliate is OKLGWithdrawable {
  modifier onlyAffiliateOrOwner() {
    require(
      msg.sender == owner() || affiliates[msg.sender] > 0,
      'caller must be affiliate or owner'
    );
    _;
  }

  uint16 public constant PERCENT_DENOMENATOR = 10000;
  address public paymentWallet = 0x0000000000000000000000000000000000000000;

  mapping(address => uint256) public affiliates; // value is percentage of fees for affiliate (denomenator of 10000)
  mapping(address => uint256) public discounts; // value is percentage off for user (denomenator of 10000)

  event AddAffiliate(address indexed wallet, uint256 percent);
  event RemoveAffiliate(address indexed wallet);
  event AddDiscount(address indexed wallet, uint256 percent);
  event RemoveDiscount(address indexed wallet);
  event Pay(address indexed payee, uint256 amount);

  function pay(
    address _caller,
    address _referrer,
    uint256 _basePrice
  ) internal {
    uint256 price = getFinalPrice(_caller, _basePrice);
    require(msg.value >= price, 'not enough ETH to pay');

    // affiliate fee if applicable
    if (affiliates[_referrer] > 0) {
      uint256 referrerFee = (price * affiliates[_referrer]) /
        PERCENT_DENOMENATOR;
      (bool sent, ) = payable(_referrer).call{ value: referrerFee }('');
      require(sent, 'affiliate payment did not go through');
      price -= referrerFee;
    }

    // if affiliate does not take everything, send normal payment
    if (price > 0) {
      address wallet = paymentWallet == address(0) ? owner() : paymentWallet;
      (bool sent, ) = payable(wallet).call{ value: price }('');
      require(sent, 'main payment did not go through');
    }
    emit Pay(msg.sender, _basePrice);
  }

  function getFinalPrice(address _caller, uint256 _basePrice)
    public
    view
    returns (uint256)
  {
    if (discounts[_caller] > 0) {
      return
        _basePrice - ((_basePrice * discounts[_caller]) / PERCENT_DENOMENATOR);
    }
    return _basePrice;
  }

  function addDiscount(address _wallet, uint256 _percent)
    external
    onlyAffiliateOrOwner
  {
    require(
      _percent <= PERCENT_DENOMENATOR,
      'cannot have more than 100% discount'
    );
    discounts[_wallet] = _percent;
    emit AddDiscount(_wallet, _percent);
  }

  function removeDiscount(address _wallet) external onlyAffiliateOrOwner {
    require(discounts[_wallet] > 0, 'affiliate must exist');
    delete discounts[_wallet];
    emit RemoveDiscount(_wallet);
  }

  function addAffiliate(address _wallet, uint256 _percent) external onlyOwner {
    require(
      _percent <= PERCENT_DENOMENATOR,
      'cannot have more than 100% referral fee'
    );
    affiliates[_wallet] = _percent;
    emit AddAffiliate(_wallet, _percent);
  }

  function removeAffiliate(address _wallet) external onlyOwner {
    require(affiliates[_wallet] > 0, 'affiliate must exist');
    delete affiliates[_wallet];
    emit RemoveAffiliate(_wallet);
  }

  function setPaymentWallet(address _wallet) external onlyOwner {
    paymentWallet = _wallet;
  }
}
