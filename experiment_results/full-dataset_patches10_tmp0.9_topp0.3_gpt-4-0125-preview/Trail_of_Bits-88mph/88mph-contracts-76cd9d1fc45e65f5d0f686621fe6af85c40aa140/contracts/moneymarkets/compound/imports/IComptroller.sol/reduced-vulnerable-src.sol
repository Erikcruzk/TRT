


pragma solidity 0.8.3;



interface IComptroller {
    function claimComp(address holder) external;

    function getCompAddress() external view returns (address);
}