// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/math/SafeMath.sol

pragma solidity <0.6.0 >=0.4.21;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, throws on overflow.
     */

    /*@CTK SafeMath_mul
    @tag spec
    @post __reverted == __has_assertion_failure
    @post __has_assertion_failure == __has_overflow
    @post __reverted == false -> c == a * b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two numbers, truncating the quotient.
     */
    /*@CTK SafeMath_div
    @tag spec
    @pre b != 0
    @post __reverted == __has_assertion_failure
    @post __has_overflow == true -> __has_assertion_failure == true
    @post __reverted == false -> __return == a / b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     */
    /*@CTK SafeMath_sub
    @tag spec
    @post __reverted == __has_assertion_failure
    @post __has_overflow == true -> __has_assertion_failure == true
    @post __reverted == false -> __return == a - b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Adds two numbers, throws on overflow.
     */
    /*@CTK SafeMath_add
    @tag spec
    @post __reverted == __has_assertion_failure
    @post __has_assertion_failure == __has_overflow
    @post __reverted == false -> c == a + b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/ownership/DSAuthority.sol

pragma solidity ^0.5.0;

interface DSAuthority {
    function canCall(
        address src,
        address dst,
        bytes4 sig
    ) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/ownership/DSAuth.sol

pragma solidity ^0.5.0;

contract DSAuthEvents {
    event LogSetAuthority(address indexed authority);
    event LogSetOwner(address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority public _authority;
    address public _owner;

    constructor() public {
        _owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    function setOwner(address owner_) public auth {
        _owner = owner_;
        emit LogSetOwner(_owner);
    }

    function setAuthority(DSAuthority authority_) public auth {
        _authority = authority_;
        emit LogSetAuthority(address(_authority));
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
        _;
    }

    function isAuthorized(address src, bytes4 sig)
        internal
        view
        returns (bool)
    {
        if (src == address(this)) {
            return true;
        } else if (src == _owner) {
            return true;
        } else if (_authority == DSAuthority(address(0))) {
            return false;
        } else {
            return _authority.canCall(src, address(this), sig);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/DSToken.sol

pragma solidity ^0.5.0;


contract DSToken is DSAuth {
    using SafeMath for uint256;
    bool public _stopped;
    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;
    string private _name;
    string private _symbol;

    constructor(string memory symbol_, string memory name_) public {
        _symbol = symbol_;
        _name = name_;
    }

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Mint(address indexed guy, uint256 wad);
    event Burn(address indexed guy, uint256 wad);
    event Stop();
    event Start();

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

    function decimals() public pure returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        require(
            account != address(0),
            "ERC721: balance query for the zero address"
        );
        return _balances[account];
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    modifier stoppable {
        require(!_stopped, "ds-stop-is-stopped");
        _;
    }

    function approve(address guy) external returns (bool) {
        return approve(guy, uint256(-1));
    }

    function approve(address guy, uint256 wad) public stoppable returns (bool) {
        require(guy != address(0), "ERC20: approve to the zero address");

        _allowances[msg.sender][guy] = wad;

        emit Approval(msg.sender, guy, wad);

        return true;
    }

    function transfer(address dst, uint256 wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) public stoppable returns (bool) {
        if (src != msg.sender && _allowances[src][msg.sender] != uint256(-1)) {
            require(
                _allowances[src][msg.sender] >= wad,
                "ds-token-insufficient-approval"
            );
            _allowances[src][msg.sender] = _allowances[src][msg.sender].sub(
                wad
            );
        }

        require(_balances[src] >= wad, "ds-token-insufficient-balance");
        _balances[src] = _balances[src].sub(wad);
        _balances[dst] = _balances[dst].add(wad);

        emit Transfer(src, dst, wad);

        return true;
    }

    function push(address dst, uint256 wad) external {
        transferFrom(msg.sender, dst, wad);
    }

    function pull(address src, uint256 wad) external {
        transferFrom(src, msg.sender, wad);
    }

    function move(
        address src,
        address dst,
        uint256 wad
    ) external {
        transferFrom(src, dst, wad);
    }

    function mint(uint256 wad) external {
        mint(msg.sender, wad);
    }

    function burn(uint256 wad) external {
        burn(msg.sender, wad);
    }

    function mint(address guy, uint256 wad) public auth stoppable {
        _balances[guy] = _balances[guy].add(wad);
        _totalSupply = _totalSupply.add(wad);
        emit Mint(guy, wad);
    }

    function burn(address guy, uint256 wad) public auth stoppable {
        if (guy != msg.sender && _allowances[guy][msg.sender] != uint256(-1)) {
            require(
                _allowances[guy][msg.sender] >= wad,
                "ds-token-insufficient-approval"
            );
            _allowances[guy][msg.sender] = _allowances[guy][msg.sender].sub(
                wad
            );
        }

        require(_balances[guy] >= wad, "ds-token-insufficient-balance");
        _balances[guy] = _balances[guy].sub(wad);
        _totalSupply = _totalSupply.sub(wad);
        emit Burn(guy, wad);
    }

    function destroy(address from_, uint256 amount_) public auth stoppable {
        // do not require allowance

        require(_balances[from_] >= amount_, "ds-token-insufficient-balance");
        _balances[from_] = _balances[from_].sub(amount_);
        _totalSupply = _totalSupply.sub(amount_);
        emit Burn(from_, amount_);
        emit Transfer(from_, address(0), amount_);
    }

    function dsStop() public auth {
        _stopped = true;
        emit Stop();
    }

    function start() public auth {
        _stopped = false;
        emit Start();
    }
}
