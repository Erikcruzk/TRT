// File: ../sc_datasets/DAppSCAN/PepperSec-POA-Network-Bridge/tokenbridge-contracts-2bf70c7e9fd42968aec2dc352017618907834401/contracts/upgradeability/EternalStorage.sol

pragma solidity 0.4.24;


/**
 * @title EternalStorage
 * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
 */
contract EternalStorage {

    mapping(bytes32 => uint256) internal uintStorage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;

}