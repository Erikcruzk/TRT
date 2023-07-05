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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/Versioned.sol

pragma solidity ^0.4.10;

/**@dev Simple contract for something that supports versioning */
contract Versioned {
    uint32 public version;
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

// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/shop/VendorManager.sol

pragma solidity ^0.4.10;



/**@dev 
The main manager for platform. Stores vendor's addresses. 
Contains refrence to factory contract that creates Vendors and Products */
contract VendorManager is IVendorManager, Owned, Versioned {

    event VendorAdded(address indexed vendorOwner, address indexed vendor);    
        
    mapping(address => bool) public validVendor; //true if address was created by factory
    mapping(address => address[]) public vendorLists;   //List of vendors grouped by ots owner    
    mapping(address => bool) public validFactory;   //true if it is valid factory for creation
    address public provider;                        //provider wallet to receive fee
    uint16 public providerFeePromille;             //fee promille [0-1000]
    bool public active;                             //true if can perform operations

    //allows execution only from factory contract
    modifier factoryOnly() {        
        require(validFactory[msg.sender]);
        _;
    }

    function VendorManager(address serviceProvider, uint16 feePromille) public {
        require(feePromille <= 1000);
        
        provider = serviceProvider;        
        providerFeePromille = feePromille;

        active = true;
        version = 1;
    }    

    /**@dev Returns a number of vendor contracts created by specific owner */
    function getVendorCount(address vendorOwner) public constant returns (uint256) {
        return vendorLists[vendorOwner].length;
    }

    /**@dev Adds vendor to storage */
    function addVendor(address vendorOwner, address vendor) public factoryOnly {
        vendorLists[vendorOwner].push(vendor);
        validVendor[vendor] = true;    
        VendorAdded(vendorOwner, vendor);
    }

    /**@dev sets new vendor/product factory */
    function setFactory(address newFactory, bool state) public ownerOnly {
        //factory = newFactory;
        validFactory[newFactory] = state;
    }

    /**@dev Changes default provider settings */
    function setParams(address newProvider, uint16 newFeePromille) public ownerOnly {
        require(newFeePromille <= 1000);

        provider = newProvider;
        providerFeePromille = newFeePromille;
    }

    /**@dev Changes 'active' state */
    function setActive(bool state) public ownerOnly {
        active = state;
    }

    /**@dev Changes valid vendor state */
    function setValidVendor(address vendor, bool state) ownerOnly {
        validVendor[vendor] = state;
    }
}
