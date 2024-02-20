

pragma solidity ^0.5.16;


contract MinimalProxyFactory {
    function _cloneAsMinimalProxy(address _base, string memory _revertMsg) internal returns (address clone) {
        bytes memory createData = _generateMinimalProxyCreateData(_base);

        assembly {
            clone := create(
                0, 
                add(createData, 0x20), 
                55 
            )
        }

        
        require(clone != address(0), _revertMsg);
    }

    function _generateMinimalProxyCreateData(address _base) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                
                bytes10(0x3d602d80600a3d3981f3),
                
                bytes10(0x363d3d373d3d3d363d73),
                _base,
                bytes15(0x5af43d82803e903d91602b57fd5bf3)
            );
    }
}