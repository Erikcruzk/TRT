// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/IERC20Token.sol

pragma solidity ^0.4.10;

/**@dev ERC20 compliant token interface. 
https://theethereum.wiki/w/index.php/ERC20_Token_Standard 
https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md */
contract IERC20Token {

    // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
    function name() public constant returns (string _name) { _name; }
    function symbol() public constant returns (string _symbol) { _symbol; }
    function decimals() public constant returns (uint8 _decimals) { _decimals; }
    
    function totalSupply() public constant returns (uint total) {total;}
    function balanceOf(address _owner) public constant returns (uint balance) {_owner; balance;}    
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {_owner; _spender; remaining;}

    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/IOwned.sol

pragma solidity ^0.4.10;

/**@dev Simple interface to Owned base class */
contract IOwned {
    function owner() public constant returns (address) {}
    function transferOwnership(address _newOwner) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Owned.sol

pragma solidity ^0.4.10;

contract Owned is IOwned {
    address public owner;        

    function Owned() public {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    /**@dev allows transferring the contract ownership. */
    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner);
        owner = _newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Manageable.sol

pragma solidity ^0.4.10;

///A token that have an owner and a list of managers that can perform some operations
///Owner is always a manager too
contract Manageable is Owned {

    event ManagerSet(address manager, bool state);

    mapping (address => bool) public managers;

    function Manageable() public Owned() {
        managers[owner] = true;
    }

    /**@dev Allows execution by managers only */
    modifier managerOnly {
        require(managers[msg.sender]);
        _;
    }

    function transferOwnership(address _newOwner) public ownerOnly {
        super.transferOwnership(_newOwner);

        managers[_newOwner] = true;
        managers[msg.sender] = false;
    }

    function setManager(address manager, bool state) public ownerOnly {
        managers[manager] = state;
        ManagerSet(manager, state);
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/ITokenHolder.sol

pragma solidity ^0.4.10;

/*
    Token Holder interface
*/
contract ITokenHolder {
    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/TokenHolder.sol

pragma solidity ^0.4.10;



/**@dev A convenient way to manage token's of a contract */
contract TokenHolder is ITokenHolder, Manageable {
    
    function TokenHolder() {
    }

    /** @dev Withdraws tokens held by the contract and sends them to a given address */
    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
        public
        managerOnly
    {
        assert(_token.transfer(_to, _amount));
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/SafeMath.sol

pragma solidity ^0.4.10;

/**dev Utility methods for overflow-proof arithmetic operations 
*/
contract SafeMath {

    /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a+b >= a);
        return a+b;
    }

    /**dev Returns the difference of a and b. Throws an exception if a is less than b*/
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a >= b);
        return a - b;
    }

    /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/
    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 z = x * y;
        require((x == 0) || (z / x == y));
        return z;
    }

    function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0);
        return x / y;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/TokenUpdater.sol

pragma solidity ^0.4.10;



/**@dev Can exchange one token to another. The common usage process is
1. Lock token transfer on oldToken in order to prevent transfer and get exploits
2. Transfer amount of newToken equal to oldToken.totalSupply to this contract
3. oldToken holders call getUpdatedToken function to receive newTokens equal to their balance
 */
contract TokenUpdater is TokenHolder, SafeMath {

    mapping (address => uint256) public claimedTokens;

    IERC20Token public oldToken;
    IERC20Token public newToken;

    function TokenUpdater(IERC20Token _oldToken, IERC20Token _newToken) public {
        oldToken = _oldToken;
        newToken = _newToken;
    }

    /**@dev Transfers to sender the newToken in amount equal to its balance of oldToken (considering the decimals) */
    function getUpdatedToken() public {
        address holder = msg.sender;
        uint256 amount = oldToken.balanceOf(holder);
        require(claimedTokens[holder] < amount);
        
        amount = amount - claimedTokens[holder];
       // claimedTokens[holder] += amount;
        claimedTokens[holder] = safeAdd(claimedTokens[holder], amount);

        amount = amount * (uint256(10) ** newToken.decimals()) / (uint256(10) ** oldToken.decimals());
        newToken.transfer(holder, amount);

    }
}
