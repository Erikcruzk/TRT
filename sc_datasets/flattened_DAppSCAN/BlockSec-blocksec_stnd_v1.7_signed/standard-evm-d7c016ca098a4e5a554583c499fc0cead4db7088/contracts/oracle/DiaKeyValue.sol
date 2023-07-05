// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/DiaKeyValueInterface.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface DiaKeyValueInterface {
    function getValue(string memory key)
        external
        view
        returns (uint128, uint128);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/interfaces/IPrice.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IPrice {
    function getThePrice() external view returns (int256 price);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/DiaKeyValue.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;


contract DiaKeyValue is IPrice {
    DiaKeyValueInterface internal priceFeed;

    string public key;

    constructor(address _aggregator, string memory _key) public {
        priceFeed = DiaKeyValueInterface(_aggregator);
        key = _key;
    }

    /**
     * Returns the latest price
     */
    function getThePrice() external view override returns (int256) {
        (
            uint256 price,
            uint256 lastUpdateTimeStamp
        ) = priceFeed.getValue(key);
        return int256(price);
    }
}
