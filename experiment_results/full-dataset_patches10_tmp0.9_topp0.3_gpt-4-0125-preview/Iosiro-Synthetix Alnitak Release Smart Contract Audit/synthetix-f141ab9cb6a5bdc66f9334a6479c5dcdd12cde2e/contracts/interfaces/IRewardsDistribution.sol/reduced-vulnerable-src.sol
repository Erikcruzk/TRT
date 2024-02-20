

pragma solidity >=0.4.24;


interface IRewardsDistribution {
    
    struct DistributionData {
        address destination;
        uint amount;
    }

    
    function authority() external view returns (address);

    function distributions(uint index) external view returns (address destination, uint amount); 

    function distributionsLength() external view returns (uint);

    
    function distributeRewards(uint amount) external returns (bool);
}