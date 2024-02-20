


pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;




interface IHARVESTDepositHelper_Partial {
    function depositAll(uint256[] memory amounts, address[] memory vaultAddresses) external;
}