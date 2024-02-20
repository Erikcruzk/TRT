



pragma solidity >=0.4.24 <0.7.0;














abstract contract Initializable {

    


    bool private _initialized;

    


    bool private _initializing;

    


    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    
    function _isConstructor() private view returns (bool) {
        
        
        
        
        
        address self = address(this);
        uint256 cs;
        
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }
}





pragma solidity ^0.6.0;





contract InitializableMock is Initializable {

  bool public initializerRan;
  uint256 public x;

  function initialize() public initializer {
    initializerRan = true;
  }

  function initializeNested() public initializer {
    initialize();
  }

  function initializeWithX(uint256 _x) public payable initializer {
    x = _x;
  }

  function nonInitializable(uint256 _x) public payable {
    x = _x;
  }

  function fail() public pure {
    require(false, "InitializableMock forced failure");
  }

}