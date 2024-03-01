



pragma solidity >=0.6.0 <0.8.0;






interface IERC721Receiver {
    








    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}





pragma solidity >=0.6.0 <0.8.0;

contract ERC721ReceiverMock is IERC721Receiver {
    bytes4 private _retval;
    bool private _reverts;

    event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas);

    constructor (bytes4 retval, bool reverts) public {
        _retval = retval;
        _reverts = reverts;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
        public override returns (bytes4)
    {
        require(!_reverts, "ERC721ReceiverMock: reverting");
        emit Received(operator, from, tokenId, data, gasleft());
        return _retval;
    }
}