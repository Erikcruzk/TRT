


pragma solidity 0.8.9;

interface IRoleManager {
    
    
    function isAdmin(address potentialAddress) external view returns (bool);

    
    
    function isAddressManagerAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isParameterManagerAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isReactionNftAdmin(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isCuratorVaultPurchaser(address potentialAddress)
        external
        view
        returns (bool);

    
    
    function isCuratorTokenAdmin(address potentialAddress)
        external
        view
        returns (bool);
}