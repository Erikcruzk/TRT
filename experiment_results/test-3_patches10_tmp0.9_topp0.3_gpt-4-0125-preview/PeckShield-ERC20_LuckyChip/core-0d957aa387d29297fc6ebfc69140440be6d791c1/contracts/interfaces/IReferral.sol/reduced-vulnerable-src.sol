



pragma solidity 0.6.12;

interface IReferral {
    


    function recordReferrer(address user, address referrer) external;

    


    function recordLpCommission(address referrer, uint256 commission) external;

    


    function recordBetCommission(address referrer, uint256 commission) external;

    


    function recordRankCommission(address referrer, uint256 commission) external;

    


    function getReferrer(address user) external view returns (address);

    


    function getReferralCommission(address user) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);

    


    function getLuckyPower(address user) external view returns (uint256);

    


    function claimLpCommission() external;

    


    function claimBetCommission() external;

    


    function claimRankCommission() external;

}