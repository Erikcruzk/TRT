




pragma solidity ^0.8.0;




interface IERC20 {
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);

    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address to, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}





pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

interface ILiquidityMiningMaster {
  
  struct UserInfo {
    uint256 amount; 
    uint256 rewardDebt; 
    
    
    
    
    
    
    
    
    
    
    
  }

  
  struct PoolInfo {
    IERC20 lpToken; 
    uint256 allocPoint; 
    uint256 lastRewardBlock; 
    uint256 accXMSPerShare; 
  }

  

  event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
  event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
  event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
  event UpdateEmissionRate(address indexed user, uint256 xmsPerBlock);
  event UpdateEndBlock(address indexed user, uint256 endBlock);
  event UpdateVestingMaster(address indexed user, address vestingMaster);

  

  function massUpdatePools() external;

  function updatePool(uint256 pid) external;

  function deposit(uint256 pid, uint256 amount) external;

  function withdraw(uint256 pid, uint256 amount) external;

  function emergencyWithdraw(uint256 pid) external;

  

  function addPool(
    uint256 allocPoint,
    IERC20 lpToken,
    bool withUpdate
  ) external;

  function setPool(
    uint256 pid,
    uint256 allocPoint,
    bool withUpdate
  ) external;

  function updateXmsPerBlock(uint256 _xmsPerBlock) external;

  function updateEndBlock(uint256 _endBlock) external;

  function updateVestingMaster(address _vestingMaster) external;

  

  function pair2Pid(address pair) external view returns (uint256);

  function pendingXMS(uint256 pid, address user) external view returns (uint256);

  function poolInfo(uint256 pid)
    external
    view
    returns (
      IERC20 lpToken,
      uint256 allocPoint,
      uint256 lastRewardBlock,
      uint256 accXMSPerShare
    );

  function userInfo(uint256 pid, address user) external view returns (uint256 amount, uint256 rewardDebt);

  function poolExistence(IERC20 lp) external view returns (bool);

  function xmsPerBlock() external view returns (uint256);

  function BONUS_MULTIPLIER() external view returns (uint256);

  function totalAllocPoint() external view returns (uint256);

  function startBlock() external view returns (uint256);

  function endBlock() external view returns (uint256);

  function poolLength() external view returns (uint256);

  function getMultiplier(uint256 from, uint256 to) external pure returns (uint256);
}