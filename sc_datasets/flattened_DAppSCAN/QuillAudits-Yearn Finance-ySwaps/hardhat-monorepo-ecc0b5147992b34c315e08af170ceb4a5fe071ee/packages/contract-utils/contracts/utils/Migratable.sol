// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/IMigratable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IMigratable {
  event Migrated(address _to);

  function migratedTo() external view returns (address _to);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/utils/Migratable.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

abstract contract Migratable is IMigratable {
  address public override migratedTo;

  constructor() {}

  modifier notMigrated() {
    require(migratedTo == address(0), 'migrated');
    _;
  }

  function _migrated(address _to) internal {
    require(migratedTo == address(0), 'already-migrated');
    require(_to != address(0), 'migrate-to-address-0');
    migratedTo = _to;
    emit Migrated(_to);
  }
}
