// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/packages/oz/upgradeability/Proxy.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

/**
 * @title Proxy
 * @dev Gives the possibility to delegate any call to a foreign implementation.
 */
abstract contract Proxy {
    /**
     * @dev Tells the address of the implementation where every call will be delegated.
     * @return address of the implementation to which it will be delegated
     */
    function implementation() public virtual view returns (address);

    /**
     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
     * This function will return whatever the implementation call returns
     */
    fallback() external payable {
        address _impl = implementation();
        require(_impl != address(0));

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
                case 0 {
                    revert(ptr, size)
                }
                default {
                    return(ptr, size)
                }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/packages/oz/upgradeability/UpgradeabilityProxy.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.10;

/**
 * @title UpgradeabilityProxy
 * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
 */
contract UpgradeabilityProxy is Proxy {
    /**
     * @dev This event will be emitted every time the implementation gets upgraded
     * @param implementation representing the address of the upgraded implementation
     */
    event Upgraded(address indexed implementation);

    /// @dev Storage position of the address of the current implementation
    bytes32 private constant implementationPosition = keccak256("org.zeppelinos.proxy.implementation");

    /**
     * @dev Tells the address of the current implementation
     * @return impl address of the current implementation
     */
    function implementation() public override view returns (address impl) {
        bytes32 position = implementationPosition;
        assembly {
            impl := sload(position)
        }
    }

    /**
     * @dev Sets the address of the current implementation
     * @param _newImplementation address representing the new implementation to be set
     */
    function setImplementation(address _newImplementation) internal {
        bytes32 position = implementationPosition;
        assembly {
            sstore(position, _newImplementation)
        }
    }

    /**
     * @dev Upgrades the implementation address
     * @param _newImplementation representing the address of the new implementation to be set
     */
    function _upgradeTo(address _newImplementation) internal {
        address currentImplementation = implementation();
        require(currentImplementation != _newImplementation);
        setImplementation(_newImplementation);
        emit Upgraded(_newImplementation);
    }
}
