

pragma solidity >=0.4.24 <0.7.0;














contract Initializable {

  


  bool private initialized;

  


  bool private initializing;

  


  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  
  function isConstructor() private view returns (bool) {
    
    
    
    
    
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  
  uint256[50] private ______gap;
}



pragma solidity ^0.6.0;











contract ContextUpgradeSafe is Initializable {
    
    

    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {


    }


    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }

    uint256[50] private __gap;
}



pragma solidity ^0.6.0;














contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    



    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {


        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);

    }


    


    function owner() public view returns (address) {
        return _owner;
    }

    


    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    






    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    



    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[49] private __gap;
}
















pragma solidity 0.6.6;

interface PriceOracle {
  
  
  function getPrice(address token0, address token1) external view returns (uint256 price, uint256 lastUpdate);
}
















pragma solidity 0.6.6;


contract SimplePriceOracle is OwnableUpgradeSafe, PriceOracle {
  event PriceUpdate(address indexed token0, address indexed token1, uint256 price);

  address private feeder;

  struct PriceData {
    uint192 price;
    uint64 lastUpdate;
  }

  
  mapping(address => mapping(address => PriceData)) public store;

  modifier onlyFeeder() {
    require(msg.sender == feeder, "SimplePriceOracle::onlyFeeder:: only feeder");
    _;
  }

  function initialize(address _feeder) external initializer {
    OwnableUpgradeSafe.__Ownable_init();

    feeder = _feeder;
  }

  function setFeeder(address _feeder) public onlyOwner {
    feeder = _feeder;
  }

  
  function setPrices(
    address[] calldata token0s,
    address[] calldata token1s,
    uint256[] calldata prices
  ) external onlyFeeder {
    uint256 len = token0s.length;
    require(token1s.length == len, "SimplePriceOracle::setPrices:: bad token1s length");
    require(prices.length == len, "SimplePriceOracle::setPrices:: bad prices length");
    for (uint256 idx = 0; idx < len; idx++) {
      address token0 = token0s[idx];
      address token1 = token1s[idx];
      uint256 price = prices[idx];
      store[token0][token1] = PriceData({ price: uint192(price), lastUpdate: uint64(now) });
      emit PriceUpdate(token0, token1, price);
    }
  }

  
  
  function getPrice(address token0, address token1) external view override returns (uint256 price, uint256 lastUpdate) {
    PriceData memory data = store[token0][token1];
    price = uint256(data.price);
    lastUpdate = uint256(data.lastUpdate);
    require(price != 0 && lastUpdate != 0, "SimplePriceOracle::getPrice:: bad price data");
    return (price, lastUpdate);
  }
}