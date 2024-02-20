



pragma solidity ^0.6.0;






interface IERC721Receiver {
    








    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
    external returns (bytes4);
}





pragma solidity ^0.6.0;

  





contract ERC721Holder is IERC721Receiver {

    




    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}