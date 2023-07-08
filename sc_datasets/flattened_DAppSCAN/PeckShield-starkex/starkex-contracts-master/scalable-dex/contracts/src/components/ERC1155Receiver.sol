// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/tokens/ERC1155/IERC1155Receiver.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/**
  Note: The ERC-165 identifier for this interface is 0x4e2312e0.
*/
interface IERC1155Receiver {
    /**
      Handles the receipt of a single ERC1155 token type.
      @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
      This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
      This function MUST revert if it rejects the transfer.
      Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
      @param operator  The address which initiated the transfer (i.e. msg.sender)
      @param from      The address which previously owned the token
      @param id        The ID of the token being transferred
      @param value     The amount of tokens being transferred
      @param data      Additional data with no specified format
      @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` .
    */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
      Handles the receipt of multiple ERC1155 token types.
      @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
      This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
      This function MUST revert if it rejects the transfer(s).
      Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
      @param operator  The address which initiated the batch transfer (i.e. msg.sender)
      @param from      The address which previously owned the token
      @param ids       An array containing ids of each token being transferred (order and length must match values array)
      @param values    An array containing amounts of each token being transferred (order and length must match ids array)
      @param data      Additional data with no specified format
      @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` .
    */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/ERC1155Receiver.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  ERC1155 token receiver interface.
  EIP-1155 requires any contract receiving ERC1155 tokens to implement IERC1155Receiver interface.
  By EIP:
  1. safeTransferFrom API of ERC1155 shall call onERC1155Received on the receiving contract.
  2. safeBatchTransferFrom API of ERC1155 to call onERC1155BatchReceived on the receiving contract.

  Have the receiving contract failed to respond as expected, the safe transfer functions shall be reverted.
*/
contract ERC1155Receiver is IERC1155Receiver {
    /**
      Handles the receipt of a single ERC1155 token type.
      @param `operator` The address which called `safeTransferFrom` function
      @param `from` The address which previously owned the token
      @param `id` The identifier of the token which is being transferred
      @param `value` the amount of token units being transferred
      @param `data` Additional data with no specified format
      Returns:
      When invoked by the receiving contract, satisfying the deposit pattern (i.e. operator == this)
      `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` is returned.
      In all other cases returns `bytes4(0)`, which should invoke an error of the form
      `ERC1155: ERC1155Receiver rejected tokens`.
    */
    function onERC1155Received(
        address operator,
        address, // from
        uint256, // id
        uint256, // value
        bytes calldata // data
    ) external override returns (bytes4) {
        return (operator == address(this) ? this.onERC1155Received.selector : bytes4(0));
    }

    /**
      Handles the receipt of multiple ERC1155 token types.
      @param `operator` The address which called `safeBatchTransferFrom` function
      @param `from` The address which previously owned the token
      @param `ids` The identifier of the token which is being transferred
      @param `values` the amount of token units being transferred
      @param `data` Additional data with no specified format
      Returns:
      When invoked by the receiving contract, satisfying the deposit pattern (i.e. operator == this)
      `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256,uint256,bytes)"))` is returned.
      In all other cases returns `bytes4(0)`, which should invoke an error of the form
      `ERC1155: ERC1155Receiver rejected tokens`.

      Note: a rejection value `bytes4(0)` is to be expected. Batch deposits are unsupported by StarkEx.
    */
    function onERC1155BatchReceived(
        address operator,
        address, // from
        uint256[] calldata, // ids
        uint256[] calldata, // values
        bytes calldata // data
    ) external override returns (bytes4) {
        return (operator == address(this) ? this.onERC1155BatchReceived.selector : bytes4(0));
    }
}
