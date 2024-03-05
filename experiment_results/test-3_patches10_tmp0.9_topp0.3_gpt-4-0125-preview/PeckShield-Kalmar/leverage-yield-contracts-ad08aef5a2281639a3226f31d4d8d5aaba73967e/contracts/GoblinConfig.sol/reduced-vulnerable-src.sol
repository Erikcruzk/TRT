

pragma solidity 0.5.16;

interface GoblinConfig {
    
    function acceptDebt(address goblin) external view returns (bool);
    
    function workFactor(address goblin, uint256 debt) external view returns (uint256);
    
    function killFactor(address goblin, uint256 debt) external view returns (uint256);
}