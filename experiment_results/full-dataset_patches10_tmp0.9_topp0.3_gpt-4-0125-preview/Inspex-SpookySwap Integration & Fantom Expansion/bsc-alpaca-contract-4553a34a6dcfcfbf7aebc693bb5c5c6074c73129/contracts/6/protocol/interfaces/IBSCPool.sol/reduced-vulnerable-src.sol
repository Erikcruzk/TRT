




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



pragma solidity >=0.5.0 <0.7.0;

interface IMdx is IERC20 {
  function mint(address to, uint256 amount) external returns (bool);
}
















pragma solidity 0.6.6;



contract IBSCPool {
  
  struct UserInfo {
    uint256 amount; 
    uint256 rewardDebt; 
    uint256 multLpRewardDebt; 
  }

  
  struct PoolInfo {
    IERC20 lpToken; 
    uint256 allocPoint; 
    uint256 lastRewardBlock; 
    uint256 accMdxPerShare; 
    uint256 accMultLpPerShare; 
    uint256 totalAmount; 
  }

  IMdx public mdx;

  
  PoolInfo[] public poolInfo;
  
  mapping(uint256 => mapping(address => UserInfo)) public userInfo;

  
  function deposit(uint256 _pid, uint256 _amount) external {}

  
  function withdraw(uint256 _pid, uint256 _amount) external {}
}