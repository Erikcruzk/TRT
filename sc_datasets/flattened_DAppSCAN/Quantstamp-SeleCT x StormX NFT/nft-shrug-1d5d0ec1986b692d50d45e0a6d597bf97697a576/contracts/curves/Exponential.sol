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
