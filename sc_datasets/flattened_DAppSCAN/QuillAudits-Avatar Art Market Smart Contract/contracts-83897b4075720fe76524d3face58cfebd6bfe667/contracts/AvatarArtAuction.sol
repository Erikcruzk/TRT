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

// File: ../sc_datasets/DAppSCAN/QuillAudits-Avatar Art Market Smart Contract/contracts-83897b4075720fe76524d3face58cfebd6bfe667/contracts/interfaces/IAvatarArtAuction.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IAvatarArtAuction{
    /**
     * @dev Owner create new auction for specific `tokenId`
     * 
     * REQUIREMENTS
     *  1. TokenId is not in other active auction
     *  2. Start time and end time is valid
     * 
     * @return Auction index
     */ 
    function createAuction(uint256 tokenId, uint256 startTime, uint256 endTime, uint256 price) external returns(uint256);
    
    /**
     * @dev Owner distributes NFT to winner
     * 
     *  REQUIREMENTS
     *  1. Auction ends
     */ 
    function distribute(uint256 auctionIndex) external returns(bool);
    
    /**
     * @dev User places a BID price to join specific auction 
     * 
     *  REQUIREMENTS
     *  1. Auction is active
     *  2. BID should be greater than current price
     */ 
    function place(uint256 auctionIndex, uint256 price) external returns(bool);
    
    /**
     * @dev Owner updates active status
     * 
     */ 
    function deactivateAuction(uint256 auctionIndex) external returns(bool);
    
     /**
     * @dev Owner update token price for specific auction, definied by `auctionIndex`
     * 
     * REQUIREMENTS
     *  1. Auction is not active, has not been started yet
     */ 
    function updateActionPrice(uint256 auctionIndex, uint256 price) external returns(bool);
    
    /**
     * @dev Owner updates auction time, definied by `auctionIndex`
     * 
     * REQUIREMENTS
     *  1. Auction is not active, has not been started yet
     */ 
    function updateActionTime(uint256 auctionIndex, uint256 startTime, uint256 endTime) external returns(bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
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

// File: ../sc_datasets/DAppSCAN/QuillAudits-Avatar Art Market Smart Contract/contracts-83897b4075720fe76524d3face58cfebd6bfe667/contracts/core/AvatarArtContext.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract AvatarArtContext is Context {
    function _now() internal view returns(uint){
        return block.timestamp;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Avatar Art Market Smart Contract/contracts-83897b4075720fe76524d3face58cfebd6bfe667/contracts/core/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Ownable is AvatarArtContext {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) internal {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Avatar Art Market Smart Contract/contracts-83897b4075720fe76524d3face58cfebd6bfe667/contracts/AvatarArtBase.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;




contract AvatarArtBase is Ownable, IERC721Receiver{
    uint256 public MULTIPLIER = 1000;
    
    IERC20 private _bnuToken;
    IERC721 private _avatarArtNFT;
    
    uint256 private _feePercent;       //Multipled by 1000
    
    constructor(address bnuTokenAddress, address avatarArtNFTAddress){
        _bnuToken = IERC20(bnuTokenAddress);
        _avatarArtNFT = IERC721(avatarArtNFTAddress);
        _feePercent = 100;        //0.1%
    }
    
    /**
     * @dev Get BNU token 
     */
    function getBnuToken() public view returns(IERC20){
        return _bnuToken;
    }
    
    /**
     * @dev Get AvatarArt NFT
     */
    function getAvatarArtNFT() public view returns(IERC721){
        return _avatarArtNFT;
    }
    
    /**
     * @dev Get fee percent, this fee is for seller
     */ 
    function getFeePercent() public view returns(uint){
        return _feePercent;
    }
    
    /**
     * @dev Set AvatarArtNFT contract 
     */
    function setAvatarArtNFT(address newAddress) public onlyOwner{
        require(newAddress != address(0), "Zero address");
        _avatarArtNFT = IERC721(newAddress);
    }
    
    /**
     * @dev Set BNU token 
     */
    function setBnuToken(address newAddress) public onlyOwner{
        require(newAddress != address(0), "Zero address");
        _bnuToken = IERC20(newAddress);
    }
    
    /**
     * @dev Set fee percent
     */
    function setFeePercent(uint feePercent) public onlyOwner{
        _feePercent = feePercent;
    }
    
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external view override returns (bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Avatar Art Market Smart Contract/contracts-83897b4075720fe76524d3face58cfebd6bfe667/contracts/AvatarArtAuction.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;




/**
* @dev Contract is used so that user can join an auction
* Business steps:
*   1. Artists submit auction information to system
*   2. Admin approve these informations and create an auction.
*   Note that: The submiting and approving will be processed outside blockchain
*   3. User joins the auction and winner will be the one who pay the highest price
*   4. At the end of auction, anyone can call `distribute` function to distribute NFT to the winner
*      If there is not winner, NFT will be payback to artist
*/
contract AvatarArtAuction is AvatarArtBase, IAvatarArtAuction{
    enum EAuctionStatus{
        Open,
        Completed,
        Canceled
    }
    
    //Store information of specific auction
    struct Auction{
        uint256 startTime;
        uint256 endTime;
        uint256 tokenId;
        address tokenOwner;
        uint256 price;
        address winner;
        EAuctionStatus status;       //0:Open, 1: Closed, 2: Canceled
    }
    
    //Store auction history when a user places
    struct AuctionHistory{
        uint256 time;
        uint256 price;
        address creator;
    }
    
    //AUCTION 
    Auction[] public _auctions;       //List of auction
    
    //Mapping between specific auction and its histories
    mapping(uint256 => AuctionHistory[]) public _auctionHistories;
    
    constructor(address bnuTokenAddress, address avatarArtNFTAddress) 
        AvatarArtBase(bnuTokenAddress, avatarArtNFTAddress){}

    function getAuctionCount() public view returns(uint256)
    {
        return _auctions.length;
    }
        
     /**
     * @dev {See - IAvatarArtAuction.createAuction}
     * 
     * IMPLEMENTATION
     *  1. Validate requirement
     *  2. Add new auction
     *  3. Transfer NFT to contract
     */ 
    function createAuction(uint256 tokenId, uint256 startTime, uint256 endTime, uint256 price) external override onlyOwner returns(uint256){
        require(_now() <= startTime, "Start time is invalid");
        require(startTime < endTime, "Time is invalid");
        (bool isExisted,,) = getActiveAuctionByTokenId(tokenId);
        require(!isExisted, "Token is in other auction");
        
        IERC721 avatarArtNFT = getAvatarArtNFT();
        address tokenOwner = avatarArtNFT.ownerOf(tokenId);
        
        avatarArtNFT.safeTransferFrom(tokenOwner, address(this), tokenId);
        
        _auctions.push(Auction(startTime, endTime, tokenId, tokenOwner, price, address(0), EAuctionStatus.Open));
        
        emit NewAuctionCreated(tokenId, startTime, endTime, price);
        
        return _auctions.length - 1;
    }
    
    /**
     * @dev {See - IAvatarArtAuction.deactivateAuction}
     * 
     */ 
    function deactivateAuction(uint256 auctionIndex) external override onlyOwner returns(bool){
        require(auctionIndex < getAuctionCount());
        _auctions[auctionIndex].status = EAuctionStatus.Canceled;
        return true;
    }
    
    /**
     * @dev {See - IAvatarArtAuction.distribute}
     * 
     *  IMPLEMENTATION
     *  1. Validate requirements
     *  2. Distribute NFT for winner
     *  3. Keep fee for dev and pay cost for token owner
     *  4. Update auction
     */ 
    function distribute(uint256 auctionIndex) external override returns(bool){       //Anyone can call this function
        require(auctionIndex < getAuctionCount());
        Auction storage auction = _auctions[auctionIndex];
        require(auction.status == EAuctionStatus.Open && auction.endTime < _now());
        
        //If have auction
        if(auction.winner != address(0)){
            IERC20 bnuToken = getBnuToken();
            
            //Pay fee for owner
            uint256 feeAmount = 0;
            uint256 feePercent = getFeePercent();
            if(feePercent > 0){
                feeAmount = auction.price * feePercent / 100 / MULTIPLIER;
                require(bnuToken.transfer(_owner, feeAmount));
            }
            
            //Pay cost for owner
            require(bnuToken.transfer(auction.tokenOwner, auction.price - feeAmount));
            
            //Transfer AvatarArtNFT from contract to winner
            getAvatarArtNFT().safeTransferFrom(address(this), auction.winner, auction.tokenId);

            emit Distributed(auction.tokenId, auction.winner, _now());
        }else{//No auction
            //Transfer AvatarArtNFT from contract to owner
            getAvatarArtNFT().safeTransferFrom(address(this), auction.tokenOwner, auction.tokenId);
        }
        
        auction.status = EAuctionStatus.Completed;
        
        return true;
    }
    
    /**
     * @dev Get active auction by `tokenId`
     */ 
    function getActiveAuctionByTokenId(uint256 tokenId) public view returns(bool, Auction memory, uint256){
        for(uint256 index = _auctions.length; index > 0; index--){
            Auction memory auction = _auctions[index - 1];
            if(auction.tokenId == tokenId && auction.status == EAuctionStatus.Open && auction.startTime <= _now() && auction.endTime >= _now())
                return (true, auction, index - 1);
        }
        
        return (false, Auction(0,0,0, address(0), 0, address(0), EAuctionStatus.Open), 0);
    }
    
     /**
     * @dev Get auction infor by `auctionIndex` 
     */
    function getAuction(uint256 auctionIndex) external view returns(Auction memory){
        require(auctionIndex < getAuctionCount());
        return _auctions[auctionIndex];
    }
    
    /**
     * @dev Get all completed auctions for specific `tokenId` with auction winner
     */ 
    function getAuctionWinnersByTokenId(uint256 tokenId) public view returns(Auction[] memory){
        uint256 resultCount = 0;
        for(uint256 index = 0; index < _auctions.length; index++){
            Auction memory auction = _auctions[index];
            if(auction.tokenId == tokenId && auction.status == EAuctionStatus.Completed)
                resultCount++;
        }
        
        if(resultCount == 0)
            return new Auction[](0);
            
        Auction[] memory result = new Auction[](resultCount);
        resultCount = 0;
        for(uint256 index = 0; index < _auctions.length; index++){
            Auction memory auction = _auctions[index];
            if(auction.tokenId == tokenId && auction.status == EAuctionStatus.Completed){
                result[resultCount] = auction;
                resultCount++;
            }
        }
        
        return result;
    }
    
    /**
     * @dev {See - IAvatarArtAuction.place}
     * 
     *  IMPLEMENTATION
     *  1. Validate requirements
     *  2. Add auction histories
     *  3. Update auction
     */ 
    function place(uint256 auctionIndex, uint256 price) external override returns(bool){
        require(auctionIndex < getAuctionCount());
        Auction storage auction = _auctions[auctionIndex];
        require(auction.status == EAuctionStatus.Open && auction.startTime <= _now() && auction.endTime >= _now(), "Invalid auction");
        require(price > auction.price, "Invalid price");
        
        IERC20 bnuToken = getBnuToken();
        //Transfer BNU to contract
        require(bnuToken.transferFrom(_msgSender(), address(this), price),"BNU transferring failed");
        
        //Add auction history
        _auctionHistories[auctionIndex].push(AuctionHistory(_now(), price, _msgSender()));
        
        //If last user exised, pay back BNU token
        if(auction.winner != address(0)){
            require(bnuToken.transfer(auction.winner, auction.price), "Can not payback for last winner");
        }
        
        //Update auction
        auction.winner = _msgSender();
        auction.price = price;
        
        emit NewPlaceSetted(auction.tokenId, auctionIndex, _msgSender(), price);
        
        return true;
    }
    
     /**
     * @dev {See - IAvatarArtAuction.updateActionPrice}
     * 
     */ 
    function updateActionPrice(uint256 auctionIndex, uint256 price) external override onlyOwner returns(bool){
        require(auctionIndex < getAuctionCount());
        Auction storage auction = _auctions[auctionIndex];
        require(auction.startTime > _now());
        auction.price = price;
        
        emit AuctionPriceUpdated(auctionIndex, price);
        return true;
    }
    
    /**
     * @dev {See - IAvatarArtAuction.updateActionTime}
     * 
     */ 
    function updateActionTime(uint256 auctionIndex, uint256 startTime, uint256 endTime) external override onlyOwner returns(bool){
        require(auctionIndex < getAuctionCount());
        Auction storage auction = _auctions[auctionIndex];
        require(auction.startTime > _now());
        auction.startTime = startTime;
        auction.endTime = endTime;
        
        emit AuctionTimeUpdated(auctionIndex, startTime, endTime);
        return true;
    }

    /**
     * @dev Owner withdraws ERC20 token from contract by `tokenAddress`
     */
    function withdrawToken(address tokenAddress) public onlyOwner{
        IERC20 token = IERC20(tokenAddress);
        token.transfer(_owner, token.balanceOf(address(this)));
    }
    
    event NewAuctionCreated(uint256 tokenId, uint256 startTime, uint256 endTime, uint256 price);
    event AuctionPriceUpdated(uint256 auctionIndex, uint256 price);
    event AuctionTimeUpdated(uint256 auctionIndex, uint256 startTime, uint256 endTime);
    event NewPlaceSetted(uint256 tokenId, uint256 auctionIndex, address account, uint256 price);
    event Distributed(uint256 tokenId, address winner, uint256 time);
}
