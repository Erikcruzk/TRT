

pragma solidity ^0.6.0;




interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}
















pragma solidity 0.6.6;

abstract contract IWexMaster {
  
  struct UserInfo {
    uint256 amount; 
    uint256 rewardDebt; 
    uint256 pendingRewards;
  }

  
  struct PoolInfo {
    IERC20 lpToken; 
    uint256 allocPoint; 
    uint256 lastRewardBlock; 
    uint256 accWexPerShare; 
  }

  
  address public wex;

  
  mapping(uint256 => PoolInfo) public poolInfo;
  mapping(uint256 => mapping(address => UserInfo)) public userInfo;

  
  function deposit(
    uint256 _pid,
    uint256 _amount,
    bool _withdrawRewards
  ) external virtual;

  
  function withdraw(
    uint256 _pid,
    uint256 _amount,
    bool _withdrawRewards
  ) external virtual;

  
  function pendingWex(uint256 _pid, address _user) external virtual returns (uint256);
}