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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/EtherHolder.sol

pragma solidity ^0.4.18;

/**@dev Contract that can hold and receive Ether and transfer it to anybody */
contract EtherHolder is Owned {
    
    //
    // Methods

    function EtherHolder() public {
    } 

    /**@dev withdraws amount of ether to specific adddress */
    function withdrawEtherTo(uint256 amount, address to) public ownerOnly {
        to.transfer(amount);
    }

    function() payable {}
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IFeePolicy.sol

pragma solidity ^0.4.18;


/**Abstraction of fee policy */
contract IFeePolicy {

    /**@dev Returns total fee amount depending on payment */
    function calculateFeeAmount(address owner, uint256 productId, uint256 payment) public returns(uint256);

    /**@dev Sends fee amount to service provider  */
    function sendFee() public payable;
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IPurchaseHandler.sol

pragma solidity ^0.4.18;

/**@dev Interface of custom PurchaseHandler that performs additional work after payment is made */
contract IPurchaseHandler {
    function handlePurchase(address buyer, uint256 unitsBought, uint256 price) public {}
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IDiscountPolicy.sol

pragma solidity ^0.4.18;

contract IDiscountPolicy {

    /**@dev Returns cashback that applies to customer when he makes a purchase of specific amount*/
    function getCustomerDiscount(address customer, uint256 amount) public constant returns(uint256) {}    

    /**@dev Transfers cashback from the pool to cashback storage, returns cashback amount*/
    function requestCustomerDiscount(address customer, uint256 amount) public returns(uint256);    
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IBancorConverter.sol

pragma solidity ^0.4.18;

contract IBancorConverter {
    function convertFor(address[] _path, uint256 _amount, uint256 _minReturn, address _for)
        public
        payable
        returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IEtherPriceProvider.sol

pragma solidity ^0.4.18;

contract IEtherPriceProvider {
    function rate() public constant returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/ProductPayment.sol

pragma solidity ^0.4.18;











/**@dev This contact accepts payments for products and transfers ether to all the parties */
contract ProductPayment is EtherHolder, Active {

    using SafeMathLib for uint256;

    //
    //Events

    //emitted during purchase process. Id is 0-based index of purchase in the engine.purchases array
    event ProductBought(address indexed buyer, address indexed vendor, uint256 indexed productId, uint256 purchaseId,
                         string clientId, uint256 price, uint256 paidUnits, uint256 discount);
    event OverpayStored(address indexed buyer, uint256 indexed productId, uint256 amount);


    //
    // Storage data

    IProductStorage public productStorage;
    IFeePolicy public feePolicy;
    IDiscountPolicy public discountPolicy;
    //contract that stores ether/usd exchange rate
    IEtherPriceProvider public etherPriceProvider;
    //token that can be used as payment tool
    IERC20Token public token;
    // Bancor quick converter to convert BCS to ETH. Important: this is NOT a BancorConverter contract.
    // This must be set to the corresponding BancorConverter.extensions.quickConverter   
    IBancorConverter public converter;
    // escrow payment hold time in seconds 
    uint256 public escrowHoldTime; 
    address[] public convertPath;

    //
    // Methods

    function ProductPayment(
        IProductStorage _productStorage, 
        IFeePolicy _feePolicy, 
        IDiscountPolicy _discountPolicy,
        IERC20Token _token,
        IEtherPriceProvider _etherPriceProvider,
        uint256 _escrowHoldTime
    ) {
        setParams(_productStorage, _feePolicy, _discountPolicy, _token, _etherPriceProvider, _escrowHoldTime);
    }

    //allows to receive direct ether transfers
    function() payable {}
    
    /**@dev Sets convert path for changing BCS to ETH through Bancor */
    function setConvertParams(IBancorConverter _converter, address[] _convertPath) public ownerOnly {
        converter = _converter;
        convertPath = _convertPath;        
    }

    /**@dev Changes parameters */
    function setParams(
        IProductStorage _productStorage,
        IFeePolicy _feePolicy, 
        IDiscountPolicy _discountPolicy,
        IERC20Token _token,
        IEtherPriceProvider _etherPriceProvider,
        uint256 _escrowHoldTime
    ) 
        public 
        ownerOnly 
    {
        productStorage = _productStorage;
        feePolicy = _feePolicy;
        discountPolicy = _discountPolicy;
        token = _token;
        etherPriceProvider = _etherPriceProvider;
        escrowHoldTime = _escrowHoldTime;
    }
    
    function getUnitsToBuy(uint256 productId, uint256 units, bool acceptLessUnits) public constant returns(uint256) {
        var (price, maxUnits, soldUnits) = productStorage.getProductData(productId);

        //if product is limited and it's not enough to buy, check acceptLessUnits flag
        if (maxUnits > 0 && soldUnits.safeAdd(units) > maxUnits) {
            if (acceptLessUnits) {
                return maxUnits.safeSub(soldUnits);
            } else {
                return 0; //set to 0 so it will fail later
            }
        } else {
            return units;
        }
    }

    /**@dev Returns true if vendor profit can be withdrawn */
    function canWithdrawPending(uint256 productId, uint256 purchaseId) public constant returns(bool) {
        var (customer, fee, profit, timestamp) = productStorage.getEscrowData(productId, purchaseId);
        IProductStorage.PurchaseState state = productStorage.getPurchase(productId, purchaseId);

        return state == IProductStorage.PurchaseState.Pending 
            || (state == IProductStorage.PurchaseState.Paid && timestamp + escrowHoldTime <= now);
    }


    /**@dev Buys product. Send ether with this function in amount equal to 
    desirable product units * current price. */
    function buyWithEth(
        uint256 productId,  
        uint256 units,         
        string clientId, 
        bool acceptLessUnits, 
        uint256 currentPrice
    ) 
        public
        payable
    {
        buy(msg.value, productId, units, clientId, acceptLessUnits, currentPrice);        
    }

    /**@dev Buys product using BCS tokens as a payment. 
    1st parameter is the amount of tokens that will be converted via bancor. This can be calculated off-chain.
    Tokens should be approved for spending by this contract */
    function buyWithTokens(
        uint256 tokens,
        uint256 productId,  
        uint256 units,       
        string clientId, 
        bool acceptLessUnits, 
        uint256 currentPrice
    ) 
        public
    {
        //transfer tokens to this contract for exchange
        token.transferFrom(msg.sender, converter, tokens);

        //exchange through Bancor
        uint256 ethAmount = converter.convertFor(convertPath, tokens, 1, this);

        //use received ether for payment
        buy(ethAmount, productId, units, clientId, acceptLessUnits, currentPrice);
    }    

    /**@dev Make a complain on purchase, only customer can call this method */
    function complain(uint256 productId, uint256 purchaseId) public {
        //check product's escrow option
        //require(productStorage.isEscrowUsed(productId));

        var (customer, fee, profit, timestamp) = productStorage.getEscrowData(productId, purchaseId);
        
        //check purchase current state, valid customer and time limits
        require(
            productStorage.getPurchase(productId, purchaseId) == IProductStorage.PurchaseState.Paid && 
            customer == msg.sender &&
            timestamp + escrowHoldTime > now
        );
        
        //change purchase status
        productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Complain);        
    }

    /**@dev Resolves a complain on specific purchase. 
    If cancelPayment is true, payment returns to customer; otherwise - to the vendor */
    function resolve(uint256 productId, uint256 purchaseId, bool cancelPayment) public managerOnly {
        
        //check purchase state
        require(productStorage.getPurchase(productId, purchaseId) == IProductStorage.PurchaseState.Complain);
        
        var (customer, fee, profit, timestamp) = productStorage.getEscrowData(productId, purchaseId);
        
        if (cancelPayment) {
            //change state first, then transfer to customer
            productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Canceled);            
            customer.transfer(fee.safeAdd(profit));
        } else {
            //change state. vendor should call withdrawPending and then fee will be sent to provider
            productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Pending);
        }
    }

    /**@dev withdraws multiple pending payments */
    function withdrawPendingPayments(uint256[] productIds, uint256[] purchaseIds) 
        public 
        activeOnly 
    {
        require(productIds.length == purchaseIds.length);
        address customer;
        uint256 fee;
        uint256 profit;
        uint256 timestamp;

        uint256 totalProfit = 0;
        uint256 totalFee = 0;

        for(uint256 i = 0; i < productIds.length; ++i) {
            (customer, fee, profit, timestamp) = productStorage.getEscrowData(productIds[i], purchaseIds[i]);
            
            require(msg.sender == productStorage.getProductOwner(productIds[i]));
            require(canWithdrawPending(productIds[i], purchaseIds[i]));

            productStorage.changePurchase(productIds[i], purchaseIds[i], IProductStorage.PurchaseState.Finished);

            totalFee = totalFee.safeAdd(fee);
            totalProfit = totalProfit.safeAdd(profit);
        }

        productStorage.getVendorWallet(msg.sender).transfer(totalProfit);
        feePolicy.sendFee.value(totalFee)();
    }

    /**@dev transfers pending profit to the vendor */
    function withdrawPending(uint256 productId, uint256 purchaseId) 
        public 
        activeOnly 
    {
        var (customer, fee, profit, timestamp) = productStorage.getEscrowData(productId, purchaseId);

        //check owner
        require(msg.sender == productStorage.getProductOwner(productId));
        //check withdrawability
        require(canWithdrawPending(productId, purchaseId));

        //change state first, then transfer funds
        productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Finished);
        productStorage.getVendorWallet(msg.sender).transfer(profit);
        feePolicy.sendFee.value(fee)();
    }

    function buy(
        uint256 ethAmount,
        uint256 productId,  
        uint256 units,        
        string clientId, 
        bool acceptLessUnits, 
        uint256 currentPrice
    ) 
        internal
        activeOnly
    {
        require(productId < productStorage.getTotalProducts());        
        require(!productStorage.banned(productId));

        uint256 price = productStorage.getProductPrice(productId);

        //check for active flag and valid price
        require(productStorage.isProductActive(productId) && currentPrice == price);        
        
        uint256 unitsToBuy = getUnitsToBuy(productId, units, acceptLessUnits);
        //check if there is enough units to buy
        require(unitsToBuy > 0);
        
        uint256 totalPrice = unitsToBuy.safeMult(price);

        //check fiat price usage
        if(productStorage.isFiatPriceUsed(productId)) {
            totalPrice = totalPrice.safeMult(etherPriceProvider.rate());
            price = totalPrice / unitsToBuy;
        }
        
        uint256 cashback = discountPolicy.requestCustomerDiscount(msg.sender, totalPrice);

        //if there is not enough ether to pay even with discount, safeSub will throw exception
        uint256 etherToReturn = ethAmount.safeSub(totalPrice);

        uint256 purchaseId = productStorage.addPurchase(productId, msg.sender, price, unitsToBuy, clientId);
        processPurchase(productId, purchaseId, totalPrice);

        //transfer excess to customer
        if (etherToReturn > 0) {
            msg.sender.transfer(etherToReturn);
        }
        
        ProductBought(msg.sender, productStorage.getProductOwner(productId), productId, purchaseId, clientId, price, unitsToBuy, cashback);
    }

    /**@dev Sends ether to vendor and provider */
    function processPurchase(uint256 productId, uint256 purchaseId, uint256 etherToPay) internal {
        address owner = productStorage.getProductOwner(productId);
        uint256 fee = feePolicy.calculateFeeAmount(owner, productId, etherToPay);
        uint256 profit = etherToPay.safeSub(fee);
        
        if (productStorage.isEscrowUsed(productId)) {
            productStorage.setEscrowData(productId, purchaseId, msg.sender, fee, profit, now);   
            productStorage.changePurchase(productId, purchaseId, IProductStorage.PurchaseState.Paid);
        } else {
            feePolicy.sendFee.value(fee)();
            productStorage.getVendorWallet(owner).transfer(profit);
        }
    }
}
