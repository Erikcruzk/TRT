// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/aliana/GFAccessControl.sol

pragma solidity ^0.5.0;

/// @title A facet of AlianaCore that manages special access privileges.
/// @dev See the AlianaCore contract documentation to understand how the various contract facets are arranged.
contract GFAccessControl {
    mapping(address => bool) public whitelist;

    event WhitelistedAddressAdded(address addr);
    event WhitelistedAddressRemoved(address addr);

    /**
     * @dev Throws if called by any account that's not whitelisted.
     */
    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "not whitelisted");
        _;
    }

    /**
     * @dev add an address to the whitelist
     * @param addr address
     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
     */
    function addAddressToWhitelist(address addr)
        external
        onlyCEO
        returns (bool success)
    {
        return _addAddressToWhitelist(addr);
    }

    /**
     * @dev add an address to the whitelist
     * @param addr address
     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
     */
    function _addAddressToWhitelist(address addr)
        private
        onlyCEO
        returns (bool success)
    {
        if (!whitelist[addr]) {
            whitelist[addr] = true;
            emit WhitelistedAddressAdded(addr);
            success = true;
        }
    }

    /**
     * @dev add addresses to the whitelist
     * @param addrs addresses
     * @return true if at least one address was added to the whitelist,
     * false if all addresses were already in the whitelist
     */
    function addAddressesToWhitelist(address[] calldata addrs)
        external
        onlyCEO
        returns (bool success)
    {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (_addAddressToWhitelist(addrs[i])) {
                success = true;
            }
        }
    }

    /**
     * @dev remove an address from the whitelist
     * @param addr address
     * @return true if the address was removed from the whitelist,
     * false if the address wasn't in the whitelist in the first place
     */
    function removeAddressFromWhitelist(address addr)
        external
        onlyCEO
        returns (bool success)
    {
        return _removeAddressFromWhitelist(addr);
    }

    /**
     * @dev remove an address from the whitelist
     * @param addr address
     * @return true if the address was removed from the whitelist,
     * false if the address wasn't in the whitelist in the first place
     */
    function _removeAddressFromWhitelist(address addr)
        private
        onlyCEO
        returns (bool success)
    {
        if (whitelist[addr]) {
            whitelist[addr] = false;
            emit WhitelistedAddressRemoved(addr);
            success = true;
        }
    }

    /**
     * @dev remove addresses from the whitelist
     * @param addrs addresses
     * @return true if at least one address was removed from the whitelist,
     * false if all addresses weren't in the whitelist in the first place
     */
    function removeAddressesFromWhitelist(address[] calldata addrs)
        external
        onlyCEO
        returns (bool success)
    {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (_removeAddressFromWhitelist(addrs[i])) {
                success = true;
            }
        }
    }

    // This facet controls access control for GameAlianas. There are four roles managed here:
    //
    //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
    //         contracts. It is also the only role that can unpause the smart contract. It is initially
    //         set to the address that created the smart contract in the AlianaCore constructor.
    //
    //     - The CFO: The CFO can withdraw funds from AlianaCore and its auction contracts.
    //
    //     - The COO: The COO can release gen0 alianas to auction, and mint promo cats.
    //
    // It should be noted that these roles are distinct without overlap in their access abilities, the
    // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
    // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
    // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
    // convenience. The less we use an address, the less likely it is that we somehow compromise the
    // account.

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public ceoAddress;
    address public candidateCEOAddress;

    address public cfoAddress;
    address public cooAddress;

    event SetCandidateCEO(address addr);
    event AcceptCEO(address addr);
    event SetCFO(address addr);
    event SetCOO(address addr);

    event Pause(address operator);
    event Unpause(address operator);

    // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public paused = false;

    /**
     * @dev The Ownable constructor sets the original `ceoAddress` of the contract to the sender
     * account.
     */
    constructor() public {
        ceoAddress = msg.sender;
        emit AcceptCEO(ceoAddress);
    }

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress, "not ceo");
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(msg.sender == cfoAddress, "not cfo");
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(msg.sender == cooAddress, "not coo");
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
                msg.sender == ceoAddress ||
                msg.sender == cfoAddress,
            "not c level"
        );
        _;
    }

    modifier onlyCLevelOrWhitelisted() {
        require(
            msg.sender == cooAddress ||
                msg.sender == ceoAddress ||
                msg.sender == cfoAddress ||
                whitelist[msg.sender],
            "not c level or whitelisted"
        );
        _;
    }

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _candidateCEO The address of the new CEO
    function setCandidateCEO(address _candidateCEO) external onlyCEO {
        require(_candidateCEO != address(0), "addr can't be 0");

        candidateCEOAddress = _candidateCEO;
        emit SetCandidateCEO(candidateCEOAddress);
    }

    /// @dev Accept CEO invite.
    function acceptCEO() external {
        require(msg.sender == candidateCEOAddress, "you are not the candidate");

        ceoAddress = candidateCEOAddress;
        emit AcceptCEO(ceoAddress);
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0), "addr can't be 0");

        cfoAddress = _newCFO;
        emit SetCFO(cfoAddress);
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0), "addr can't be 0");

        cooAddress = _newCOO;
        emit SetCOO(cooAddress);
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused, "paused");
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused() {
        require(paused, "not paused");
        _;
    }

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function pause() external onlyCEO whenNotPaused {
        paused = true;
        emit Pause(msg.sender);
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
        emit Unpause(msg.sender);
    }

    // Set in case the core contract is broken and an upgrade is required
    address public newContractAddress;

    /// @dev Used to mark the smart contract as upgraded, in case there is a serious
    ///  breaking bug. This method does nothing but keep track of the new contract and
    ///  emit a message indicating that the new address is set. It's up to clients of this
    ///  contract to update to the new contract address in that case. (This contract will
    ///  be paused indefinitely if such an upgrade takes place.)
    /// @param _v2Address new address
    function setNewAddress(address _v2Address) external onlyCEO whenPaused {
        // See README.md for updgrade plan
        newContractAddress = _v2Address;
        emit ContractUpgrade(_v2Address);
    }

    //////////
    // Safety Methods
    //////////

    /// @notice This method can be used by the owner to extract mistakenly
    ///  sent tokens to this contract.
    /// @param token_ The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract ether.
    function claimTokens(address token_) external onlyCEO {
        if (token_ == address(0)) {
            address(msg.sender).transfer(address(this).balance);
            return;
        }

        IERC20 token = IERC20(token_);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(address(msg.sender), balance);

        emit ClaimedTokens(token_, address(msg.sender), balance);
    }

    function withdrawTokens(
        IERC20 token_,
        address to_,
        uint256 amount_
    ) external onlyCEO {
        assert(token_.transfer(to_, amount_));
        emit WithdrawTokens(address(token_), address(msg.sender), to_, amount_);
    }

    ////////////////
    // Events
    ////////////////

    event ClaimedTokens(
        address indexed token_,
        address indexed controller_,
        uint256 amount_
    );

    event WithdrawTokens(
        address indexed token_,
        address indexed controller_,
        address indexed to_,
        uint256 amount_
    );
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

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

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
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
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
    function transferFrom(address from, address to, uint256 tokenId) external;

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
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/aliana/IAliana.sol

pragma solidity ^0.5.0;

/// @title SEKRETOOOO
contract IAliana is IERC721 {
    function createOfficialAliana(uint256 _genes, address _owner)
        public
        returns (uint256);

    function burn(uint256 _tokenID) external;

    function isAliana() public returns (bool);

    function geneLpLabor(int256 _id, uint256 _gene)
        public
        view
        returns (uint256);

    function geneLpLabors(int256[] memory _ids, uint256[] memory _genes)
        public
        view
        returns (uint256[] memory);

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory ownerTokens);

    function getAliana(uint256 _id)
        external
        view
        returns (
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 genes,
            uint256 lpLabor
        );
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/math/SafeMath.sol

pragma solidity <0.6.0 >=0.4.21;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, throws on overflow.
     */

    /*@CTK SafeMath_mul
    @tag spec
    @post __reverted == __has_assertion_failure
    @post __has_assertion_failure == __has_overflow
    @post __reverted == false -> c == a * b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two numbers, truncating the quotient.
     */
    /*@CTK SafeMath_div
    @tag spec
    @pre b != 0
    @post __reverted == __has_assertion_failure
    @post __has_overflow == true -> __has_assertion_failure == true
    @post __reverted == false -> __return == a / b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     */
    /*@CTK SafeMath_sub
    @tag spec
    @post __reverted == __has_assertion_failure
    @post __has_overflow == true -> __has_assertion_failure == true
    @post __reverted == false -> __return == a - b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Adds two numbers, throws on overflow.
     */
    /*@CTK SafeMath_add
    @tag spec
    @post __reverted == __has_assertion_failure
    @post __has_assertion_failure == __has_overflow
    @post __reverted == false -> c == a + b
    @post msg == msg__post
   */
    /* CertiK Smart Labelling, for more details visit: https://certik.org */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/aliana/AuctionOwner.sol

pragma solidity ^0.5.0;

contract AuctionOwner {
    using SafeMath for uint256;

    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokensAuction;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndexAuction;

    /**
     * @dev Gets the list of token IDs of the requested owner.
     * @param owner address owning the tokens
     * @return uint256[] List of token IDs owned by the requested address
     */
    function _tokensOfOwnerAuction(address owner)
        internal
        view
        returns (uint256[] storage)
    {
        return _ownedTokensAuction[owner];
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumerationAuction(address to, uint256 tokenId)
        internal
    {
        _ownedTokensIndexAuction[tokenId] = _ownedTokensAuction[to].length;
        _ownedTokensAuction[to].push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumerationAuction(
        address from,
        uint256 tokenId
    ) internal {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokensAuction[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndexAuction[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokensAuction[from][lastTokenIndex];

            _ownedTokensAuction[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndexAuction[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokensAuction[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
        // lastTokenId, or just over the end of the array if the token was the last one).
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/FlashSale.sol

pragma solidity ^0.5.0;





/// @title Auction Core
/// @dev Contains models, variables, and internal methods for the auction.
/// @notice We omit a fallback function to prevent accidental sends to this contract.
contract FlashSaleBase is AuctionOwner, GFAccessControl {
    using SafeMath for uint256;
    uint256 maxBiddingNum;
    uint256[] biddingId;
    uint256 public lastBiddingId;
    uint256 c_startingPrice = 1e16; // 0.01 GFT
    uint256 c_duration = 50; // 300s
    uint256 c_minAddPrice = 1e16; // 0.01 GFT
    uint256 c_startBlockOffset; // begin of the block
    uint256 c_cycleBlock; // cycle time
    uint256 c_maxCycle; // max cycle

    // Represents an auction on an NFT
    struct Auction {
        uint256 currentPrice;
        address buyer;
        uint64 endAt;
        bool taked;
    }

    // Reference to contract tracking NFT ownership
    IAliana public alianaContract;

    // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
    // Values 0-10,000 map to 0%-100%
    uint256 public ownerCut;

    // The gae TOKEN
    IERC20 public gaeToken;

    // Map from token ID to their corresponding auction.
    mapping(uint256 => Auction) tokenIdToAuction;

    struct GeneEntry {
        uint256 gene;
        bool used;
    }
    // Map from token ID to their gene value.
    mapping(uint256 => GeneEntry) tokenIdToGene;

    event TakeBid(
        uint256 indexed tokenId,
        address indexed winner,
        uint256 totalPrice
    );

    event Bid(uint256 indexed tokenId, address indexed buyer, uint256 price);

    constructor(IERC20 _gaeToken, uint256 _cycleBlock) public {
        gaeToken = _gaeToken;
        updateMaxBiddingNum(6);
        setStartBlockOffset(block.number);
        setCycleBlock(_cycleBlock);
    }

    function updateMaxBiddingNum(uint256 _value) public onlyCEO {
        maxBiddingNum = _value;
        for (uint256 i = maxBiddingNum; i < biddingId.length; i++) {
            Auction storage auction = tokenIdToAuction[biddingId[i]];
            require(
                !_hasAuctionByInfo(auction) || !_isOnAuction(auction),
                "FlashSale: reduced capacity auction in bidding"
            );
        }
        biddingId.length = maxBiddingNum;
        _updateBidding();
    }

    function getStartingPrice() public view returns (uint256) {
        return c_startingPrice;
    }

    function setStartingPrice(uint256 _value) public onlyCEO {
        c_startingPrice = _value;
    }

    function getCycleBlock() public view returns (uint256) {
        return c_cycleBlock;
    }

    function setCycleBlock(uint256 _cycleBlock) public onlyCEO {
        require(_cycleBlock > 0, "require _cycleBlock > 0");
        require(_cycleBlock > c_duration, "require _cycleBlock > c_duration");
        c_cycleBlock = _cycleBlock;
    }

    function getStartBlockOffset() public view returns (uint256) {
        return c_startBlockOffset;
    }

    function setStartBlockOffset(uint256 _startBlockOffset) public onlyCEO {
        require(
            _startBlockOffset <= block.number,
            "require _startBlockOffset <= block.number"
        );
        c_startBlockOffset = _startBlockOffset;
    }

    function getMaxCycle() public view returns (uint256) {
        return c_maxCycle;
    }

    function setMaxCycle(uint256 _maxCycle) public onlyCEO {
        c_maxCycle = _maxCycle;
    }

    function getDuration() public view returns (uint256) {
        return c_duration;
    }

    function setDuration(uint256 _value) public onlyCEO {
        require(_value > 0, "require _value > 0");
        require(c_cycleBlock > _value, "require c_cycleBlock > _value");
        c_duration = _value;
    }

    function getLatestActivity()
        public
        view
        returns (uint256 begin, uint256 end)
    {
        uint256 cycleNum = getCurrentCycleNum();
        if (cycleNum >= c_maxCycle) {
            return (0, 0);
        }
        end = c_startBlockOffset.add(cycleNum.add(1).mul(c_cycleBlock));
        begin = end.sub(c_duration);
        return (begin, end);
    }

    function isNowInActivity() public view returns (bool) {
        (uint256 begin, uint256 end) = getLatestActivity();
        return block.number >= begin && block.number < end;
    }

    function getCurrentCycleNum() public view returns (uint256) {
        uint256 n = block.number;
        return n.sub(c_startBlockOffset).div(c_cycleBlock);
    }

    function getMinAddPrice() public view returns (uint256) {
        return c_minAddPrice;
    }

    function setMinAddPrice(uint256 _value) public onlyCEO {
        c_minAddPrice = _value;
    }

    function minAddPrice() public view returns (uint256) {
        return c_minAddPrice;
    }

    function _updateBidding() internal {
        uint256 _lastBidding = lastBiddingId;
        for (uint256 i = 0; i < maxBiddingNum; i++) {
            uint256 id = biddingId[i];
            if (id != 0) {
                Auction storage auction = tokenIdToAuction[id];
                if (_hasAuctionByInfo(auction)) {
                    if (_isOnAuction(auction)) {
                        continue;
                    }
                } else {
                    continue;
                }
            }
            // set bidding id
            biddingId[i] = _lastBidding + 1;
            _lastBidding = _lastBidding + 1;
        }
        if (lastBiddingId != _lastBidding) {
            lastBiddingId = _lastBidding;
        }
    }

    function _isBidding(uint256 _id) internal view returns (bool) {
        uint256[] memory list = _biddingIdList();
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == _id) {
                return true;
            }
        }
        return false;
    }

    function _isBiddingNoCheck(uint256 _id) internal view returns (bool) {
        for (uint256 i = 0; i < biddingId.length; i++) {
            if (biddingId[i] == _id) {
                return true;
            }
        }
        return false;
    }

    function _biddingNum() internal view returns (uint256) {
        return maxBiddingNum;
    }

    function _biddingIdList() internal view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](maxBiddingNum);
        uint256 resultIndex = 0;
        uint256 addNum = 1;
        for (uint256 i = 0; i < maxBiddingNum; i++) {
            uint256 id = biddingId[i];
            if (id != 0) {
                Auction storage auction = tokenIdToAuction[id];
                if (_hasAuctionByInfo(auction)) {
                    if (!_isOnAuction(auction)) {
                        id = lastBiddingId + addNum;
                        addNum = addNum + 1;
                    }
                }
            } else {
                id = lastBiddingId + addNum;
                addNum = addNum + 1;
            }
            result[resultIndex] = id;
            resultIndex = resultIndex + 1;
            if (resultIndex == maxBiddingNum) {
                break;
            }
        }
        return result;
    }

    function _getGene(uint256 _id) internal view returns (uint256) {
        GeneEntry storage gene = tokenIdToGene[_id];
        require(gene.used, "target gene not set");
        return gene.gene;
    }

    function _getBiddingGene(uint256 _id) internal view returns (uint256) {
        require(
            _id <= lastBiddingId || _isBidding(_id),
            "FlashSale: id must in bidding"
        );
        require(_id > 0, "FlashSale: id must gt 0");
        return _getGene(_id);
    }

    function _getBiddingGeneNoCheck(uint256 _id)
        internal
        view
        returns (uint256)
    {
        return _getGene(_id);
    }

    function _tokensOfOwnerAuctionOn(address _owner, bool on)
        internal
        view
        returns (uint256[] memory)
    {
        uint256[] memory list = _tokensOfOwnerAuction(_owner);
        uint256 num;
        for (uint256 i = 0; i < list.length; i++) {
            uint256 id = list[i];
            Auction storage auction = tokenIdToAuction[id];
            if (_isOnAuction(auction) == on) {
                num++;
            }
        }
        uint256 resultIndex = 0;
        uint256[] memory result = new uint256[](num);
        for (uint256 i = 0; i < list.length; i++) {
            uint256 id = list[i];
            Auction storage auction = tokenIdToAuction[id];
            if (_isOnAuction(auction) == on) {
                result[resultIndex] = id;
                resultIndex++;
                if (resultIndex >= num) {
                    break;
                }
            }
        }
        return result;
    }

    function _hasAuction(uint256 _id) internal view returns (bool) {
        // Get a reference to the auction struct
        Auction storage auction = tokenIdToAuction[_id];
        return auction.endAt > 0;
    }

    function _hasAuctionByInfo(Auction storage _auction)
        internal
        view
        returns (bool)
    {
        return _auction.endAt > 0;
    }

    /// @dev Computes the price and transfers winnings.
    /// Does NOT transfer ownership of token.
    function _bidFrom(
        address _buyer,
        uint256 _id,
        uint256 _bidAmount
    ) internal whenNotPaused {
        require(isNowInActivity(), "not in activity");

        // Get a reference to the auction struct
        Auction storage auction = tokenIdToAuction[_id];
        if (!_hasAuctionByInfo(auction)) {
            _updateBidding();
            require(
                _isBiddingNoCheck(_id),
                "FlashSale: target id is not in the bidding"
            );
            auction.currentPrice = uint128(c_startingPrice);
            (, uint256 end) = getLatestActivity();
            auction.endAt = uint64(end);
        } else {
            require(
                _isBiddingNoCheck(_id),
                "FlashSale: target id is not in the bidding"
            );
        }

        // Explicitly check that this auction is currently live.
        // (Because of how Ethereum mappings work, we can't just count
        // on the lookup above failing. An invalid _id will just
        // return an auction object that is all zeros.)
        require(
            _isOnAuction(auction),
            "FlashSale: target id is not in the auction"
        );

        // Check that the bid is greater than or equal to the current price
        uint256 minPrice = auction.currentPrice;
        if (auction.buyer != address(0)) {
            minPrice = auction.currentPrice.add(c_minAddPrice);
        }
        require(_bidAmount >= minPrice, "FlashSale: underbid");

        if (auction.buyer != address(0)) {
            require(
                gaeToken.transferFrom(
                    _buyer,
                    auction.buyer,
                    auction.currentPrice
                ),
                "FlashSale: failed to transfer gae token to old buyer"
            );
            _removeTokenFromOwnerEnumerationAuction(auction.buyer, _id);
            uint256 inAmount = _bidAmount.sub(auction.currentPrice);
            require(
                gaeToken.transferFrom(_buyer, address(this), inAmount),
                "FlashSale: failed to transfer gae token to contract"
            );
        } else {
            require(
                gaeToken.transferFrom(_buyer, address(this), _bidAmount),
                "FlashSale: failed to transfer gae token to contract"
            );
        }
        auction.currentPrice = _bidAmount;
        auction.buyer = _buyer;
        _addTokenToOwnerEnumerationAuction(_buyer, _id);
        emit Bid(_id, _buyer, _bidAmount);
    }

    function _takeBid(uint256 _id) internal {
        // Get a reference to the auction struct
        Auction storage auction = tokenIdToAuction[_id];
        address buyer = auction.buyer;
        // Explicitly check that this auction is currently live.
        // (Because of how Ethereum mappings work, we can't just count
        // on the lookup above failing. An invalid _id will just
        // return an auction object that is all zeros.)
        require(_hasAuctionByInfo(auction), "FlashSale: no target auction");
        require(
            !_isOnAuction(auction),
            "FlashSale: target id still in auction"
        );
        require(!auction.taked, "FlashSale: already take");
        require(buyer != address(0), "FlashSale: no buyer");

        alianaContract.createOfficialAliana(_getBiddingGeneNoCheck(_id), buyer);
        auction.taked = true;
        _removeTokenFromOwnerEnumerationAuction(buyer, _id);
        // Tell the world!
        emit TakeBid(_id, buyer, auction.currentPrice);
    }

    // _takeBids LP tokens from Mine.
    function _takeBids(uint32[] memory _tokenIds) internal {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _takeBid(_tokenIds[i]);
        }
    }

    // _takeBids256 LP tokens from Mine.
    function _takeBids256(uint256[] memory _tokenIds) internal {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _takeBid(_tokenIds[i]);
        }
    }

    /// @dev Adds an auction to the list of open auctions. Also fires the
    ///  AuctionCreated event.
    /// @param _tokenId The ID of the token to be put on auction.
    /// @param _auction Auction to add.
    function _addAuction(uint256 _tokenId, Auction memory _auction)
        internal
        whenNotPaused
    {
        // Require that all auctions have a duration of
        // at least one minute. (Keeps our math from getting hairy!)
        require(c_duration >= 1, "FlashSale: duration < 1");

        tokenIdToAuction[_tokenId] = _auction;
    }

    /// @dev Returns true if the NFT is on auction.
    /// @param _auction - Auction to check.
    function _isOnAuction(Auction storage _auction)
        internal
        view
        returns (bool)
    {
        if (_auction.endAt <= block.number || _auction.taked) {
            return false;
        }
        return true;
    }
}

/// @title Clock auction modified for sale of alianas
/// @notice We omit a fallback function to prevent accidental sends to this contract.
contract FlashSale is FlashSaleBase {
    function isFlashSale() public pure returns (bool) {
        return true;
    }

    /// @dev Constructor creates a reference to the NFT ownership contract
    ///  and verifies the owner cut is in the valid range.
    /// @param _alianaAddress - address of a deployed contract implementing
    ///  the Nonfungible Interface.
    /// @param _cut - percent cut the owner takes on each auction, must be
    ///  between 0-10,000.
    constructor(
        IAliana _alianaAddress,
        uint256 _cut,
        IERC20 gaeToken,
        uint256 _cycleBlock
    ) public FlashSaleBase(gaeToken, _cycleBlock) {
        require(_cut <= 10000, "FlashSale: cut too large");
        ownerCut = _cut;

        require(_alianaAddress.isAliana(), "FlashSale: not aliana");

        alianaContract = _alianaAddress;
    }

    /// @dev Returns auction info for an NFT on auction.
    /// @param _tokenId - ID of NFT on auction.
    function getAuction(uint256 _tokenId)
        external
        view
        returns (
            uint256 currentPrice,
            uint256 endAt,
            uint256 gene,
            uint256 lpLabor,
            address buyer,
            bool taked
        )
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        currentPrice = auction.currentPrice;
        endAt = auction.endAt;
        gene = _getBiddingGeneNoCheck(_tokenId);
        buyer = auction.buyer;
        taked = auction.taked;
        if (!_hasAuctionByInfo(auction)) {
            gene = _getBiddingGene(_tokenId);
            currentPrice = uint128(c_startingPrice);
        }
        lpLabor = alianaContract.geneLpLabor(int256(_tokenId), gene);
    }

    /// @dev Returns the current price of an auction.
    /// @param _tokenId - ID of the token price we are checking.
    function getCurrentPrice(uint256 _tokenId) external view returns (uint256) {
        return tokenIdToAuction[_tokenId].currentPrice;
    }

    function updateBidding() external {
        _updateBidding();
    }

    function biddingNum() external view returns (uint256) {
        return _biddingNum();
    }

    function biddingIdList() external view returns (uint256[] memory) {
        return _biddingIdList();
    }

    function getBiddingGene(uint256 _id) external view returns (uint256) {
        return _getBiddingGene(_id);
    }

    /// @notice Returns a list of all Aliana IDs assigned to an address.
    /// @param _owner The owner whose Kitties we are interested in.
    /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
    ///  expensive (it walks the entire Aliana array looking for cats belonging to owner),
    ///  but it also returns a dynamic array, which is only supported for web3 calls, and
    ///  not contract-to-contract calls.
    function tokensOfOwnerAuction(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        return _tokensOfOwnerAuction(_owner);
    }

    function tokensOfOwnerAuctionOn(address _owner, bool on)
        external
        view
        returns (uint256[] memory)
    {
        return _tokensOfOwnerAuctionOn(_owner, on);
    }

    /// @dev Updates lastSalePrice if seller is the nft contract
    /// Otherwise, works the same as default bid method.
    function bid(uint32 _tokenId, uint256 _price) external {
        // _bid verifies token ID size
        _bidFrom(msg.sender, _tokenId, _price);
    }

    function takeBid(uint32 _tokenId) external {
        // _bid verifies token ID size
        _takeBid(_tokenId);
    }

    function takeBids(uint32[] calldata _tokenIds) external {
        _takeBids(_tokenIds);
    }

    function setTokenGene(
        uint256[] calldata _tokenIds,
        uint256[] calldata _gene
    ) external onlyCEO {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            tokenIdToGene[_tokenIds[i]].gene = _gene[i];
            tokenIdToGene[_tokenIds[i]].used = true;
        }
    }

    function unsetTokenGene(uint256[] calldata _tokenIds) external onlyCEO {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            tokenIdToGene[_tokenIds[i]].used = false;
        }
    }

    // takeMyBids LP tokens from Mine.
    function takeMyBids() external {
        _takeBids256(_tokensOfOwnerAuctionOn(msg.sender, false));
    }

    // takeBidsOf LP tokens from Mine.
    function takeBidsOf(address addr) external {
        _takeBids256(_tokensOfOwnerAuctionOn(addr, false));
    }

    function receiveApproval(
        address _sender,
        uint256 _value,
        address _tokenContract,
        bytes memory _extraData
    ) public {
        require(_value > 0, "FlashSale: approval zero");
        uint256 action;
        assembly {
            action := mload(add(_extraData, 0x20))
        }
        require(action == 2, "FlashSale: unknow action");
        if (action == 2) {
            // buy
            require(
                _tokenContract == address(gaeToken),
                "FlashSale: approval and want buy a aliana, but used token isn't GFT"
            );
            uint256 tokenId;
            uint256 price;
            assembly {
                tokenId := mload(add(_extraData, 0x40))
                price := mload(add(_extraData, 0x60))
            }
            _bidFrom(_sender, tokenId, price);
        }
    }
}
