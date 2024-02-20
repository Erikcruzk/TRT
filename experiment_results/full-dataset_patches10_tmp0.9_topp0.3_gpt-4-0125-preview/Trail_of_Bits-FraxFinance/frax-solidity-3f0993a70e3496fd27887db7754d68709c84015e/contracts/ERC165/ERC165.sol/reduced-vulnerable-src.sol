



pragma solidity ^0.8.0;










interface IERC165 {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}





pragma solidity ^0.8.0;







abstract contract ERC165 is IERC165 {
    


    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () {
        
        
        _registerInterface(type(IERC165).interfaceId);
    }

    




    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    










    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}