// File: ../sc_datasets/DAppSCAN/Coinfabrik-RCN Network Smart Contract Audit/rcn-network-master/rcn-network-master/contracts/test_utils/IERC721Receiver.sol

/* solium-disable */
pragma solidity ^0.5.11;


interface IERC721Receiver {
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _userData
    )
        external returns (bytes4);
}