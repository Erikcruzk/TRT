


pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;


interface IAaveIncentivesControllerPartial {
    




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

    


    function REWARD_TOKEN() external view returns (address);
}