// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-b1bbcf88cc3f49e5d67954003313ede4520ba00a/contracts/interfaces/IRewardsDistribution.sol

pragma solidity >=0.4.24;


interface IRewardsDistribution {
    // Structs
    struct DistributionData {
        address destination;
        uint amount;
    }

    // Views
    function authority() external view returns (address);

    function distributions(uint index) external view returns (address destination, uint amount); // DistributionData

    function distributionsLength() external view returns (uint);

    // Mutative Functions
    function distributeRewards(uint amount) external returns (bool);
}
