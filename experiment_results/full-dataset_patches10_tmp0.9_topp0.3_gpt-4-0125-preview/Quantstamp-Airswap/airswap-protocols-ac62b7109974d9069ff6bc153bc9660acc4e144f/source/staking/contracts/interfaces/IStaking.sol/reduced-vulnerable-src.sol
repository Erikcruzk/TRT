



pragma solidity ^0.8.0;

interface IStaking {
  struct Stake {
    uint256 duration;
    uint256 balance;
    uint256 timestamp;
  }

  
  event Transfer(address indexed from, address indexed to, uint256 tokens);

  
  event ScheduleDurationChange(uint256 indexed unlockTimestamp);

  
  event CancelDurationChange();

  
  event CompleteDurationChange(uint256 indexed newDuration);

  
  event ProposeDelegate(address indexed delegate, address indexed account);

  
  event SetDelegate(address indexed delegate, address indexed account);

  



  function stake(uint256 amount) external;

  



  function unstake(uint256 amount) external;

  



  function getStakes(address account)
    external
    view
    returns (Stake memory accountStake);

  


  function totalSupply() external view returns (uint256);

  


  function balanceOf(address account) external view returns (uint256);

  


  function decimals() external view returns (uint8);

  




  function stakeFor(address account, uint256 amount) external;

  



  function available(address account) external view returns (uint256);
}