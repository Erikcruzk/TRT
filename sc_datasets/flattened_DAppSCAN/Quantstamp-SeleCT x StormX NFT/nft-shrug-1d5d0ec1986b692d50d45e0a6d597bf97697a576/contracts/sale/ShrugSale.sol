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

// File: ../sc_datasets/DAppSCAN/Quantstamp-SeleCT x StormX NFT/nft-shrug-1d5d0ec1986b692d50d45e0a6d597bf97697a576/contracts/interfaces/IShrugToken.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @title Shrug ERC-721 Token Interface
 */
interface IShrugToken {
    /**
     * @dev Public Function returns base URI.
     */
    function getBaseURI() external view returns (string memory);

    /**
     * @dev Mint function
     * @param to Address of owner
     * @param tokenId Id of the token
     */
    function mint(
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) external view returns (address);

    /**
     * @dev Burn token function
     * @param tokenId Id of the token
     */
    function burn(
        uint256 tokenId
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-SeleCT x StormX NFT/nft-shrug-1d5d0ec1986b692d50d45e0a6d597bf97697a576/contracts/interfaces/IAggregator.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IAggregator {
  function latestAnswer() external view returns (int256);
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

// File: ../sc_datasets/DAppSCAN/Quantstamp-SeleCT x StormX NFT/nft-shrug-1d5d0ec1986b692d50d45e0a6d597bf97697a576/contracts/curves/Exponential.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract Exponential is Ownable {
    uint256 constant public decimals = 10**18;

    IAggregator public ETHUSDAggregator;
    IAggregator public USDTUSDAggregator;
    IAggregator public STMXUSDAggregator;

    function calculatePrice(
        uint256 totalSupply,
        uint256 currency
    )   public
        view
        returns (uint256)
    {
        if(currency == 0)
            return  decimals * 20477 * (totalSupply + 1) ** 11 / 10 ** 32 + decimals * 2 / 100;

        if(currency == 1)
            return (decimals * 20477 * (totalSupply + 1) ** 11 / 10 ** 32 + decimals * 2 / 100) * uint256(ETHUSDAggregator.latestAnswer()) / uint256(USDTUSDAggregator.latestAnswer()) / 10 ** 12;
            
        return (decimals * 20477 * (totalSupply + 1) ** 11 / 10 ** 32 + decimals * 2 / 100) * uint256(ETHUSDAggregator.latestAnswer()) / uint256(STMXUSDAggregator.latestAnswer());
    }

    /**
     * @dev Owner can set ETH / USD Aggregator contract
     * @param _addr Address of aggregator contract
     */
    function setETHUSDAggregatorContract(address _addr) public onlyOwner {
        ETHUSDAggregator = IAggregator(address(_addr));
    }

    /**
     * @dev Owner can set USDT / USD Aggregator contract
     * @param _addr Address of aggregator contract
     */
    function setUSDTUSDAggregatorContract(address _addr) public onlyOwner {
        USDTUSDAggregator = IAggregator(address(_addr));
    }

    /**
     * @dev Owner can set STMX / USD Aggregator contract
     * @param _addr Address of aggregator contract
     */
    function setSTMXUSDAggregatorContract(address _addr) public onlyOwner {
        STMXUSDAggregator = IAggregator(address(_addr));
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-SeleCT x StormX NFT/nft-shrug-1d5d0ec1986b692d50d45e0a6d597bf97697a576/contracts/sale/ShrugSale.sol

// SPDX-License-Identifier: UNLICENSED
//SWC-Floating Pragma: L3
pragma solidity ^0.8.0;




/**
 * @title Shrug Sale Contract
 */
contract ShrugSale is Exponential {

    /// @notice Event emitted only on construction. To be used by indexers
    event ShrugSaleDeployed();

    /// @notice Recipients update event
    event UpdatedRecipients(
        address[] recipients
    );

    /// @notice Token bought event
    event TokenBought(
        address buyer,
        uint256 tokenId,
        uint256 value,
        string currency
    );

    /// @notice addresses of recipients who received the funds
    address[] public recipients;

    /// @notice ERC721 NFT
    IShrugToken public token;

    /// @notice max supply of token
    uint256 public constant maxSupply = 500;

    /// @notice total supply of token
    uint256 public totalSupply;

    /// @notice USDT token contract
    IERC20 public USDTToken;

    /// @notice STMX token contract
    IERC20 public STMXToken;

    /**
     * @dev Constructor function
     * @param _token Token Instance
     */
    constructor(
        IShrugToken _token
    ) {
        token = _token;

        emit ShrugSaleDeployed();
    }

    /**
     * @dev Set recipients
     * @param _recipients array of recipients' address
     */
    function setRecipients(address[] memory _recipients) external onlyOwner {
        require(
            _recipients.length > 0,
            "ShrugSale: Empty array is provided"
        );
        require(
            _recipients.length <= 2,
            "ShrugSale: Count of recipients can't exceed 2"
        );
        
        for(uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "ShrugSale: Invalid recipient address");
        }

        recipients = _recipients;

        emit UpdatedRecipients(_recipients);
    }

    /**
     * @dev Buy Function in ETH
     * @param _count Count of tokens to buy
     */
     //SWC-Reentrancy: L89-L119
    function buyInETH(uint256 _count) external payable {
        require(
            _count < 100,
            "ShrugSale: Count should be less than 100"
        );
        require(
            (totalSupply + _count) <= maxSupply,
            "ShrugSale: All tokens are minted"
        );

        uint256 price = getPrice(_count, 0);
        require(
            msg.value == price,
            "ShrugSale: Value is not same as the price"
        );

        for(uint256 i = 0; i < recipients.length; i++) {
            (bool transferSuccess, ) = recipients[i].call{value: price / recipients.length}("");
            require(
                transferSuccess,
                "ShrugSale: failed to transfer"
            );
        }

        for(uint256 i = 0; i < _count; i++) {
            totalSupply++;
            token.mint(msg.sender, maxSupply + 1 - totalSupply);
        }

        emit TokenBought(msg.sender, maxSupply + 1 - totalSupply, price, "ETH");
    }

    /**
     * @dev Buy Function in USDT
     * @param _count Count of tokens to buy
     */
    function buyInUSDT(uint256 _count) external {
        require(
            _count < 100,
            "ShrugSale: Count should be less than 100"
        );
        require(
            (totalSupply + _count) <= maxSupply,
            "ShrugSale: All tokens are minted"
        );

        uint256 price = getPrice(_count, 1);
        require(
            USDTToken.balanceOf(msg.sender) >= price,
            "ShrugSale: Caller does not have enough USDT balance"
        );
        require(
            USDTToken.allowance(msg.sender, address(this)) >= price,
            "ShrugSale: Caller has not allowed enough USDT balance"
        );

        for(uint256 i = 0; i < recipients.length; i++) {
            bool transferSuccess = USDTToken.transferFrom(msg.sender, recipients[i], price / recipients.length);
            require(
                transferSuccess,
                "ShrugSale: failed to transfer"
            );
        }

        for(uint256 i = 0; i < _count; i++) {
            totalSupply++;
            token.mint(msg.sender, maxSupply + 1 - totalSupply);
        }

        emit TokenBought(msg.sender, maxSupply + 1 - totalSupply, price, "USDT");
    }

    /**
     * @dev Buy Function in STMX
     * @param _count Count of tokens to buy
     */
    function buyInSTMX(uint256 _count) external {
        require(
            _count < 100,
            "ShrugSale: Count should be less than 100"
        );
        require(
            (totalSupply + _count) <= maxSupply,
            "ShrugSale: All tokens are minted"
        );

        uint256 price = getPrice(_count, 2);
        require(
            STMXToken.balanceOf(msg.sender) >= price,
            "ShrugSale: Caller does not have enough STMX balance"
        );
        require(
            STMXToken.allowance(msg.sender, address(this)) >= price,
            "ShrugSale: Caller has not allowed enough STMX balance"
        );

        for(uint256 i = 0; i < recipients.length; i++) {
            bool transferSuccess = STMXToken.transferFrom(msg.sender, recipients[i], price / recipients.length);
            require(
                transferSuccess,
                "ShrugSale: failed to transfer"
            );
        }

        for(uint256 i = 0; i < _count; i++) {
            totalSupply++;
            token.mint(msg.sender, maxSupply + 1 - totalSupply);
        }

        emit TokenBought(msg.sender, maxSupply + 1 - totalSupply, price, "STMX");
    }

    /**
     * @dev Public get price
     * @param _count Count of tokens which wanna get the price of
     */
    function getPrice(uint256 _count, uint256 currency) public view returns (uint256) {
        require(
            _count < 100,
            "ShrugSale: Count should be less than 100"
        );
        uint256 price;
        for(uint256 i = 0; i < _count; i++) {
            price += calculatePrice(totalSupply + i, currency);
        }

        return price;
    }

    /**
     * @dev Owner can set USDT token contract
     * @param _addr address of USDT token
     */
    function setUSDTTokenContract(address _addr) public onlyOwner {
        USDTToken = IERC20(address(_addr));
    }

    /**
     * @dev Owner can set STMX token contract
     * @param _addr address of STMX token
     */
    function setSTMXTokenContract(address _addr) public onlyOwner {
        STMXToken = IERC20(address(_addr));
    }
}
