

pragma solidity ^0.4.24;




contract ITwoKeySingletoneAddressStorage {
    function getContractAddress(string contractName) external view returns (address);
}