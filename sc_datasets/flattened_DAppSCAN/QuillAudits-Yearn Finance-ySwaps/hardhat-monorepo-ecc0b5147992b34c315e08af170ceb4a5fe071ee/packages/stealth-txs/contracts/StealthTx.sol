// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/stealth-txs/contracts/interfaces/IStealthVault.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IStealthVault {
  //events
  event Bonded(address indexed _caller, uint256 _amount, uint256 _finalBond);
  event Unbonded(address indexed _caller, uint256 _amount, uint256 _finalBond);
  event ReportedHash(bytes32 _hash, address _reportedBy);
  event PenaltyApplied(bytes32 _hash, address _caller, uint256 _penalty, address _reportedBy);
  event ValidatedHash(bytes32 _hash, address _caller, uint256 _penalty);

  event StealthContractEnabled(address indexed _caller, address _contract);

  event StealthContractsEnabled(address indexed _caller, address[] _contracts);

  event StealthContractDisabled(address indexed _caller, address _contract);

  event StealthContractsDisabled(address indexed _caller, address[] _contracts);

  function isStealthVault() external pure returns (bool);

  // getters
  function eoaAuthCallProtection() external view returns (bool _eoaAuthCallProtection);

  function callers() external view returns (address[] memory _callers);

  function callerContracts(address _caller) external view returns (address[] memory _contracts);

  // global bond
  function gasBuffer() external view returns (uint256 _gasBuffer);

  function totalBonded() external view returns (uint256 _totalBonded);

  function bonded(address _caller) external view returns (uint256 _bond);

  function canUnbondAt(address _caller) external view returns (uint256 _canUnbondAt);

  // global caller
  function caller(address _caller) external view returns (bool _enabled);

  function callerStealthContract(address _caller, address _contract) external view returns (bool _enabled);

  // global hash
  function hashReportedBy(bytes32 _hash) external view returns (address _reportedBy);

  // governor
  function setEoaAuthCallProtection(bool _eoaAuthCallProtection) external;

  function setGasBuffer(uint256 _gasBuffer) external;

  function transferGovernorBond(address _caller, uint256 _amount) external;

  function transferBondToGovernor(address _caller, uint256 _amount) external;

  // caller
  function bond() external payable;

  function startUnbond() external;

  function cancelUnbond() external;

  function unbondAll() external;

  function unbond(uint256 _amount) external;

  function enableStealthContract(address _contract) external;

  function enableStealthContracts(address[] calldata _contracts) external;

  function disableStealthContract(address _contract) external;

  function disableStealthContracts(address[] calldata _contracts) external;

  // stealth-contract
  function validateHash(
    address _caller,
    bytes32 _hash,
    uint256 _penalty
  ) external returns (bool);

  // watcher
  function reportHash(bytes32 _hash) external;

  function reportHashAndPay(bytes32 _hash) external payable;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/stealth-txs/contracts/interfaces/IStealthTx.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IStealthTx {
  event StealthVaultSet(address _stealthVault);
  event PenaltySet(uint256 _penalty);
  event MigratedStealthVault(address _migratedTo);

  function stealthVault() external view returns (address);

  function penalty() external view returns (uint256);

  function setStealthVault(address _stealthVault) external;

  function setPenalty(uint256 _penalty) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/stealth-txs/contracts/StealthTx.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


/*
 * StealthTxAbstract
 */
abstract contract StealthTx is IStealthTx {
  address public override stealthVault;
  uint256 public override penalty = 1 ether;

  constructor(address _stealthVault) {
    _setStealthVault(_stealthVault);
  }

  modifier validateStealthTx(bytes32 _stealthHash) {
    // if not valid, do not revert execution. just return.
    if (!_validateStealthTx(_stealthHash)) return;
    _;
  }

  modifier validateStealthTxAndBlock(bytes32 _stealthHash, uint256 _blockNumber) {
    // if not valid, do not revert execution. just return.
    if (!_validateStealthTxAndBlock(_stealthHash, _blockNumber)) return;
    _;
  }

  function _validateStealthTx(bytes32 _stealthHash) internal returns (bool) {
    return IStealthVault(stealthVault).validateHash(msg.sender, _stealthHash, penalty);
  }

  function _validateStealthTxAndBlock(bytes32 _stealthHash, uint256 _blockNumber) internal returns (bool) {
    require(block.number == _blockNumber, 'ST: wrong block');
    return _validateStealthTx(_stealthHash);
  }

  function _setPenalty(uint256 _penalty) internal {
    require(_penalty > 0, 'ST: zero penalty');
    penalty = _penalty;
    emit PenaltySet(_penalty);
  }

  function _setStealthVault(address _stealthVault) internal {
    require(_stealthVault != address(0), 'ST: zero address');
    require(IStealthVault(_stealthVault).isStealthVault(), 'ST: not stealth vault');
    stealthVault = _stealthVault;
    emit StealthVaultSet(_stealthVault);
  }
}
