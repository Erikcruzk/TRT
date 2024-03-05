



pragma solidity >=0.6.2 <0.8.0;








library ERC165Checker {
    
    bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;

    


    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    


    function supportsERC165(address account) internal view returns (bool) {
        
        
        return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
            !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
    }

    





    function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
        
        return supportsERC165(account) &&
            _supportsERC165Interface(account, interfaceId);
    }

    








    function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
        
        if (!supportsERC165(account)) {
            return false;
        }

        
        for (uint256 i = 0; i < interfaceIds.length; i++) {
            if (!_supportsERC165Interface(account, interfaceIds[i])) {
                return false;
            }
        }

        
        return true;
    }

    










    function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
        
        
        (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);

        return (success && result);
    }

    







    function _callERC165SupportsInterface(address account, bytes4 interfaceId)
        private
        view
        returns (bool, bool)
    {
        bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
        (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
        if (result.length < 32) return (false, false);
        return (success, abi.decode(result, (bool)));
    }
}





pragma solidity >=0.6.0 <0.8.0;

contract ERC165CheckerMock {
    using ERC165Checker for address;

    function supportsERC165(address account) public view returns (bool) {
        return account.supportsERC165();
    }

    function supportsInterface(address account, bytes4 interfaceId) public view returns (bool) {
        return account.supportsInterface(interfaceId);
    }

    function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) public view returns (bool) {
        return account.supportsAllInterfaces(interfaceIds);
    }
}