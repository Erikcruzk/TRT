// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/interfaces/IV1.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IV1 {
    function mint(address to, uint256 tokenId_) external;
    function burn(uint256 tokenId_) external;
    function burnFromVault(uint vaultId_) external;
    function exists(uint256 tokenId_) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_stnd_v1.7_signed/standard-evm-d7c016ca098a4e5a554583c499fc0cead4db7088/contracts/vaults/meter/libraries/NFTHelper.sol

// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.6.0;

/*
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library NFTHelper {
    /// @notice Checks owner of the NFT
    /// @dev Calls owner on NFT contract, errors with NO if address is not owner
    /// @param token The contract address of the token which will be transferred
    /// @param to The recipient of the transfer
    /// @param value The value of the transfer
    function ownerOf(
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSelector(IV1.ownerOf.selector, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TF');
    }
}
*/
