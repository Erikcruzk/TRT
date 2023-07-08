// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Aloith Release Smart Contract Audit/synthetix-ac7dafbf461695ad10f41cdb2bcc32d3b9fc9caf/contracts/interfaces/IRewardsDistribution.sol

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
