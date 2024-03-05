


pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;






interface ICompComptrollerPartial {
    function claimComp(address holder) external;
    function claimComp(address holder, address[] memory cTokens) external;
}