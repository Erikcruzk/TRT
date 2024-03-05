





pragma solidity ^0.5.0;





interface IERC1400TokensSender {

  function canTransfer(
    bytes4 functionSig,
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external view returns(bool);

  function tokensToTransfer(
    bytes4 functionSig,
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external;

}







pragma solidity ^0.5.0;


contract ERC1820Implementer {
  bytes32 constant ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

  mapping(bytes32 => bool) internal _interfaceHashes;

  function canImplementInterfaceForAddress(bytes32 interfaceHash, address ) 
    external
    view
    returns(bytes32)
  {
    if(_interfaceHashes[interfaceHash]) {
      return ERC1820_ACCEPT_MAGIC;
    } else {
      return "";
    }
  }

  function _setInterface(string memory interfaceLabel) internal {
    _interfaceHashes[keccak256(abi.encodePacked(interfaceLabel))] = true;
  }

}



pragma solidity ^0.5.0;


contract ERC1400TokensSenderMock is IERC1400TokensSender, ERC1820Implementer {

  string constant internal ERC1400_TOKENS_SENDER = "ERC1400TokensSender";

  constructor() public {
    ERC1820Implementer._setInterface(ERC1400_TOKENS_SENDER);
  }

  function canTransfer(
    bytes4 ,
    bytes32 ,
    address ,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata 
  ) 
    external
    view
    returns(bool)
  {
    return(_canTransfer(from, to, value, data));
  }

  function tokensToTransfer(
    bytes4 ,
    bytes32 ,
    address ,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata 
  ) 
    external
  {
    require(_canTransfer(from, to, value, data), "56"); 
  }

  function _canTransfer(
    address ,
    address ,
    uint ,
    bytes memory data
  ) 
    internal
    pure
    returns(bool)
  {
    bytes32 transferRevert = 0x1100000000000000000000000000000000000000000000000000000000000000; 
    bytes32 data32;
    assembly {
        data32 := mload(add(data, 32))
    }
    if (data32 == transferRevert) {
      return false;
    } else {
      return true;
    }
  }

}