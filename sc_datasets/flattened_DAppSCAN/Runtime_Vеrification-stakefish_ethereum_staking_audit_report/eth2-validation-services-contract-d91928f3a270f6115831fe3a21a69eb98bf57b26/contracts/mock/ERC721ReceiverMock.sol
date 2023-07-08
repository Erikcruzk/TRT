// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/interfaces/IERC165.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/interfaces/IERC721.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-stakefish_ethereum_staking_audit_report/eth2-validation-services-contract-d91928f3a270f6115831fe3a21a69eb98bf57b26/contracts/mock/ERC721ReceiverMock.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// Contract to test safe transfer behavior.
contract ERC721ReceiverMock {

  bytes4 constant internal ERC721_RECEIVED_SIG = 0x150b7a02;
  bytes4 constant internal ERC721_RECEIVED_INVALID = 0xdeadbeef;
  bytes4 constant internal IS_ERC721_RECEIVER = 0x150b7a02;

  // Keep values from last received contract.
  bool public shouldReject;

  bytes public lastData;
  address public lastOperator;
  uint256 public lastId;
  uint256 public lastValue;

  //Debug event
  event TransferReceiver(address _from, address _to, uint256 _fromBalance, uint256 _toBalance, address _tokenOwner);

  /**
   * @notice Indicates whether a contract implements the `ERC721TokenReceiver` functions and so can accept ERC721 token types.
   * @param  interfaceID The ERC-165 interface ID that is queried for support.s
   * @dev This function MUST return true if it implements the ERC721TokenReceiver interface and ERC-165 interface.
   *      This function MUST NOT consume more than 5,000 gas.
   * @return Wheter ERC-165 or ERC721TokenReceiver interfaces are supported.
   */
  function supportsInterface(bytes4 interfaceID)
      external
      pure
      returns (bool)
  {
      return  interfaceID == 0x01ffc9a7 || // ERC-165 support (i.e. `bytes4(keccak256('supportsInterface(bytes4)'))`).
          interfaceID == IS_ERC721_RECEIVER;         // ERC-721 `ERC721TokenReceiver` support
  }

  /**
   * @notice Handle the receipt of a single ERC721 token type.
   * @dev An ERC721-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
   * This function MAY throw to revert and reject the transfer.
   * Return of other than the magic value MUST result in the transaction being reverted.
   * Note: The contract address is always the message sender.
   * @param _from      The address which previously owned the token
   * @param _tokenId   The token id
   * @param _data      Additional data with no specified format
   * @return           `bytes4(keccak256("onERC721Received(address,address,uint256,uint256,bytes)"))`
   */
  function onERC721Received(
      address,
      address _from,
      uint256 _tokenId,
      bytes memory _data
  )
      public
      returns(bytes4)
  {
      // To check the following conditions;
      //   All the balances in the transfer MUST have been updated to match the senders intent before any hook is called on a recipient.
      //   All the transfer events for the transfer MUST have been emitted to reflect the balance changes before any hook is called on a recipient.
      //   If data is passed, must be specific
      uint256 fromBalance = IERC721(msg.sender).balanceOf(_from);
      uint256 toBalance = IERC721(msg.sender).balanceOf(address(this));
      address tokenOwner = IERC721(msg.sender).ownerOf(_tokenId);
      emit TransferReceiver(_from, address(this), fromBalance, toBalance, tokenOwner);

      if (_data.length != 0) {
          require(
              keccak256(_data) == keccak256(abi.encodePacked("Hello from the other side")),
              "ERC721ReceiverMock#onERC721Received: UNEXPECTED_DATA"
          );
      }

      if (shouldReject == true) {
          return ERC721_RECEIVED_INVALID; // Some random value
      } else {
          return ERC721_RECEIVED_SIG;
      }
  }

  function setShouldReject(bool _value)
      public
  {
      shouldReject = _value;
  }
}
