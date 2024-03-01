




pragma solidity ^0.8.0;










interface IERC165 {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}






pragma solidity ^0.8.0;




interface IERC721 is IERC165 {
    


    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    


    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    


    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    


    function balanceOf(address owner) external view returns (uint256 balance);

    






    function ownerOf(uint256 tokenId) external view returns (address owner);

    












    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    













    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    















    function transferFrom(address from, address to, uint256 tokenId) external;

    












    function approve(address to, uint256 tokenId) external;

    









    function setApprovalForAll(address operator, bool approved) external;

    






    function getApproved(uint256 tokenId) external view returns (address operator);

    




    function isApprovedForAll(address owner, address operator) external view returns (bool);
}



pragma solidity 0.8.6;

























interface IOptionsManager is IERC721 {
    


    function createOptionFor(address holder) external returns (uint256);

    


    function tokenPool(uint256 tokenId) external returns (address pool);

    




    function isApprovedOrOwner(address spender, uint256 tokenId)
        external
        view
        returns (bool);
}