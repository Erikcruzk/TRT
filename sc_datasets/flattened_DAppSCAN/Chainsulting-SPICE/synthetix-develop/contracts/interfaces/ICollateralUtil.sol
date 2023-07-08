// File: ../sc_datasets/DAppSCAN/Chainsulting-SPICE/synthetix-develop/contracts/interfaces/ICollateralLoan.sol

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

// File: ../sc_datasets/DAppSCAN/Chainsulting-SPICE/synthetix-develop/contracts/interfaces/ICollateralUtil.sol

pragma solidity >=0.4.24;

pragma experimental ABIEncoderV2;

interface ICollateralUtil {
    function getCollateralRatio(ICollateralLoan.Loan calldata loan, bytes32 collateralKey)
        external
        view
        returns (uint cratio);

    function maxLoan(
        uint amount,
        bytes32 currency,
        uint minCratio,
        bytes32 collateralKey
    ) external view returns (uint max);

    function liquidationAmount(
        ICollateralLoan.Loan calldata loan,
        uint minCratio,
        bytes32 collateralKey
    ) external view returns (uint amount);

    function collateralRedeemed(
        bytes32 currency,
        uint amount,
        bytes32 collateralKey
    ) external view returns (uint collateral);
}
