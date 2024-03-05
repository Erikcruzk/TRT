





pragma solidity ^0.5.0;





interface IERC1400TokensChecker {

  
  
  
  
  
  
  
  
  

  function canTransferByPartition(
    bytes4 functionSig,
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint256 value,
    bytes calldata data,
    bytes calldata operatorData
    ) external view returns (byte, bytes32, bytes32);

}