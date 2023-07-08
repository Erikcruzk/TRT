// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IOwned.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Owned contract interface
*/
interface IOwned {
    // this function isn't since the compiler emits automatically generated getter functions as external
    function owner() external view returns (address);

    function transferOwnership(address _newOwner) external;
    function acceptOwnership() external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/IConverterAnchor.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Converter Anchor interface
*/
interface IConverterAnchor is IOwned {
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/converter/interfaces/ITypedConverterAnchorFactory.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Typed Converter Anchor Factory interface
*/
interface ITypedConverterAnchorFactory {
    function converterType() external pure returns (uint16);
    function createAnchor(string memory _name, string memory _symbol, uint8 _decimals) external returns (IConverterAnchor);
}
