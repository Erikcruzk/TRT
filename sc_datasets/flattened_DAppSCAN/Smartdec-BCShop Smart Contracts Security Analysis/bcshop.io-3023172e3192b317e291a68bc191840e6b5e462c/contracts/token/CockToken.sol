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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/ERC20StandardToken.sol

pragma solidity ^0.4.10;


/**@dev Standard ERC20 compliant token implementation */
contract ERC20StandardToken is IERC20Token, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals;

    //tokens already issued
    uint256 tokensIssued;
    //balances for each account
    mapping (address => uint256) balances;
    //one account approves the transfer of an amount to another account
    mapping (address => mapping (address => uint256)) allowed;

    function ERC20StandardToken() public {
     
    }    

    //
    //IERC20Token implementation
    // 

    function totalSupply() public constant returns (uint total) {
        total = tokensIssued;
    }
 
    function balanceOf(address _owner) public constant returns (uint balance) {
        balance = balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));

        // safeSub inside doTransfer will throw if there is not enough balance.
        doTransfer(msg.sender, _to, _value);        
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        
        // Check for allowance is not needed because sub(_allowance, _value) will throw if this condition is not met
        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);        
        // safeSub inside doTransfer will throw if there is not enough balance.
        doTransfer(_from, _to, _value);        
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        remaining = allowed[_owner][_spender];
    }    

    //
    // Additional functions
    //
    /**@dev Gets real token amount in the smallest token units */
    function getRealTokenAmount(uint256 tokens) public constant returns (uint256) {
        return tokens * (uint256(10) ** decimals);
    }

    //
    // Internal functions
    //    
    
    function doTransfer(address _from, address _to, uint256 _value) internal {
        balances[_from] = safeSub(balances[_from], _value);
        balances[_to] = safeAdd(balances[_to], _value);
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/PreapprovedToken.sol

pragma solidity ^0.4.18;


/**@dev This token stores list of preapproved spenders - those allowed to 'transferFrom' without approval.
 It also contains a flag 'transferAllowed' that switches possibility of user-to-user transfer */
contract PreapprovedToken is Owned, ERC20StandardToken {
    event SpenderPreapproved(address spender, bool state);

    mapping (address => bool) public preapproved;
    
    bool public transferAllowed;

    function PreapprovedToken() {        
    }

    modifier canTransfer(address _to) {
        require(_to != address(0));
        require(preapproved[msg.sender] || transferAllowed);
        _;
    }

    function preapprove(address spender, bool state) public ownerOnly {
        preapproved[spender] = state;
        SpenderPreapproved(spender, state);
    }

    function allowTransfer(bool state) public ownerOnly {
        transferAllowed = state;
    }

    function transferFrom(address _from, address _to, uint256 _value) 
        public 
        canTransfer(_to)
        returns (bool) 
    {        
        //if msg.sender is not preapproved check the allowance
        if(!preapproved[msg.sender]) {
            // Check for allowance is not needed because 'safeSub' throws if result is negative
            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
        }

        // safeSub inside doTransfer will throw if there is not enough balance.
        doTransfer(_from, _to, _value);        
        Transfer(_from, _to, _value);
        return true;
    }
    
    function transfer(address _to, uint256 _value) 
        public 
        canTransfer(_to)
        returns (bool) 
    {
        // safeSub inside doTransfer will throw if there is not enough balance.
        doTransfer(msg.sender, _to, _value);        
        Transfer(msg.sender, _to, _value);
        return true;
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/MintableToken.sol

pragma solidity ^0.4.10;



///Token that can be minted after creation
contract MintableToken is Manageable, ERC20StandardToken {

    /** List of minters */
    mapping(address => bool) public minters;

    /**@dev Allows execution by minters only */
    modifier minterOnly {
        require(minters[msg.sender]);
        _;
    }

    function MintableToken() public {
        minters[owner] = true;        
    }

    /**@dev Allow or disallow given address to mint new tokens */
    function setMinter(address minter, bool state) public managerOnly {
        minters[minter] = state;
    }

    /**@dev Creates given amount of tokens*/
    function mint(address beneficiary, uint256 amount) public minterOnly {
        balances[beneficiary] = safeAdd(balances[beneficiary], amount);
        tokensIssued = safeAdd(tokensIssued, amount);
        Transfer(0x0, beneficiary, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/IBurnableToken.sol

pragma solidity ^0.4.10;

/**@dev A token that can be burnt */
contract IBurnableToken {
    function burn(uint256 _value) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/FloatingSupplyToken.sol

pragma solidity ^0.4.10;


/**@dev A token that can be minted and burnt */
contract FloatingSupplyToken is MintableToken, IBurnableToken {
    
    event Burn(address sender, uint256 value);

    function burn(uint256 amount) public {
        balances[msg.sender] = safeSub(balances[msg.sender], amount);
        tokensIssued = safeSub(tokensIssued, amount);
 
        Burn(msg.sender, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/CockToken.sol

pragma solidity ^0.4.18;


contract CockToken is PreapprovedToken, FloatingSupplyToken {
    function CockToken(string _name, string _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals; 
    }
}
