// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-eb36644a2d8db32c92cc4df936069db8836d0233/contracts/interfaces/IRewardEscrow.sol

pragma solidity >=0.4.24;


// https://docs.synthetix.io/contracts/source/interfaces/irewardescrow
interface IRewardEscrow {
    // Views
    function balanceOf(address account) external view returns (uint);

    function numVestingEntries(address account) external view returns (uint);

    function totalEscrowedAccountBalance(address account) external view returns (uint);

    function totalVestedAccountBalance(address account) external view returns (uint);

    // Mutative functions
    function appendVestingEntry(address account, uint quantity) external;

    function vest() external;
}