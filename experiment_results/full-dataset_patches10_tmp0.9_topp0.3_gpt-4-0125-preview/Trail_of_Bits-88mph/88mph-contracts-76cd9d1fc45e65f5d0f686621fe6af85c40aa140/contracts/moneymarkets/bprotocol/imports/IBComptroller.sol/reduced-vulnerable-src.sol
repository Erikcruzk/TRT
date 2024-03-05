


pragma solidity 0.8.3;


interface IRegistry {
    function comp() external returns (address);
}




pragma solidity 0.8.3;


interface IBComptroller {
    function claimComp(address holder) external;

    function registry() external returns (IRegistry);
}