

pragma solidity 0.5.16;

interface Goblin {
    
    function work(uint256 id, address user, uint256 debt, bytes calldata data) external payable;

    
    function reinvest() external;

    
    function health(uint256 id) external view returns (uint256);

    
    function liquidate(uint256 id) external;
}