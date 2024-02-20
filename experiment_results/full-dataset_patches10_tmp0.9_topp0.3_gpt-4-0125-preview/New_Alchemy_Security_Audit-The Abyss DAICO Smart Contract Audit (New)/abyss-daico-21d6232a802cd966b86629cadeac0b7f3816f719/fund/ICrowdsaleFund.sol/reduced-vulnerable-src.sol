

pragma solidity ^0.4.21;





interface ICrowdsaleFund {
    



    function processContribution(address contributor) external payable;
    


    function onCrowdsaleEnd() external;
    


    function enableCrowdsaleRefund() external;
}