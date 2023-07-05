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

// File: ../sc_datasets/DAppSCAN/QuillAudits-Bond Appetit-Bond Appetit/bondappetit-protocol-88680691fe8d872c5fc26e9500d19cf7caaa9861/contracts/depositary/IDepositaryOracle.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/**
 * @title The Depositary Oracle interface.
 */
interface IDepositaryOracle {
    /// @notice Type of security on depositary.
    struct Security {
        // International securities identification number.
        string isin;
        // Amount.
        uint256 amount;
    }

    /**
     * @notice Write a security amount to the storage mapping.
     * @param isin International securities identification number.
     * @param amount Amount of securities.
     */
    function put(string calldata isin, uint256 amount) external;

    /**
     * @notice Get amount securities.
     * @param isin International securities identification number.
     * @return amount Amount of securities.
     */
    function get(string calldata isin) external view returns (Security memory);

    /**
     * @notice Get all depositary securities.
     * @return All securities.
     */
    function all() external view returns (Security[] memory);

    /**
     * @dev Emitted when the depositary update.
     */
    event Update(string isin, uint256 amount);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Bond Appetit-Bond Appetit/bondappetit-protocol-88680691fe8d872c5fc26e9500d19cf7caaa9861/contracts/depositary/DepositaryOracle.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


contract DepositaryOracle is IDepositaryOracle, Ownable {
    /// @dev Securities in depositary.
    mapping(string => Security) private bonds;

    /// @dev ISIN in depositary.
    string[] private keys;

    /// @notice The maximum number of security in this depositary.
    function maxSize() public pure returns (uint256) {
        return 50;
    }

    function put(
        string calldata isin,
        uint256 amount
    ) external override onlyOwner {
        require(keys.length < maxSize(), "DepositaryOracle::put: too many securities");

        bonds[isin] = Security(isin, amount);
        keys.push(isin);
        emit Update(isin, amount);
    }

    function get(string calldata isin) external view override returns (Security memory) {
        return bonds[isin];
    }

    function all() external view override returns (Security[] memory) {
        DepositaryOracle.Security[] memory result = new DepositaryOracle.Security[](keys.length);

        for (uint256 i = 0; i < keys.length; i++) {
            result[i] = bonds[keys[i]];
        }

        return result;
    }
}
