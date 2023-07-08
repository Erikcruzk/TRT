// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/liquity/interfaces/IPriceFeed.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IPriceFeed {
    function fetchPrice() external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/test/liquity/utils/MockPriceFeed.sol

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
