





pragma solidity ^0.5.0;



contract CertificateController {

  
  bool _certificateControllerActivated;

  
  mapping(address => bool) internal _certificateSigners;

  
  

  
  mapping(bytes32 => bool) internal _usedCertificate;

  event Used(address sender);

  constructor(address _certificateSigner, bool activated) public {
    _setCertificateSigner(_certificateSigner, true);
    _certificateControllerActivated = activated;
  }

  


  modifier isValidCertificate(bytes memory data) {

    if(_certificateControllerActivated) {
      require(_certificateSigners[msg.sender] || _checkCertificate(data, 0, 0x00000000), "54"); 

      bytes32 salt;
      assembly {
        salt := mload(add(data, 0x20))
      }

      _usedCertificate[salt] = true; 

      emit Used(msg.sender);
    }
    
    _;
  }

  


  














  




  function isUsedCertificate(bytes32 salt) external view returns (bool) {
    return _usedCertificate[salt];
  }

  




  function _setCertificateSigner(address operator, bool authorized) internal {
    require(operator != address(0)); 
    _certificateSigners[operator] = authorized;
  }

  


  function certificateControllerActivated() external view returns (bool) {
    return _certificateControllerActivated;
  }

  



  function _setCertificateControllerActivated(bool activated) internal {
    _certificateControllerActivated = activated;
  }

  



  function _checkCertificate(
    bytes memory data,
    uint256 amount,
    bytes4 functionID
  )
    internal
    view
    returns(bool)
  {
    bytes32 salt;
    uint256 e;
    bytes32 r;
    bytes32 s;
    uint8 v;

    
    if (data.length != 129) {
      return false;
    }

    
    assembly {
      
      
      salt := mload(add(data, 0x20))
      e := mload(add(data, 0x40))
      r := mload(add(data, 0x60))
      s := mload(add(data, 0x80))
      v := byte(0, mload(add(data, 0xa0)))
    }

    
    if (e < now) {
      return false;
    }

    if (v < 27) {
      v += 27;
    }

    
    if (v == 27 || v == 28) {
      
      bytes memory payload;

      assembly {
        let payloadsize := sub(calldatasize, 192)
        payload := mload(0x40) 
        mstore(0x40, add(payload, and(add(add(payloadsize, 0x20), 0x1f), not(0x1f)))) 
        mstore(payload, payloadsize) 
        calldatacopy(add(add(payload, 0x20), 4), 4, sub(payloadsize, 4))
      }

      if(functionID == 0x00000000) {
        assembly {
          calldatacopy(add(payload, 0x20), 0, 4)
        }
      } else {
        for (uint i = 0; i < 4; i++) { 
          payload[i] = functionID[i];
        }
      }

      
      bytes memory pack = abi.encodePacked(
        msg.sender,
        this,
        amount,
        payload,
        e,
        salt
      );
      bytes32 hash = keccak256(pack);

      
      if (_certificateSigners[ecrecover(hash, v, r, s)] && !_usedCertificate[salt]) {
        return true;
      }
    }
    return false;
  }
}