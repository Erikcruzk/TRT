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

// File: ../sc_datasets/DAppSCAN/Inspex-Admin & Poll/iAM-Admin-Poll-Token-main/interfaces/IERC20Burnable.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IERC20Burnable {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function burn(uint256 amount) external;

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function adminTransfer(
    address,
    address,
    uint256
  ) external returns (bool);

  function transferOwnership(address) external;
}

// File: ../sc_datasets/DAppSCAN/Inspex-Admin & Poll/iAM-Admin-Poll-Token-main/admin/BigOwner.sol

// SPDX-License-Identifier: MIT
// SWC-Outdated Compiler Version: L3
pragma solidity =0.8.4;


contract BigOwner {
  event NewAdmin(address indexed newAdmin, address indexed removeAdmin);
  event PendingAdmin(address indexed newPendingAdmin, address indexed removeAdmin);
  event ApprovePendingAdmin(address indexed newPendingAdmin, address indexed removeAdmin);
  event ExecuteAdminTransfer(
    bytes32 indexed txHash,
    address indexed target,
    address sender,
    address recipient,
    uint256 amount
  );
  event PendingAdminTransfer(
    bytes32 indexed txHash,
    address indexed target,
    address sender,
    address recipient,
    uint256 amount
  );
  event ExecuteTransferOwnership(bytes32 indexed txHash, address indexed target, address indexed newOwner);
  event PendingTransferOwnership(bytes32 indexed txHash, address indexed target, address indexed newOwner);

  uint256 public PANDING_BLOCK; // block
  bytes32 public pendingAdminHash;
  bool public pendingAdminHashApprove;
  address public pendingAdminHashSubmitter;
  uint256 private pendingAdminHashSubmitBlock;
  address[] private adminList;

  mapping(address => bool) public admin;
  mapping(bytes32 => pendingQueue) public queuedTransactions;

  struct pendingQueue {
    uint256 submitedBlock;
    address by;
  }

  modifier onlyOwner() {
    require(admin[msg.sender] == true, 'BigOwner: caller is not the admin');
    _;
  }

  constructor(address[] memory admin_, uint256 deadline_) {
    require(admin_.length >= 2, 'BigOwner: initial admin should more then 1 address.');

    for (uint32 i = 0; i < admin_.length; i++) {
      admin[admin_[i]] = true;
      adminList.push(admin_[i]);
    }

    PANDING_BLOCK = deadline_;
  }

  receive() external payable {}

  function getAdminList() external view returns (address[] memory) {
    return adminList;
  }

  function setDeadline(uint256 deadline_) external onlyOwner {
    PANDING_BLOCK = deadline_;
  }

  function acceptAdmin(address pendingAdmin_, address pendingRemoveAdmin_) public {
    bytes32 txHash = keccak256(abi.encode(pendingAdmin_, pendingRemoveAdmin_));
    require(txHash == pendingAdminHash, 'BigOwner::acceptAdmin: Argument not match pendingAdminHash.');
    require(msg.sender == pendingAdmin_, 'BigOwner::acceptAdmin: Call must come from newAdmin.');
    require(
      pendingAdminHashSubmitBlock + PANDING_BLOCK >= getBlockNumber(),
      "BigOwner::acceptAdmin: PendingAdmin hasn't surpassed pending time."
    );

    admin[pendingAdmin_] = true;
    admin[pendingRemoveAdmin_] = false;

    uint256 removeAdminIndex = 0;
    bool isFound = false;
    for (uint256 i = 0; i < adminList.length; i++) {
      if (adminList[i] == pendingRemoveAdmin_) {
        removeAdminIndex = i;
        isFound = true;
        break;
      }
    }
    assert(isFound);

    adminList[removeAdminIndex] = pendingAdmin_;

    pendingAdminHashSubmitter = address(0);
    pendingAdminHash = '';

    emit NewAdmin(pendingAdmin_, pendingAdmin_);
  }

  function approvePendingAdmin(address pendingAdmin_, address pendingRemoveAdmin_) external onlyOwner returns (bool) {
    bytes32 txHash = keccak256(abi.encode(pendingAdmin_, pendingRemoveAdmin_));
    require(txHash == pendingAdminHash, 'BigOwner::approvePendingAdmin: Argument not match to pendingAdminHash.');
    require(
      msg.sender != pendingAdminHashSubmitter,
      'BigOwner::approvePendingAdmin: Call must not come from pendingAdminHashSubmitter.'
    );

    pendingAdminHashApprove = true;

    emit ApprovePendingAdmin(pendingAdmin_, pendingRemoveAdmin_);
    return true;
  }

  function setPendingAdmin(address pendingAdmin_, address pendingRemoveAdmin_) external onlyOwner {
    // allows one time setting of admin for deployment purposes
    require(admin[pendingRemoveAdmin_] == true, 'BigOwner::setPendingAdmin: pendingRemoveAdmin should be admin.');
    require(admin[pendingAdmin_] == false, 'BigOwner::setPendingAdmin: pendingAdmin should not be admin.');

    bytes32 txHash = keccak256(abi.encode(pendingAdmin_, pendingRemoveAdmin_));
    pendingAdminHashSubmitter = msg.sender;
    pendingAdminHashSubmitBlock = getBlockNumber();
    pendingAdminHashApprove = false;
    pendingAdminHash = txHash;

    emit PendingAdmin(pendingAdmin_, pendingRemoveAdmin_);
  }

  function setPendingTransferOwnership(address target, address newOwner) external onlyOwner returns (bytes32) {
    bytes32 txHash = keccak256(abi.encode(target, newOwner));
    queuedTransactions[txHash] = pendingQueue(getBlockNumber(), msg.sender);

    emit PendingTransferOwnership(txHash, target, newOwner);
    return txHash;
  }

  function setPendingAdminTransfer(
    address target,
    address sender,
    address recipient,
    uint256 amount
  ) external onlyOwner returns (bytes32) {
    bytes32 txHash = keccak256(abi.encode(target, sender, recipient, amount));
    queuedTransactions[txHash] = pendingQueue(getBlockNumber(), msg.sender);

    emit PendingAdminTransfer(txHash, target, sender, recipient, amount);
    return txHash;
  }

  function executeTransferOwnership(address target, address newOwner) external onlyOwner returns (bool) {
    bytes32 txHash = keccak256(abi.encode(target, newOwner));
    require(
      queuedTransactions[txHash].by != address(0),
      "BigOwner::executeTransferOwnership: Transaction hasn't been queued."
    );
    require(
      getBlockNumber() <= queuedTransactions[txHash].submitedBlock + PANDING_BLOCK,
      "BigOwner::executeTransferOwnership: Transaction hasn't surpassed pending time."
    );

    // shoule not execute by queue creator
    require(
      queuedTransactions[txHash].by != msg.sender,
      'BigOwner::executeTransferOwnership: can not execute by queue creator.'
    );

    queuedTransactions[txHash] = pendingQueue(0, address(0));

    IERC20Burnable(target).transferOwnership(newOwner);

    emit ExecuteTransferOwnership(txHash, target, newOwner);

    return true;
  }

  function executeAdminTransfer(
    address target,
    address sender,
    address recipient,
    uint256 amount
  ) external onlyOwner returns (bool) {
    bytes32 txHash = keccak256(abi.encode(target, sender, recipient, amount));
    require(
      queuedTransactions[txHash].by != address(0),
      "BigOwner::executeAdminTransfer: Transaction hasn't been queued."
    );
    require(
      getBlockNumber() <= queuedTransactions[txHash].submitedBlock + PANDING_BLOCK,
      "BigOwner::executeAdminTransfer: Transaction hasn't surpassed pending time."
    );

    // shoule not execute by queue creator
    require(
      queuedTransactions[txHash].by != msg.sender,
      'BigOwner::executeAdminTransfer: can not execute by queue creator.'
    );

    queuedTransactions[txHash] = pendingQueue(0, address(0));

    bool success = IERC20Burnable(target).adminTransfer(sender, recipient, amount);
    require(success, 'BigOwner::executeAdminTransfer: Transaction execution reverted.');

    emit ExecuteAdminTransfer(txHash, target, sender, recipient, amount);

    return success;
  }

  function getBlockNumber() public view returns (uint256) {
    return block.number;
  }
}
