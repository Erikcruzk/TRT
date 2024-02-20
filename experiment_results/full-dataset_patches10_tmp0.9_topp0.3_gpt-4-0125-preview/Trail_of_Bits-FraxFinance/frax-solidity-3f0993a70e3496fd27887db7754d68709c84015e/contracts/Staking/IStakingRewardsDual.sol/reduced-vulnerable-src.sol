


pragma solidity 0.6.11;


interface IStakingRewardsDual {
    
    function lastTimeRewardApplicable() external view returns (uint256);

    function rewardPerToken() external view returns (uint256, uint256);

    function earned(address account) external view returns (uint256, uint256);

    function getRewardForDuration() external view returns (uint256, uint256);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    

    function stake(uint256 amount) external;

    function withdraw(uint256 amount) external;

    function getReward() external;

    
}