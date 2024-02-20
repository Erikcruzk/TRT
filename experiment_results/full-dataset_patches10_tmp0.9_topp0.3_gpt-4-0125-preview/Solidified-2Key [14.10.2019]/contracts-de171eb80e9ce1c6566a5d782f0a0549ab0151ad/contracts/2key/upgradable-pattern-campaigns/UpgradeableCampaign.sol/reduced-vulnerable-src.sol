

pragma solidity ^0.4.24;





interface ITwoKeySingletonesRegistry {

    



    event ProxyCreated(address proxy);


    




    event VersionAdded(string version, address implementation);

    




    function addVersion(string _contractName, string version, address implementation) public;

    





    function getVersion(string _contractName, string version) public view returns (address);
}



pragma solidity ^0.4.24;





contract UpgradeabilityCampaignStorage {
    
    ITwoKeySingletonesRegistry internal registry;

    address internal twoKeyFactory;

    
    address internal _implementation;

    



    function implementation() public view returns (address) {
        return _implementation;
    }
}



pragma solidity ^0.4.24;

contract UpgradeableCampaign is UpgradeabilityCampaignStorage {






}