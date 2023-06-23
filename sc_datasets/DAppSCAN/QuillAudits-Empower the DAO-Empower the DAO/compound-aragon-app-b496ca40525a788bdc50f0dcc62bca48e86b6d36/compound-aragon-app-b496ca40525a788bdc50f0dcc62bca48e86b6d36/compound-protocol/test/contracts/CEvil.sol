pragma solidity ^0.5.8;

import "./CErc20Scenario.sol";

contract CEvil is CErc20Scenario {
    constructor(address underlying_,
                ComptrollerInterface comptroller_,
                InterestRateModel interestRateModel_,
                uint initialExchangeRateMantissa,
                string memory name_,
                string memory symbol_,
                uint decimals_)
    CErc20Scenario(
    underlying_,
    comptroller_,
    interestRateModel_,
    initialExchangeRateMantissa,
    name_,
    symbol_,
    decimals_) public {}

    function evilSeize(CToken treasure, address liquidator, address borrower, uint seizeTokens) public returns (uint) {
        return treasure.seize(liquidator, borrower, seizeTokens);
    }
}
