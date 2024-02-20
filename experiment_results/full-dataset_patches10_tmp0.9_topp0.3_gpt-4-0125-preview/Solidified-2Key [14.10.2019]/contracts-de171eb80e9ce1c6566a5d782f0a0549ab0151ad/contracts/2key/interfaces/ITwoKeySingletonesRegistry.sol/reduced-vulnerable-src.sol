

pragma solidity ^0.4.24;





interface ITwoKeySingletonesRegistry {

    



    event ProxyCreated(address proxy);


    




    event VersionAdded(string version, address implementation);

    




    function addVersion(string _contractName, string version, address implementation) public;

    





    function getVersion(string _contractName, string version) public view returns (address);
}