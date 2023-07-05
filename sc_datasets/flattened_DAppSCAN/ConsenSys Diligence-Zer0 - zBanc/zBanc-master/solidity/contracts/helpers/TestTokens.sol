// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Utils.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Utilities & Common Modifiers
*/
contract Utils {
    // verifies that a value is greater than zero
    modifier greaterThanZero(uint256 _value) {
        _greaterThanZero(_value);
        _;
    }

    // error message binary size optimization
    function _greaterThanZero(uint256 _value) internal pure {
        require(_value > 0, "ERR_ZERO_VALUE");
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        _validAddress(_address);
        _;
    }

    // error message binary size optimization
    function _validAddress(address _address) internal pure {
        require(_address != address(0), "ERR_INVALID_ADDRESS");
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        _notThis(_address);
        _;
    }

    // error message binary size optimization
    function _notThis(address _address) internal view {
        require(_address != address(this), "ERR_ADDRESS_IS_SELF");
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/SafeMath.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Library for basic math operations with overflow/underflow protection
*/
library SafeMath {
    /**
      * @dev returns the sum of _x and _y, reverts if the calculation overflows
      *
      * @param _x   value 1
      * @param _y   value 2
      *
      * @return sum
    */
    function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 z = _x + _y;
        require(z >= _x, "ERR_OVERFLOW");
        return z;
    }

    /**
      * @dev returns the difference of _x minus _y, reverts if the calculation underflows
      *
      * @param _x   minuend
      * @param _y   subtrahend
      *
      * @return difference
    */
    function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
        require(_x >= _y, "ERR_UNDERFLOW");
        return _x - _y;
    }

    /**
      * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
      *
      * @param _x   factor 1
      * @param _y   factor 2
      *
      * @return product
    */
    function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        // gas optimization
        if (_x == 0)
            return 0;

        uint256 z = _x * _y;
        require(z / _x == _y, "ERR_OVERFLOW");
        return z;
    }

    /**
      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
      *
      * @param _x   dividend
      * @param _y   divisor
      *
      * @return quotient
    */
    function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
        require(_y > 0, "ERR_DIVIDE_BY_ZERO");
        uint256 c = _x / _y;
        return c;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/helpers/TestTokens.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;


/**
  * ERC20 Non-Standard Token implementation
*/
contract NonStandardToken is Utils {
    using SafeMath for uint256;

    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /**
      * @dev initializes a new NonStandardToken instance
      *
      * @param _supply      initial supply
    */
    constructor(uint256 _supply)
        internal
    {
        totalSupply = _supply;
        balanceOf[msg.sender] = _supply;
    }

    /**
      * @dev send coins
      * throws on any error rather then return a false flag to minimize user errors
      *
      * @param _to      target address
      * @param _value   transfer amount
    */
    function _transfer(address _to, uint256 _value)
        internal
        validAddress(_to)
    {
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
    }

    /**
      * @dev an account/contract attempts to get the coins
      * throws on any error rather then return a false flag to minimize user errors
      *
      * @param _from    source address
      * @param _to      target address
      * @param _value   transfer amount
    */
    function _transferFrom(address _from, address _to, uint256 _value)
        internal
        validAddress(_from)
        validAddress(_to)
    {
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
    }

    /**
      * @dev allow another account/contract to spend some tokens on your behalf
      * throws on any error rather then return a false flag to minimize user errors
      *
      * also, to minimize the risk of the approve/transferFrom attack vector
      * (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
      * in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
      *
      * @param _spender approved address
      * @param _value   allowance amount
    */
    function _approve(address _spender, uint256 _value)
        internal
        validAddress(_spender)
    {
        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
        require(_value == 0 || allowance[msg.sender][_spender] == 0);

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }
}

contract NonStandardTokenDetailed is NonStandardToken {
    string public name;
    string public symbol;
    uint8 public decimals;

    /**
      * @dev initializes a new NonStandardToken instance
      *
      * @param _name        token name
      * @param _symbol      token symbol
      * @param _decimals    decimal points
      * @param _supply      initial supply
    */
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _supply)
        internal
        NonStandardToken(_supply)
    {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}

contract TestNonStandardToken is NonStandardTokenDetailed {
    bool public ok;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _supply) public
        NonStandardTokenDetailed(_name, _symbol, _decimals, _supply) {
        set(true);
    }

    function set(bool _ok) public {
        ok = _ok;
    }

    function approve(address _spender, uint256 _value) public {
        _approve(_spender, _value);
        require(ok);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(_to, _value);
        require(ok);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        _transferFrom(_from, _to, _value);
        require(ok);
    }
}

contract TestNonStandardTokenWithoutDecimals is NonStandardToken {
    string public name;
    string public symbol;

    constructor(string memory _name, string memory _symbol, uint256 _supply) public
        NonStandardToken(_supply) {
        name = _name;
        symbol = _symbol;
    }

    function approve(address _spender, uint256 _value) public {
        _approve(_spender, _value);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        _transferFrom(_from, _to, _value);
    }
}

contract TestStandardToken is NonStandardTokenDetailed {
    bool public ok;
    bool public ret;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _supply) public
        NonStandardTokenDetailed(_name, _symbol, _decimals, _supply) {
        set(true, true);
    }

    function set(bool _ok, bool _ret) public {
        ok = _ok;
        ret = _ret;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        _approve(_spender, _value);
        require(ok);
        return ret;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(_to, _value);
        require(ok);
        return ret;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        _transferFrom(_from, _to, _value);
        require(ok);
        return ret;
    }
}
