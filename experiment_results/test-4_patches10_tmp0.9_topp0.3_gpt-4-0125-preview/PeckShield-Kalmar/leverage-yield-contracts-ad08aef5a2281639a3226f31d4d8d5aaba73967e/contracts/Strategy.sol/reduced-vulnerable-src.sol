

pragma solidity 0.5.16;

interface Strategy {
    
    
    
    
    function execute(address user, uint256 debt, bytes calldata data) external payable;
}