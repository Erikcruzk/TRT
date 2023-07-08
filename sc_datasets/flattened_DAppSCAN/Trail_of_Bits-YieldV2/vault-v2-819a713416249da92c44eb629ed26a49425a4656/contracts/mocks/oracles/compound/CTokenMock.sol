// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/ISourceMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

interface ISourceMock {
    function set(uint) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/compound/CTokenMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

contract CTokenMock is ISourceMock {
    uint public exchangeRateStored;
    address public underlying;
    uint counter; // Just to avoid warnings

    constructor (address underlying_) {
        underlying = underlying_;
    }

    function set(uint chi) external override {
        exchangeRateStored = chi;
    }

    function exchangeRateCurrent() public returns (uint) {
        counter++;
        return exchangeRateStored;
    }
}
