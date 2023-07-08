// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/interfaces/IOneSwapToken.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

interface IOneSwapBlackList {
    event OwnerChanged(address);
    event AddedBlackLists(address[]);
    event RemovedBlackLists(address[]);

    function owner()external view returns (address);
    function isBlackListed(address)external view returns (bool);

    function changeOwner(address newOwner) external;
    function addBlackLists(address[] calldata  accounts)external;
    function removeBlackLists(address[] calldata  accounts)external;
}

interface IOneSwapToken is IERC20, IOneSwapBlackList{
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
    function multiTransfer(uint256[] calldata mixedAddrVal) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/libraries/SafeMath256.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

library SafeMath256 {
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

// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/OneSwapBlackList.sol

// SPDX-License-Identifier: GPL
pragma solidity ^0.6.6;

abstract contract OneSwapBlackList is IOneSwapBlackList {
    address private _owner;
    mapping(address => bool) private _isBlackListed;

    constructor() public {
        _owner = msg.sender;
    }

    function owner() public view override returns (address) {
        return _owner;
    }
    function isBlackListed(address user) public view override returns (bool) {
        return _isBlackListed[user];
    }
    modifier onlyOwner() {
        require(msg.sender == _owner, "msg.sender is not owner");
        _;
    }

    function changeOwner(address newOwner) public override onlyOwner {
        _setOwner(newOwner);
    }

    function addBlackLists(address[] calldata _evilUser) public override onlyOwner {
        for (uint i = 0; i < _evilUser.length; i++) {
            _isBlackListed[_evilUser[i]] = true;
        }
        emit AddedBlackLists(_evilUser);
    }

    function removeBlackLists(address[] calldata _clearedUser) public override onlyOwner {
        for (uint i = 0; i < _clearedUser.length; i++) {
            delete _isBlackListed[_clearedUser[i]];
        }
        emit RemovedBlackLists(_clearedUser);
    }

    function _setOwner(address newOwner) internal {
        if (newOwner != address(0)) {
            _owner = newOwner;
            emit OwnerChanged(newOwner);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-OneSwap/oneswap_contract_ethereum-4194ac1a55934cd573bd93987111eaa8f70676fe/contracts/OneSwapToken.sol

// SPDX-License-Identifier: GPL
pragma solidity ^0.6.6;



contract OneSwapToken is IOneSwapToken,OneSwapBlackList {

    using SafeMath256 for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    // solhint-disable-next-line state-visibility
    uint8 immutable _decimals;

    constructor (string memory name, string memory symbol, uint256 supply, uint8 decimals) public OneSwapBlackList() {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = supply;
        _balances[msg.sender] = supply;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender,
                _allowances[sender][msg.sender].sub(amount, "OneSwapToken: TRANSFER_AMOUNT_EXCEEDS_ALLOWANCE"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "OneSwapToken: DECREASED_ALLOWANCE_BELOW_ZERO"));
        return true;
    }

    function burn(uint256 amount) public virtual override {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public virtual override {
        uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "OneSwapToken: BURN_AMOUNT_EXCEEDS_ALLOWANCE");

        _approve(account, msg.sender, decreasedAllowance);
        _burn(account, amount);
    }

    function multiTransfer(uint256[] calldata mixedAddrVal) public override returns (bool) {
        for (uint i = 0; i < mixedAddrVal.length; i++) {
            address to = address(mixedAddrVal[i]>>96);
            uint256 value = mixedAddrVal[i]&0xffffffffffff;
            _transfer(msg.sender,to,value);
        }
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "OneSwapToken: TRANSFER_FROM_THE_ZERO_ADDRESS");
        require(recipient != address(0), "OneSwapToken: TRANSFER_TO_THE_ZERO_ADDRESS");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "OneSwapToken: TRANSFER_AMOUNT_EXCEEDS_BALANCE");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "OneSwapToken: BURN_FROM_THE_ZERO_ADDRESS");

        _balances[account] = _balances[account].sub(amount, "OneSwapToken: BURN_AMOUNT_EXCEEDS_BALANCE");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "OneSwapToken: APPROVE_FROM_THE_ZERO_ADDRESS");
        require(spender != address(0), "OneSwapToken: APPROVE_TO_THE_ZERO_ADDRESS");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 ) internal virtual view {
        require(!isBlackListed(from), "OneSwapToken: FROM_IS_BLACKLISTED_BY_TOKEN_OWNER");
        require(!isBlackListed(to), "OneSwapToken: TO_IS_BLACKLISTED_BY_TOKEN_OWNER");
    }

}
