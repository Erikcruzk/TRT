


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