// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/IPriceFeed.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IPriceFeed {
    function fetchPrice() external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/ILiquityBase.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface ILiquityBase {
    function priceFeed() external view returns (IPriceFeed);
}