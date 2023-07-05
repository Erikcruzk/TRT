// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Tracer_Perpetual_Pools_V2/perpetual-pools-contracts-846bbf62652d7c83aee1cf3766275c4d08b00c8a/contracts/interfaces/IPriceObserver.sol

//SPDX-License-Identifier: CC-BY-NC-ND-4.0
pragma solidity 0.8.7;

/// @title The price observer interface
interface IPriceObserver {
    function capacity() external view returns (uint256);

    function length() external view returns (uint256);

    function get(uint256 i) external view returns (int256);

    function getAll() external view returns (int256[24] memory);

    function add(int256 x) external returns (bool);
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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Tracer_Perpetual_Pools_V2/perpetual-pools-contracts-846bbf62652d7c83aee1cf3766275c4d08b00c8a/contracts/implementation/PriceObserver.sol

//SPDX-License-Identifier: CC-BY-NC-ND-4.0
pragma solidity 0.8.7;


contract PriceObserver is Ownable, IPriceObserver {
    uint256 public constant MAX_NUM_ELEMS = 24;
    uint256 public numElems = 0;
    int256[MAX_NUM_ELEMS] public observations;
    address writer = address(0);

    function capacity() public pure override returns (uint256) {
        return MAX_NUM_ELEMS;
    }

    function length() public view override returns (uint256) {
        return numElems;
    }

    function get(uint256 i) public view override returns (int256) {
        require(i < length(), "PO: Out of bounds");
        return observations[i];
    }

    function getAll() public view override returns (int256[24] memory) {
        return observations;
    }

    function add(int256 x) public override onlyWriter returns (bool) {
        if (full()) {
            leftRotateWithPad(x);
            return true;
        } else {
            observations[length()] = x;
            numElems += 1;
            return false;
        }
    }

    function setWriter(address _writer) public onlyOwner {
        require(_writer != address(0), "PO: Null address not allowed");
        writer = _writer;
    }

    function getWriter() public view returns (address) {
        return writer;
    }

    function full() private view returns (bool) {
        return length() == capacity();
    }

    function clear() public onlyOwner {
        numElems = 0;
        delete observations;
    }

    /**
     * @notice Rotates observations array to the **left** by one element and sets the last element of `xs` to `x`
     * @param x Element to "rotate into" observations array
     *
     */
    function leftRotateWithPad(int256 x) private {
        uint256 n = length();

        /* linear scan over the [1, n] subsequence */
        for (uint256 i = 1; i < n; i++) {
            observations[i - 1] = observations[i];
        }

        /* rotate `x` into `observations` from the right (remember, we're **left**
         * rotating -- with padding!) */
        observations[n - 1] = x;
    }

    modifier onlyWriter() {
        require(msg.sender == writer, "PO: Permission denied");
        _;
    }
}
