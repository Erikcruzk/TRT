

pragma solidity 0.4.24;


interface IOwnedUpgradeabilityProxy {
    function proxyOwner() public view returns (address);
}



pragma solidity 0.4.24;

contract OwnedUpgradeability {

    function upgradeabilityAdmin() public view returns (address) {
        return IOwnedUpgradeabilityProxy(this).proxyOwner();
    }

    
    modifier onlyIfOwnerOfProxy() {
        require(msg.sender == upgradeabilityAdmin());
        _;
    }
}