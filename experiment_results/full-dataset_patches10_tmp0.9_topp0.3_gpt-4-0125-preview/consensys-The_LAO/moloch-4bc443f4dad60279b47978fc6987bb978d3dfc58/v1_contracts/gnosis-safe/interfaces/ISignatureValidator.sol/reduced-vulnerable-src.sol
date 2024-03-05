

pragma solidity ^0.5.0;

contract ISignatureValidator {
    
    bytes4 constant internal EIP1271_MAGIC_VALUE = 0x20c13b0b;

    







 
    function isValidSignature(
        bytes calldata _data, 
        bytes calldata _signature)
        external 
        returns (bytes4);
}