// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-119164e1624309606db3edd806c520cdd8937743/contracts/interfaces/IRewardsDistribution.sol

pragma solidity >=0.4.24;


// https://docs.synthetix.io/contracts/source/interfaces/irewardsdistribution
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
