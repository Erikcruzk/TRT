

pragma solidity >=0.4.24;

pragma experimental ABIEncoderV2;

interface ICollateralLoan {
    struct Loan {
        
        uint id;
        
        address payable account;
        
        uint collateral;
        
        bytes32 currency;
        
        uint amount;
        
        bool short;
        
        uint accruedInterest;
        
        uint interestIndex;
        
        uint lastInteraction;
    }
}