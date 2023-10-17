// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Alnitak Release Smart Contract Audit/synthetix-500c84f2d0998b9c7fd6f0965a2fb730ef698cb2/contracts/interfaces/IEtherCollateralsUSD.sol

pragma solidity >=0.4.24;

// https://docs.synthetix.io/contracts/source/interfaces/iethercollateralsusd
interface IEtherCollateralsUSD {
    // Views
    function totalIssuedSynths() external view returns (uint256);

    function totalLoansCreated() external view returns (uint256);

    function totalOpenLoanCount() external view returns (uint256);

    // Mutative functions
    function openLoan(uint256 _loanAmount) external payable returns (uint256 loanID);

    function closeLoan(uint256 loanID) external;

    function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external;

    function depositCollateral(address account, uint256 loanID) external payable;

    function withdrawCollateral(uint256 loanID, uint256 withdrawAmount) external;

    function repayLoan(
        address _loanCreatorsAddress,
        uint256 _loanID,
        uint256 _repayAmount
    ) external;
}