// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/common/ICheckList.sol

pragma solidity ^0.4.10;

contract ICheckList {
    function contains(address addr) public constant returns(bool) {return false;}
    function set(address addr, bool state) public;
}
