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

// File: ../sc_datasets/DAppSCAN/Quantstamp-MetaVault V2/metavault-3538b8a8c1ea4ec2b68a635c48b938aa1acfbc26/contracts/interfaces/PickleJar.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

interface PickleJar {
    function balanceOf(address account) external view returns (uint);
    function balance() external view returns (uint);
    function available() external view returns (uint);
    function depositAll() external;
    function deposit(uint _amount) external;
    function withdrawAll() external;
    function withdraw(uint _shares) external;
    function getRatio() external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-MetaVault V2/metavault-3538b8a8c1ea4ec2b68a635c48b938aa1acfbc26/contracts/metavault/mock/MockERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract MockERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    address private _owner;

    uint internal _totalSupply;

    mapping(address => uint)                   private _balance;
    mapping(address => mapping(address => uint)) private _allowance;

    modifier _onlyOwner_() {
        require(msg.sender == _owner, "ERR_NOT_OWNER");
        _;
    }

    event Approval(address indexed src, address indexed dst, uint amt);
    event Transfer(address indexed src, address indexed dst, uint amt);

    // Math
    function add(uint a, uint b) internal pure returns (uint c) {
        require((c = a + b) >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require((c = a - b) <= a);
    }

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _owner = msg.sender;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function _move(address src, address dst, uint amt) internal {
        require(_balance[src] >= amt, "!bal");
        _balance[src] = sub(_balance[src], amt);
        _balance[dst] = add(_balance[dst], amt);
        emit Transfer(src, dst, amt);
    }

    function _push(address to, uint amt) internal {
        _move(address(this), to, amt);
    }

    function _pull(address from, uint amt) internal {
        _move(from, address(this), amt);
    }

    function _mint(address dst, uint amt) internal {
        _balance[dst] = add(_balance[dst], amt);
        _totalSupply = add(_totalSupply, amt);
        emit Transfer(address(0), dst, amt);
    }

    function _burn(address dst, uint amt) internal {
        _balance[dst] = sub(_balance[dst], amt);
        _totalSupply = sub(_totalSupply, amt);
        emit Transfer(dst, address(0), amt);
    }

    function allowance(address src, address dst) external view returns (uint) {
        return _allowance[src][dst];
    }

    function balanceOf(address whom) public view returns (uint) {
        return _balance[whom];
    }

    function faucet(uint256 amt) public returns (bool) {
        _mint(msg.sender, amt);
        return true;
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function approve(address dst, uint amt) external returns (bool) {
        _allowance[msg.sender][dst] = amt;
        emit Approval(msg.sender, dst, amt);
        return true;
    }

    function mint(address dst, uint256 amt) public _onlyOwner_ returns (bool) {
        _mint(dst, amt);
        return true;
    }

    function burn(uint amt) public returns (bool) {
        require(_balance[msg.sender] >= amt, "!bal");
        _burn(msg.sender, amt);
        return true;
    }

    function transfer(address dst, uint amt) external returns (bool) {
        _move(msg.sender, dst, amt);
        return true;
    }

    function transferFrom(address src, address dst, uint amt) external returns (bool) {
        require(msg.sender == src || amt <= _allowance[src][msg.sender], "!spender");
        _move(src, dst, amt);
        if (msg.sender != src && _allowance[src][msg.sender] != uint256(- 1)) {
            _allowance[src][msg.sender] = sub(_allowance[src][msg.sender], amt);
            emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
        }
        return true;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-MetaVault V2/metavault-3538b8a8c1ea4ec2b68a635c48b938aa1acfbc26/contracts/metavault/mock/MockPickleJar.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;


contract MockPickleJar is MockERC20 {
    IERC20 public t3crv;
    IERC20 public lpToken;

    constructor(IERC20 _t3crv) public MockERC20("pickling Curve.fi DAI/USDC/USDT", "p3Crv", 18) {
        t3crv = _t3crv;
    }

    function balance() public view returns (uint) {
        return t3crv.balanceOf(address(this));
    }

    function available() external view returns (uint) {
        return balance() * 9500 / 10000;
    }

    function depositAll() external {
        deposit(t3crv.balanceOf(msg.sender));
    }

    function deposit(uint _amount) public {
        t3crv.transferFrom(msg.sender, address(this), _amount);
        uint256 shares = _amount * 1000000000000000000 / getRatio();
        _mint(msg.sender, shares);
    }

    function withdrawAll() external {
        withdraw(balanceOf(msg.sender));
    }

    function withdraw(uint _shares) public {
        uint256 r = _shares * getRatio() / 1000000000000000000;
        _burn(msg.sender, _shares);
        t3crv.transfer(msg.sender, r);
    }

    function getRatio() public pure returns (uint) {
        return 1010000000000000000; // +1%
    }
}
