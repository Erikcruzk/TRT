// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-119164e1624309606db3edd806c520cdd8937743/contracts/interfaces/IAddressResolver.sol

pragma solidity >=0.4.24;


// https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
interface IAddressResolver {
    function getAddress(bytes32 name) external view returns (address);

    function getSynth(bytes32 key) external view returns (address);

    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
}
