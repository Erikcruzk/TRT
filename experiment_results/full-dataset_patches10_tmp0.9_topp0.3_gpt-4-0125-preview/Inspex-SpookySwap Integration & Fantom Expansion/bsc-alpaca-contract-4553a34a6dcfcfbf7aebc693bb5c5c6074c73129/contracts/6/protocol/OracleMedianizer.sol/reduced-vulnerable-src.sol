

pragma solidity ^0.6.0;














library SafeMath {
    








    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    








    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    








    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    








    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    










    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    










    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    










    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    










    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}



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
pragma experimental ABIEncoderV2;


contract OracleMedianizer is OwnableUpgradeSafe, PriceOracle {
  using SafeMath for uint256;

  
  mapping(address => mapping(address => uint256)) public primarySourceCount;
  
  mapping(address => mapping(address => mapping(uint256 => PriceOracle))) public primarySources;
  
  mapping(address => mapping(address => uint256)) public maxPriceDeviations;
  
  mapping(address => mapping(address => uint256)) public maxPriceStales;
  
  uint256 public constant MIN_PRICE_DEVIATION = 1e18;
  
  uint256 public constant MAX_PRICE_DEVIATION = 1.5e18;

  event SetPrimarySources(
    address indexed token0,
    address indexed token1,
    uint256 maxPriceDeviation,
    uint256 maxPriceStale,
    PriceOracle[] oracles
  );

  function initialize() external initializer {
    OwnableUpgradeSafe.__Ownable_init();
  }

  
  
  
  
  
  
  function setPrimarySources(
    address token0,
    address token1,
    uint256 maxPriceDeviation,
    uint256 maxPriceStale,
    PriceOracle[] calldata sources
  ) external onlyOwner {
    _setPrimarySources(token0, token1, maxPriceDeviation, maxPriceStale, sources);
  }

  
  
  
  
  
  
  function setMultiPrimarySources(
    address[] calldata token0s,
    address[] calldata token1s,
    uint256[] calldata maxPriceDeviationList,
    uint256[] calldata maxPriceStaleList,
    PriceOracle[][] calldata allSources
  ) external onlyOwner {
    require(
      token0s.length == token1s.length &&
        token0s.length == allSources.length &&
        token0s.length == maxPriceDeviationList.length &&
        token0s.length == maxPriceStaleList.length,
      "OracleMedianizer::setMultiPrimarySources:: inconsistent length"
    );
    for (uint256 idx = 0; idx < token0s.length; idx++) {
      _setPrimarySources(
        token0s[idx],
        token1s[idx],
        maxPriceDeviationList[idx],
        maxPriceStaleList[idx],
        allSources[idx]
      );
    }
  }

  
  
  
  
  
  
  function _setPrimarySources(
    address token0,
    address token1,
    uint256 maxPriceDeviation,
    uint256 maxPriceStale,
    PriceOracle[] memory sources
  ) internal {
    require(
      maxPriceDeviation >= MIN_PRICE_DEVIATION && maxPriceDeviation <= MAX_PRICE_DEVIATION,
      "OracleMedianizer::setPrimarySources:: bad max deviation value"
    );
    require(sources.length <= 3, "OracleMedianizer::setPrimarySources:: sources length exceed 3");
    primarySourceCount[token0][token1] = sources.length;
    primarySourceCount[token1][token0] = sources.length;
    maxPriceDeviations[token0][token1] = maxPriceDeviation;
    maxPriceDeviations[token1][token0] = maxPriceDeviation;
    maxPriceStales[token0][token1] = maxPriceStale;
    maxPriceStales[token1][token0] = maxPriceStale;
    for (uint256 idx = 0; idx < sources.length; idx++) {
      primarySources[token0][token1][idx] = sources[idx];
      primarySources[token1][token0][idx] = sources[idx];
    }
    emit SetPrimarySources(token0, token1, maxPriceDeviation, maxPriceStale, sources);
  }

  
  
  
  
  function _getPrice(address token0, address token1) internal view returns (uint256) {
    uint256 candidateSourceCount = primarySourceCount[token0][token1];
    require(candidateSourceCount > 0, "OracleMedianizer::getPrice:: no primary source");
    uint256[] memory prices = new uint256[](candidateSourceCount);
    
    uint256 validSourceCount = 0;
    for (uint256 idx = 0; idx < candidateSourceCount; idx++) {
      try primarySources[token0][token1][idx].getPrice(token0, token1) returns (uint256 price, uint256 lastUpdate) {
        if (lastUpdate >= now - maxPriceStales[token0][token1]) {
          prices[validSourceCount++] = price;
        }
      } catch {}
    }
    require(validSourceCount > 0, "OracleMedianizer::getPrice:: no valid source");
    
    for (uint256 i = 0; i < validSourceCount - 1; i++) {
      for (uint256 j = 0; j < validSourceCount - i - 1; j++) {
        if (prices[j] > prices[j + 1]) {
          (prices[j], prices[j + 1]) = (prices[j + 1], prices[j]);
        }
      }
    }
    uint256 maxPriceDeviation = maxPriceDeviations[token0][token1];
    
    
    
    
    
    
    
    
    if (validSourceCount == 1) return prices[0]; 
    if (validSourceCount == 2) {
      require(
        prices[1].mul(1e18) / prices[0] <= maxPriceDeviation,
        "OracleMedianizer::getPrice:: too much deviation 2 valid sources"
      );
      return prices[0].add(prices[1]) / 2; 
    }
    bool midP0P1Ok = prices[1].mul(1e18) / prices[0] <= maxPriceDeviation;
    bool midP1P2Ok = prices[2].mul(1e18) / prices[1] <= maxPriceDeviation;
    if (midP0P1Ok && midP1P2Ok) return prices[1]; 
    if (midP0P1Ok) return prices[0].add(prices[1]) / 2; 
    if (midP1P2Ok) return prices[1].add(prices[2]) / 2; 
    revert("OracleMedianizer::getPrice:: too much deviation 3 valid sources");
  }

  
  function getPrice(address token0, address token1) external view override returns (uint256, uint256) {
    return (_getPrice(token0, token1), block.timestamp);
  }
}