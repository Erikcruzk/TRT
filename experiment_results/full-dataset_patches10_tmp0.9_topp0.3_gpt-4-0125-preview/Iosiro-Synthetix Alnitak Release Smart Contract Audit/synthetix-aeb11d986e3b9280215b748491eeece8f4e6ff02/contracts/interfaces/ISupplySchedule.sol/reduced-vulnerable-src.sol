

pragma solidity >=0.4.24;


interface ISupplySchedule {
    
    function mintableSupply() external view returns (uint);

    function isMintable() external view returns (bool);

    function minterReward() external view returns (uint);

    
    function recordMintEvent(uint supplyMinted) external returns (bool);
}