// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Aloith Release Smart Contract Audit/synthetix-1159c8aad0a1880d71e77e3b14f3a17826819136/contracts/interfaces/IAddressResolver.sol

pragma solidity >=0.4.24;

// https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
interface IAddressResolver {
    function getAddress(bytes32 name) external view returns (address);

    function getSynth(bytes32 key) external view returns (address);

    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
}
