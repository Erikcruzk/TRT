

pragma solidity 0.5.16;

interface PriceOracle {
    
    
    function getPrice(address token0, address token1)
        external view
        returns (uint256 price, uint256 lastUpdate);
}