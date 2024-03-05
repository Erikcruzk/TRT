

pragma solidity 0.6.6;

contract MockContractContext {
  function executeTransaction(
    address target,
    uint value,
    string calldata signature,
    bytes calldata data
  ) external payable returns (bytes memory) {
    bytes memory callData;

    if (bytes(signature).length == 0) {
      callData = data;
    } else {
      callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
    }

    
    (bool success, bytes memory returnData) = target.call{value: value}(callData);
    require(success, _getRevertMsg(returnData));

    return returnData;
  }

  function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
    
    if (_returnData.length < 68) return "Transaction reverted silently";

    assembly {
      
      _returnData := add(_returnData, 0x04)
    }
    return abi.decode(_returnData, (string)); 
  }
}