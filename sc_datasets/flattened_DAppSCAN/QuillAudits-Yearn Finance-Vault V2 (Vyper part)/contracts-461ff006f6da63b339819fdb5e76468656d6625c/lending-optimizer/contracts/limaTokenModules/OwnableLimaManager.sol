// File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract ContextUpgradeSafe is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.

    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {


    }


    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/limaTokenModules/OwnableLimaManager.sol

pragma solidity ^0.6.6;


// import "@openzeppelin/upgrades/contracts/Initializable.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an limaManager) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the limaManager account will be the one that deploys the contract. This
 * can later be changed with {transferLimaManagerOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyLimaManager`, which can be applied to your functions to restrict their use to
 * the limaManager.
 */
contract OwnableLimaManager is Initializable {
    address private _limaManager;

    event LimaManagerOwnershipTransferred(address indexed previousLimaManager, address indexed newLimaManager);

    /**
     * @dev Initializes the contract setting the deployer as the initial limaManager.
     */

    function __OwnableLimaManager_init_unchained() internal initializer {
        address msgSender = msg.sender;
        _limaManager = msgSender;
        emit LimaManagerOwnershipTransferred(address(0), msgSender);

    }


    /**
     * @dev Returns the address of the current limaManager.
     */
    function limaManager() public view returns (address) {
        return _limaManager;
    }

    /**
     * @dev Throws if called by any account other than the limaManager.
     */
    modifier onlyLimaManager() {
        require(_limaManager == msg.sender, "OwnableLimaManager: caller is not the limaManager");
        _;
    }

    /**
     * @dev Transfers limaManagership of the contract to a new account (`newLimaManager`).
     * Can only be called by the current limaManager.
     */
    function transferLimaManagerOwnership(address newLimaManager) public virtual onlyLimaManager {
        require(newLimaManager != address(0), "OwnableLimaManager: new limaManager is the zero address");
        emit LimaManagerOwnershipTransferred(_limaManager, newLimaManager);
        _limaManager = newLimaManager;
    }

}
