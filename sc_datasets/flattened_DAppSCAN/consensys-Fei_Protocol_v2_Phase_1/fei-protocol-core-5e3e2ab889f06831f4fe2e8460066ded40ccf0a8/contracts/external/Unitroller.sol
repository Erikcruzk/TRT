// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/external/CToken.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

abstract contract CToken {
    function getCash() external view returns (uint) {}
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/external/Unitroller.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

abstract contract Unitroller {

    struct Market {
        bool isListed;
        uint collateralFactorMantissa;
        mapping(address => bool) accountMembership;
    }
    
    address public admin;
    uint public closeFactorMantissa;
    uint public liquidationIncentiveMantissa;
    mapping(address => Market) public markets;
    function _setPendingAdmin(address newPendingAdmin) public virtual returns (uint); 
    function _setCloseFactor(uint newCloseFactorMantissa) external virtual returns (uint256);
    function _setLiquidationIncentive(uint newLiquidationIncentiveMantissa) external virtual returns (uint);
    function _setCollateralFactor(CToken cToken, uint newCollateralFactorMantissa) public virtual returns (uint256);
}
