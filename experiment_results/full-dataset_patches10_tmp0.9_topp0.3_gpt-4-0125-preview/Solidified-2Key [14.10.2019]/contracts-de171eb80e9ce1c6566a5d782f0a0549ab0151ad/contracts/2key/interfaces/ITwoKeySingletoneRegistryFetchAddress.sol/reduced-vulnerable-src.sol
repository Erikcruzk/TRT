

pragma solidity ^0.4.24;




contract ITwoKeySingletoneRegistryFetchAddress {
    function getContractProxyAddress(string _contractName) public view returns (address);
    function getNonUpgradableContractAddress(string contractName) public view returns (address);
    function getLatestContractVersion(string contractName) public view returns (string);
}