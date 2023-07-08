// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/utils/IGasPriceLimited.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IGasPriceLimited {
  event SetMaxGasPrice(uint256 _maxGasPrice);

  function maxGasPrice() external view returns (uint256 _maxGasPrice);

  function setMaxGasPrice(uint256 _maxGasPrice) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/keep3r/IChainLinkFeed.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IChainLinkFeed {
  function latestAnswer() external view returns (int256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/utils/GasPriceLimited.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


abstract contract GasPriceLimited is IGasPriceLimited {
  IChainLinkFeed public constant FASTGAS = IChainLinkFeed(0x169E633A2D1E6c10dD91238Ba11c4A708dfEF37C);

  uint256 public override maxGasPrice;

  // solhint-disable-next-line no-empty-blocks
  constructor() {}

  // MaxGasPrice
  function _setMaxGasPrice(uint256 _maxGasPrice) internal {
    maxGasPrice = _maxGasPrice;
    emit SetMaxGasPrice(_maxGasPrice);
  }

  modifier limitGasPrice() {
    require(uint256(FASTGAS.latestAnswer()) <= maxGasPrice, 'GasPriceLimited::limit-gas-price:gas-price-exceed-max');
    _;
  }
}
