// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-09a0e0122c4e4439d96a1e761c6e2c0c4c81233b/contracts/interfaces/IDepot.sol

pragma solidity >=0.4.24;


interface IDepot {
    // Views
    function fundsWallet() external view returns (address payable);

    function maxEthPurchase() external view returns (uint);

    function minimumDepositAmount() external view returns (uint);

    function synthsReceivedForEther(uint amount) external view returns (uint);

    function totalSellableDeposits() external view returns (uint);

    // Mutative functions
    function depositSynths(uint amount) external;

    function exchangeEtherForSynths() external payable returns (uint);

    function exchangeEtherForSynthsAtRate(uint guaranteedRate) external payable returns (uint);

    function withdrawMyDepositedSynths() external;

    // Note: On mainnet no SNX has been deposited. The following functions are kept alive for testnet SNX faucets.
    function exchangeEtherForSNX() external payable returns (uint);

    function exchangeEtherForSNXAtRate(uint guaranteedRate, uint guaranteedSynthetixRate) external payable returns (uint);

    function exchangeSynthsForSNX(uint synthAmount) external returns (uint);

    function synthetixReceivedForEther(uint amount) external view returns (uint);

    function synthetixReceivedForSynths(uint amount) external view returns (uint);

    function withdrawSynthetix(uint amount) external;
}