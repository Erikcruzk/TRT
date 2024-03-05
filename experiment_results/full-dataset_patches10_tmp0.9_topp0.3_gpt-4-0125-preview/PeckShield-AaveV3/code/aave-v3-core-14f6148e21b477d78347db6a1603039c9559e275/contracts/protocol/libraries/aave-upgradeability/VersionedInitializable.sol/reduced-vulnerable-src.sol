


pragma solidity 0.8.7;













abstract contract VersionedInitializable {
  


  uint256 private lastInitializedRevision = 0;

  


  bool private initializing;

  


  modifier initializer() {
    uint256 revision = getRevision();
    require(
      initializing || isConstructor() || revision > lastInitializedRevision,
      'Contract instance has already been initialized'
    );

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      lastInitializedRevision = revision;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  




  function getRevision() internal pure virtual returns (uint256);

  



  function isConstructor() private view returns (bool) {
    
    
    
    
    
    uint256 cs;
    
    assembly {
      cs := extcodesize(address())
    }
    return cs == 0;
  }

  
  uint256[50] private ______gap;
}