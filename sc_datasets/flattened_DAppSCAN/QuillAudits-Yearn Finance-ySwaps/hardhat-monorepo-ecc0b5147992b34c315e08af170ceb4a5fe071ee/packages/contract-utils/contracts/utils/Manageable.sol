// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/IManageable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IManageable {
  event PendingManagerSet(address pendingManager);
  event ManagerAccepted();

  function setPendingManager(address _pendingManager) external;

  function acceptManager() external;

  function manager() external view returns (address _manager);

  function pendingManager() external view returns (address _pendingManager);

  function isManager(address _account) external view returns (bool _isManager);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/utils/Manageable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

abstract contract Manageable is IManageable {
  address public override manager;
  address public override pendingManager;

  constructor(address _manager) {
    require(_manager != address(0), 'manageable/manager-should-not-be-zero-address');
    manager = _manager;
  }

  function _setPendingManager(address _pendingManager) internal {
    require(_pendingManager != address(0), 'manageable/pending-manager-should-not-be-zero-addres');
    pendingManager = _pendingManager;
    emit PendingManagerSet(_pendingManager);
  }

  function _acceptManager() internal {
    manager = pendingManager;
    pendingManager = address(0);
    emit ManagerAccepted();
  }

  function isManager(address _account) public view override returns (bool _isManager) {
    return _account == manager;
  }

  modifier onlyManager() {
    require(isManager(msg.sender), 'manageable/only-manager');
    _;
  }

  modifier onlyPendingManager() {
    require(msg.sender == pendingManager, 'manageable/only-pending-manager');
    _;
  }
}
