


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




pragma solidity 0.8.7;

contract MockInitializableImple is VersionedInitializable {
  uint256 public value;
  string public text;
  uint256[] public values;

  uint256 public constant REVISION = 1;

  



  function getRevision() internal pure override returns (uint256) {
    return REVISION;
  }

  function initialize(
    uint256 val,
    string memory txt,
    uint256[] memory vals
  ) external initializer {
    value = val;
    text = txt;
    values = vals;
  }

  function setValue(uint256 newValue) public {
    value = newValue;
  }

  function setValueViaProxy(uint256 newValue) public {
    value = newValue;
  }
}

contract MockInitializableImpleV2 is VersionedInitializable {
  uint256 public value;
  string public text;
  uint256[] public values;

  uint256 public constant REVISION = 2;

  



  function getRevision() internal pure override returns (uint256) {
    return REVISION;
  }

  function initialize(
    uint256 val,
    string memory txt,
    uint256[] memory vals
  ) public initializer {
    value = val;
    text = txt;
    values = vals;
  }

  function setValue(uint256 newValue) public {
    value = newValue;
  }

  function setValueViaProxy(uint256 newValue) public {
    value = newValue;
  }
}

contract MockInitializableFromConstructorImple is VersionedInitializable {
  uint256 public value;

  uint256 public constant REVISION = 2;

  



  function getRevision() internal pure override returns (uint256) {
    return REVISION;
  }

  constructor(uint256 val) {
    initialize(val);
  }

  function initialize(uint256 val) public initializer {
    value = val;
  }
}

contract MockReentrantInitializableImple is VersionedInitializable {
  uint256 public value;

  uint256 public constant REVISION = 2;

  



  function getRevision() internal pure override returns (uint256) {
    return REVISION;
  }

  function initialize(uint256 val) public initializer {
    value = val;
    if (value < 2) {
      initialize(value + 1);
    }
  }
}