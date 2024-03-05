



pragma solidity ^0.6.0;










interface IERC165 {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}





pragma solidity ^0.6.0;







contract ERC165 is IERC165 {
    


    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    


    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        
        
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    




    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    










    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}