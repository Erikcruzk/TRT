// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/IDiscountPolicy.sol

pragma solidity ^0.4.18;

contract IDiscountPolicy {

    /**@dev Returns cashback that applies to customer when he makes a purchase of specific amount*/
    function getCustomerDiscount(address customer, uint256 amount) public constant returns(uint256) {}    

    /**@dev Transfers cashback from the pool to cashback storage, returns cashback amount*/
    function requestCustomerDiscount(address customer, uint256 amount) public returns(uint256);    
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/IWallet.sol

pragma solidity ^0.4.18;

/**@dev Wallet that stores some amount of currency (eth or tokens) */
contract IWallet {

    //
    // Methods

    /**@dev Returns balance of the wallet */
    function getBalance() public constant returns (uint256) {}
    
    /**@dev Withdraws caller's share */
    function withdraw(uint amount) public;

    /**@dev Withdraws caller's share to a given address */
    function withdrawTo(address to, uint256 amount) public;
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/product/DiscountPolicy.sol

pragma solidity ^0.4.18;






/**@dev 
Discount settings that calcultes cashback for token holders. Also stores accumulated cashback for each holder */
contract DiscountPolicy is Active, EtherHolder, IDiscountPolicy {

    using SafeMathLib for uint256;

    //
    // Events
    event CashbackCalculated(address indexed customer, uint256 amount);
    event CashbackAdded(address indexed customer, uint256 amount);


    //
    // Storage data
    uint256[] public levelTokens;       // how many tokens user needs to get the corresponding level of discount
    uint16[] public levelPcts;           // multiplier for standard discount 1/Y of pool for each level
    uint256 public minPoolBalance;      // minimum discount pool balance that enables discounts
    uint256 public discountsInPool;     // 1/discountsInPool is a share of pool for a single discount
    uint256 public maxDiscountPermille; // maximum discount permile [0-1000] 
    IWallet public pool;                // discount pool
    IERC20Token public token;           // token to check minimum token balance
    mapping(address => uint256) public totalCashback; //accumulated cashback amount for each holder



    //
    // Methods

    function DiscountPolicy(
        uint256 _minPoolBalance, 
        uint256 _discountsInPool, 
        uint256 _maxDiscountPermille, 
        IWallet _pool,
        IERC20Token _token,
        uint256[] _levelTokens,
        uint16[] _levelPcts
    ) 
        public 
    {
        setParams(_minPoolBalance, _discountsInPool, _maxDiscountPermille, _pool, _token, _levelTokens, _levelPcts);
    }


    /**@dev Returns cashback level % of specific customer  */
    function getLevelPct(address customer) public constant returns(uint16) {
        uint256 tokens = token.balanceOf(customer);
        
        if(tokens < levelTokens[0]) {
            return 0;
        }
        uint256 i;
        for(i = 0; i < levelTokens.length - 1; ++i) {
            if(tokens < levelTokens[i + 1]) {
                return levelPcts[i];
            }
        }

        return levelPcts[i];
    }


    /**@dev Returns discount for specific amount and buyer */
    function getCustomerDiscount(address customer, uint256 amount) public constant returns(uint256) {
        uint16 levelPct = getLevelPct(customer);

        if(levelPct > 0) {
            uint256 poolBalance = pool.getBalance();
            
            if(poolBalance >= minPoolBalance) {
                uint256 discount = poolBalance * levelPct / (discountsInPool * 100);
                uint256 maxDiscount = amount * maxDiscountPermille / 1000;
                
                return discount < maxDiscount ? discount : maxDiscount;
            }
        }
        return 0;
    }
    

    /**@dev Transfers discount to the sender, returns discount amount*/
    function requestCustomerDiscount(address customer, uint256 amount) 
        public 
        managerOnly
        returns(uint256)
    {
        uint256 discount = getCustomerDiscount(customer, amount);
        if(discount > 0) {
            //accumulate discount
            pool.withdrawTo(this, discount);
            CashbackCalculated(customer, discount);

            //Don't add the cashback here. it will be calculated later by oracle once a certain period
            //totalCashback[customer] = totalCashback[customer].safeAdd(discount);            
        }
        return discount;
    }


    /**@dev transfer user's cashback to his wallet */
    function withdrawCashback() public activeOnly {
        uint256 amount = totalCashback[msg.sender];        
        totalCashback[msg.sender] = 0;
        
        msg.sender.transfer(amount);
    }


    /**@dev Adds a certain amount to a customer's cashback */
    function addCashbacks(address[] customers, uint256[] amounts) public managerOnly {
        require(customers.length == amounts.length);

        for(uint256 i = 0; i < customers.length; ++i) {
            totalCashback[customers[i]] = totalCashback[customers[i]].safeAdd(amounts[i]);
            CashbackAdded(customers[i], amounts[i]); 
        }
    }


    function setParams(
        uint256 _minPoolBalance, 
        uint256 _discountsInPool, 
        uint256 _maxDiscountPermille, 
        IWallet _pool,
        IERC20Token _token,
        uint256[] _levelTokens,
        uint16[] _levelPcts
    ) 
        public 
        ownerOnly
    {
        minPoolBalance = _minPoolBalance;
        discountsInPool = _discountsInPool;
        maxDiscountPermille = _maxDiscountPermille;
        pool = _pool;
        token = _token;
        levelTokens = _levelTokens;
        levelPcts = _levelPcts;

        require(paramsValid());
    }

    function paramsValid() internal constant returns (bool) {
        if(maxDiscountPermille > 1000) {
            return false;
        }
        
        if (levelTokens.length == 0 || levelTokens.length > 10 || levelPcts.length != levelTokens.length) {
            return false;
        }        

        for (uint256 i = 0; i < levelTokens.length - 1; ++i) {
            if (levelTokens[i] >= levelTokens[i + 1]) {
                return false;
            }
            if (levelPcts[i] >= levelPcts[i + 1]) {
                return false;
            }
        }
        return true;
    }


    function () public payable {}
}
