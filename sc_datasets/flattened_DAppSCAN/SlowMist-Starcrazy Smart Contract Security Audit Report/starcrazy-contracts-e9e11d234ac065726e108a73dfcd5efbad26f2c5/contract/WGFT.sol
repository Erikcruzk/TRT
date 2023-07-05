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

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/IERC20Basic.sol

pragma solidity <0.6.0 >=0.4.21;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract IERC20Basic {
    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/IERC20.sol

pragma solidity <0.6.0 >=0.4.21;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract IERC20 is IERC20Basic {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function allowance(address owner, address spender)
        public
        view
        returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/IERC223.sol

pragma solidity <0.6.0 >=0.4.21;

interface IERC223 {
    function transfer(
        address to,
        uint256 amount,
        bytes calldata data
    ) external returns (bool ok);

    function transferFrom(
        address from,
        address to,
        uint256 amount,
        bytes calldata data
    ) external returns (bool ok);

    event ERC223Transfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data
    );
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/ISmartToken.sol

pragma solidity <0.6.0 >=0.4.21;

interface ISmartToken {
    function transferOwnership(address newOwner_) external;

    function acceptOwnership() external;

    function disableTransfers(bool disable_) external;

    function issue(address to_, uint256 amount_) external;
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

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/IApproveAndCallFallBack.sol

pragma solidity ^0.5.0;

contract IApproveAndCallFallBack {
    function receiveApproval(
        address from,
        uint256 amount_,
        address token_,
        bytes memory data_
    ) public;
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/ITokenController.sol

pragma solidity ^0.5.0;

/// @dev The token _controller contract must implement these functions
contract ITokenController {
    /// @notice Called when `owner_` sends ether to the MiniMe Token contract
    /// @param owner_ The address that sent the ether to create tokens
    /// @return True if the ether is accepted, false if it throws
    function proxyPayment(
        address owner_,
        bytes4 sig,
        bytes memory data
    ) public payable returns (bool);

    /// @notice Notifies the _controller about a token transfer allowing the
    ///  _controller to react if desired
    /// @param from_ The origin of the transfer
    /// @param to_ The destination of the transfer
    /// @param amount_ The amount of the transfer
    /// @return False if the _controller does not authorize the transfer
    function onTransfer(
        address from_,
        address to_,
        uint256 amount_
    ) public returns (bool);

    /// @notice Notifies the _controller about an approval allowing the
    ///  _controller to react if desired
    /// @param owner_ The address that calls `approve()`
    /// @param spender_ The spender in the `approve()` call
    /// @param amount_ The amount in the `approve()` call
    /// @return False if the _controller does not authorize the approval
    function onApprove(
        address owner_,
        address spender_,
        uint256 amount_
    ) public returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/IERC223Receiving.sol

pragma solidity ^0.5.0;

/// @title IERC223Receiving - Standard interface implementation for compatibility with ERC223 tokens.
interface IERC223Receiving {
    /// @dev Function that is called when a user or another contract wants to transfer funds.
    /// @param from_ Transaction initiator, analogue of msg.sender
    /// @param value_ Number of tokens to transfer.
    /// @param data_ Data containig a function signature and/or parameters
    function tokenFallback(
        address from_,
        uint256 value_,
        bytes calldata data_
    ) external;
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/WGFT.sol

pragma solidity ^0.5.0;








contract WGFT is
    DSToken("WGFT", "Wrapped Game Fantasy Token"),
    IERC223,
    ISmartToken
{
    using SafeMath for uint256;
    address private _newOwner;
    bool public _transfersEnabled = true; // true if transfer/transferFrom are enabled, false if not

    uint256 private _cap;

    address private _controller;

    // The Wrapped TOKEN
    IERC20 public wrappedToken;

    // allows execution only when transfers aren't disabled
    modifier transfersAllowed() {
        assert(_transfersEnabled);
        _;
    }

    constructor(IERC20 _wrappedToken) public {
        wrappedToken = _wrappedToken;
        _controller = msg.sender;
        uint256 perCoin = 1e18;
        _cap = perCoin.mul(3000 * 10000);
    }

    //////////
    // IOwned Methods
    //////////

    /**
        @dev allows transferring the contract ownership
        the new owner still needs to accept the transfer
        can only be called by the contract owner
        @param newOwner_    new contract owner
    */
    function transferOwnership(address newOwner_) public auth {
        require(newOwner_ != _owner, "WGFT-already-an-owner");
        _newOwner = newOwner_;
    }

    /**
        @dev used by a new owner to accept an ownership transfer
    */
    function acceptOwnership() public {
        require(msg.sender == _newOwner, "WGFT-not-new-owner");
        _owner = _newOwner;
        _newOwner = address(0);
    }

    //////////
    // SmartToken Methods
    //////////
    /**
        @dev disables/enables transfers
        can only be called by the contract owner
        @param disable_    true to disable transfers, false to enable them
    */
    function disableTransfers(bool disable_) public auth {
        _transfersEnabled = !disable_;
    }

    function issue(address to_, uint256 amount_) public auth stoppable {
        mint(to_, amount_);
    }

    //////////
    // Cap Methods
    //////////
    function cap() public view returns (uint256) {
        return _cap;
    }

    //////////
    // Cap Methods
    //////////
    function changeCap(uint256 newCap_) public auth {
        require(newCap_ >= totalSupply());

        _cap = newCap_;
    }

    //////////
    // Controller Methods
    //////////
    /// @notice Changes the _controller of the contract
    /// @param newController_ The new _controller of the contract
    function changeController(address newController_) public auth {
        _controller = newController_;
    }

    /// @notice Send `amount_` tokens to `to_` from `from_` on the condition it
    ///  is approved by `from_`
    /// @param from_ The address holding the tokens being transferred
    /// @param to_ The address of the recipient
    /// @param amount_ The amount of tokens to be transferred
    /// @return True if the transfer was successful
    function transferFrom(
        address from_,
        address to_,
        uint256 amount_
    ) public transfersAllowed returns (bool success) {
        // Alerts the token _controller of the transfer
        if (isContract(_controller)) {
            if (!ITokenController(_controller).onTransfer(from_, to_, amount_))
                revert();
        }

        success = super.transferFrom(from_, to_, amount_);
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     */
    function transferFrom(
        address from_,
        address to_,
        uint256 amount_,
        bytes memory data_
    ) public transfersAllowed returns (bool success) {
        // Alerts the token _controller of the transfer
        if (isContract(_controller)) {
            if (!ITokenController(_controller).onTransfer(from_, to_, amount_))
                revert();
        }

        require(
            super.transferFrom(from_, to_, amount_),
            "WGFT-insufficient-balance"
        );

        if (isContract(to_)) {
            IERC223Receiving receiver = IERC223Receiving(to_);
            receiver.tokenFallback(from_, amount_, data_);
        }

        emit ERC223Transfer(from_, to_, amount_, data_);

        return true;
    }

    /*
     * ERC 223
     * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
     * https://github.com/ethereum/EIPs/issues/223
     * function transfer(address to_, uint256 value_, bytes memory data_) public returns (bool success);
     */
    /// @notice Send `value_` tokens to `to_` from `msg.sender` and trigger
    /// tokenFallback if sender is a contract.
    /// @dev Function that is called when a user or another contract wants to transfer funds.
    /// @param to_ Address of token receiver.
    /// @param amount_ Number of tokens to transfer.
    /// @param data_ Data to be sent to tokenFallback
    /// @return Returns success of function call.
    function transfer(
        address to_,
        uint256 amount_,
        bytes memory data_
    ) public returns (bool success) {
        return transferFrom(msg.sender, to_, amount_, data_);
    }

    /// @notice `msg.sender` approves `spender_` to spend `amount_` tokens on
    ///  its behalf. This is a modified version of the ERC20 approve function
    ///  to be a little bit safer
    /// @param spender_ The address of the account able to transfer the tokens
    /// @param amount_ The amount of tokens to be approved for transfer
    /// @return True if the approval was successful
    function approve(address spender_, uint256 amount_)
        public
        returns (bool success)
    {
        // Alerts the token _controller of the approve function call
        if (isContract(_controller)) {
            if (
                !ITokenController(_controller).onApprove(
                    msg.sender,
                    spender_,
                    amount_
                )
            ) revert();
        }

        return super.approve(spender_, amount_);
    }

    function mint(address guy_, uint256 wad_) public auth stoppable {
        require(totalSupply().add(wad_) <= _cap, "WGFT-insufficient-cap");

        super.mint(guy_, wad_);

        emit Transfer(address(0), guy_, wad_);
    }

    function burn(address guy_, uint256 wad_) public auth stoppable {
        super.burn(guy_, wad_);

        emit Transfer(guy_, address(0), wad_);
    }

    /// @notice `msg.sender` approves `spender_` to send `amount_` tokens on
    ///  its behalf, and then a function is triggered in the contract that is
    ///  being approved, `spender_`. This allows users to use their tokens to
    ///  interact with contracts in one function call instead of two
    /// @param spender_ The address of the contract able to transfer the tokens
    /// @param amount_ The amount of tokens to be approved for transfer
    /// @return True if the function call was successful
    function approveAndCall(
        address spender_,
        uint256 amount_,
        bytes memory extraData_
    ) public returns (bool success) {
        if (!approve(spender_, amount_)) revert();

        IApproveAndCallFallBack(spender_).receiveApproval(
            msg.sender,
            amount_,
            address(this),
            extraData_
        );

        return true;
    }

    /// @dev Internal function to determine if an address is a contract
    /// @param addr_ The address being queried
    /// @return True if `addr_` is a contract
    function isContract(address addr_) internal view returns (bool) {
        uint256 size;
        if (addr_ == address(0)) return false;
        assembly {
            size := extcodesize(addr_)
        }
        return size > 0;
    }

    /// @notice The fallback function: If the contract's _controller has not been
    ///  set to 0, then the `proxyPayment` method is called which relays the
    ///  ether and creates tokens as described in the token _controller contract
    function() external payable {
        if (isContract(_controller)) {
            if (
                !ITokenController(_controller).proxyPayment.value(msg.value)(
                    msg.sender,
                    msg.sig,
                    msg.data
                )
            ) revert();
        } else {
            revert();
        }
    }

    //////////
    // Safety Methods
    //////////

    /// @notice This method can be used by the owner to extract mistakenly
    ///  sent tokens to this contract.
    /// @param token_ The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract ether.
    function claimTokens(address token_) public auth {
        if (token_ == address(0)) {
            address(msg.sender).transfer(address(this).balance);
            return;
        }

        IERC20 token = IERC20(token_);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(address(msg.sender), balance);

        emit ClaimedTokens(token_, address(msg.sender), balance);
    }

    function withdrawTokens(
        IERC20 token_,
        address to_,
        uint256 amount_
    ) public auth {
        assert(token_.transfer(to_, amount_));
    }

    ////////////////
    // Events
    ////////////////

    event ClaimedTokens(
        address indexed token_,
        address indexed controller_,
        uint256 amount_
    );

    event ReceiveApproval(
        address _sender,
        uint256 _value,
        address _tokenContract,
        bytes _extraData,
        uint256 action
    );

    function receiveApproval(
        address _sender,
        uint256 _value,
        address _tokenContract,
        bytes memory _extraData
    ) public {
        require(_value > 0, "approval zero");
        uint256 action;
        assembly {
            action := mload(add(_extraData, 0x20))
        }
        emit ReceiveApproval(
            _sender,
            _value,
            _tokenContract,
            _extraData,
            action
        );
        require(action == 5, "unknow action");
        if (action == 5) {
            // swapFrom
            require(
                _tokenContract == address(wrappedToken),
                "approval and want deposit, but used token isn't GFT"
            );
            uint256 amount;
            assembly {
                amount := mload(add(_extraData, 0x40))
            }
            _swapFrom(_sender, amount);
        }
    }

    function _swapBurn(address guy, uint256 wad) private stoppable {
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
        emit Transfer(guy, address(0), wad);
    }

    function _swapMint(address guy, uint256 wad) private stoppable {
        require(totalSupply().add(wad) <= _cap, "WGFT-insufficient-cap");

        _balances[guy] = _balances[guy].add(wad);
        _totalSupply = _totalSupply.add(wad);
        emit Mint(guy, wad);
        emit Transfer(address(0), guy, wad);
    }

    function swapTo(uint256 _amount) external stoppable {
        _swapTo(msg.sender, _amount);
    }

    function _swapTo(address _from, uint256 _amount) internal stoppable {
        _swapBurn(_from, _amount);
        wrappedToken.transferFrom(address(this), msg.sender, _amount);
    }

    function swapFrom(uint256 _amount) external stoppable {
        _swapFrom(msg.sender, _amount);
    }

    function _swapFrom(address _from, uint256 _amount) internal stoppable {
        wrappedToken.transferFrom(msg.sender, address(this), _amount);
        _swapMint(_from, _amount);
    }
}
