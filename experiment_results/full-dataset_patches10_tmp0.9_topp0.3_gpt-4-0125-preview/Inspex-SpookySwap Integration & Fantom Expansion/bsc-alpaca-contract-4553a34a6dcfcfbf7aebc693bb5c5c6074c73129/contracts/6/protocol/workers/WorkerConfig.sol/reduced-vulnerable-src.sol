

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



pragma solidity >=0.5.0;

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}
















pragma solidity 0.6.6;

interface IWorker {
  
  function work(
    uint256 id,
    address user,
    uint256 debt,
    bytes calldata data
  ) external;

  
  function reinvest() external;

  
  function health(uint256 id) external view returns (uint256);

  
  function liquidate(uint256 id) external;

  
  function setStrategyOk(address[] calldata strats, bool isOk) external;

  
  function setReinvestorOk(address[] calldata reinvestor, bool isOk) external;

  
  function lpToken() external view returns (IPancakePair);

  
  function baseToken() external view returns (address);

  
  function farmingToken() external view returns (address);
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

interface PriceOracle {
  
  
  function getPrice(address token0, address token1) external view returns (uint256 price, uint256 lastUpdate);
}
















pragma solidity 0.6.6;

interface ERC20Interface {
  function balanceOf(address user) external view returns (uint256);
}

library SafeToken {
  function myBalance(address token) internal view returns (uint256) {
    return ERC20Interface(token).balanceOf(address(this));
  }

  function balanceOf(address token, address user) internal view returns (uint256) {
    return ERC20Interface(token).balanceOf(user);
  }

  function safeApprove(address token, address to, uint256 value) internal {
    
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
  }

  function safeTransfer(address token, address to, uint256 value) internal {
    
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
  }

  function safeTransferFrom(address token, address from, address to, uint256 value) internal {
    
    (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
    require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
  }

  function safeTransferETH(address to, uint256 value) internal {
    
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, "!safeTransferETH");
  }
}
















pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;






contract WorkerConfig is OwnableUpgradeSafe, IWorkerConfig {
  
  using SafeToken for address;
  using SafeMath for uint256;

  
  event SetOracle(address indexed caller, address oracle);
  event SetConfig(
    address indexed caller,
    address indexed worker,
    bool acceptDebt,
    uint64 workFactor,
    uint64 killFactor,
    uint64 maxPriceDiff
  );
  event SetGovernor(address indexed caller, address indexed governor);

  
  struct Config {
    bool acceptDebt;
    uint64 workFactor;
    uint64 killFactor;
    uint64 maxPriceDiff;
  }

  PriceOracle public oracle;
  mapping(address => Config) public workers;
  address public governor;

  function initialize(PriceOracle _oracle) external initializer {
    OwnableUpgradeSafe.__Ownable_init();
    oracle = _oracle;
  }

  
  modifier onlyGovernor() {
    require(_msgSender() == governor, "WorkerConfig::onlyGovernor:: msg.sender not governor");
    _;
  }

  
  function setOracle(PriceOracle _oracle) external onlyOwner {
    oracle = _oracle;
    emit SetOracle(_msgSender(), address(oracle));
  }

  
  function setConfigs(address[] calldata addrs, Config[] calldata configs) external onlyOwner {
    uint256 len = addrs.length;
    require(configs.length == len, "WorkConfig::setConfigs:: bad len");
    for (uint256 idx = 0; idx < len; idx++) {
      workers[addrs[idx]] = Config({
        acceptDebt: configs[idx].acceptDebt,
        workFactor: configs[idx].workFactor,
        killFactor: configs[idx].killFactor,
        maxPriceDiff: configs[idx].maxPriceDiff
      });
      emit SetConfig(
        _msgSender(),
        addrs[idx],
        workers[addrs[idx]].acceptDebt,
        workers[addrs[idx]].workFactor,
        workers[addrs[idx]].killFactor,
        workers[addrs[idx]].maxPriceDiff
      );
    }
  }

  function isReserveConsistent(address worker) public view override returns (bool) {
    IPancakePair lp = IWorker(worker).lpToken();
    address token0 = lp.token0();
    address token1 = lp.token1();
    (uint256 r0, uint256 r1, ) = lp.getReserves();
    uint256 t0bal = token0.balanceOf(address(lp));
    uint256 t1bal = token1.balanceOf(address(lp));
    _isReserveConsistent(r0, r1, t0bal, t1bal);
    return true;
  }

  function _isReserveConsistent(
    uint256 r0,
    uint256 r1,
    uint256 t0bal,
    uint256 t1bal
  ) internal pure {
    require(t0bal.mul(100) <= r0.mul(101), "WorkerConfig::isReserveConsistent:: bad t0 balance");
    require(t1bal.mul(100) <= r1.mul(101), "WorkerConfig::isReserveConsistent:: bad t1 balance");
  }

  
  function isStable(address worker) public view override returns (bool) {
    IPancakePair lp = IWorker(worker).lpToken();
    address token0 = lp.token0();
    address token1 = lp.token1();
    
    (uint256 r0, uint256 r1, ) = lp.getReserves();
    uint256 t0bal = token0.balanceOf(address(lp));
    uint256 t1bal = token1.balanceOf(address(lp));
    _isReserveConsistent(r0, r1, t0bal, t1bal);
    
    (uint256 price, uint256 lastUpdate) = oracle.getPrice(token0, token1);
    require(lastUpdate >= now - 1 days, "WorkerConfig::isStable:: price too stale");
    uint256 lpPrice = r1.mul(1e18).div(r0);
    uint256 maxPriceDiff = workers[worker].maxPriceDiff;
    require(lpPrice.mul(10000) <= price.mul(maxPriceDiff), "WorkerConfig::isStable:: price too high");
    require(lpPrice.mul(maxPriceDiff) >= price.mul(10000), "WorkerConfig::isStable:: price too low");
    
    return true;
  }

  
  function acceptDebt(address worker) external view override returns (bool) {
    require(isStable(worker), "WorkerConfig::acceptDebt:: !stable");
    return workers[worker].acceptDebt;
  }

  
  function workFactor(
    address worker,
    uint256 
  ) external view override returns (uint256) {
    require(isStable(worker), "WorkerConfig::workFactor:: !stable");
    return uint256(workers[worker].workFactor);
  }

  
  function killFactor(
    address worker,
    uint256 
  ) external view override returns (uint256) {
    require(isStable(worker), "WorkerConfig::killFactor:: !stable");
    return uint256(workers[worker].killFactor);
  }

  
  function rawKillFactor(
    address worker,
    uint256 
  ) external view override returns (uint256) {
    return uint256(workers[worker].killFactor);
  }

  
  function setGovernor(address newGovernor) external onlyOwner {
    governor = newGovernor;
    emit SetGovernor(_msgSender(), governor);
  }

  
  function emergencySetAcceptDebt(address[] calldata addrs, bool isAcceptDebt) external onlyGovernor {
    uint256 len = addrs.length;
    for (uint256 idx = 0; idx < len; idx++) {
      workers[addrs[idx]].acceptDebt = isAcceptDebt;
      emit SetConfig(
        _msgSender(),
        addrs[idx],
        workers[addrs[idx]].acceptDebt,
        workers[addrs[idx]].workFactor,
        workers[addrs[idx]].killFactor,
        workers[addrs[idx]].maxPriceDiff
      );
    }
  }
}