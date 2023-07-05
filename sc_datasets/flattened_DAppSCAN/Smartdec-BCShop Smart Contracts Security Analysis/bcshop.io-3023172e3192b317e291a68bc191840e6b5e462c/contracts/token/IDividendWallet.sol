// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/token/IDividendWallet.sol

pragma solidity ^0.4.10;

/**@dev Wallet that distributes its balance according to some rules */
contract IDividendWallet {
    function() public payable;

    /**@dev Withdraws all sender's ether balance */
    function withdrawAll() public returns (bool);     

    /**@dev Account specific ethereum balance getter */
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function etherBalanceOf(address _addr) public constant returns (uint balance) {_addr; balance;}
}
