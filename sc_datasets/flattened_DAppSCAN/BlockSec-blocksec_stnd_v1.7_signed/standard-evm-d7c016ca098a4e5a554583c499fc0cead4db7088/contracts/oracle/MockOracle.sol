// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/interfaces/IPrice.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IPrice {
    function getThePrice() external view returns (int256 price);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/oracle/MockOracle.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

contract MockOracle is IPrice {
    int256 price;
    string public name;
    address operator;

    constructor(int256 price_, string memory name_) {
        price = price_;
        operator = msg.sender;
        name = name_;
    }

    function setPrice(int256 price_) public {
        require(msg.sender == operator, "IA");
        price = price_;
    }

    /**
     * Returns the latest price
     */
    function getThePrice() external view override returns (int256) {
        return price;
    }
}
