

pragma solidity >=0.4.24;


interface IDepot {
    
    function fundsWallet() external view returns (address payable);

    function maxEthPurchase() external view returns (uint);

    function minimumDepositAmount() external view returns (uint);

    function synthsReceivedForEther(uint amount) external view returns (uint);

    function totalSellableDeposits() external view returns (uint);

    
    function depositSynths(uint amount) external;

    function exchangeEtherForSynths() external payable returns (uint);

    function exchangeEtherForSynthsAtRate(uint guaranteedRate) external payable returns (uint);

    function withdrawMyDepositedSynths() external;

    
    function exchangeEtherForSNX() external payable returns (uint);

    function exchangeEtherForSNXAtRate(uint guaranteedRate, uint guaranteedSynthetixRate) external payable returns (uint);

    function exchangeSynthsForSNX(uint synthAmount) external returns (uint);

    function synthetixReceivedForEther(uint amount) external view returns (uint);

    function synthetixReceivedForSynths(uint amount) external view returns (uint);

    function withdrawSynthetix(uint amount) external;
}