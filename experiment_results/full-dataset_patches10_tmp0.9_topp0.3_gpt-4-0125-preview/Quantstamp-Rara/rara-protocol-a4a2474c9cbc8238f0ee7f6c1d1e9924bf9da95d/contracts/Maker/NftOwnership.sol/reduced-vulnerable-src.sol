




pragma solidity ^0.8.0;










interface IERC165Upgradeable {
    







    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}






pragma solidity ^0.8.0;







interface IERC1155Upgradeable is IERC165Upgradeable {
    


    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    



    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    



    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    






    event URI(string value, uint256 indexed id);

    






    function balanceOf(address account, uint256 id) external view returns (uint256);

    






    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    








    function setApprovalForAll(address operator, bool approved) external;

    




    function isApprovedForAll(address account, address operator) external view returns (bool);

    












    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    










    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}




pragma solidity 0.8.9;




library NftOwnership {
    
    function _verifyOwnership(
        address nftContractAddress,
        uint256 nftId,
        address potentialOwner
    ) internal view returns (bool) {
        
        (bool success, bytes memory result) = nftContractAddress.staticcall(
            abi.encodeWithSignature(
                "balanceOf(address,uint256)",
                potentialOwner,
                nftId
            )
        );

        
        if (success) {
            uint256 balance = abi.decode(result, (uint256));
            return balance > 0;
        }

        
        (success, result) = nftContractAddress.staticcall(
            abi.encodeWithSignature("ownerOf(uint256)", nftId)
        );

        
        if (success) {
            address foundOwner = abi.decode(result, (address));
            return foundOwner == potentialOwner;
        }

        
        (success, result) = nftContractAddress.staticcall(
            abi.encodeWithSignature("punkIndexToAddress(uint256)", nftId)
        );

        
        if (success) {
            address foundOwner = abi.decode(result, (address));
            return foundOwner == potentialOwner;
        }

        return false;
    }
}