// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/IGovernable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IGovernable {
  event PendingGovernorSet(address pendingGovernor);
  event GovernorAccepted();

  function setPendingGovernor(address _pendingGovernor) external;

  function acceptGovernor() external;

  function governor() external view returns (address _governor);

  function pendingGovernor() external view returns (address _pendingGovernor);

  function isGovernor(address _account) external view returns (bool _isGovernor);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/ICollectableDust.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface ICollectableDust {
  event DustSent(address _to, address token, uint256 amount);

  function sendDust(
    address _to,
    address _token,
    uint256 _amount
  ) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/IPausable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IPausable {
  event Paused(bool _paused);

  function pause(bool _paused) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/abstract/IUtilsReady.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;



interface IUtilsReady is IGovernable, ICollectableDust, IPausable {}
