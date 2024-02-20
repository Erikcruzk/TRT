

















pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;




library Types {

  bytes constant internal EIP191_HEADER = "\x19\x01";

  struct Order {
    uint256 nonce;                
    uint256 expiry;               
    Party signer;                 
    Party sender;                 
    Party affiliate;              
    Signature signature;          
  }

  struct Party {
    bytes4 kind;                  
    address wallet;               
    address token;                
    uint256 param;                
  }

  struct Signature {
    address signatory;            
    address validator;            
    bytes1 version;               
    uint8 v;                      
    bytes32 r;                    
    bytes32 s;                    
  }

  bytes32 constant internal DOMAIN_TYPEHASH = keccak256(abi.encodePacked(
    "EIP712Domain(",
    "string name,",
    "string version,",
    "address verifyingContract",
    ")"
  ));

  bytes32 constant internal ORDER_TYPEHASH = keccak256(abi.encodePacked(
    "Order(",
    "uint256 nonce,",
    "uint256 expiry,",
    "Party signer,",
    "Party sender,",
    "Party affiliate",
    ")",
    "Party(",
    "bytes4 kind,",
    "address wallet,",
    "address token,",
    "uint256 param",
    ")"
  ));

  bytes32 constant internal PARTY_TYPEHASH = keccak256(abi.encodePacked(
    "Party(",
    "bytes4 kind,",
    "address wallet,",
    "address token,",
    "uint256 param",
    ")"
  ));

  






  function hashOrder(
    Order calldata order,
    bytes32 domainSeparator
  ) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(
      EIP191_HEADER,
      domainSeparator,
      keccak256(abi.encode(
        ORDER_TYPEHASH,
        order.nonce,
        order.expiry,
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.signer.kind,
          order.signer.wallet,
          order.signer.token,
          order.signer.param
        )),
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.sender.kind,
          order.sender.wallet,
          order.sender.token,
          order.sender.param
        )),
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.affiliate.kind,
          order.affiliate.wallet,
          order.affiliate.token,
          order.affiliate.param
        ))
      ))
    ));
  }

  







  function hashDomain(
    bytes calldata name,
    bytes calldata version,
    address verifyingContract
  ) external pure returns (bytes32) {
    return keccak256(abi.encode(
      DOMAIN_TYPEHASH,
      keccak256(name),
      keccak256(version),
      verifyingContract
    ));
  }
}



pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;






contract MockTypes {
  function hashOrder(Types.Order memory _order, bytes32 _domainSeparator) public pure returns (bytes32) {
    return Types.hashOrder(_order, _domainSeparator);
  }

  function hashDomain(
    bytes memory _name,
    bytes memory _version,
    address _verifyingContract
  ) public pure returns (bytes32) {
    return Types.hashDomain(_name, _version, _verifyingContract);
  }
}