

pragma solidity 0.4.24;






contract Proxy {

  



    function implementation() public view returns (address);

  



    function () payable public {
        address _impl = implementation();
        require(_impl != address(0));
        assembly {
            





            let ptr := mload(0x40)
            









            calldatacopy(ptr, 0, calldatasize)
            
















            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
            


            









            mstore(0x40, add(ptr, returndatasize))
            





            returndatacopy(ptr, 0, returndatasize)

            




            switch result
            case 0 { revert(ptr, returndatasize) }
            default { return(ptr, returndatasize) }
        }
    }
}



pragma solidity 0.4.24;






contract UpgradeabilityStorage {
    
    uint256 internal _version;

    
    address internal _implementation;

    



    function version() public view returns (uint256) {
        return _version;
    }

    



    function implementation() public view returns (address) {
        return _implementation;
    }
}



pragma solidity 0.4.24;






contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
    




    event Upgraded(uint256 version, address indexed implementation);

    




    function _upgradeTo(uint256 version, address implementation) internal {
        require(_implementation != implementation);
        require(version > _version);
        _version = version;
        _implementation = implementation;
        emit Upgraded(version, implementation);
    }
}