// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/utils/IOnlyStealthRelayer.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IOnlyStealthRelayer {
  event StealthRelayerSet(address _stealthRelayer);

  function setStealthRelayer(address _stealthRelayer) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/utils/OnlyStealthRelayer.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

/*
 * OnlyStealthRelayerAbstract
 */
abstract contract OnlyStealthRelayer is IOnlyStealthRelayer {
  address public stealthRelayer;

  constructor(address _stealthRelayer) {
    _setStealthRelayer(_stealthRelayer);
  }

  modifier onlyStealthRelayer() {
    require(msg.sender == stealthRelayer, 'OnlyStealthRelayer::msg-sender-not-stealth-relayer');
    _;
  }

  function _setStealthRelayer(address _stealthRelayer) internal {
    stealthRelayer = _stealthRelayer;
    emit StealthRelayerSet(_stealthRelayer);
  }
}
