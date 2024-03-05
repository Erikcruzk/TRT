


pragma solidity 0.8.3;








interface ILendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
}