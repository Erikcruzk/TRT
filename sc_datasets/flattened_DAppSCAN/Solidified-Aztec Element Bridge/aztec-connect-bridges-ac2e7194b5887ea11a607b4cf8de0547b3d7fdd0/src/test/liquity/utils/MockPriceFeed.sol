// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/IPriceFeed.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IPriceFeed {
    function fetchPrice() external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/test/liquity/utils/MockPriceFeed.sol

// SPDX-License-Identifier: GPL-2.0-only
pragma solidity >=0.8.0 <=0.8.10;

contract MockPriceFeed is IPriceFeed {
    uint256 public immutable lastGoodPrice;

    constructor(uint256 _price) {
        lastGoodPrice = _price;
    }

    function fetchPrice() external override returns (uint256) {
        return lastGoodPrice;
    }
}
