

pragma solidity 0.5.16;

interface BankConfig {
    
    function minDebtSize() external view returns (uint256);

    
    function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);

    
    function getReservePoolBps() external view returns (uint256);

    
    function getKillBps() external view returns (uint256);

    
    function isGoblin(address goblin) external view returns (bool);

    
    function acceptDebt(address goblin) external view returns (bool);

    
    function workFactor(address goblin, uint256 debt) external view returns (uint256);

    
    function killFactor(address goblin, uint256 debt) external view returns (uint256);
}