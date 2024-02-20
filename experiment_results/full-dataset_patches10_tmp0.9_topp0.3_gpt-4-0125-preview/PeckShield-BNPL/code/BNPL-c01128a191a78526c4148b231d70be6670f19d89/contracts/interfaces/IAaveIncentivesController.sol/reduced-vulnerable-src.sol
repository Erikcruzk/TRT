


pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

library DistributionTypes {
    struct AssetConfigInput {
        uint104 emissionPerSecond;
        uint256 totalStaked;
        address underlyingAsset;
    }

    struct UserStakeInput {
        address underlyingAsset;
        uint256 stakedByUser;
        uint256 totalStaked;
    }
}




pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

interface IAaveDistributionManager {
    event AssetConfigUpdated(address indexed asset, uint256 emission);
    event AssetIndexUpdated(address indexed asset, uint256 index);
    event UserIndexUpdated(
        address indexed user,
        address indexed asset,
        uint256 index
    );
    event DistributionEndUpdated(uint256 newDistributionEnd);

    



    function setDistributionEnd(uint256 distributionEnd) external;

    



    function getDistributionEnd() external view returns (uint256);

    



    function DISTRIBUTION_END() external view returns (uint256);

    





    function getUserAssetData(address user, address asset)
        external
        view
        returns (uint256);

    




    function getAssetData(address asset)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );
}




pragma solidity ^0.8.0;

pragma experimental ABIEncoderV2;

interface IAaveIncentivesController is IAaveDistributionManager {
    event RewardsAccrued(address indexed user, uint256 amount);

    event RewardsClaimed(
        address indexed user,
        address indexed to,
        address indexed claimer,
        uint256 amount
    );

    event ClaimerSet(address indexed user, address indexed claimer);

    




    function setClaimer(address user, address claimer) external;

    




    function getClaimer(address user) external view returns (address);

    




    function configureAssets(
        address[] calldata assets,
        uint256[] calldata emissionsPerSecond
    ) external;

    





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

    




    function claimRewardsToSelf(address[] calldata assets, uint256 amount)
        external
        returns (uint256);

    




    function getUserUnclaimedRewards(address user)
        external
        view
        returns (uint256);

    


    function REWARD_TOKEN() external view returns (address);
}