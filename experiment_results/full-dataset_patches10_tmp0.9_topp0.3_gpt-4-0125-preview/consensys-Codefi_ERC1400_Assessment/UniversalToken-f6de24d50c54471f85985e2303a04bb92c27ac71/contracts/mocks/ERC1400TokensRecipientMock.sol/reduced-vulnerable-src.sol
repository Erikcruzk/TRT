





pragma solidity ^0.5.0;





interface IERC1400TokensRecipient {

  function canReceive(
    bytes4 functionSig,
    bytes32 partition,
    address operator,
    address from,
    address to,
    uint value,
    bytes calldata data,
    bytes calldata operatorData
  ) external view returns(bool);

  function tokensReceived(
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


contract ERC1400TokensRecipientMock is IERC1400TokensRecipient, ERC1820Implementer {

  string constant internal ERC1400_TOKENS_RECIPIENT = "ERC1400TokensRecipient";

  constructor() public {
    ERC1820Implementer._setInterface(ERC1400_TOKENS_RECIPIENT);
  }

  function canReceive(
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
    return(_canReceive(from, to, value, data));
  }

  function tokensReceived(
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
    require(_canReceive(from, to, value, data), "57"); 
  }

  function _canReceive(
    address ,
    address ,
    uint ,
    bytes memory data
  ) 
    internal
    pure
    returns(bool)
  {
    bytes32 receiveRevert = 0x2200000000000000000000000000000000000000000000000000000000000000; 
    bytes32 data32;
    assembly {
        data32 := mload(add(data, 32))
    }
    if (data32 == receiveRevert) {
      return false;
    } else {
      return true;
    }
  }

}