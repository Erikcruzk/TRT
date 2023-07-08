// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Governance Crosschain Bridges V3/governance-crosschain-bridges-7f56e7ae63f30ba8dcd7ced6a11a34c2eb865a1d/contracts/dependencies/SafeMath.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, 'SafeMath: addition overflow');

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, 'SafeMath: subtraction overflow');
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, 'SafeMath: multiplication overflow');

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, 'SafeMath: division by zero');
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, 'SafeMath: modulo by zero');
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Governance Crosschain Bridges V3/governance-crosschain-bridges-7f56e7ae63f30ba8dcd7ced6a11a34c2eb865a1d/contracts/interfaces/IBridgeExecutor.sol

//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.5;
pragma abicoder v2;

interface IBridgeExecutor {
  enum ActionsSetState {Queued, Executed, Canceled, Expired}

  struct ActionsSet {
    uint256 id;
    address[] targets;
    uint256[] values;
    string[] signatures;
    bytes[] calldatas;
    bool[] withDelegatecalls;
    uint256 executionTime;
    bool executed;
    bool canceled;
  }

  /**
   * @dev emitted when an ActionsSet is received from the bridge message processor and queued
   * @param id Id of the ActionsSet
   * @param targets list of contracts called by each action's associated transaction
   * @param values list of value in wei for each action's  associated transaction
   * @param signatures list of function signatures (can be empty) to be used when created the callData
   * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
   * @param withDelegatecalls boolean, true = transaction delegatecalls the taget, else calls the target
   * @param executionTime the time these actions can be executed
   **/
  event ActionsSetQueued(
    uint256 id,
    address[] targets,
    uint256[] values,
    string[] signatures,
    bytes[] calldatas,
    bool[] withDelegatecalls,
    uint256 executionTime
  );

  /**
   * @dev emitted when an ActionsSet is executed successfully
   * @param id Id of the ActionsSet
   * @param initiatorExecution address that triggered the ActionsSet execution
   **/
  event ActionsSetExecuted(uint256 id, address indexed initiatorExecution);

  /**
   * @dev emitted when an ActionsSet is cancelled by the guardian
   * @param id Id of the ActionsSet
   **/
  event ActionsSetCanceled(uint256 id);

  /**
   * @dev emitted when a new bridge is set
   * @param bridge address of the new admin
   * @param initiatorChange address of the creator of this change
   **/
  event NewBridge(address bridge, address indexed initiatorChange);

  /**
   * @dev emitted when a new admin is set
   * @param newAdmin address of the new admin
   **/
  event NewAdmin(address newAdmin);

  /**
   * @dev emitted when a new delay (between queueing and execution) is set
   * @param delay new delay
   **/
  event NewDelay(uint256 delay);

  /**
   * @dev Execute the ActionsSet
   * @param actionsSetId id of the ActionsSet to execute
   **/
  function execute(uint256 actionsSetId) external payable;

  /**
   * @dev Cancel the ActionsSet
   * @param actionsSetId id of the ActionsSet to cancel
   **/
  function cancel(uint256 actionsSetId) external;

  /**
   * @dev Set the delay
   * @param delay delay between queue and execution of an ActionSet
   **/
  function setDelay(uint256 delay) external;

  /**
   * @dev Get the ActionsSet by Id
   * @param actionsSetId id of the ActionsSet
   * @return the ActionsSet requested
   **/
  function getActionsSetById(uint256 actionsSetId) external view returns (ActionsSet memory);

  /**
   * @dev Get the current state of an ActionsSet
   * @param actionsSetId id of the ActionsSet
   * @return The current state if the ActionsSet
   **/
  function getActionsSetState(uint256 actionsSetId) external view returns (ActionsSetState);

  /**
   * @dev Returns whether an action (via actionHash) is queued
   * @param actionHash hash of the action to be checked
   * keccak256(abi.encode(target, value, signature, data, executionTime, withDelegatecall))
   * @return true if underlying action of actionHash is queued
   **/
  function isActionQueued(bytes32 actionHash) external view returns (bool);

  /**
   * @dev Getter of the delay between queuing and execution
   * @return The delay in seconds
   **/
  function getDelay() external view returns (uint256);

  /**
   * @dev Getter of grace period constant
   * @return grace period in seconds
   **/
  function GRACE_PERIOD() external view returns (uint256);

  /**
   * @dev Getter of minimum delay constant
   * @return minimum delay in seconds
   **/
  function MINIMUM_DELAY() external view returns (uint256);

  /**
   * @dev Getter of maximum delay constant
   * @return maximum delay in seconds
   **/
  function MAXIMUM_DELAY() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Governance Crosschain Bridges V3/governance-crosschain-bridges-7f56e7ae63f30ba8dcd7ced6a11a34c2eb865a1d/contracts/BridgeExecutorBase.sol

//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.5;
pragma abicoder v2;


abstract contract BridgeExecutorBase is IBridgeExecutor {
  using SafeMath for uint256;

  uint256 public immutable override GRACE_PERIOD;
  uint256 public immutable override MINIMUM_DELAY;
  uint256 public immutable override MAXIMUM_DELAY;

  uint256 private _actionsSetCounter;
  address private _guardian;
  uint256 private _delay;

  mapping(uint256 => ActionsSet) private _actionsSets;
  mapping(bytes32 => bool) private _queuedActions;

  modifier onlyGuardian() {
    require(msg.sender == _guardian, 'ONLY_BY_GUARDIAN');
    _;
  }

  constructor(
    uint256 delay,
    uint256 gracePeriod,
    uint256 minimumDelay,
    uint256 maximumDelay,
    address guardian
  ) {
    require(delay >= minimumDelay, 'DELAY_SHORTER_THAN_MINIMUM');
    require(delay <= maximumDelay, 'DELAY_LONGER_THAN_MAXIMUM');
    _delay = delay;
    GRACE_PERIOD = gracePeriod;
    MINIMUM_DELAY = minimumDelay;
    MAXIMUM_DELAY = maximumDelay;

    _guardian = guardian;

    emit NewDelay(delay);
  }

  /**
   * @dev Execute the ActionsSet
   * @param actionsSetId id of the ActionsSet to execute
   **/
  function execute(uint256 actionsSetId) external payable override {
    require(getActionsSetState(actionsSetId) == ActionsSetState.Queued, 'ONLY_QUEUED_ACTIONS');

    ActionsSet storage actionsSet = _actionsSets[actionsSetId];
    require(block.timestamp >= actionsSet.executionTime, 'TIMELOCK_NOT_FINISHED');

    actionsSet.executed = true;
    for (uint256 i = 0; i < actionsSet.targets.length; i++) {
      _executeTransaction(
        actionsSet.targets[i],
        actionsSet.values[i],
        actionsSet.signatures[i],
        actionsSet.calldatas[i],
        actionsSet.executionTime,
        actionsSet.withDelegatecalls[i]
      );
    }
    emit ActionsSetExecuted(actionsSetId, msg.sender);
  }

  /**
   * @dev Cancel the ActionsSet
   * @param actionsSetId id of the ActionsSet to cancel
   **/
  function cancel(uint256 actionsSetId) external override onlyGuardian {
    ActionsSetState state = getActionsSetState(actionsSetId);
    require(state == ActionsSetState.Queued, 'ONLY_BEFORE_EXECUTED');

    ActionsSet storage actionsSet = _actionsSets[actionsSetId];
    actionsSet.canceled = true;
    for (uint256 i = 0; i < actionsSet.targets.length; i++) {
      _cancelTransaction(
        actionsSet.targets[i],
        actionsSet.values[i],
        actionsSet.signatures[i],
        actionsSet.calldatas[i],
        actionsSet.executionTime,
        actionsSet.withDelegatecalls[i]
      );
    }

    emit ActionsSetCanceled(actionsSetId);
  }

  /**
   * @dev Set the delay
   * @param delay delay between queue and execution of an ActionsSet
   **/
  function setDelay(uint256 delay) public override onlyGuardian {
    _validateDelay(delay);
    _delay = delay;

    emit NewDelay(delay);
  }

  /**
   * @dev Get the ActionsSet by Id
   * @param actionsSetId id of the ActionsSet
   * @return the ActionsSet requested
   **/
  function getActionsSetById(uint256 actionsSetId)
    external
    view
    override
    returns (ActionsSet memory)
  {
    return _actionsSets[actionsSetId];
  }

  /**
   * @dev Get the current state of an ActionsSet
   * @param actionsSetId id of the ActionsSet
   * @return The current state if the ActionsSet
   **/
  function getActionsSetState(uint256 actionsSetId) public view override returns (ActionsSetState) {
    require(_actionsSetCounter >= actionsSetId, 'INVALID_ACTION_ID');
    ActionsSet storage actionsSet = _actionsSets[actionsSetId];
    if (actionsSet.canceled) {
      return ActionsSetState.Canceled;
    } else if (actionsSet.executed) {
      return ActionsSetState.Executed;
    } else if (block.timestamp > actionsSet.executionTime.add(GRACE_PERIOD)) {
      return ActionsSetState.Expired;
    } else {
      return ActionsSetState.Queued;
    }
  }

  /**
   * @dev Returns whether an action (via actionHash) is queued
   * @param actionHash hash of the action to be checked
   * keccak256(abi.encode(target, value, signature, data, executionTime, withDelegatecall))
   * @return true if underlying action of actionHash is queued
   **/
  function isActionQueued(bytes32 actionHash) public view override returns (bool) {
    return _queuedActions[actionHash];
  }

  /**
   * @dev Receive Funds if necessary for delegate calls
   **/
  function receiveFunds() external payable {}

  /**
   * @dev Getter of the delay between queuing and execution
   * @return The delay in seconds
   **/
  function getDelay() external view override returns (uint256) {
    return _delay;
  }

  /**
   * @dev Queue the ActionsSet - only callable by the BridgeMessageProvessor
   * @param targets list of contracts called by each action's associated transaction
   * @param values list of value in wei for each action's  associated transaction
   * @param signatures list of function signatures (can be empty) to be used when created the callData
   * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
   * @param withDelegatecalls boolean, true = transaction delegatecalls the taget, else calls the target
   **/
  function _queue(
    address[] memory targets,
    uint256[] memory values,
    string[] memory signatures,
    bytes[] memory calldatas,
    bool[] memory withDelegatecalls
  ) internal {
    require(targets.length != 0, 'INVALID_EMPTY_TARGETS');
    require(
      targets.length == values.length &&
        targets.length == signatures.length &&
        targets.length == calldatas.length &&
        targets.length == withDelegatecalls.length,
      'INCONSISTENT_PARAMS_LENGTH'
    );

    uint256 actionsSetId = _actionsSetCounter;
    uint256 executionTime = block.timestamp.add(_delay);
    _actionsSetCounter++;

    for (uint256 i = 0; i < targets.length; i++) {
      bytes32 actionHash =
        keccak256(
          abi.encode(
            targets[i],
            values[i],
            signatures[i],
            calldatas[i],
            executionTime,
            withDelegatecalls[i]
          )
        );
      require(!isActionQueued(actionHash), 'DUPLICATED_ACTION');
      // SWC-Presence of unused variables: L203
      _queuedActions[actionHash] = true;
    }

    ActionsSet storage actionsSet = _actionsSets[actionsSetId];
    actionsSet.id = actionsSetId;
    actionsSet.targets = targets;
    actionsSet.values = values;
    actionsSet.signatures = signatures;
    actionsSet.calldatas = calldatas;
    actionsSet.withDelegatecalls = withDelegatecalls;
    actionsSet.executionTime = executionTime;

    emit ActionsSetQueued(
      actionsSetId,
      targets,
      values,
      signatures,
      calldatas,
      withDelegatecalls,
      executionTime
    );
  }

  function _executeTransaction(
    address target,
    uint256 value,
    string memory signature,
    bytes memory data,
    uint256 executionTime,
    bool withDelegatecall
  ) internal {
    bytes32 actionHash =
      keccak256(abi.encode(target, value, signature, data, executionTime, withDelegatecall));
      // SWC-Presence of unused variables: L237
    _queuedActions[actionHash] = false;

    bytes memory callData;

    if (bytes(signature).length == 0) {
      callData = data;
    } else {
      callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
    }

    bool success;
    bytes memory resultData;
    if (withDelegatecall) {
      require(msg.value >= value, 'NOT_ENOUGH_MSG_VALUE');
      // solium-disable-next-line security/no-call-value
      (success, resultData) = target.delegatecall(callData);
    } else {
      // solium-disable-next-line security/no-call-value
      (success, resultData) = target.call{value: value}(callData);
    }

    require(success, 'FAILED_ACTION_EXECUTION');
  }

  function _cancelTransaction(
    address target,
    uint256 value,
    string memory signature,
    bytes memory data,
    uint256 executionTime,
    bool withDelegatecall
  ) internal {
    bytes32 actionHash =
      keccak256(abi.encode(target, value, signature, data, executionTime, withDelegatecall));
      // SWC-Presence of unused variables: L271
    _queuedActions[actionHash] = false;
  }

  function _validateDelay(uint256 delay) internal view {
    require(delay >= MINIMUM_DELAY, 'DELAY_SHORTER_THAN_MINIMUM');
    require(delay <= MAXIMUM_DELAY, 'DELAY_LONGER_THAN_MAXIMUM');
  }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Governance Crosschain Bridges V3/governance-crosschain-bridges-7f56e7ae63f30ba8dcd7ced6a11a34c2eb865a1d/contracts/ArbitrumBridgeExecutor.sol

//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.5;
pragma abicoder v2;

contract ArbitrumBridgeExecutor is BridgeExecutorBase {
  address private immutable _ethereumGovernanceExecutor;

  constructor(
    address ethereumGovernanceExecutor,
    uint256 delay,
    uint256 gracePeriod,
    uint256 minimumDelay,
    uint256 maximumDelay,
    address guardian
  ) BridgeExecutorBase(delay, gracePeriod, minimumDelay, maximumDelay, guardian) {
    _ethereumGovernanceExecutor = ethereumGovernanceExecutor;
  }

  /**
   * @dev Queue the cross-chain message in the BridgeExecutor
   * @param targets list of contracts called by each action's associated transaction
   * @param values list of value in wei for each action's  associated transaction
   * @param signatures list of function signatures (can be empty) to be used when created the callData
   * @param calldatas list of calldatas: if associated signature empty, calldata ready, else calldata is arguments
   * @param withDelegatecalls boolean, true = transaction delegatecalls the taget, else calls the target
   **/
  function queue(
    address[] memory targets,
    uint256[] memory values,
    string[] memory signatures,
    bytes[] memory calldatas,
    bool[] memory withDelegatecalls
  ) external {
    require(msg.sender == _ethereumGovernanceExecutor, 'UNAUTHORIZED_EXECUTOR');
    _queue(targets, values, signatures, calldatas, withDelegatecalls);
  }
}
