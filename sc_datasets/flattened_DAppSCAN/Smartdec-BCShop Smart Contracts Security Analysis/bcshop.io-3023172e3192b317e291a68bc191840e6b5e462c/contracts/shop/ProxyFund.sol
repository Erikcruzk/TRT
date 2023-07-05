// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/IFund.sol

pragma solidity ^0.4.10;

/**#@dev interface to contract that contains ether distributed among several receivers */
contract IFund {

    /**@dev Returns how much ether can be claimed */
    function etherBalanceOf(address receiver) public constant returns (uint balance) {receiver;balance;}
    
    /**@dev Withdraws caller's share to it */
    function withdraw(uint amount) public;

    /**@dev Withdraws caller's share to some another address */
    function withdrawTo(address to, uint amount) public;
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/ProxyFund.sol

pragma solidity ^0.4.18;



/**@dev Ether fund that can take Ether from another fund */
contract ProxyFund is IWallet, Manageable {
    
    //
    // Events



    //
    // Storage data
    IFund public baseFund;



    //
    // Methods

    function ProxyFund() public {        
    } 

    function setBaseFund(IFund _baseFund) public ownerOnly {
        baseFund = _baseFund;
    }

    /**@dev Returns how much ether can be claimed */
    function getBalance() public constant returns (uint256) {
        return this.balance + baseFund.etherBalanceOf(this);
    }
    
    /**@dev Withdraws caller's share  */
    function withdraw(uint amount) public managerOnly {
        withdrawTo(msg.sender, amount);
    }

    /**@dev Withdraws caller's share to a given address */
    function withdrawTo(address to, uint256 amount) public managerOnly {
        uint256 fundBalance = baseFund.etherBalanceOf(this);

        if (amount <= fundBalance && amount > this.balance) {
            baseFund.withdraw(fundBalance);
        }
        to.transfer(amount);
    }

    function () payable {}    
}
