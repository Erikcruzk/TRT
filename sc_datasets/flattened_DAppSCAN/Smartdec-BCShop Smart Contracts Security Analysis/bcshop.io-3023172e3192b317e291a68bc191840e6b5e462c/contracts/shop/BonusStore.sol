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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Active.sol

pragma solidity ^0.4.10;

/**@dev Simple contract that provides active/inactive flag, its setter method 
 and modifer for certain method to be called only in active/inactive state  */
contract Active is Owned {
    
    bool public activeState;    
    
    function Active() public {
        activeState = true;
    }

    modifier activeOnly() {
        require(activeState);
        _;
    }

    modifier inactiveOnly() {
        require(!activeState);
        _;
    }

    function setActive(bool state) public ownerOnly {
        activeState = state;
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/ITokenGenerator.sol

pragma solidity ^0.4.10;

contract ITokenGenerator {

    /**@dev returns BonusToken/ETH rate */
    function tokenEtherRate() public constant returns(uint256) {}

    /**@dev Returns token to issue */
    function bonusToken() public constant returns(FloatingSupplyToken) {} 

    /**@dev allows another contracts to request ether from this */
    function requestEther(uint amount) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/IProductEngine.sol

pragma solidity ^0.4.10;

/*Interface to ProductEngine library */
library IProductEngine {

    //Purchase information
    struct Purchase {
        uint256 id; //purchase id
        address buyer; //who made a purchase
        string clientId; //product-specific client id
        uint256 price; //unit price at the moment of purchase
        uint256 paidUnits; //how many units
        bool delivered; //true if Product was delivered
        bool badRating; //true if user changed rating to 'bad'
    }

    /**@dev
    Storage data of product
    1. A couple of words on 'denominator'. It shows how many smallest units can 1 unit be splitted into.
    'price' field still represents price per one unit. One unit = 'denominator' * smallest unit. 
    'maxUnits', 'soldUnits' and 'paidUnits' show number of smallest units. 
    For simple products which can't be fractioned 'denominator' should equal 1.

    For example: denominator = 1,000, 'price' = 100,000. 
    a. If user pays for one product (100,000), his 'paidUnits' field will be 1000.
    b. If 'buy' function receives 50,000, that means user is going to buy
        a half of the product, and 'paidUnits' will be calculated as 500.
    c.If 'buy' function receives 100, that means user wants to buy the smallest unit possible
        and 'paidUnits' will be 1;
        
    Therefore 'paidUnits' = 'weiReceived' * 'denominator' / 'price'
    */
    struct ProductData {        
        address owner; //VendorBase - product's owner
        string name; //Name of the product        
        uint256 price; //Price of one product unit        
        uint256 maxUnits; //Max quantity of limited product units, or 0 if unlimited        
        bool isActive; //True if it is possible to buy a product        
        uint256 soldUnits; //How many units already sold        
        uint256 denominator; //This shows how many decimal digits the smallest unit fraction can hold
        mapping (address => uint256) pendingWithdrawals; //List of overpays to withdraw        
        Purchase[] purchases; //Array of purchase information
        mapping (address => uint256) userRating; //index of first-purchase structure in Purchase[] array. Starts with 1 so you need to subtract 1 to get actual!        
    }

    /**@dev 
    Calculates and returns payment details: how many units are bought, 
     what part of ether should be paid and what part should be returned to buyer  */
    function calculatePaymentDetails(IProductEngine.ProductData storage self, uint256 weiAmount, bool acceptLessUnits) 
        public
        constant        
        returns(uint256 unitsToBuy, uint256 etherToPay, uint256 etherToReturn) 
    {
        self; unitsToBuy; etherToPay; etherToReturn; weiAmount; acceptLessUnits;
    } 

    /**@dev 
    Buy product. Send ether with this function in amount equal to desirable product quantity total price
     * clientId - Buyer's product-specific information. 
     * acceptLessUnits - 'true' if buyer doesn't care of buying the exact amount of limited products.
     If N units left and buyer sends payment for N+1 units then settings this flag to 'true' will result in
     buying N units, while 'false' will simply decline transaction 
     * currentPrice - current product price as shown in 'price' property. 
     Used for security reasons to compare actual price with the price at the moment of transaction. 
     If they are not equal, transaction is declined  */
    function buy(IProductEngine.ProductData storage self, string clientId, bool acceptLessUnits, uint256 currentPrice) public;

    /**@dev 
    Call this to return all previous overpays */
    function withdrawOverpay(IProductEngine.ProductData storage self) public;

    /**@dev 
    Marks purchase with given id as delivered or not */
    function markAsDelivered(IProductEngine.ProductData storage self, uint256 purchaseId, bool state) public;

    /**@dev 
    Changes parameters of product */
    function setParams(
        IProductEngine.ProductData storage self,
        string newName, 
        uint256 newPrice,         
        uint256 newMaxUnits,    
        bool newIsActive        
    ) public;

    /**@dev Changes rating of product */
    function changeRating(IProductEngine.ProductData storage self, bool newLikeState) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/IProduct.sol

pragma solidity ^0.4.10;


/**@dev Product abstraction with 'buy' method */
contract IProduct is IOwned {
    /**@dev 
    Buy product. Send ether with this function in amount equal to desirable product quantity total price
     * clientId - Buyer's product-specific information. 
     * acceptLessUnits - 'true' if buyer doesn't care of buying the exact amount of limited products.
     If N units left and buyer sends payment for N+1 units then settings this flag to 'true' will result in
     buying N units, while 'false' will simply decline transaction 
     * currentPrice - current product price as shown in 'price' property. 
     Used for security reasons to compare actual price with the price at the moment of transaction. 
     If they are not equal, transaction is declined  */
    function buy(string clientId, bool acceptLessUnits, uint256 currentPrice) public payable;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/IVendorManager.sol

pragma solidity ^0.4.10;

contract IVendorManager {
    /**@dev Returns true if it is valid factory for creation */
    function validFactory(address factory) public constant returns (bool) {factory;}

    /**@dev Returns true if it allows creation operations */
    function active() public constant returns (bool) {}

    /**@dev Returns provider wallet address */
    function provider() public constant returns (address) {}

    /**@dev Retursn default fee to provider */
    function providerFeePromille() public constant returns (uint256) {}

    /**@dev Returns true if vendor contract was created by factory */
    function validVendor(address vendor) public constant returns(bool) {vendor;}

    /**@dev Adds new vendor to storage */
    function addVendor(address vendorOwner, address vendor) public;}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/VendorBase.sol

pragma solidity ^0.4.10;



/// An interface to Vendor object, stored in product as an owner 
contract VendorBase is Owned {    
    address public vendor;
    //address public provider;
    uint256 public providerFeePromille;    
    
    /**@dev Manager for vendors */
    IVendorManager public vendorManager;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/ICheckList.sol

pragma solidity ^0.4.10;

contract ICheckList {
    function contains(address addr) public constant returns(bool) {return false;}
    function set(address addr, bool state) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/BonusStore.sol

pragma solidity ^0.4.10;







contract BonusStore is Active {

    event ProductBought(address indexed buyer, address indexed product, string clientId, uint256 price, uint32 paidUnits);
    
    /**@dev Manager that controls vendor validity */
    ICheckList public allowedProducts;

    /**@dev Token generator that give Ether to compensate bonus tokens */
    ITokenGenerator public generator;

    function BonusStore(ITokenGenerator _generator, ICheckList _allowedProducts) {
        generator = _generator;
        allowedProducts = _allowedProducts;
    }

    /**@dev allows to receive ether directly */
    function () payable {}

    /**@dev Sets fund to new one */
    function setTokenGenerator(ITokenGenerator newGenerator) public ownerOnly {
        generator = newGenerator;
    }

    /**@dev Buys specific product for Bonus Tokens. User should first call 'approve' on token contract */
    function buy(IProduct product, string clientId, uint32 units, uint256 currentPrice) activeOnly {
        require(allowedProducts.contains(product));

        //calculate the amount of tokens to pay
        uint256 etherAmount = units * currentPrice;
     
        uint256 tokenAmount = etherAmount * generator.tokenEtherRate();
        generator.bonusToken().transferFrom(msg.sender, this, tokenAmount);
        generator.bonusToken().burn(tokenAmount);
        
        //get ether from fund, this will throw if there is not enough ether in the fund, which is unlikely
        generator.requestEther(etherAmount);
        
        //call product.buy
        product.buy.value(etherAmount)(clientId, false, currentPrice);

        ProductBought(msg.sender, product, clientId, currentPrice, units);
    }
}
