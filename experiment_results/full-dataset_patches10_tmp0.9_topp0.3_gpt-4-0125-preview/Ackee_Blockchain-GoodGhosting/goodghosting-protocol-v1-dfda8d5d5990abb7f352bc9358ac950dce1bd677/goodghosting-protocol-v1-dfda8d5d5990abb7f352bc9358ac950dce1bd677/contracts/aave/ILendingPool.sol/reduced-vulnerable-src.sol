



pragma solidity 0.6.11;

interface ILendingPool {
    function deposit(address _reserve, uint256 _amount, address onBehalfOf, uint16 _referralCode) external;
    
    function withdraw(address asset, uint amount, address to) external;
}

interface AaveProtocolDataProvider {
    function getReserveTokensAddresses(address asset) external view returns(address, address, address);
}