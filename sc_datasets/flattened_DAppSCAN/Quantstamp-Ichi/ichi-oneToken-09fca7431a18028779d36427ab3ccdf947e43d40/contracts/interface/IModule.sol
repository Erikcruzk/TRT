// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IICHIOwnable.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IICHIOwnable {
    
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function owner() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/InterfaceCommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;
pragma abicoder v2;

interface InterfaceCommon {

    enum ModuleType { Version, Controller, Strategy, MintMaster, Oracle }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IICHICommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


interface IICHICommon is IICHIOwnable, InterfaceCommon {}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IModule.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


interface IModule is IICHICommon { 
       
    function oneTokenFactory() external view returns(address);
    function updateDescription(string memory description) external;
    function moduleDescription() external view returns(string memory);
    function MODULE_TYPE() external view returns(bytes32);
    function moduleType() external view returns(ModuleType);
}
