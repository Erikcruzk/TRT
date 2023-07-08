// File: ../sc_datasets/DAppSCAN/Byterocket-Orbit DeFi[05.29.2022]/orbit-defi-541460999b7d8fa80c4a4a86383f583392436b67/interfaces/IAaveAddressHolder.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

interface IAaveAddressHolder {
    ///@notice default getter for lendingPoolAddress
    ///@return address The address of the lending pool from aave
    function lendingPoolAddress() external view returns (address);

    ///@notice Set the address of lending pool
    ///@param newAddress new address of the lending pool from aave
    function setLendingPoolAddress(address newAddress) external;
}

// File: ../sc_datasets/DAppSCAN/Byterocket-Orbit DeFi[05.29.2022]/orbit-defi-541460999b7d8fa80c4a4a86383f583392436b67/contracts/utils/AaveAddressHolder.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

contract AaveAddressHolder is IAaveAddressHolder {
    address public override lendingPoolAddress;

    constructor(address _lendingPoolAddress) {
        lendingPoolAddress = _lendingPoolAddress;
    }

    ///@notice Set the address of the lending pool from aave
    ///@param newAddress The address of the lending pool from aave
    function setLendingPoolAddress(address newAddress) external override {
        lendingPoolAddress = newAddress;
    }
}
