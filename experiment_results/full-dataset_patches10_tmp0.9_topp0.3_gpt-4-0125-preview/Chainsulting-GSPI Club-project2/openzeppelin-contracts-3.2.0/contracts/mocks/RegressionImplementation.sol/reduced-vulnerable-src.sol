



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

contract Implementation1 is Initializable {
  uint internal _value;

  function initialize() public initializer {
  }

  function setValue(uint _number) public {
    _value = _number;
  }
}

contract Implementation2 is Initializable {
  uint internal _value;

  function initialize() public initializer {
  }

  function setValue(uint _number) public {
    _value = _number;
  }

  function getValue() public view returns (uint) {
    return _value;
  }
}

contract Implementation3 is Initializable {
  uint internal _value;

  function initialize() public initializer {
  }

  function setValue(uint _number) public {
    _value = _number;
  }

  function getValue(uint _number) public view returns (uint) {
    return _value + _number;
  }
}

contract Implementation4 is Initializable {
  uint internal _value;

  function initialize() public initializer {
  }

  function setValue(uint _number) public {
    _value = _number;
  }

  function getValue() public view returns (uint) {
    return _value;
  }

  
  fallback() external {
    _value = 1;
  }
}