// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/ISourceMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

interface ISourceMock {
    function set(uint) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/chainlink/ChainlinkAggregatorV3Mock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

contract ChainlinkAggregatorV3Mock is ISourceMock {
    int public price;   // Prices in Chainlink can be negative (!)
    uint public timestamp;
    uint8 public decimals = 18;  // Decimals provided in the oracle prices

    function set(uint price_) external override {// We provide prices with 18 decimals, which will be scaled Chainlink's decimals
        price = int(price_);
        timestamp = block.timestamp;
    }

    function latestRoundData() public view returns (uint80, int256, uint256, uint256, uint80) {
        return (0, price, 0, timestamp, 0);
    }
}
