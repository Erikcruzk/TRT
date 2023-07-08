// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/ISourceMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

interface ISourceMock {
    function set(uint) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-YieldV2/vault-v2-819a713416249da92c44eb629ed26a49425a4656/contracts/mocks/oracles/compound/CTokenChiMock.sol

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

contract CTokenChiMock is ISourceMock {
    uint public exchangeRateStored;

    function set(uint chi) external override {
        exchangeRateStored = chi;
    }

    function exchangeRateCurrent() public view returns (uint) {
        return exchangeRateStored;
    }
}
