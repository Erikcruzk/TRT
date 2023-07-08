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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/misc/ProductEngineTest.sol

pragma solidity ^0.4.10;



/*
ProductEngine that performs actual work */
library ProductEngineTest {

    using SafeMathLib for uint256;
    event ProductBoughtEx(uint256 indexed id, address indexed buyer, string clientId, uint256 price, uint256 paidUnits);

    /**@dev 
    Calculates and returns payment details: how many units are bought, 
     what part of ether should be paid and what part should be returned to buyer  */
    function calculatePaymentDetails(IProductEngine.ProductData storage self, uint256 weiAmount, bool acceptLessUnits) 
        constant
        returns(uint256 unitsToBuy, uint256 etherToPay, uint256 etherToReturn) 
    {
        unitsToBuy = 10;
        etherToReturn = 0;
        etherToPay = weiAmount;
    } 

    /**@dev 
    Buy product. Send ether with this function in amount equal to desirable product quantity total price */
    function buy(
        IProductEngine.ProductData storage self, 
        string clientId, 
        bool acceptLessUnits, 
        uint256 currentPrice) 
    {
        //check for active flag and valid price
        require(self.isActive && currentPrice == self.price);        

        require(msg.value > 10000);

        //check time limit        
        //require((self.startTime == 0 || now > self.startTime) && (self.endTime == 0 || now < self.endTime));

        //how much units do we buy
        var (unitsToBuy, etherToPay, etherToReturn) = calculatePaymentDetails(self, msg.value, acceptLessUnits);

        //check if there is enough units to buy
        require(unitsToBuy > 0);

        //how much to send to both provider and vendor
        VendorBase vendorInfo = VendorBase(self.owner);
        uint256 etherToProvider = etherToPay;
        uint256 etherToVendor = 0;
     
        createPurchase(self, clientId, unitsToBuy);

        self.soldUnits = uint32(self.soldUnits + unitsToBuy);
        
        vendorInfo.vendorManager().provider().transfer(etherToProvider);        
        vendorInfo.vendor().transfer(etherToVendor);

    }

    /**@dev 
    Call this to return all previous overpays */
    function withdrawOverpay(IProductEngine.ProductData storage self) {
        uint amount = self.pendingWithdrawals[msg.sender];        
        self.pendingWithdrawals[msg.sender] = 0;

        if (!msg.sender.send(amount)) {
            self.pendingWithdrawals[msg.sender] = amount;
        }
    }
    
    /**@dev 
    Marks purchase with given id as delivered or not */
    function markAsDelivered(IProductEngine.ProductData storage self, uint256 purchaseId, bool state) {
        require(VendorBase(self.owner).owner() == msg.sender);
        require(purchaseId < self.purchases.length);
        self.purchases[purchaseId].delivered = state;
    }

    /**@dev 
    Changes parameters of product */
    function setParams(
        IProductEngine.ProductData storage self,
        string newName, 
        uint256 newPrice,         
        uint256 newMaxUnits,
        // bool newAllowFractions,
        // uint256 newStartTime,
        // uint256 newEndTime,
        bool newIsActive
    ) {
        // require(VendorBase(self.owner).owner() == msg.sender);

        // self.name = newName;
        // self.price = newPrice;
        // self.maxUnits = newMaxUnits;
        // self.allowFractions = newAllowFractions;
        // self.isActive = newIsActive;
        // self.startTime = newStartTime;
        // self.endTime = newEndTime;
    }

    /**@dev Creates new Purchase record */
    function createPurchase(IProductEngine.ProductData storage self, string clientId, uint256 paidUnits) 
        internal 
    {
        uint256 pid = self.purchases.length++;
        IProductEngine.Purchase storage p = self.purchases[pid];
        //p.id = pid;
        //p.buyer = msg.sender;
        //p.clientId = clientId;
        p.price = self.price;
        //p.paidUnits = paidUnits * 2;
        p.delivered = false;        
        ProductBoughtEx(self.purchases.length, msg.sender, clientId, self.price, paidUnits);
    }
}
