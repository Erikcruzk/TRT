// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/misc/ErrorVendor.sol

pragma solidity ^0.4.10;

/**@dev Throws an exception when there is ether transfer to this account */
contract ErrorVendor {

    function ()  {
        
    }
}

/**@dev A contract with payable function that consumes large amount of gas */
contract HugePayableFunction {
    function HugePayableFunction() {}
    
    uint v1;

    function() payable {
        v1 = 1;
        uint a = 0;
        for (uint i = 0; i < 1000; ++i) {
            a += i;
        }
    }
}

contract Buyable {
    function buy(string clientId) payable;
}

/**@dev A contract that tries to call a calling method again */
contract ReenterAttackVendor {
    function ReenterAttackVendor() {}

    function () payable {
        Buyable s = Buyable(msg.sender);
        s.buy.value(0)("ERROR!");
    }
}
