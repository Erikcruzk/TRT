



pragma solidity ^0.6.0;










interface IERC165 {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}





pragma solidity ^0.6.0;











contract SupportsInterfaceWithLookupMock is IERC165 {
    


    bytes4 public constant INTERFACE_ID_ERC165 = 0x01ffc9a7;

    


    mapping(bytes4 => bool) private _supportedInterfaces;

    



    constructor () public {
        _registerInterface(INTERFACE_ID_ERC165);
    }

    


    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    


    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165InterfacesSupported: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

contract ERC165InterfacesSupported is SupportsInterfaceWithLookupMock {
    constructor (bytes4[] memory interfaceIds) public {
        for (uint256 i = 0; i < interfaceIds.length; i++) {
            _registerInterface(interfaceIds[i]);
        }
    }
}