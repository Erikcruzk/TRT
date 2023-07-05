// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/IFundsHandler.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface IFundsHandler {

    function init(address[] calldata _recipients, uint256[] calldata _splits) external;

    function totalRecipients() external view returns (uint256);

    function royaltyAtIndex(uint256 index) external view returns (address _recipient, uint256 _split);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/handlers/FundsSplitter.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/**
 * splits all funds as soon as the contract receives it
 */
contract FundsSplitter is IFundsHandler {

    bool private locked;

    uint256 constant SCALE = 100000;

    address[] public recipients;
    uint256[] public splits;

    /**
     * @notice Using a minimal proxy contract pattern initialises the contract and sets delegation
     * @dev initialises the FundsReceiver (see https://eips.ethereum.org/EIPS/eip-1167)
     */
    function init(address[] calldata _recipients, uint256[] calldata _splits) override external {
        require(!locked, "contract locked sorry");
        locked = true;
        recipients = _recipients;
        splits = _splits;
    }

    // TODO test GAS limit problems ... ? call vs transfer 21000 limits?

    // accept all funds
    receive() external payable {

        // accept funds
        uint256 balance = msg.value;
        uint256 singleUnitOfValue = balance / SCALE;

        // split according to total
        for (uint256 i = 0; i < recipients.length; i++) {

            // Work out split
            uint256 share = singleUnitOfValue * splits[i];

            // TODO assumed all recipients are EOA and not contracts ... ?
            // AMG: would it be a problem if a contract? Doubt it?

            // Fire split to recipient
            payable(recipients[i]).transfer(share);
        }
    }

    // Enumerable by something else

    function totalRecipients() public override view returns (uint256) {
        return recipients.length;
    }

    function royaltyAtIndex(uint256 _index) public override view returns (address recipient, uint256 split) {
        recipient = recipients[_index];
        split = splits[_index];
    }
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/IFundsDrainable.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface IFundsDrainable {

    function drain() external;
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/collaborators/handlers/FundsReceiver.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;


/**
 * Allows funds to be split using a pull pattern, holding a balance until drained
 */

// FIXME use a single contract as a registry for splits rather than one per collab split
contract FundsReceiver is IFundsHandler, IFundsDrainable {

    bool private _notEntered = true;

    /** @dev Prevents a contract from calling itself, directly or indirectly. */
    modifier nonReentrant() {
        require(_notEntered, "ReentrancyGuard: reentrant call");
        _notEntered = false;
        _;
        _notEntered = true;
    }

    bool private locked;
    address[] public recipients;
    uint256[] public splits;

    /**
     * @notice Using a minimal proxy contract pattern initialises the contract and sets delegation
     * @dev initialises the FundsReceiver (see https://eips.ethereum.org/EIPS/eip-1167)
     */
    function init(address[] calldata _recipients, uint256[] calldata _splits) override external {
        require(!locked, "contract locked sorry");
        locked = true;
        recipients = _recipients;
        splits = _splits;
    }

    // accept all funds
    receive() external payable {}

    function drain() nonReentrant public override {

        // accept funds
        uint256 balance = address(this).balance;
        uint256 singleUnitOfValue = balance / 100000;

        // split according to total
        for (uint256 i = 0; i < recipients.length; i++) {

            // Work out split
            uint256 share = singleUnitOfValue * splits[i];

            // Assumed all recipients are EOA and not contracts atm
            // Fire split to recipient

            // TODO how to handle failures ... call and validate?
            //      - if fails to accept the money, ideally we remove them from the list ...
            payable(recipients[i]).transfer(share);
        }
    }

    function totalRecipients() public override virtual view returns (uint256) {
        return recipients.length;
    }

    function royaltyAtIndex(uint256 _index) public override view returns (address recipient, uint256 split) {
        recipient = recipients[_index];
        split = splits[_index];
    }
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/IERC2981.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/// @notice This is purely an extension for the KO platform
/// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
interface IERC2981EditionExtension {

    /// @notice Does the edition have any royalties defined
    function hasRoyalties(uint256 _editionId) external view returns (bool);

    /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
    function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
}

/**
 * ERC2981 standards interface for royalties
 */
interface IERC2981 is IERC165, IERC2981EditionExtension {
    /// ERC165 bytes to add to interface array - set in parent contract
    /// implementing this standard
    ///
    /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
    /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    /// _registerInterface(_INTERFACE_ID_ERC2981);

    /// @notice Called with the sale price to determine how much royalty
    //          is owed and to whom.
    /// @param _tokenId - the NFT asset queried for royalty information
    /// @param _value - the sale price of the NFT asset specified by _tokenId
    /// @return _receiver - address of who should be sent the royalty payment
    /// @return _royaltyAmount - the royalty payment amount for _value sale price
    function royaltyInfo(
        uint256 _tokenId,
        uint256 _value
    ) external view returns (
        address _receiver,
        uint256 _royaltyAmount
    );

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/royalties/ITokenRoyaltiesRegistry.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface ITokenRoyaltiesRegistry is IERC2981 {

    // get total payable royalties recipients
    function totalPotentialRoyalties(uint256 _tokenId) external view returns (uint256);

    // get total payable royalties recipients
    function royaltyParticipantAtIndex(uint256 _tokenId, uint256 _index) external view returns (address, uint256);

    // immutable single time only call - call on token creation by default
    function defineRoyalty(uint256 _tokenId, address _recipient, uint256 _amount) external;

    // enable staged multi-sig style approved joint royalty
    function initMultiOwnerRoyalty(uint256 _tokenId, address _defaultRecipient, uint256 _defaultRoyalty, address[] calldata _recipients, uint256[] calldata _amounts) external;

    // confirm token share - approve use of joint holder
    function confirm(uint256 _tokenId, uint8[] calldata _sigV, bytes32[] calldata _sigR, bytes32[] calldata _sigS) external;

    // reject token share - removes from potential multi-sig address
    function reject(uint256 _tokenId, uint256 _quitterIndex) external;
}

// File: @openzeppelin/contracts/proxy/Clones.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (proxy/Clones.sol)

pragma solidity ^0.8.0;

/**
 * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
 * deploying minimal proxy contracts, also known as "clones".
 *
 * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
 * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
 *
 * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
 * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
 * deterministic method.
 *
 * _Available since v3.4._
 */
library Clones {
    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create opcode, which should never revert.
     */
    function clone(address implementation) internal returns (address instance) {
        /// @solidity memory-safe-assembly
        assembly {
            // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
            // of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0xe8, shl(0x60, implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
            mstore(0x20, or(shl(0x78, implementation), 0x5af43d82803e903d91602b57fd5bf3))
            instance := create(0, 0x09, 0x37)
        }
        require(instance != address(0), "ERC1167: create failed");
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple time will revert, since
     * the clones cannot be deployed twice at the same address.
     */
    function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
        /// @solidity memory-safe-assembly
        assembly {
            // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
            // of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0xe8, shl(0x60, implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
            mstore(0x20, or(shl(0x78, implementation), 0x5af43d82803e903d91602b57fd5bf3))
            instance := create2(0, 0x09, 0x37, salt)
        }
        require(instance != address(0), "ERC1167: create2 failed");
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(add(ptr, 0x38), deployer)
            mstore(add(ptr, 0x24), 0x5af43d82803e903d91602b57fd5bf3ff)
            mstore(add(ptr, 0x14), implementation)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73)
            mstore(add(ptr, 0x58), salt)
            mstore(add(ptr, 0x78), keccak256(add(ptr, 0x0c), 0x37))
            predicted := keccak256(add(ptr, 0x43), 0x55)
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt
    ) internal view returns (address predicted) {
        return predictDeterministicAddress(implementation, salt, address(this));
    }
}

// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/introspection/ERC165.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/royalties/TokenRoyaltiesRegistry.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;





contract TokenRoyaltiesRegistry is ERC165, ITokenRoyaltiesRegistry, Ownable {

    struct MultiHolder {
        address defaultRecipient;
        uint256 royaltyAmount;
        address splitter;
        address[] recipients;
        uint256[] splits;
    }

    struct SingleHolder {
        address recipient;
        uint256 amount;
    }

    // any EOA or wallet that can receive ETH
    mapping(uint256 => SingleHolder) royalty;

    // a micro multi-sig funds splitter
    mapping(uint256 => MultiHolder) multiHolderRoyalties;

    // global single time use flag for confirming royalties are present
    mapping(uint256 => bool) public royaltiesSet;

    /// @notice the blueprint funds splitter to clone using CloneFactory (https://eips.ethereum.org/EIPS/eip-1167)
    address public baseFundsSplitter;

    // EIP712 Precomputed hashes:
    // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
    bytes32 constant EIP712DOMAINTYPE_HASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;

    // hash for EIP712, computed from contract address
    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("RoyaltyAgreement(uint256 token,uint256 royaltyAmount,address[] recipients,uint256[] splits)")
    // TODO generate properly
    bytes32 constant TXTYPE_HASH = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;

    // Some random salt (TODO generate new one ... )
    bytes32 constant SALT = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;

    constructor(address _baseFundsSplitter) {
        // cloneable base contract for multi party fund splitting
        baseFundsSplitter = _baseFundsSplitter;

        // Grab chain ID
        uint256 chainId;
        assembly {chainId := chainid()}

        // Define on creation as needs to include this address
        DOMAIN_SEPARATOR = keccak256(abi.encode(
                EIP712DOMAINTYPE_HASH, // pre-computed hash
                keccak256("TokenRoyaltiesRegistry"), // NAME_HASH
                keccak256("1"), // VERSION_HASH
                chainId, // chainId
                address(this), // verifyingContract
                SALT // random salt
            )
        );
    }

    ////////////////////
    // ERC 2981 PROXY //
    ////////////////////

    function getRoyaltiesReceiver(uint256 _editionId) external override view returns (address _receiver) {
        MultiHolder memory holder = multiHolderRoyalties[_editionId];
        if (holder.splitter != address(0)) {
            return holder.splitter;
        }
        return holder.defaultRecipient;
    }

    function royaltyInfo(
        uint256 _tokenId,
        uint256 _value
    ) external override view returns (
        address _receiver,
        uint256 _royaltyAmount
    ) {
        // Royalties can be optional
        if (!royaltiesSet[_tokenId]) {
            return (address(0), 0);
        }

        // Default single creator
        if (royalty[_tokenId].amount != 0) {
            return (royalty[_tokenId].recipient, royalty[_tokenId].amount);
        }

        // Must be a multi-holder
        MultiHolder memory holder = multiHolderRoyalties[_tokenId];

        // If quorum reached and a fund splitting wallet is defined
        if (holder.splitter != address(0)) {
            return (holder.splitter, holder.royaltyAmount);
        }

        // Fall back to default multi-holder royalties
        return (holder.defaultRecipient, holder.royaltyAmount);
    }

    function hasRoyalties(uint256 _tokenId) external override pure returns (bool) {
        return true;
    }

    //////////////////////
    // Royalty Register //
    //////////////////////

    // get total payable royalties recipients
    function totalPotentialRoyalties(uint256 _tokenId) external view override returns (uint256) {
        // Royalties can be optional
        if (!royaltiesSet[_tokenId]) {
            return 0;
        }

        // single or multiple
        return royalty[_tokenId].amount != 0 ? 1 : multiHolderRoyalties[_tokenId].recipients.length;
    }

    // get total payable royalties recipients
    function royaltyParticipantAtIndex(uint256 _tokenId, uint256 _index) external view override returns (address, uint256) {
        return (multiHolderRoyalties[_tokenId].recipients[_index], multiHolderRoyalties[_tokenId].splits[_index]);
    }

    function defineRoyalty(uint256 _tokenId, address _recipient, uint256 _amount)
    onlyOwner
    override
    external {
        require(!royaltiesSet[_tokenId], "cannot change royalties again");
        royaltiesSet[_tokenId] = true;

        // Define single recipient and amount
        royalty[_tokenId] = SingleHolder(_recipient, _amount);
    }

    function initMultiOwnerRoyalty(
        uint256 _tokenId,
        address _defaultRecipient,
        uint256 _royaltyAmount,
        address[] calldata _recipients,
        uint256[] calldata _splits
    )
    onlyOwner
    override
    external {
        require(!royaltiesSet[_tokenId], "cannot change royalties again");

        // Define single recipient and amount
        multiHolderRoyalties[_tokenId] = MultiHolder({
        defaultRecipient : _defaultRecipient,
        royaltyAmount : _royaltyAmount,
        splitter : address(0), // no splitter agreed on yet, will fallback to default if quorum not reached
        recipients : _recipients,
        splits : _splits
        });
    }

    ///////////////////////////////
    // Multi-holder confirmation //
    ///////////////////////////////

    function confirm(uint256 _tokenId, uint8[] calldata sigV, bytes32[] calldata sigR, bytes32[] calldata sigS)
    override
    public {

        MultiHolder memory holder = multiHolderRoyalties[_tokenId];

        // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
        // create hash of expected signature params
        bytes32 inputHash = keccak256(
            abi.encode(
                TXTYPE_HASH, // scheme
                _tokenId, // target token ID
                holder.royaltyAmount, // total royalty percentage expected
                holder.recipients, // the recipients
                holder.splits // the splits
            )
        );

        // Ensure all participants signatures include (tokenId, array or recipients and splits, plus default royalty)
        bytes32 expectedSignedAgreement = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, inputHash));

        address[] memory totalRecipients = holder.recipients;

        // for each participant, check they have signed the agreement
        for (uint i = 0; i < totalRecipients.length; i++) {
            address recovered = ecrecover(expectedSignedAgreement, sigV[i], sigR[i], sigS[i]);
            require(recovered == totalRecipients[i], "Agreement not reached");
        }

        // Once all approved, confirm royalties set
        royaltiesSet[_tokenId] = true;

        // Setup a new funds splitter and assign a new funds split now all parties have assigned
        address splitter = Clones.clone(baseFundsSplitter);

        // Use either pull (FundsReceiver) or push (FundsSplitter) pattern
        // IFundsHandler splitterContract = FundSplitter(payable(splitter));
        IFundsHandler splitterContract = FundsReceiver(payable(splitter));
        splitterContract.init(totalRecipients, holder.splits);

        // assign newly created splitter
        holder.splitter = address(splitter);

        // clean up mappings to claw back some GAS
        delete multiHolderRoyalties[_tokenId].recipients;
        delete multiHolderRoyalties[_tokenId].splits;
    }

    function reject(uint256 _tokenId, uint256 _quitterIndex)
    override
    public {

        // TODO make this less shit and GAS efficient ...

        // check quitter is at in the list
        require(multiHolderRoyalties[_tokenId].recipients[_quitterIndex] == _msgSender(), "Not a member");

        // assign last in array, overwriting the quitter
        multiHolderRoyalties[_tokenId].recipients[_quitterIndex] = multiHolderRoyalties[_tokenId].recipients[multiHolderRoyalties[_tokenId].recipients.length - 1];

        // shorten the array by one
        multiHolderRoyalties[_tokenId].recipients.pop();
    }
}
