

pragma solidity 0.6.11;

interface MILendingPool {
    function deposit( address _reserve, uint256 _amount, uint16 _referralCode) external;
    
    function withdraw(address asset, uint amount, address to) external;
}