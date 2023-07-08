// File: ../sc_datasets/DAppSCAN/Chainsecurity-Compound  cToken unredacted/compound-protocol-4a54ec5c55b66ea67d44b76f3056f0ed7229db8c/contracts/InterestRateModel.sol

// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.6;

/**
  * @title Compound's InterestRateModel Interface
  * @author Compound
  */
abstract contract InterestRateModel {
    /// @notice Indicator that this is an InterestRateModel contract (for inspection)
    bool public constant isInterestRateModel = true;

    /**
      * @notice Calculates the current borrow interest rate per block
      * @param cash The total amount of cash the market has
      * @param borrows The total amount of borrows the market has outstanding
      * @param reserves The total amount of reserves the market has
      * @return The borrow rate per block (as a percentage, and scaled by 1e18)
      */
    function getBorrowRate(uint cash, uint borrows, uint reserves) virtual external view returns (uint);

    /**
      * @notice Calculates the current supply interest rate per block
      * @param cash The total amount of cash the market has
      * @param borrows The total amount of borrows the market has outstanding
      * @param reserves The total amount of reserves the market has
      * @param reserveFactorMantissa The current reserve factor the market has
      * @return The supply rate per block (as a percentage, and scaled by 1e18)
      */
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) virtual external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Compound  cToken unredacted/compound-protocol-4a54ec5c55b66ea67d44b76f3056f0ed7229db8c/tests/Contracts/InterestRateModelHarness.sol

// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.6;

/**
  * @title An Interest Rate Model for tests that can be instructed to return a failure instead of doing a calculation
  * @author Compound
  */
contract InterestRateModelHarness is InterestRateModel {
    uint public constant opaqueBorrowFailureCode = 20;
    bool public failBorrowRate;
    uint public borrowRate;

    constructor(uint borrowRate_) {
        borrowRate = borrowRate_;
    }

    function setFailBorrowRate(bool failBorrowRate_) public {
        failBorrowRate = failBorrowRate_;
    }

    function setBorrowRate(uint borrowRate_) public {
        borrowRate = borrowRate_;
    }

    function getBorrowRate(uint _cash, uint _borrows, uint _reserves) override public view returns (uint) {
        _cash;     // unused
        _borrows;  // unused
        _reserves; // unused
        require(!failBorrowRate, "INTEREST_RATE_MODEL_ERROR");
        return borrowRate;
    }

    function getSupplyRate(uint _cash, uint _borrows, uint _reserves, uint _reserveFactor) override external view returns (uint) {
        _cash;     // unused
        _borrows;  // unused
        _reserves; // unused
        return borrowRate * (1 - _reserveFactor);
    }
}
