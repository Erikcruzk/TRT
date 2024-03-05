

pragma solidity ^0.4.21;





interface ICrowdsaleReservationFund {
    


    function canCompleteContribution(address contributor) external returns(bool);
    



    function completeContribution(address contributor) external;
    





    function processContribution(address contributor, uint256 _tokensToIssue, uint256 _bonusTokensToIssue) external payable;

    


    function contributionsOf(address contributor) external returns(uint256);

    


    function onCrowdsaleEnd() external;
}