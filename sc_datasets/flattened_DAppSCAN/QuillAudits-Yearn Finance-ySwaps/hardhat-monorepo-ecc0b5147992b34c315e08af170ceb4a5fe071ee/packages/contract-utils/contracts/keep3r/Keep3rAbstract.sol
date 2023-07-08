// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/keep3r/IKeep3rV1Helper.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IKeep3rV1Helper {
  function quote(uint256 eth) external view returns (uint256);

  function getFastGas() external view returns (uint256);

  function bonds(address keeper) external view returns (uint256);

  function getQuoteLimit(uint256 gasUsed) external view returns (uint256);

  function getQuoteLimitFor(address origin, uint256 gasUsed) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/keep3r/IKeep3rV1.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;


interface IKeep3rV1 is IERC20 {
  function name() external returns (string memory);

  function KPRH() external view returns (IKeep3rV1Helper);

  function isKeeper(address _keeper) external returns (bool);

  function isMinKeeper(
    address _keeper,
    uint256 _minBond,
    uint256 _earned,
    uint256 _age
  ) external returns (bool);

  function isBondedKeeper(
    address _keeper,
    address _bond,
    uint256 _minBond,
    uint256 _earned,
    uint256 _age
  ) external returns (bool);

  function addKPRCredit(address _job, uint256 _amount) external;

  function addJob(address _job) external;

  function removeJob(address _job) external;

  function addVotes(address voter, uint256 amount) external;

  function removeVotes(address voter, uint256 amount) external;

  function revoke(address keeper) external;

  function worked(address _keeper) external;

  function workReceipt(address _keeper, uint256 _amount) external;

  function receipt(
    address credit,
    address _keeper,
    uint256 _amount
  ) external;

  function receiptETH(address _keeper, uint256 _amount) external;

  function addLiquidityToJob(
    address liquidity,
    address job,
    uint256 amount
  ) external;

  function applyCreditToJob(
    address provider,
    address liquidity,
    address job
  ) external;

  function unbondLiquidityFromJob(
    address liquidity,
    address job,
    uint256 amount
  ) external;

  function removeLiquidityFromJob(address liquidity, address job) external;

  function jobs(address _job) external view returns (bool);

  function jobList(uint256 _index) external view returns (address _job);

  function credits(address _job, address _credit) external view returns (uint256 _amount);

  function liquidityAccepted(address _liquidity) external view returns (bool);

  function liquidityProvided(
    address _provider,
    address _liquidity,
    address _job
  ) external view returns (uint256 _amount);

  function liquidityApplied(
    address _provider,
    address _liquidity,
    address _job
  ) external view returns (uint256 _amount);

  function liquidityAmount(
    address _provider,
    address _liquidity,
    address _job
  ) external view returns (uint256 _amount);

  function liquidityUnbonding(
    address _provider,
    address _liquidity,
    address _job
  ) external view returns (uint256 _amount);

  function liquidityAmountsUnbonding(
    address _provider,
    address _liquidity,
    address _job
  ) external view returns (uint256 _amount);

  function bond(address bonding, uint256 amount) external;

  function activate(address bonding) external;

  function unbond(address bonding, uint256 amount) external;

  function withdraw(address bonding) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/interfaces/keep3r/IKeep3r.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

interface IKeep3r {
  event Keep3rSet(address _keep3r);
  event Keep3rRequirementsSet(address _bond, uint256 _minBond, uint256 _earned, uint256 _age, bool _onlyEOA);

  function keep3r() external view returns (address _keep3r);

  function bond() external view returns (address _bond);

  function minBond() external view returns (uint256 _minBond);

  function earned() external view returns (uint256 _earned);

  function age() external view returns (uint256 _age);

  function onlyEOA() external view returns (bool _onlyEOA);

  function setKeep3r(address _keep3r) external;

  function setKeep3rRequirements(
    address _bond,
    uint256 _minBond,
    uint256 _earned,
    uint256 _age,
    bool _onlyEOA
  ) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/contract-utils/contracts/keep3r/Keep3rAbstract.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;


abstract contract Keep3r is IKeep3r {
  IKeep3rV1 internal _Keep3r;
  address public override bond;
  uint256 public override minBond;
  uint256 public override earned;
  uint256 public override age;
  bool public override onlyEOA;

  constructor(address _keep3r) {
    _setKeep3r(_keep3r);
  }

  // Setters
  function _setKeep3r(address _keep3r) internal {
    _Keep3r = IKeep3rV1(_keep3r);
    emit Keep3rSet(_keep3r);
  }

  function _setKeep3rRequirements(
    address _bond,
    uint256 _minBond,
    uint256 _earned,
    uint256 _age,
    bool _onlyEOA
  ) internal {
    bond = _bond;
    minBond = _minBond;
    earned = _earned;
    age = _age;
    onlyEOA = _onlyEOA;
    emit Keep3rRequirementsSet(_bond, _minBond, _earned, _age, _onlyEOA);
  }

  // Modifiers
  // Only checks if caller is a valid keeper, payment should be handled manually
  modifier onlyKeeper(address _keeper) {
    _isKeeper(_keeper);
    _;
  }

  // view
  function keep3r() external view override returns (address _keep3r) {
    return address(_Keep3r);
  }

  // handles default payment after execution
  modifier paysKeeper(address _keeper) {
    _;
    _paysKeeper(_keeper);
  }

  // Internal helpers
  function _isKeeper(address _keeper) internal {
    if (onlyEOA) require(_keeper == tx.origin, 'keep3r::isKeeper:keeper-is-not-eoa');
    if (minBond == 0 && earned == 0 && age == 0) {
      // If no custom keeper requirements are set, just evaluate if sender is a registered keeper
      require(_Keep3r.isKeeper(_keeper), 'keep3r::isKeeper:keeper-is-not-registered');
    } else {
      if (bond == address(0)) {
        // Checks for min KP3R, earned and age.
        require(_Keep3r.isMinKeeper(_keeper, minBond, earned, age), 'keep3r::isKeeper:keeper-not-min-requirements');
      } else {
        // Checks for min custom-bond, earned and age.
        require(_Keep3r.isBondedKeeper(_keeper, bond, minBond, earned, age), 'keep3r::isKeeper:keeper-not-custom-min-requirements');
      }
    }
  }

  function _getQuoteLimitFor(address _for, uint256 _initialGas) internal view returns (uint256 _credits) {
    return _Keep3r.KPRH().getQuoteLimitFor(_for, _initialGas - gasleft());
  }

  // pays in bonded KP3R after execution
  function _paysKeeper(address _keeper) internal {
    _Keep3r.worked(_keeper);
  }

  // pays _amount in KP3R after execution
  function _paysKeeperInTokens(address _keeper, uint256 _amount) internal {
    _Keep3r.receipt(address(_Keep3r), _keeper, _amount);
  }

  // pays _amount in bonded KP3R after execution
  function _paysKeeperAmount(address _keeper, uint256 _amount) internal {
    _Keep3r.workReceipt(_keeper, _amount);
  }

  // pays _amount in _credit after execution
  function _paysKeeperCredit(
    address _credit,
    address _keeper,
    uint256 _amount
  ) internal {
    _Keep3r.receipt(_credit, _keeper, _amount);
  }

  // pays _amount in ETH after execution
  function _paysKeeperEth(address _keeper, uint256 _amount) internal {
    _Keep3r.receiptETH(_keeper, _amount);
  }
}
