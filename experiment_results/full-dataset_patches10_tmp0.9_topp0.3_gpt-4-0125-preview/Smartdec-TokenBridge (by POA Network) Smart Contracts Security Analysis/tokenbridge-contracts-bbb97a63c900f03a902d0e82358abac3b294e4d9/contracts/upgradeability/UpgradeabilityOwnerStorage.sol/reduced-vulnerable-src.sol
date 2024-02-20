

pragma solidity 0.4.24;






contract UpgradeabilityOwnerStorage {
    
    address private _upgradeabilityOwner;

    



    function upgradeabilityOwner() public view returns (address) {
        return _upgradeabilityOwner;
    }

    


    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
        _upgradeabilityOwner = newUpgradeabilityOwner;
    }
}