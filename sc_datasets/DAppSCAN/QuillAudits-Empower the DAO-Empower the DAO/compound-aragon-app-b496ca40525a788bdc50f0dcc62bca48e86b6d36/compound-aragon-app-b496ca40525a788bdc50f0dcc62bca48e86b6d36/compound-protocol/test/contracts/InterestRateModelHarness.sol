pragma solidity ^0.5.8;

import "../InterestRateModel.sol";

/**
  * @title An Interest Rate Model for tests that can be instructed to return a failure instead of doing a calculation
  * @author Compound
  */
contract InterestRateModelHarness is InterestRateModel {
    bool public constant isInterestRateModel = true;
    uint public constant opaqueBorrowFailureCode = 20;
    bool public failBorrowRate;
    uint public borrowRate;

    constructor(uint borrowRate_) public {
        borrowRate = borrowRate_;
    }

    function setFailBorrowRate(bool failBorrowRate_) public {
        failBorrowRate = failBorrowRate_;
    }

    function setBorrowRate(uint borrowRate_) public {
        borrowRate = borrowRate_;
    }

    function getBorrowRate(uint _cash, uint _borrows, uint _reserves) public view returns (uint, uint) {
        _cash;     // unused
        _borrows;  // unused
        _reserves; // unused

        if (failBorrowRate) {
            return (opaqueBorrowFailureCode, 0);
        }
        return (0, borrowRate);
    }
}