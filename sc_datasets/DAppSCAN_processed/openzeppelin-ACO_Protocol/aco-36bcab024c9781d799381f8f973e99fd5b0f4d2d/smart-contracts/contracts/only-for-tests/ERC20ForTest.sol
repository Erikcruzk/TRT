// File: ../sc_datasets/DAppSCAN/openzeppelin-ACO_Protocol/aco-36bcab024c9781d799381f8f973e99fd5b0f4d2d/smart-contracts/contracts/libs/SafeMath.sol

pragma solidity ^0.6.6;

// Contract on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts

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
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-ACO_Protocol/aco-36bcab024c9781d799381f8f973e99fd5b0f4d2d/smart-contracts/contracts/interfaces/IERC20.sol

pragma solidity ^0.6.6;

// Contract on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts

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

// File: ../sc_datasets/DAppSCAN/openzeppelin-ACO_Protocol/aco-36bcab024c9781d799381f8f973e99fd5b0f4d2d/smart-contracts/contracts/core/ERC20.sol

pragma solidity ^0.6.6;


/**
 * @title ERC20
 * @dev Base implementation of ERC20 token.
 */
abstract contract ERC20 is IERC20 {
    using SafeMath for uint256;
    
    uint256 private _totalSupply;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    function name() public view virtual returns(string memory);
    function symbol() public view virtual returns(string memory);
    function decimals() public view virtual returns(uint8);

    function totalSupply() public view override returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns(uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view override returns(uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount) public override returns(bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns(bool) {
        _approveAction(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        _transfer(sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns(bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 amount) public returns(bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(amount));
        return true;
    }

    function decreaseAllowance(address spender, uint256 amount) public returns(bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(amount));
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        _transferAction(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        _approveAction(owner, spender, amount);
    }
    
    function _burnFrom(address account, uint256 amount) internal {
        _approveAction(account, msg.sender, _allowances[account][msg.sender].sub(amount));
        _burnAction(account, amount);
    }

    function _transferAction(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20::_transferAction: Invalid sender");
        require(recipient != address(0), "ERC20::_transferAction: Invalid recipient");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        
        emit Transfer(sender, recipient, amount);
    }
    
    function _approveAction(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20::_approveAction: Invalid owner");
        require(spender != address(0), "ERC20::_approveAction: Invalid spender");

        _allowances[owner][spender] = amount;
        
        emit Approval(owner, spender, amount);
    }
    
    function _mintAction(address account, uint256 amount) internal {
        require(account != address(0), "ERC20::_mintAction: Invalid account");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        
        emit Transfer(address(0), account, amount);
    }

    function _burnAction(address account, uint256 amount) internal {
        require(account != address(0), "ERC20::_burnAction: Invalid account");

        _balances[account] = _balances[account].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        
        emit Transfer(account, address(0), amount);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-ACO_Protocol/aco-36bcab024c9781d799381f8f973e99fd5b0f4d2d/smart-contracts/contracts/only-for-tests/ERC20ForTest.sol

pragma solidity ^0.6.6;

/**
 * @title ERC20ForTest
 * @dev The contract is only for test purpose.
 */
contract ERC20ForTest is ERC20 {
    
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    constructor(
        string memory _erc20name, 
        string memory _erc20symbol, 
        uint8 _erc20decimals, 
        uint256 _erc20totalSupply
    ) public {
        _name = _erc20name;
        _symbol = _erc20symbol;
        _decimals = _erc20decimals;
        super._mintAction(msg.sender, _erc20totalSupply);
    }
    
    function name() public view override returns(string memory) {
        return _name;    
    }
    
    function symbol() public view override returns(string memory) {
        return _symbol;    
    }
    
    function decimals() public view override returns(uint8) {
        return _decimals;
    }
}