



pragma solidity >=0.6.0 <0.8.0;










interface IERC165 {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}





pragma solidity >=0.6.2 <0.8.0;




interface IERC721 is IERC165 {
    


    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    


    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    


    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    


    function balanceOf(address owner) external view returns (uint256 balance);

    






    function ownerOf(uint256 tokenId) external view returns (address owner);

    













    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    













    function transferFrom(address from, address to, uint256 tokenId) external;

    












    function approve(address to, uint256 tokenId) external;

    






    function getApproved(uint256 tokenId) external view returns (address operator);

    









    function setApprovalForAll(address operator, bool _approved) external;

    




    function isApprovedForAll(address owner, address operator) external view returns (bool);

    












    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}





pragma solidity >=0.6.2 <0.8.0;





interface IERC721Metadata is IERC721 {

    


    function name() external view returns (string memory);

    


    function symbol() external view returns (string memory);

    


    function tokenURI(uint256 tokenId) external view returns (string memory);
}