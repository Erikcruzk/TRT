


pragma solidity 0.8.7;






interface IAaveIncentivesController {
  




  event RewardsAccrued(address indexed user, uint256 amount);

  event RewardsClaimed(address indexed user, address indexed to, uint256 amount);

  






  event RewardsClaimed(
    address indexed user,
    address indexed to,
    address indexed claimer,
    uint256 amount
  );

  




  event ClaimerSet(address indexed user, address indexed claimer);

  






  function getAssetData(address asset)
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    );

  




  function setClaimer(address user, address claimer) external;

  




  function getClaimer(address user) external view returns (address);

  




  function configureAssets(address[] calldata assets, uint256[] calldata emissionsPerSecond)
    external;

  





  function handleAction(
    address asset,
    uint256 userBalance,
    uint256 totalSupply
  ) external;

  





  function getRewardsBalance(address[] calldata assets, address user)
    external
    view
    returns (uint256);

  






  function claimRewards(
    address[] calldata assets,
    uint256 amount,
    address to
  ) external returns (uint256);

  








  function claimRewardsOnBehalf(
    address[] calldata assets,
    uint256 amount,
    address user,
    address to
  ) external returns (uint256);

  




  function getUserUnclaimedRewards(address user) external view returns (uint256);

  





  function getUserAssetData(address user, address asset) external view returns (uint256);

  



  function REWARD_TOKEN() external view returns (address);

  



  function PRECISION() external view returns (uint8);
}




pragma solidity 0.8.7;

contract MockIncentivesController is IAaveIncentivesController {
  function getAssetData(address)
    external
    pure
    override
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    return (0, 0, 0);
  }

  function setClaimer(address, address) external override {}

  function getClaimer(address) external pure override returns (address) {
    return address(1);
  }

  function configureAssets(address[] calldata, uint256[] calldata) external override {}

  function handleAction(
    address,
    uint256,
    uint256
  ) external override {}

  function getRewardsBalance(address[] calldata, address) external pure override returns (uint256) {
    return 0;
  }

  function claimRewards(
    address[] calldata,
    uint256,
    address
  ) external pure override returns (uint256) {
    return 0;
  }

  function claimRewardsOnBehalf(
    address[] calldata,
    uint256,
    address,
    address
  ) external pure override returns (uint256) {
    return 0;
  }

  function getUserUnclaimedRewards(address) external pure override returns (uint256) {
    return 0;
  }

  function getUserAssetData(address, address) external pure override returns (uint256) {
    return 0;
  }

  function REWARD_TOKEN() external pure override returns (address) {
    return address(0);
  }

  function PRECISION() external pure override returns (uint8) {
    return 0;
  }
}