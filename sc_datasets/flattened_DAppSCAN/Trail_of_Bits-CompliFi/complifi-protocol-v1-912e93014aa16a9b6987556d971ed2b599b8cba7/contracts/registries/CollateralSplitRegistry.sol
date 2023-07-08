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

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-CompliFi/complifi-protocol-v1-912e93014aa16a9b6987556d971ed2b599b8cba7/contracts/registries/IAddressRegistry.sol

// "SPDX-License-Identifier: GPL-3.0-or-later"

pragma solidity 0.7.6;

interface IAddressRegistry {
    function get(bytes32 _key) external view returns (address);

    function set(address _value) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-CompliFi/complifi-protocol-v1-912e93014aa16a9b6987556d971ed2b599b8cba7/contracts/registries/AddressRegistryParent.sol

// "SPDX-License-Identifier: GPL-3.0-or-later"
pragma solidity 0.7.6;


abstract contract AddressRegistryParent is Ownable, IAddressRegistry {
    mapping(bytes32 => address) internal _registry;

    event AddressAdded(bytes32 _key, address _value);

    function generateKey(address _value)
        public
        view
        virtual
        returns (bytes32 _key)
    {
        return keccak256(abi.encodePacked(_value));
    }

    function set(address _value) external override onlyOwner() {
        bytes32 key = generateKey(_value);
        _check(key, _value);
        emit AddressAdded(key, _value);
        _registry[key] = _value;
    }

    function get(bytes32 _key) external view override returns (address) {
        return _registry[_key];
    }

    function _check(bytes32 _key, address _value) internal virtual {
        require(_value != address(0), "Nullable address");
        require(_registry[_key] == address(0), "Key already exists");
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-CompliFi/complifi-protocol-v1-912e93014aa16a9b6987556d971ed2b599b8cba7/contracts/collateralSplits/ICollateralSplit.sol

// "SPDX-License-Identifier: GPL-3.0-or-later"

pragma solidity 0.7.6;

/// @title Collateral Split interface
/// @notice Contains mathematical functions used to calculate relative claim
/// on collateral of primary and complement assets after settlement.
/// @dev Created independently from specification and published to the CollateralSplitRegistry
interface ICollateralSplit {
    /// @notice Proof of collateral split contract
    /// @dev Verifies that contract is a collateral split contract
    /// @return true if contract is a collateral split contract
    function isCollateralSplit() external pure returns (bool);

    /// @notice Symbol of the collateral split
    /// @dev Should be resolved through CollateralSplitRegistry contract
    /// @return collateral split specification symbol
    function symbol() external pure returns (string memory);

    /// @notice Calcs primary asset class' share of collateral at settlement.
    /// @dev Returns ranged value between 0 and 1 multiplied by 10 ^ 12
    /// @param _underlyingStarts underlying values in the start of Live period
    /// @param _underlyingEndRoundHints specify for each oracle round of the end of Live period
    /// @return _split primary asset class' share of collateral at settlement
    /// @return _underlyingEnds underlying values in the end of Live period
    function split(
        address[] calldata _oracles,
        address[] calldata _oracleIterators,
        int256[] calldata _underlyingStarts,
        uint256 _settleTime,
        uint256[] calldata _underlyingEndRoundHints
    ) external view returns (uint256 _split, int256[] memory _underlyingEnds);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-CompliFi/complifi-protocol-v1-912e93014aa16a9b6987556d971ed2b599b8cba7/contracts/registries/CollateralSplitRegistry.sol

// "SPDX-License-Identifier: GPL-3.0-or-later"

pragma solidity 0.7.6;


contract CollateralSplitRegistry is AddressRegistryParent {
    function generateKey(address _value)
        public
        view
        override
        returns (bytes32 _key)
    {
        require(
            ICollateralSplit(_value).isCollateralSplit(),
            "Should be collateral split"
        );
        return keccak256(abi.encodePacked(ICollateralSplit(_value).symbol()));
    }
}
