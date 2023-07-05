// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/DiaCoinInfoInterface.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface DiaCoinInfoInterface {
    function getCoinInfo(string memory name) external view returns (uint256, uint256, uint256, string memory);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/interfaces/IPrice.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IPrice {
    function getThePrice() external view returns (int256 price);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/DiaCoinInfo.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;


contract DiaCoinInfo is IPrice {
    DiaCoinInfoInterface internal priceFeed;

    string public name;

    constructor(address _aggregator, string memory _name) public {
        priceFeed = DiaCoinInfoInterface(_aggregator);
        name = _name;
    }

    /**
     * Returns the latest price
     */
    function getThePrice() external view override returns (int256) {
        (
            uint256 price,
            uint256 supply,
            uint256 lastUpdateTimeStamp,
            string memory symbol
        ) = priceFeed.getCoinInfo(name);
        return int256(price);
    }
}
