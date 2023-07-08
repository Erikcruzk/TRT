// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/IOwned.sol

pragma solidity ^0.4.10;

/**@dev Simple interface to Owned base class */
contract IOwned {
    function owner() public constant returns (address) {}
    function transferOwnership(address _newOwner) public;
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
