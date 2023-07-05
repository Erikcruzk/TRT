// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Aloith Release Smart Contract Audit/synthetix-1159c8aad0a1880d71e77e3b14f3a17826819136/contracts/interfaces/ICollateralLoan.sol

pragma solidity >=0.4.24;

pragma experimental ABIEncoderV2;

interface ICollateralLoan {
    struct Loan {
        // ID for the loan
        uint id;
        //  Acccount that created the loan
        address payable account;
        //  Amount of collateral deposited
        uint collateral;
        // The synth that was borowed
        bytes32 currency;
        //  Amount of synths borrowed
        uint amount;
        // Indicates if the position was short sold
        bool short;
        // interest amounts accrued
        uint accruedInterest;
        // last interest index
        uint interestIndex;
        // time of last interaction.
        uint lastInteraction;
    }
}
