

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
















pragma solidity 0.6.6;

interface IVaultConfig {
  
  function minDebtSize() external view returns (uint256);

  
  function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);

  
  function getWrappedNativeAddr() external view returns (address);

  
  function getWNativeRelayer() external view returns (address);

  
  function getFairLaunchAddr() external view returns (address);

  
  function getReservePoolBps() external view returns (uint256);

  
  function getKillBps() external view returns (uint256);

  
  function whitelistedCallers(address caller) external returns (bool);

  
  function whitelistedLiquidators(address caller) external returns (bool);

  
  function approvedAddStrategies(address addStrats) external returns (bool);

  
  function isWorker(address worker) external view returns (bool);

  
  function acceptDebt(address worker) external view returns (bool);

  
  function workFactor(address worker, uint256 debt) external view returns (uint256);

  
  function killFactor(address worker, uint256 debt) external view returns (uint256);

  
  function rawKillFactor(address worker, uint256 debt) external view returns (uint256);

  
  function getKillTreasuryBps() external view returns (uint256);

  
  function getTreasuryAddr() external view returns (address);

  
  function isWorkerStable(address worker) external view returns (bool);

  
  function isWorkerReserveConsistent(address worker) external view returns (bool);
}
















pragma solidity 0.6.6;

interface IWorkerConfig {
  
  function acceptDebt(address worker) external view returns (bool);

  
  function workFactor(address worker, uint256 debt) external view returns (uint256);

  
  function killFactor(address worker, uint256 debt) external view returns (uint256);

  
  function rawKillFactor(address worker, uint256 debt) external view returns (uint256);

  
  function isStable(address worker) external view returns (bool);

  
  function isReserveConsistent(address worker) external view returns (bool);
}
















pragma solidity 0.6.6;

interface InterestModel {
  
  function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);
}
















pragma solidity 0.6.6;





contract ConfigurableInterestVaultConfig is IVaultConfig, OwnableUpgradeSafe {
  
  event SetWhitelistedCaller(address indexed caller, address indexed addr, bool ok);
  event SetParams(
    address indexed caller,
    uint256 minDebtSize,
    uint256 reservePoolBps,
    uint256 killBps,
    address interestModel,
    address wrappedNative,
    address wNativeRelayer,
    address fairLaunch,
    uint256 killTreasuryBps,
    address treasury
  );
  event SetWorkers(address indexed caller, address worker, address workerConfig);
  event SetMaxKillBps(address indexed caller, uint256 maxKillBps);
  event SetWhitelistedLiquidator(address indexed caller, address indexed addr, bool ok);
  event SetApprovedAddStrategy(address indexed caller, address addStrat, bool ok);

  
  uint256 public override minDebtSize;
  
  uint256 public override getReservePoolBps;
  
  uint256 public override getKillBps;
  
  mapping(address => IWorkerConfig) public workers;
  
  InterestModel public interestModel;
  
  address public override getWrappedNativeAddr;
  
  address public override getWNativeRelayer;
  
  address public override getFairLaunchAddr;
  
  uint256 public maxKillBps;
  
  mapping(address => bool) public override whitelistedCallers;
  
  uint256 public override getKillTreasuryBps;
  
  address public treasury;
  
  mapping(address => bool) public override approvedAddStrategies;
  
  mapping(address => bool) public override whitelistedLiquidators;

  function initialize(
    uint256 _minDebtSize,
    uint256 _reservePoolBps,
    uint256 _killBps,
    InterestModel _interestModel,
    address _getWrappedNativeAddr,
    address _getWNativeRelayer,
    address _getFairLaunchAddr,
    uint256 _getKillTreasuryBps,
    address _treasury
  ) external initializer {
    OwnableUpgradeSafe.__Ownable_init();

    maxKillBps = 500;
    setParams(
      _minDebtSize,
      _reservePoolBps,
      _killBps,
      _interestModel,
      _getWrappedNativeAddr,
      _getWNativeRelayer,
      _getFairLaunchAddr,
      _getKillTreasuryBps,
      _treasury
    );
  }

  
  
  
  
  
  
  
  function setParams(
    uint256 _minDebtSize,
    uint256 _reservePoolBps,
    uint256 _killBps,
    InterestModel _interestModel,
    address _getWrappedNativeAddr,
    address _getWNativeRelayer,
    address _getFairLaunchAddr,
    uint256 _getKillTreasuryBps,
    address _treasury
  ) public onlyOwner {
    require(
      _killBps + _getKillTreasuryBps <= maxKillBps,
      "ConfigurableInterestVaultConfig::setParams:: kill bps exceeded max kill bps"
    );

    minDebtSize = _minDebtSize;
    getReservePoolBps = _reservePoolBps;
    getKillBps = _killBps;
    interestModel = _interestModel;
    getWrappedNativeAddr = _getWrappedNativeAddr;
    getWNativeRelayer = _getWNativeRelayer;
    getFairLaunchAddr = _getFairLaunchAddr;
    getKillTreasuryBps = _getKillTreasuryBps;
    treasury = _treasury;

    emit SetParams(
      _msgSender(),
      minDebtSize,
      getReservePoolBps,
      getKillBps,
      address(interestModel),
      getWrappedNativeAddr,
      getWNativeRelayer,
      getFairLaunchAddr,
      getKillTreasuryBps,
      treasury
    );
  }

  
  function setWorkers(address[] calldata addrs, IWorkerConfig[] calldata configs) external onlyOwner {
    require(addrs.length == configs.length, "ConfigurableInterestVaultConfig::setWorkers:: bad length");
    for (uint256 idx = 0; idx < addrs.length; idx++) {
      workers[addrs[idx]] = configs[idx];
      emit SetWorkers(_msgSender(), addrs[idx], address(configs[idx]));
    }
  }

  
  function setWhitelistedCallers(address[] calldata callers, bool ok) external onlyOwner {
    for (uint256 idx = 0; idx < callers.length; idx++) {
      whitelistedCallers[callers[idx]] = ok;
      emit SetWhitelistedCaller(_msgSender(), callers[idx], ok);
    }
  }

  
  function setApprovedAddStrategy(address[] calldata addStrats, bool ok) external onlyOwner {
    for (uint256 idx = 0; idx < addStrats.length; idx++) {
      approvedAddStrategies[addStrats[idx]] = ok;
      emit SetApprovedAddStrategy(_msgSender(), addStrats[idx], ok);
    }
  }

  
  function setMaxKillBps(uint256 _maxKillBps) external onlyOwner {
    require(_maxKillBps < 1000, "ConfigurableInterestVaultConfig::setMaxKillBps:: bad _maxKillBps");
    maxKillBps = _maxKillBps;
    emit SetMaxKillBps(_msgSender(), maxKillBps);
  }

  
  function setWhitelistedLiquidators(address[] calldata callers, bool ok) external onlyOwner {
    for (uint256 idx = 0; idx < callers.length; idx++) {
      whitelistedLiquidators[callers[idx]] = ok;
      emit SetWhitelistedLiquidator(_msgSender(), callers[idx], ok);
    }
  }

  
  function getInterestRate(uint256 debt, uint256 floating) external view override returns (uint256) {
    return interestModel.getInterestRate(debt, floating);
  }

  
  function isWorker(address worker) external view override returns (bool) {
    return address(workers[worker]) != address(0);
  }

  
  function acceptDebt(address worker) external view override returns (bool) {
    return workers[worker].acceptDebt(worker);
  }

  
  function workFactor(address worker, uint256 debt) external view override returns (uint256) {
    return workers[worker].workFactor(worker, debt);
  }

  
  function killFactor(address worker, uint256 debt) external view override returns (uint256) {
    return workers[worker].killFactor(worker, debt);
  }

  
  function rawKillFactor(address worker, uint256 debt) external view override returns (uint256) {
    return workers[worker].rawKillFactor(worker, debt);
  }

  
  function isWorkerStable(address worker) external view override returns (bool) {
    return workers[worker].isStable(worker);
  }

  
  function isWorkerReserveConsistent(address worker) external view override returns (bool) {
    return workers[worker].isReserveConsistent(worker);
  }

  
  function getTreasuryAddr() external view override returns (address) {
    return treasury == address(0) ? 0xC44f82b07Ab3E691F826951a6E335E1bC1bB0B51 : treasury;
  }
}