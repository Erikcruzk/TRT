



















pragma solidity ^0.5.9;


contract IProtocolFees {

    
    event ProtocolFeeMultiplier(uint256 oldProtocolFeeMultiplier, uint256 updatedProtocolFeeMultiplier);

    
    event ProtocolFeeCollectorAddress(address oldProtocolFeeCollector, address updatedProtocolFeeCollector);

    
    
    function setProtocolFeeMultiplier(uint256 updatedProtocolFeeMultiplier)
        external;

    
    
    function setProtocolFeeCollectorAddress(address updatedProtocolFeeCollector)
        external;

    
    function protocolFeeMultiplier()
        external
        view
        returns (uint256);

    
    function protocolFeeCollector()
        external
        view
        returns (address);
}