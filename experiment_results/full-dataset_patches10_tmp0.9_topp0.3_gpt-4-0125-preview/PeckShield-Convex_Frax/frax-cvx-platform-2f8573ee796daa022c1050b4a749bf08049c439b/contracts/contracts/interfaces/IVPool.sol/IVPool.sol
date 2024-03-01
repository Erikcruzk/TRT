// File: ../sc_datasets/DAppSCAN/PeckShield-Convex_Frax/frax-cvx-platform-2f8573ee796daa022c1050b4a749bf08049c439b/contracts/contracts/interfaces/IVPool.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

//vesper pool interface
interface IVPool {
  function DOMAIN_SEPARATOR() external view returns (bytes32);
  function MAX_BPS() external view returns (uint256);
  function VERSION() external view returns (string memory);
  function acceptGovernorship() external;
  function addInList(address _listToUpdate, address _addressToAdd) external;
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function availableCreditLimit(address _strategy) external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function convertFrom18(uint256 _amount) external view returns (uint256);
  function decimalConversionFactor() external view returns (uint256);
  function decimals() external view returns (uint8);
  function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
  function deposit(uint256 _amount) external;
  function depositWithPermit(uint256 _amount, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external;
  function excessDebt(address _strategy) external view returns (uint256);
  function feeCollector() external view returns (address);
  function feeWhitelist() external view returns (address);
  function getStrategies() external view returns (address[] memory);
  function getWithdrawQueue() external view returns (address[] memory);
  function governor() external view returns (address);
  function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
  function initialize(string memory _name, string memory _symbol, address _token, address _poolAccountant, address _addressListFactory) external;
  function keepers() external view returns (address);
  function maintainers() external view returns (address);
  function migrateStrategy(address _old, address _new) external;
  function multiTransfer(address[] memory _recipients, uint256[] memory _amounts) external returns (bool);
  function name() external view returns (string memory);
  function nonces(address) external view returns (uint256);
  function open() external;
  function pause() external;
  function paused() external view returns (bool);
  function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
  function poolAccountant() external view returns (address);
  function poolRewards() external view returns (address);
  function pricePerShare() external view returns (uint256);
  function removeFromList(address _listToUpdate, address _addressToRemove) external;
  function reportEarning(uint256 _profit, uint256 _loss, uint256 _payback) external;
  function reportLoss(uint256 _loss) external;
  function shutdown() external;
  function stopEverything() external view returns (bool);
  function strategy(address _strategy) external view returns (bool _active, uint256 _interestFee, uint256 _debtRate, uint256 _lastRebalance, uint256 _totalDebt, uint256 _totalLoss, uint256 _totalProfit, uint256 _debtRatio);
  function sweepERC20(address _fromToken) external;
  function symbol() external view returns (string memory);
  function token() external view returns (address);
  function tokensHere() external view returns (uint256);
  function totalDebt() external view returns (uint256);
  function totalDebtOf(address _strategy) external view returns (uint256);
  function totalDebtRatio() external view returns (uint256);
  function totalSupply() external view returns (uint256);
  function totalValue() external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  function transferGovernorship(address _proposedGovernor) external;
  function unpause() external;
  function updateFeeCollector(address _newFeeCollector) external;
  function updatePoolRewards(address _newPoolRewards) external;
  function updateWithdrawFee(uint256 _newWithdrawFee) external;
  function whitelistedWithdraw(uint256 _shares) external;
  function withdraw(uint256 _shares) external;
  function withdrawFee() external view returns (uint256);
}