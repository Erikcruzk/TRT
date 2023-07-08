// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/IOwned.sol

pragma solidity ^0.4.10;

/**@dev Simple interface to Owned base class */
contract IOwned {
    function owner() public constant returns (address) {}
    function transferOwnership(address _newOwner) public;
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/ReentryProtected.sol

pragma solidity ^0.4.10;

/** @dev Mutex based reentry protection */
contract ReentryProtected {
    // The reentry protection state mutex.
    bool _mutex;

    //Ensures that there are no reenters in function.
    //Functions shouldn't use 'return'. Instead they assign return values through parameters    
    modifier preventReentry() {
        require(!_mutex);
        _mutex = true;
        _;
        _mutex = false;
        return;
    }

    //allows execution if mutex has already been set
    modifier noReentry() {
        require(!_mutex);
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/upgrade/LibDispatcher.sol

pragma solidity ^0.4.10;

/*
Based on https://blog.zeppelin.solutions/proxy-libraries-in-solidity-79fbe4b970fd

LibDispatcher is used to switch contract's that uses library to new library version

Contract should link it instead of any other library it plans upgrade

LibDispatcherStorage stores metadata for dispatching - current library version and return 
value sizes for every function that returns some result. Its address is hardcoded in LibDispatcher
 s it doesn't allowed to have its own storage in order to be able to 'delgatecall' libraries.

During deploy phase you should replace '1111222233334444555566667777888899990000' in binary data 
of LibDispatcher with address of actual LibDispatcherStorage instance omitting '0x' prefix.
*/

contract LibDispatcherStorage is Owned {
    address public lib;
    mapping(bytes4 => uint32) public sizes;
    event FunctionChanged(string name, bytes4 sig, uint32 size);

    function LibDispatcherStorage(address newLib) public {
        replace(newLib);
    }

    function replace(address newLib) public ownerOnly {
        lib = newLib;
    }

    /**@dev Adds information about function return value suze.
    IMPORTANT! 'func' parameter should contain no spaces after commas in parameters list, also no parameter names.
    
    Valid examples are:
    getVars(IExampleLib.Data storage,uint256)
    getVars(uint256)
    getVars()

    Invalid examples are
    getVars(IExampleLib.Data storage, uint256) - space after comma
    getVars(uint256 a) - parameter name
     */
    function addFunction(string func, uint32 size) public ownerOnly {
        bytes4 sig = bytes4(sha3(func));
        sizes[sig] = size;
        FunctionChanged(func, sig, size);
    }
}

contract LibDispatcher {
    //event FunctionCalled(bytes4 sig, uint32 size, address dest);

    function LibDispatcher() public {}

    function() public payable {
        LibDispatcherStorage dispatcherStorage = LibDispatcherStorage(0x1111222233334444555566667777888899990000);

        uint32 len = dispatcherStorage.sizes(msg.sig);
        address target = dispatcherStorage.lib();

        //FunctionCalled(msg.sig, len, target);
        bool callResult = false;
        assembly {
            calldatacopy(0x0, 0x0, calldatasize)
            callResult := delegatecall(sub(gas, 10000), target, 0x0, calldatasize, 0, len)
        }

        require (callResult);
        
        assembly {
            return(0, len)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Versioned.sol

pragma solidity ^0.4.10;

/**@dev Simple contract for something that supports versioning */
contract Versioned {
    uint32 public version;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/Product.sol

pragma solidity ^0.4.10;






/* 
IProductEngine Library Dispatcher's storage that initially stores return values 
for IProductEngines functions 
*/
contract ProductDispatcherStorage is LibDispatcherStorage {

    function ProductDispatcherStorage(address newLib) public
        LibDispatcherStorage(newLib) {

        addFunction("calculatePaymentDetails(IProductEngine.ProductData storage,uint256,bool)", 96);
    }
}

//Vendor's product for sale
//TODO add return money function
//TODO add ratings
contract Product is Owned, Versioned {
    using IProductEngine for IProductEngine.ProductData;

    IProductEngine.ProductData public engine;

    //event FunctionCalled(bytes4 sig, uint32 size, address dest);    
    event ProductBoughtEx(uint256 indexed id, address indexed buyer, string clientId, uint256 price, uint256 paidUnits);
    event Created(string name, uint32 version, uint256 price, uint256 maxUnits);

    /**@dev 
    unitPriceInWei - price of one whole unit
    maxProductUnits - amount of smallest units possible for sale or 0 if unlimited.    
    Read IProductEngine.sol for more info on 'denominator', 'price' and 'maxUnits' connection */
    function Product(        
        string productName,
        uint256 unitPriceInWei,         
        uint256 maxProductUnits, 
        uint256 denominator
    ) public {
        engine.owner = owner;
        engine.name = productName;
        engine.soldUnits = 0;        
        engine.price = unitPriceInWei * 1 wei;       
        engine.maxUnits = maxProductUnits;
        engine.isActive = true;
        engine.denominator = denominator;
        version = 1;
        Created(productName, version, unitPriceInWei, maxProductUnits);
    }
    
    //function() public payable {}

    /**@dev 
    Returns total amount of purchase transactions */
    function getTotalPurchases() public constant returns (uint256) {
        return engine.purchases.length;
    }

    /**@dev 
    Returns information about purchase with given index */
    function getPurchase(uint256 index) 
        public
        constant 
        returns(uint256 id, address buyer, string clientId, uint256 price, uint256 paidUnits, bool delivered, bool badRating) 
    {
        return (
            engine.purchases[index].id,
            engine.purchases[index].buyer,
            engine.purchases[index].clientId,
            engine.purchases[index].price,   
            engine.purchases[index].paidUnits,     
            engine.purchases[index].delivered,
            engine.purchases[index].badRating);
    }

    /**@dev 
    Returns purchase/rating structure index */
    function getUserRatingIndex(address user)
        public
        constant 
        returns (uint256)
    {
        return engine.userRating[user];
    }


    /**@dev 
    Returns pending withdrawal of given buyer */
    function getPendingWithdrawal(address buyer) public constant returns(uint256) {
        return engine.pendingWithdrawals[buyer];
    }    

    /**@dev 
    Buy product. */
    function buy(string clientId, bool acceptLessUnits, uint256 currentPrice)
        public 
    /* preventReentry */
        payable 
    {
        engine.buy(clientId, acceptLessUnits, currentPrice);
    }

    /**@dev Call this to return all previous overpays */
    function withdrawOverpay() public {
        engine.withdrawOverpay();
    }
    
    /**@dev Returns payment details - how much units can be bought, and how much to pay  */
    function calculatePaymentDetails(uint256 weiAmount, bool acceptLessUnits)
        public 
        constant
        returns(uint256 unitsToBuy, uint256 etherToPay, uint256 etherToReturn) 
    {
        return engine.calculatePaymentDetails(weiAmount, acceptLessUnits);        
    }
    
    /**@dev Marks purchase as delivered or undelivered */
    function markAsDelivered(uint256 purchaseId, bool state) public {
        engine.markAsDelivered(purchaseId, state);
    }

    /**@dev Changes parameters of product */
    function setParams(
        string newName, 
        uint256 newPrice,         
        uint256 newMaxUnits,
        bool newIsActive        
    ) 
        public 
    {
        engine.setParams(newName, newPrice, newMaxUnits, newIsActive);
    }

    function changeRating(bool newLikeState) public {
        engine.changeRating(newLikeState);
    } 

    /**@dev Owned override */
    function transferOwnership(address _newOwner) public ownerOnly {
        super.transferOwnership(_newOwner);
        engine.owner = owner;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/IVendor.sol

pragma solidity ^0.4.10;

/**@dev Vendor interface for interaction with manager contracts */
contract IVendor is IOwned {
    /**@dev Returns count of products */
    //function getProductsCount() public constant returns(uint32) {}

    /**@dev Adds product to storage */
    function addProduct(address product) public;    
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/ICheckList.sol

pragma solidity ^0.4.10;

contract ICheckList {
    function contains(address addr) public constant returns(bool) {return false;}
    function set(address addr, bool state) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/CheckList.sol

pragma solidity ^0.4.10;


/**@dev Simple map address=>bool. Sometimes it is convenient or even 
 necessary to store the mapping outside of any other contract */
contract CheckList is Manageable, ICheckList {

    mapping (address=>bool) public contains;

    function CheckList() {
    }

    function set(address addr, bool state) public managerOnly {
        contains[addr] = state;
    }

    function setArray(address[] addresses, bool state) public managerOnly {
        for(uint256 i = 0; i < addresses.length; ++i) {
            contains[addresses[i]] = state;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/ProductFactory.sol

pragma solidity ^0.4.18;






/**@dev Factory to create and vendors and products */
contract ProductFactory is Owned, Versioned {
    
    event ProductCreated(address indexed product, address indexed vendor, string name);
    event ProductAdded(address indexed product, address indexed vendor);

    IVendorManager public manager;
    ICheckList public allowedProducts;

    function ProductFactory(IVendorManager _manager, ICheckList _allowedProducts) public {
        manager = _manager;
        allowedProducts = _allowedProducts;
        version = 1;
    }

    // allows execution only if this factory is set in manager
    modifier activeOnly {
        require(manager.validFactory(this) && manager.active());
        _;
    }

    /**@dev Creates product with specified parameters */
    function createProduct(
        IVendor vendor,
        string name, 
        uint256 unitPriceInWei,
        uint256 maxQuantity,
        uint256 denominator
    )
        public      
        activeOnly 
        returns (address) 
    {
        //check that sender is owner of given vendor
        require(msg.sender == vendor.owner());

        //check that vendor is stored in manager
        require(manager.validVendor(vendor));        

        Product product = new Product(            
            name, 
            unitPriceInWei, 
            maxQuantity,
            denominator);            

        product.transferOwnership(address(vendor));
        vendor.addProduct(address(product));
        allowedProducts.set(product, true);

        ProductCreated(product, vendor, name);        
        return product;
    }

    /**@dev Manually adds externally created product to a vendor. 
    In addition to calling this method product ownership should be transfered to vendor*/
    function addProduct(IVendor vendor, IProduct product) 
        public
        activeOnly
        ownerOnly
    {
        vendor.addProduct(address(product));
        allowedProducts.set(product, true);
        ProductAdded(product, vendor);  
    }
}
