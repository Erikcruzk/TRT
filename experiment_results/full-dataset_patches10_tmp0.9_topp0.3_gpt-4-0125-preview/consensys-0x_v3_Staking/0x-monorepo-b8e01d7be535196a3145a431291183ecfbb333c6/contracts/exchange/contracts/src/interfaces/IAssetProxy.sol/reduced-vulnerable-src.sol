



















pragma solidity ^0.5.9;


contract IAssetProxy {

    
    
    
    
    
    function transferFrom(
        bytes calldata assetData,
        address from,
        address to,
        uint256 amount
    )
        external;

    
    
    function getProxyId()
        external
        pure
        returns (bytes4);
}