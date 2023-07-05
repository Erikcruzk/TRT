// File: ../sc_datasets/DAppSCAN/Smartdec-BCShop Smart Contracts Security Analysis/bcshop.io-3023172e3192b317e291a68bc191840e6b5e462c/contracts/crowdsale/ICrowdsaleFormula.sol

pragma solidity ^0.4.10;

/**@dev Abstraction of crowdsale token calculation function */
contract ICrowdsaleFormula {

    /**@dev Returns amount of tokens that can be bought with given weiAmount */
    function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {
        weiAmount; tokens; excess;
    }

    /**@dev Returns how many tokens left for sale */
    function tokensLeft() constant returns(uint256 _left) { _left;}    
}
