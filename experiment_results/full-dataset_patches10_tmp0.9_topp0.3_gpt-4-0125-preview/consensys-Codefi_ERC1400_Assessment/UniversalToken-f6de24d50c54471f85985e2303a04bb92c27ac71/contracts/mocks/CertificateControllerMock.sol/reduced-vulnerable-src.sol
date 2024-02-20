

pragma solidity ^0.5.0;


contract CertificateControllerMock {

  
  bool _certificateControllerActivated;

  
  mapping(address => bool) internal _certificateSigners;

  
  mapping(address => uint256) internal _checkCount;

  event Checked(address sender);

  constructor(address _certificateSigner, bool activated) public {
    _setCertificateSigner(_certificateSigner, true);
    _certificateControllerActivated = activated;
  }

  


  modifier isValidCertificate(bytes memory data) {

    if(_certificateControllerActivated) {
      require(_certificateSigners[msg.sender] || _checkCertificate(data, 0, 0x00000000), "54"); 

      _checkCount[msg.sender] += 1; 

      emit Checked(msg.sender);
    }

    _;
  }

  




  function checkCount(address sender) external view returns (uint256) {
    return _checkCount[sender];
  }

  




  function certificateSigners(address operator) external view returns (bool) {
    return _certificateSigners[operator];
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

  



   function _checkCertificate(bytes memory data, uint256 , bytes4 ) internal pure returns(bool) { 
     if(data.length > 0 && (data[0] == hex"10" || data[0] == hex"11" || data[0] == hex"22" || data[0] == hex"33")) {
       return true;
     } else {
       return false;
     }
   }
}