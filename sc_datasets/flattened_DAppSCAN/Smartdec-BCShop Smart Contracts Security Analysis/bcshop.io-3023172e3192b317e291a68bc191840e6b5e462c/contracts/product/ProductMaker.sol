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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/SafeMathLib.sol

pragma solidity ^0.4.10;

/**dev Utility methods for overflow-proof arithmetic operations 
*/
library SafeMathLib {

    /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/
    function safeAdd(uint256 self, uint256 b) internal pure returns (uint256) {        
        uint256 c = self + b;
        require(c >= self);

        return c;
    }

    /**dev Returns the difference of a and b. Throws an exception if a is less than b*/
    function safeSub(uint256 self, uint256 b) internal pure returns (uint256) {
        require(self >= b);
        return self - b;
    }

    /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/
    function safeMult(uint256 self, uint256 y) internal pure returns(uint256) {
        uint256 z = self * y;
        require((self == 0) || (z / self == y));
        return z;
    }

    function safeDiv(uint256 self, uint256 y) internal pure returns (uint256) {
        require(y != 0);
        return self / y;
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IProductStorage.sol

pragma solidity ^0.4.18;

//Abstraction of ProductStorage
contract IProductStorage {

    //
    //Inner types
    /**dev Purchase state 
        0-finished. purchase is completed and can't be reverted, 
        1-paid. can be complained using escrow.
        2-complain. there was a complain
        3-canceled. customer won the dispute and got eth back
        4-pending. vendor can withdraw his funds from escrow
    */
    enum PurchaseState {Finished, Paid, Complain, Canceled, Pending}

    //
    // Methods

    function banned(uint256 productId) public constant returns(bool) {}

    function getTotalProducts() public constant returns(uint256);    

    function getTextData(uint256 productId) public constant returns(string name, string data);    

    /**@dev Returns information about purchase with given index for the given product */
    function getProductData(uint256 productId) public constant returns(
            uint256 price, 
            uint256 maxUnits, 
            uint256 soldUnits
        );    

    function getProductActivityData(uint256 productId) public constant returns(
            bool active,
            uint256 startTime,
            uint256 endTime
        );

    /**@dev Returns product's creator */
    function getProductOwner(uint256 productId) public constant returns(address);    

    /**@dev Returns product's price in wei */
    function getProductPrice(uint256 productId) public constant returns(uint256);    

    function isEscrowUsed(uint256 productId) public constant returns(bool);

    function isFiatPriceUsed(uint256 productId) public constant returns(bool);

    function isProductActive(uint256 productId) public constant returns(bool);

    /**@dev Returns total amount of purchase transactions for the given product */
    function getTotalPurchases(uint256 productId) public constant returns (uint256);    

    /**@dev Returns information about purchase with given index for the given product */
    function getPurchase(uint256 productId, uint256 purchaseId) public constant returns(PurchaseState);    

    /**@dev Returns escrow-related data for specified purchase */
    function getEscrowData(uint256 productId, uint256 purchaseId)
        public
        constant
        returns (address, uint256, uint256, uint256);    

    /**@dev Returns wallet for specific vendor */
    function getVendorWallet(address vendor) public constant returns(address);    

    /**@dev Returns fee permille for specific vendor */
    function getVendorFee(address vendor) public constant returns(uint16);    

    function setVendorInfo(address vendor, address wallet, uint16 feePermille) public;        

    /**@dev Adds new product to the storage */
    function createProduct(
        address owner,         
        uint256 price, 
        uint256 maxUnits,
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) public;

    /**@dev Edits product in the storage */   
    function editProduct(
        uint256 productId,        
        uint256 price, 
        uint256 maxUnits, 
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) public;

    // function editProductData(
    //     uint256 productId,        
    //     uint256 price,
    //     bool useFiatPrice, 
    //     uint256 maxUnits, 
    //     bool isActive,
    //     uint256 startTime, 
    //     uint256 endTime,
    //     bool useEscrow        
    // ) public;

    // function editProductText(
    //     uint256 productId,        
    //     string name,
    //     string data
    // ) public;

    /**@dev Changes the value of sold units */
    function changeSoldUnits(uint256 productId, uint256 soldUnits) public;
    
    /**@dev  Adds new purchase to the list of given product */
    function addPurchase(
        uint256 productId,        
        address buyer,    
        uint256 price,         
        uint256 paidUnits,
        string clientId   
    ) public returns (uint256);    

    /**@dev Changes purchase state */
    function changePurchase(uint256 productId, uint256 purchaseId, PurchaseState state) public;

    /**@dev Sets escrow data for specified purchase */
    function setEscrowData(
        uint256 productId, 
        uint256 purchaseId, 
        address customer, 
        uint256 fee, 
        uint256 profit, 
        uint256 timestamp
    ) public;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/ProductStorage.sol

pragma solidity ^0.4.18;



/**@dev Contract that stores all products' data. Contains simple methods for retrieving and changing products */
contract ProductStorage is Manageable, IProductStorage {
    
    using SafeMathLib for uint256;

    //
    //Inner types

    //Escrow information
    struct EscrowData {
        address customer;   //customer address
        uint256 fee;        //fee to provider
        uint256 profit;     //profit to vendor
        uint256 timestamp;  //date and time of purchase
    }

    //Purchase information
    struct Purchase {
        PurchaseState state;
    }

    /**@dev
    Storage data of product */
    struct ProductData {    
        //product's creator
        address owner;        
        //price of one product unit in WEI
        uint256 price;
        //max quantity of limited product units, or 0 if unlimited
        uint256 maxUnits;
        //true if it is possible to buy a product
        bool isActive;
        //how many units already sold
        uint256 soldUnits;
        //timestamp of the purchases start
        uint256 startTime;
        //timestamp of the purchases end
        uint256 endTime;
        //true if escrow should be used
        bool useEscrow;
        //true if fiat price is used, in that case 
        bool useFiatPrice;
        //name of the product 
        string name; 
        //custom fields
        string data;
        //array of purchase information
        Purchase[] purchases;
    }    

    /**@dev Vendor-related information  */
    struct VendorInfo {
        address wallet;      //wallet to get profit        
        uint16 feePermille;   //fee permille for that vendor or 0 if default fee is used
    }
    


    //
    //Events
    event ProductAdded(
        uint256 indexed id,
        address indexed owner,         
        uint256 price, 
        uint256 maxUnits,
        bool isActive,         
        uint256 startTime, 
        uint256 endTime, 
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    );

    event PurchaseAdded(
        uint256 indexed productId,
        uint256 indexed id,
        address indexed buyer,    
        uint256 price,         
        uint256 paidUnits,        
        string clientId  
    );

    event ProductEdited(
        uint256 indexed productId,        
        uint256 price, 
        bool useFiatPrice,
        uint256 maxUnits, 
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,        
        string name,
        string data
    );

    event CustomParamsSet(uint256 indexed productId, address feePolicy);

    event VendorInfoSet(address indexed vendor, address wallet, uint16 feePermille);

    event EscrowDataSet(
        uint256 indexed productId,
        uint256 indexed purchaseId,   
        address indexed customer,         
        uint256 fee, 
        uint256 profit, 
        uint256 timestamp
    );



    //
    //Storage data    

    //List of all created products
    ProductData[] public products;
    //true if [x] product is not allowed to be purchase
    mapping(uint256=>bool) public banned;
    //vendor-related information of specific wallet
    mapping(address=>VendorInfo) public vendors;
    //first index is product id, second one - purchase id
    mapping(uint256=>mapping(uint256=>EscrowData)) public escrowData;


    //
    //Modifiers
    modifier validProductId(uint256 productId) {
        require(productId < products.length);
        _;
    }

    
    
    //
    //Methods

    function ProductStorage() public {        
    }

    /**@dev Returns total amount of products */
    function getTotalProducts() public constant returns(uint256) {
        return products.length;
    }

    /**@dev Returns text information about product */
    function getTextData(uint256 productId) 
        public
        constant
        returns(            
            string name, 
            string data
        ) 
    {
        ProductData storage p = products[productId];
        return (            
            p.name, 
            p.data
        );
    }

    /**@dev Returns information about product */
    function getProductData(uint256 productId) 
        public
        constant
        returns(            
            uint256 price, 
            uint256 maxUnits, 
            uint256 soldUnits
        ) 
    {
        ProductData storage p = products[productId];
        return (            
            p.price, 
            p.maxUnits, 
            p.soldUnits
        );
    }

    /**@dev Returns information about product's active state and time limits */
    function getProductActivityData(uint256 productId) 
        public
        constant
        returns(            
            bool active, 
            uint256 startTime, 
            uint256 endTime
        ) 
    {
        ProductData storage p = products[productId];
        return (            
            p.isActive, 
            p.startTime, 
            p.endTime
        );
    }

    /**@dev Returns product's creator */
    function getProductOwner(uint256 productId) 
        public 
        constant         
        returns(address)
    {
        return products[productId].owner;
    }   

    /**@dev Returns product's price */
    function getProductPrice(uint256 productId) 
        public 
        constant         
        returns(uint256)
    {
        return products[productId].price;
    }   

    /**@dev Returns product's escrow usage */
    function isEscrowUsed(uint256 productId) 
        public 
        constant         
        returns(bool)
    {
        return products[productId].useEscrow;
    }

    /**@dev Returns true if product price is set in fiat currency */
    function isFiatPriceUsed(uint256 productId) 
        public 
        constant         
        returns(bool)
    {
        return products[productId].useFiatPrice;
    }   

    /**@dev Returns true if product can be bought now */
    function isProductActive(uint256 productId) 
        public 
        constant         
        returns(bool)
    {
        return products[productId].isActive && 
            (products[productId].startTime == 0 || now >= products[productId].startTime) &&
            (products[productId].endTime == 0 || now <= products[productId].endTime);
    }   

    /**@dev Returns total amount of purchase transactions for the given product */
    function getTotalPurchases(uint256 productId) 
        public 
        constant
        returns (uint256) 
    {
        return products[productId].purchases.length;
    }

    /**@dev Returns information about purchase with given index for the given product */
    function getPurchase(uint256 productId, uint256 purchaseId) 
        public
        constant         
        returns(PurchaseState state) 
    {
        Purchase storage p = products[productId].purchases[purchaseId];
        return p.state;
    }

    /**@dev Returns escrow-related data for specified purchase */
    function getEscrowData(uint256 productId, uint256 purchaseId)
        public
        constant
        returns (address, uint256, uint256, uint256)
    {
        EscrowData storage data = escrowData[productId][purchaseId];
        return (data.customer, data.fee, data.profit, data.timestamp);
    }

    /**@dev Returns wallet for specific vendor */
    function getVendorWallet(address vendor) public constant returns(address) {
        return vendors[vendor].wallet == 0 ? vendor : vendors[vendor].wallet;
    }

    /**@dev Returns fee permille for specific vendor */
    function getVendorFee(address vendor) public constant returns(uint16) {
        return vendors[vendor].feePermille;
    }

    function setVendorInfo(address vendor, address wallet, uint16 feePermille) 
        public 
        managerOnly 
    {
        vendors[vendor].wallet = wallet;
        vendors[vendor].feePermille = feePermille;
        VendorInfoSet(vendor, wallet, feePermille);
    }

    /**@dev Adds new product to the storage */
    function createProduct(
        address owner,         
        uint256 price, 
        uint256 maxUnits,
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) 
        public 
        managerOnly
    {
        ProductData storage product = products[products.length++];
        product.owner = owner;
        product.price = price;
        product.maxUnits = maxUnits;
        product.isActive = isActive;
        product.startTime = startTime;
        product.endTime = endTime;
        product.isActive = isActive;
        product.useEscrow = useEscrow;
        product.useFiatPrice = useFiatPrice;
        product.name = name;
        product.data = data;
        ProductAdded(products.length - 1, owner, price, maxUnits, isActive, startTime, endTime, useEscrow, useFiatPrice, name, data);
    }


    /**@dev Edits product in the storage */   
    function editProduct(
        uint256 productId,        
        uint256 price, 
        uint256 maxUnits, 
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) 
        public 
        validProductId(productId)
        managerOnly
    {
        ProductData storage product = products[productId];
        product.price = price;
        product.maxUnits = maxUnits;
        product.startTime = startTime;
        product.endTime = endTime;
        product.isActive = isActive;
        product.useEscrow = useEscrow;
        product.useFiatPrice = useFiatPrice;
        product.name = name;
        product.data = data;
        ProductEdited(productId, price,useFiatPrice, maxUnits, isActive, startTime, endTime, useEscrow, name, data);
    }

    // function editProductData(
    //     uint256 productId,        
    //     uint256 price, 
    //     bool useFiatPrice,
    //     uint256 maxUnits, 
    //     bool isActive,
    //     uint256 startTime, 
    //     uint256 endTime,
    //     bool useEscrow
    // ) 
    //     public 
    //     validProductId(productId)
    //     managerOnly
    // {
    //     // ProductData storage product = products[productId];
    //     // product.price = price;
    //     // product.maxUnits = maxUnits;
    //     // product.startTime = startTime;
    //     // product.endTime = endTime;
    //     // product.isActive = isActive;
    //     // product.useEscrow = useEscrow;
    //     // product.useFiatPrice = useFiatPrice;
    //     ProductEdited(productId, price, useFiatPrice, maxUnits, isActive, startTime, endTime, useEscrow, "", "");
    // }

    // function editProductText(
    //     uint256 productId,        
    //     string name,
    //     string data
    // ) 
    //     public 
    //     validProductId(productId)
    //     managerOnly
    // {
    //     // ProductData storage product = products[productId];
    //     // product.name = name;
    //     // product.data = data;
    //     ProductEdited(productId, 0, false, 0, false, 0, 0, false, name, data);
    // }


    /**@dev Changes the value of currently sold units */
    function changeSoldUnits(uint256 productId, uint256 soldUnits)
        public 
        validProductId(productId)
        managerOnly
    {
        products[productId].soldUnits = soldUnits;
    }

    /**@dev Changes owner of the product */
    function changeOwner(uint256 productId, address newOwner) 
        public 
        validProductId(productId)
        managerOnly
    {
        products[productId].owner = newOwner;
    }

    /**@dev Marks product as banned. other contracts shoudl take this into account when interacting with product */
    function banProduct(uint256 productId, bool state) 
        public 
        managerOnly
        validProductId(productId)
    {
        banned[productId] = state;
    }

    /**@dev  Adds new purchase to the list of given product */
    function addPurchase(
        uint256 productId,        
        address buyer,    
        uint256 price,         
        uint256 paidUnits,        
        string clientId   
    ) 
        public 
        managerOnly
        validProductId(productId)
        returns (uint256)
    {
        PurchaseAdded(product.purchases.length, productId, buyer, price, paidUnits, clientId);        
        
        ProductData storage product = products[productId];
        product.soldUnits = product.soldUnits.safeAdd(paidUnits);

        //Purchase storage purchase = product.purchases[product.purchases.length++];
        product.purchases.length++;
        //purchase.state = state;
        return product.purchases.length - 1;
    }

    /**@dev Changes purchase state of specific purchase */
    function changePurchase(uint256 productId, uint256 purchaseId, PurchaseState state) 
        public 
        managerOnly 
        validProductId(productId)
    {
        require(purchaseId < products[productId].purchases.length);

        products[productId].purchases[purchaseId].state = state;
    }    

    /**@dev Sets escrow data for specified purchase */
    function setEscrowData(uint256 productId, uint256 purchaseId, address customer, uint256 fee, uint256 profit, uint256 timestamp) 
        public
        managerOnly
        validProductId(productId)
    {
        require(products[productId].useEscrow);
        require(purchaseId < products[productId].purchases.length);

        EscrowData storage data = escrowData[productId][purchaseId];
        data.customer = customer;
        data.fee = fee;
        data.profit = profit;
        data.timestamp = timestamp;

        EscrowDataSet(productId, purchaseId, customer, fee, profit, timestamp);
    }
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/ProductMaker.sol

pragma solidity ^0.4.18;



contract ProductMaker is Active {

    //
    // Events
    event ProductCreated
    (
        address indexed owner, 
        uint256 price, 
        uint256 maxUnits,
        uint256 startTime, 
        uint256 endTime, 
        bool useEscrow,
        string name,
        string data
    );

    event ProductEdited
    (
        uint256 indexed productId, 
        uint256 price, 
        bool useFiatPrice,
        uint256 maxUnits,
        bool isActive,
        uint256 startTime, 
        uint256 endTime, 
        bool useEscrow,
        string name,
        string data
    );

    //
    // Storage data
    IProductStorage public productStorage;    


    //
    // Methods

    function ProductMaker(IProductStorage _productStorage) public {
        productStorage = _productStorage;
    }

    /**@dev Creates product. Can be called by end user */
    function createSimpleProduct(
        uint256 price, 
        uint256 maxUnits,
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) 
        public
        activeOnly
    {
        if(startTime > 0 && endTime > 0) {
            require(endTime > startTime);
        }

        productStorage.createProduct(msg.sender, price, maxUnits, isActive, startTime, endTime, useEscrow, useFiatPrice, name, data);
        //ProductCreated(msg.sender, price, maxUnits, startTime, endTime, 0, name, data);
    }

    /**@dev Creates product and enters the information about vendor wallet. Can be called by end user */
    function createSimpleProductAndVendor(
        address wallet,
        uint256 price, 
        uint256 maxUnits,
        bool isActive,
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) 
        public
        activeOnly
    {
        productStorage.setVendorInfo(msg.sender, wallet, productStorage.getVendorFee(msg.sender));   
        createSimpleProduct(price, maxUnits, isActive, startTime, endTime, useEscrow, useFiatPrice, name, data);
        //productStorage.createProduct(msg.sender, price, maxUnits, isActive, startTime, endTime, useEscrow, useFiatPrice, name, data);
        //ProductCreated(msg.sender, price, maxUnits, startTime, endTime, 0, name, data);
    }

    /**@dev Edits product in the storage */   
    function editSimpleProduct(
        uint256 productId,        
        uint256 price,         
        uint256 maxUnits, 
        bool isActive, 
        uint256 startTime, 
        uint256 endTime,
        bool useEscrow,
        bool useFiatPrice,
        string name,
        string data
    ) 
        public
        activeOnly
    {
        require(msg.sender == productStorage.getProductOwner(productId));                
        if(startTime > 0 && endTime > 0) {
            require(endTime > startTime);
        }

        //uint256[5] memory inputs = [productId, price, maxUnits, startTime, endTime];
        //productStorage.editProduct(inputs[0], inputs[1], inputs[2], isActive, inputs[3], inputs[4], useEscrow, useFiatPrice, name, data);        
        
        productStorage.editProduct(productId, price, maxUnits, isActive, startTime, endTime, useEscrow, useFiatPrice, name, data);        
        ProductEdited(productId, price, useFiatPrice, maxUnits, isActive, startTime, endTime, useEscrow, name, data);
        // productStorage.editProductData(productId, price, useFiatPrice, maxUnits, isActive, startTime, endTime, useEscrow);        
        // productStorage.editProductText(productId, name, data);        
    }

    /**@dev Changes vendor wallet for profit */
    function setVendorWallet(address wallet) public 
    activeOnly 
    {
        productStorage.setVendorInfo(msg.sender, wallet, productStorage.getVendorFee(msg.sender));
    }
}
