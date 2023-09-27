// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/IPausable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IPausable {
  event Paused(bool _paused);

  function pause(bool _paused) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/utils/Pausable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

abstract contract Pausable is IPausable {
  bool public paused;

  constructor() {}

  modifier notPaused() {
    require(!paused, 'paused');
    _;
  }

  function _pause(bool _paused) internal {
    require(paused != _paused, 'no-change');
    paused = _paused;
    emit Paused(_paused);
  }
}