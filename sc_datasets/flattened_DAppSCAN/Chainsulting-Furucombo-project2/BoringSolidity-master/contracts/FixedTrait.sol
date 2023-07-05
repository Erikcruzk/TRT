// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/interfaces/IERC721.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
interface IERC721 /* is ERC165 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable;

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external;

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address);

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

/// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
interface IERC721Metadata /* is ERC721 */ {
    /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external view returns (string memory _name);

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external view returns (string memory _symbol);

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
interface IERC721Enumerable /* is ERC721 */ {
    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256);

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) external view returns (uint256);

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/interfaces/IERC721TokenReceiver.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721TokenReceiver {
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external returns (bytes4);
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/libraries/BoringAddress.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// solhint-disable no-inline-assembly

library BoringAddress {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendNative(address to, uint256 amount) internal {
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = to.call{value: amount}("");
        require(success, "BoringAddress: transfer failed");
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/BoringMultipleNFT.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;



// solhint-disable avoid-low-level-calls

struct TraitsData {
    uint8 trait0;
    uint8 trait1;
    uint8 trait2;
    uint8 trait3;
    uint8 trait4;
    uint8 trait5;
    uint8 trait6;
    uint8 trait7;
    uint8 trait8;
}

abstract contract BoringMultipleNFT is IERC721, IERC721Metadata, IERC721Enumerable {
    /// This contract is an EIP-721 compliant contract with enumerable support
    /// To optimize for gas, tokenId is sequential and start at 0. Also, tokens can't be removed/burned.
    using BoringAddress for address;

    string public name;
    string public symbol;

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    uint256 public totalSupply = 0;

    struct TokenInfo {
        // There 3 pack into a single storage slot 160 + 24 + 9*8 = 256 bits
        address owner;
        uint24 index; // index in the tokensOf array, one address can hold a maximum of 16,777,216 tokens
        TraitsData data; // data field can be used to store traits
    }

    // operator mappings as per usual
    mapping(address => mapping(address => bool)) public isApprovedForAll;
    mapping(address => uint256[]) public tokensOf; // Array of tokens owned by
    mapping(uint256 => TokenInfo) internal _tokens; // The index in the tokensOf array for the token, needed to remove tokens from tokensOf
    mapping(uint256 => address) internal _approved; // keep track of approved nft

    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return
            interfaceID == this.supportsInterface.selector || // EIP-165
            interfaceID == 0x80ac58cd || // EIP-721
            interfaceID == 0x5b5e139f || // EIP-721 metadata extension
            interfaceID == 0x780e9d63; // EIP-721 enumeration extension
    }

    function approve(address approved, uint256 tokenId) public payable {
        address owner = _tokens[tokenId].owner;
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "Not allowed");
        _approved[tokenId] = approved;
        emit Approval(owner, approved, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address approved) {
        require(tokenId < totalSupply, "Invalid tokenId");
        return _approved[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokens[tokenId].owner;
        require(owner != address(0), "No owner");
        return owner;
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "No 0 owner");
        return tokensOf[owner].length;
    }

    function _transferBase(
        uint256 tokenId,
        address from,
        address to,
        TraitsData memory data
    ) internal {
        address owner = _tokens[tokenId].owner;
        require(from == owner, "From not owner");

        uint24 index;
        // Remove the token from the current owner's tokensOf array
        if (from != address(0)) {
            index = _tokens[tokenId].index; // The index of the item to remove in the array
            data = _tokens[tokenId].data;
            uint256 last = tokensOf[from].length - 1;
            uint256 lastTokenId = tokensOf[from][last];
            tokensOf[from][index] = lastTokenId; // Copy the last item into the slot of the one to be removed
            _tokens[lastTokenId].index = index; // Update the token index for the last item that was moved
            tokensOf[from].pop(); // Delete the last item
        }

        index = uint24(tokensOf[to].length);
        tokensOf[to].push(tokenId);
        _tokens[tokenId] = TokenInfo({owner: to, index: index, data: data});

        // EIP-721 seems to suggest not to emit the Approval event here as it is indicated by the Transfer event.
        _approved[tokenId] = address(0);
        emit Transfer(from, to, tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        require(msg.sender == from || msg.sender == _approved[tokenId] || isApprovedForAll[from][msg.sender], "Transfer not allowed");
        require(to != address(0), "No zero address");
        // check for owner == from is in base
        _transferBase(tokenId, from, to, TraitsData(0, 0, 0, 0, 0, 0, 0, 0, 0));
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable {
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public payable {
        _transfer(from, to, tokenId);
        if (to.isContract()) {
            require(
                IERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, data) ==
                    bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),
                "Wrong return value"
            );
        }
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(tokenId < totalSupply, "Not minted");
        return _tokenURI(tokenId);
    }

    function _tokenURI(uint256 tokenId) internal view virtual returns (string memory);

    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply, "Out of bounds");
        return index; // This works due the optimization of sequential tokenIds and no burning
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        return tokensOf[owner][index];
    }

    //
    function _mint(address owner, TraitsData memory data) internal returns (uint256 tokenId) {
        tokenId = totalSupply;
        _transferBase(tokenId, address(0), owner, data);
        totalSupply++;
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/interfaces/IBoringGenerativeNFT.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

struct GeneInfo {
    ITrait trait;
    string name;
}

interface ITrait {
    // Should return bytes4(keccak256("setName(uint8,string)"))
    function setName(uint8 trait, string calldata name) external returns (bytes4);

    // Should return bytes4(keccak256("addData(address,uint8,bytes)"))
    function addData(uint8 trait, bytes calldata data) external returns (bytes4);

    function renderTrait(
        IBoringGenerativeNFT nft,
        uint256 tokenId,
        uint8 trait,
        uint8 gene
    ) external view returns (string memory output);

    function renderSVG(
        IBoringGenerativeNFT nft,
        uint256 tokenId,
        uint8 trait,
        uint8 gene
    ) external view returns (string memory output);
}

interface IBoringGenerativeNFT {
    function traits(uint256 index) external view returns (ITrait trait);

    function traitsCount() external view returns (uint256 count);

    function addTrait(string calldata name, ITrait trait) external;

    function mint(TraitsData calldata genes, address to) external;

    function batchMint(TraitsData[] calldata genes, address[] calldata to) external;
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/FixedTrait.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract FixedTrait is ITrait {
    struct Option {
        string name;
        string svg;
    }

    mapping(IBoringGenerativeNFT => mapping(uint8 => string)) public names;
    mapping(IBoringGenerativeNFT => mapping(uint8 => Option[])) public options;

    function setName(uint8 trait, string calldata name) external override returns (bytes4) {
        names[IBoringGenerativeNFT(msg.sender)][trait] = name;

        return bytes4(keccak256("setName(uint8,string)"));
    }

    function addData(uint8 trait, bytes calldata data) external override returns (bytes4) {
        Option memory option = abi.decode(data, (Option));
        options[IBoringGenerativeNFT(msg.sender)][trait].push(option);

        return bytes4(keccak256("addData(address,uint8,bytes)"));
    }

    function renderTrait(
        IBoringGenerativeNFT nft,
        uint256,
        uint8 trait,
        uint8 gene
    ) external view override returns (string memory output) {
        return string(abi.encodePacked('{"trait_type":"', names[nft][trait], '","value":"', options[nft][trait][gene].name, '"}'));
    }

    function renderSVG(
        IBoringGenerativeNFT nft,
        uint256,
        uint8 trait,
        uint8 gene
    ) external view override returns (string memory output) {
        return options[nft][trait][gene].svg;
    }
}
