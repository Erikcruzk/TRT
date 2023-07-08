// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/liquity/interfaces/IPriceFeed.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IPriceFeed {
    function fetchPrice() external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/liquity/interfaces/ILiquityBase.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface ILiquityBase {
    function priceFeed() external view returns (IPriceFeed);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/liquity/interfaces/IStabilityPool.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IStabilityPool {
    function provideToSP(uint256 _amount, address _frontEndTag) external;

    function withdrawFromSP(uint256 _amount) external;

    function getCompoundedLUSDDeposit(address _depositor) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/liquity/interfaces/ILQTYStaking.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface ILQTYStaking {
    function stakes(address _user) external view returns (uint);

    function stake(uint _LQTYamount) external;

    function unstake(uint _LQTYamount) external;
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/liquity/interfaces/ITroveManager.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;



// Common interface for the Trove Manager.
interface ITroveManager is ILiquityBase {
    function getCurrentICR(address _borrower, uint _price) external view returns (uint);

    function liquidate(address _borrower) external;

    function redeemCollateral(
        uint _LUSDAmount,
        address _firstRedemptionHint,
        address _upperPartialRedemptionHint,
        address _lowerPartialRedemptionHint,
        uint _partialRedemptionHintNICR,
        uint _maxIterations,
        uint _maxFee
    ) external;

    function getEntireDebtAndColl(address _borrower) external view returns (
        uint debt, 
        uint coll, 
        uint pendingLUSDDebtReward, 
        uint pendingETHReward
    );

    function closeTrove(address _borrower) external;

    function getBorrowingRateWithDecay() external view returns (uint);

    function getTroveStatus(address _borrower) external view returns (uint);
    
    function checkRecoveryMode(uint _price) external view returns (bool);
}
