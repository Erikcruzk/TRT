

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


contract SimpleVaultConfig is IVaultConfig, OwnableUpgradeSafe {
  
  struct WorkerConfig {
    bool isWorker;
    bool acceptDebt;
    uint256 workFactor;
    uint256 killFactor;
    bool isStable;
    bool isReserveConsistent;
  }

  
  uint256 public override minDebtSize;
  
  uint256 public interestRate;
  
  uint256 public override getReservePoolBps;
  
  uint256 public override getKillBps;
  
  mapping(address => WorkerConfig) public workers;
  
  address public override getWrappedNativeAddr;
  
  address public override getWNativeRelayer;
  
  address public override getFairLaunchAddr;
  
  mapping(address => bool) public override whitelistedCallers;
  
  uint256 public override getKillTreasuryBps;
  
  address public treasury;
  
  mapping(address => bool) public override approvedAddStrategies;
  
  mapping(address => bool) public override whitelistedLiquidators;

  function initialize(
    uint256 _minDebtSize,
    uint256 _interestRate,
    uint256 _reservePoolBps,
    uint256 _killBps,
    address _getWrappedNativeAddr,
    address _getWNativeRelayer,
    address _getFairLaunchAddr,
    uint256 _getKillTreasuryBps,
    address _treasury
  ) external initializer {
    OwnableUpgradeSafe.__Ownable_init();

    setParams(
      _minDebtSize,
      _interestRate,
      _reservePoolBps,
      _killBps,
      _getWrappedNativeAddr,
      _getWNativeRelayer,
      _getFairLaunchAddr,
      _getKillTreasuryBps,
      _treasury
    );
  }

  
  
  
  
  
  function setParams(
    uint256 _minDebtSize,
    uint256 _interestRate,
    uint256 _reservePoolBps,
    uint256 _killBps,
    address _getWrappedNativeAddr,
    address _getWNativeRelayer,
    address _getFairLaunchAddr,
    uint256 _getKillTreasuryBps,
    address _treasury
  ) public onlyOwner {
    minDebtSize = _minDebtSize;
    interestRate = _interestRate;
    getReservePoolBps = _reservePoolBps;
    getKillBps = _killBps;
    getWrappedNativeAddr = _getWrappedNativeAddr;
    getWNativeRelayer = _getWNativeRelayer;
    getFairLaunchAddr = _getFairLaunchAddr;
    getKillTreasuryBps = _getKillTreasuryBps;
    treasury = _treasury;
  }

  
  
  
  
  
  
  
  function setWorker(
    address worker,
    bool _isWorker,
    bool _acceptDebt,
    uint256 _workFactor,
    uint256 _killFactor,
    bool _isStable,
    bool _isReserveConsistent
  ) public onlyOwner {
    workers[worker] = WorkerConfig({
      isWorker: _isWorker,
      acceptDebt: _acceptDebt,
      workFactor: _workFactor,
      killFactor: _killFactor,
      isStable: _isStable,
      isReserveConsistent: _isReserveConsistent
    });
  }

  
  function setWhitelistedCallers(address[] calldata callers, bool ok) external onlyOwner {
    for (uint256 idx = 0; idx < callers.length; idx++) {
      whitelistedCallers[callers[idx]] = ok;
    }
  }

  
  function setWhitelistedLiquidators(address[] calldata callers, bool ok) external onlyOwner {
    for (uint256 idx = 0; idx < callers.length; idx++) {
      whitelistedLiquidators[callers[idx]] = ok;
    }
  }

  
  function setApprovedAddStrategy(address[] calldata addStrats, bool ok) external onlyOwner {
    for (uint256 idx = 0; idx < addStrats.length; idx++) {
      approvedAddStrategies[addStrats[idx]] = ok;
    }
  }

  
  function getInterestRate(
    uint256, 
    uint256 
  ) external view override returns (uint256) {
    return interestRate;
  }

  
  function isWorker(address worker) external view override returns (bool) {
    return workers[worker].isWorker;
  }

  
  function acceptDebt(address worker) external view override returns (bool) {
    require(workers[worker].isWorker, "SimpleVaultConfig::acceptDebt:: !worker");
    return workers[worker].acceptDebt;
  }

  
  function workFactor(
    address worker,
    uint256 
  ) external view override returns (uint256) {
    require(workers[worker].isWorker, "SimpleVaultConfig::workFactor:: !worker");
    return workers[worker].workFactor;
  }

  
  function killFactor(
    address worker,
    uint256 
  ) external view override returns (uint256) {
    require(workers[worker].isWorker, "SimpleVaultConfig::killFactor:: !worker");
    return workers[worker].killFactor;
  }

  
  function rawKillFactor(
    address worker,
    uint256 
  ) external view override returns (uint256) {
    require(workers[worker].isWorker, "SimpleVaultConfig::killFactor:: !worker");
    return workers[worker].killFactor;
  }

  
  function isWorkerStable(address worker) external view override returns (bool) {
    require(workers[worker].isWorker, "SimpleVaultConfig::isWorkerStable:: !worker");
    return workers[worker].isStable;
  }

  
  function isWorkerReserveConsistent(address worker) external view override returns (bool) {
    return workers[worker].isReserveConsistent;
  }

  
  function getTreasuryAddr() external view override returns (address) {
    return treasury == address(0) ? 0xC44f82b07Ab3E691F826951a6E335E1bC1bB0B51 : treasury;
  }
}