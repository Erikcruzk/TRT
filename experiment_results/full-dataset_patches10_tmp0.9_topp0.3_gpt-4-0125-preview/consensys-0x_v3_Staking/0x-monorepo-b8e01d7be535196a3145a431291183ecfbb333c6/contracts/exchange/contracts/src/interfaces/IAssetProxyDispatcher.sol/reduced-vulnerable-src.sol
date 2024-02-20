



















pragma solidity ^0.5.9;


contract IAssetProxyDispatcher {

    
    event AssetProxyRegistered(
        bytes4 id,              
        address assetProxy      
    );

    
    
    
    function registerAssetProxy(address assetProxy)
        external;

    
    
    
    function getAssetProxy(bytes4 assetProxyId)
        external
        view
        returns (address);
}