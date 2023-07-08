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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/Escrow.sol

pragma solidity ^0.4.18;



/**dev not used now, merged with ProductPayment */
contract Escrow is Manageable {

    using SafeMathLib for uint256;

    //
    // Inner Types


	
    //
    // Events



    //
    // Storage data    

    uint256 public holdTime; //payment hold time in seconds
    IProductStorage public productStorage;


    //
    // Modifiers



    //
    // Methods

    function Escrow(IProductStorage _productStorage, uint256 _holdTimeHours) public {
        productStorage = _productStorage;
        holdTime = _holdTimeHours * 1 hours;
    }    

    /**@dev Allows to receive ETH */
    function() payable {}

    /**@dev Adds payment info. this funcion should carry ETH equal to fee+profit */
    function addPayment(uint256 productId, uint256 purchaseId, address customer, uint256 fee, uint256 profit) 
        public 
        payable
        managerOnly 
    {
        require(msg.value == fee + profit);

        //if product doesn't support escrow setEscrowData will throw exception        
        productStorage.setEscrowData(productId, purchaseId, customer, fee, profit, now);    
    }

    /**@dev Make a complain on purchase, only customer can call this method */
    function complain(uint256 productId, uint256 purchaseId) public {
        //check product's escrow option
        require(productStorage.isEscrowUsed(productId));

        var (customer, fee, profit, timestamp) = productStorage.getEscrowData(productId, purchaseId);
        
        //check valid customer
        require(customer == msg.sender);        
        //check complain time
        require(timestamp + holdTime > now);

        //change purchase status
        productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Complain);        
    }

    /**@dev Resolves a complain on specific purchase. 
    If cancelPayment is true, payment returns to customer; otherwise - to the vendor */
    function resolve(uint256 productId, uint256 purchaseId, bool cancelPayment) public managerOnly {
        
        //check purchase state
        require(productStorage.getPurchase(productId, purchaseId) == IProductStorage.PurchaseState.Complain);
        
        var (customer, fee, profit, timestamp) = productStorage.getEscrowData(productId, purchaseId);
        
        if(cancelPayment) {            
            productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Canceled);
            //transfer to customer
            customer.transfer(fee.safeAdd(profit));
        } else {
            productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Pending);

        }
    }
}
