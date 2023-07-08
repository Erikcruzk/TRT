// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/security/Pausable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/proxy/Clones.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (proxy/Clones.sol)

pragma solidity ^0.8.0;

/**
 * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
 * deploying minimal proxy contracts, also known as "clones".
 *
 * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
 * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
 *
 * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
 * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
 * deterministic method.
 *
 * _Available since v3.4._
 */
library Clones {
    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create opcode, which should never revert.
     */
    function clone(address implementation) internal returns (address instance) {
        /// @solidity memory-safe-assembly
        assembly {
            // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
            // of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0xe8, shl(0x60, implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
            mstore(0x20, or(shl(0x78, implementation), 0x5af43d82803e903d91602b57fd5bf3))
            instance := create(0, 0x09, 0x37)
        }
        require(instance != address(0), "ERC1167: create failed");
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple time will revert, since
     * the clones cannot be deployed twice at the same address.
     */
    function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
        /// @solidity memory-safe-assembly
        assembly {
            // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
            // of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0xe8, shl(0x60, implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
            mstore(0x20, or(shl(0x78, implementation), 0x5af43d82803e903d91602b57fd5bf3))
            instance := create2(0, 0x09, 0x37, salt)
        }
        require(instance != address(0), "ERC1167: create2 failed");
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(add(ptr, 0x38), deployer)
            mstore(add(ptr, 0x24), 0x5af43d82803e903d91602b57fd5bf3ff)
            mstore(add(ptr, 0x14), implementation)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73)
            mstore(add(ptr, 0x58), salt)
            mstore(add(ptr, 0x78), keccak256(add(ptr, 0x0c), 0x37))
            predicted := keccak256(add(ptr, 0x43), 0x55)
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt
    ) internal view returns (address predicted) {
        return predictDeterministicAddress(implementation, salt, address(this));
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/Types.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface Types {
    struct Fee{
        uint16 total;
        uint16 operators;
        uint16 developers;
        uint16 treasury;
    }

    struct Stash {
        bytes32 stashAccount;
        uint64  eraId;
    }

    enum LedgerStatus {
        // bonded but not participate in staking
        Idle,
        // participate as nominator
        Nominator,
        // participate as validator
        Validator,
        // not bonded not participate in staking
        None
    }

    struct UnlockingChunk {
        uint128 balance;
        uint64 era;
    }

    struct OracleData {
        bytes32 stashAccount;
        bytes32 controllerAccount;
        LedgerStatus stakeStatus;
        // active part of stash balance
        uint128 activeBalance;
        // locked for stake stash balance.
        uint128 totalBalance;
        // totalBalance = activeBalance + sum(unlocked.balance)
        UnlockingChunk[] unlocking;
        uint32[] claimedRewards;
        // stash account balance. It includes locked (totalBalance) balance assigned
        // to a controller.
        uint128 stashBalance;
    }

    struct RelaySpec {
        uint64 genesisTimestamp;
        uint64 secondsPerEra;
        uint64 unbondingPeriod;
        uint16 maxValidatorsPerLedger;
        uint128 minNominatorBalance;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/IOracle.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IOracle {
    function initialize(address oracleMaster, address ledger) external;

    function reportRelay(uint256 index, uint256 quorum, uint64 eraId, Types.OracleData calldata staking) external;

    function softenQuorum(uint8 quorum, uint64 _eraId) external;

    function clearReporting() external;

    function isReported(uint256 index) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/ILido.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ILido {
    function distributeRewards(uint256 totalRewards, uint256 ledgerBalance) external;

    function distributeLosses(uint256 totalLosses, uint256 ledgerBalance) external;

    function getStashAccounts() external view returns (bytes32[] memory);

    function getLedgerAddresses() external view returns (address[] memory);

    function ledgerStake(address ledger) external view returns (uint256);

    function avaliableForStake() external view returns (uint256);

    function flushStakes() external;

    function findLedger(bytes32 stash) external view returns (address);

    function AUTH_MANAGER() external returns(address);

    function ORACLE_MASTER() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/ILedger.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ILedger {
    function initialize(
        bytes32 stashAccount,
        bytes32 controllerAccount,
        address vKSM,
        address controller,
        uint128 minNominatorBalance
    ) external;

    function pushData(uint64 eraId, Types.OracleData calldata staking) external;

    function nominate(bytes32[] calldata validators) external;

    function status() external view returns (Types.LedgerStatus);

    function isEmpty() external view returns (bool);

    function stashAccount() external view returns (bytes32);

    function totalBalance() external view returns (uint128);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/IAuthManager.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAuthManager {
    function has(bytes32 role, address member) external view returns (bool);

    function add(bytes32 role, address member) external;

    function remove(bytes32 role, address member) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/contracts/utils/LedgerUtils.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library LedgerUtils {
    /// @notice Return unlocking and withdrawable balances
    function getTotalUnlocking(Types.OracleData memory report, uint64 _eraId) internal pure returns (uint128, uint128) {
        uint128 _total = 0;
        uint128 _withdrawble = 0;
        for (uint i = 0; i < report.unlocking.length; i++) {
            _total += report.unlocking[i].balance;
            if (report.unlocking[i].era <= _eraId) {
                _withdrawble += report.unlocking[i].balance;
            }
        }
        return (_total, _withdrawble);
    }
    /// @notice Return stash balance that can be freely transfer or allocated for stake
    function getFreeBalance(Types.OracleData memory report) internal pure returns (uint128) {
        return report.stashBalance - report.totalBalance;
    }

    /// @notice Return true if report is consistent
    function isConsistent(Types.OracleData memory report) internal pure returns (bool) {
        (uint128 _total,) = getTotalUnlocking(report, 0);
        return report.unlocking.length < type(uint8).max
            && report.totalBalance == (report.activeBalance + _total)
            && report.stashBalance >= report.totalBalance;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/contracts/OracleMaster.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma abicoder v2;





contract OracleMaster is Pausable {
    using Clones for address;
    using LedgerUtils for Types.OracleData;

    event MemberAdded(address member);
    event MemberRemoved(address member);
    event QuorumChanged(uint8 QUORUM);

    // current era id
    uint64 public eraId;

    // Oracle members
    address[] public members;

    // ledger -> oracle pairing
    mapping(address => address) private oracleForLedger;


    // address of oracle clone template contract
    address public ORACLE_CLONE;

    // Lido smart contract
    address public LIDO;

    // Quorum threshold
    uint8 public QUORUM;

    // Relay genesis timestamp
    uint64 public RELAY_GENESIS_TIMESTAMP;

    // Relay seconds per era
    uint64 public RELAY_SECONDS_PER_ERA;


    /// Maximum number of oracle committee members
    uint256 public constant MAX_MEMBERS = 255;

    // Missing member index
    uint256 internal constant MEMBER_NOT_FOUND = type(uint256).max;

    // General oracle manager role
    bytes32 internal constant ROLE_ORACLE_MANAGER = keccak256("ROLE_ORACLE_MANAGER");

    // Oracle members manager role
    bytes32 internal constant ROLE_ORACLE_MEMBERS_MANAGER = keccak256("ROLE_ORACLE_MEMBERS_MANAGER");

    // Oracle members manager role
    bytes32 internal constant ROLE_ORACLE_QUORUM_MANAGER = keccak256("ROLE_ORACLE_QUORUM_MANAGER");


    modifier auth(bytes32 role) {
        require(IAuthManager(ILido(LIDO).AUTH_MANAGER()).has(role, msg.sender), "OM: UNAUTHOROZED");
        _;
    }

    modifier onlyLido() {
        require(msg.sender == LIDO, "OM: CALLER_NOT_LIDO");
        _;
    }


    /**
    * @notice Initialize oracle master contract, allowed to call only once
    * @param _oracleClone oracle clone contract address
    * @param _quorum inital quorum threshold
    */
    function initialize(
        address _oracleClone,
        uint8 _quorum
    ) external {
        require(ORACLE_CLONE == address(0), "OM: ALREADY_INITIALIZED");

        ORACLE_CLONE = _oracleClone;
        QUORUM = _quorum;
    }

    /**
    * @notice Set lido contract address, allowed to only once
    * @param _lido lido contract address
    */
    function setLido(address _lido) external {
        require(LIDO == address(0), "OM: LIDO_ALREADY_DEFINED");
        LIDO = _lido;
    }

    /**
    * @notice Set relaychain params required for oracles, allowed to call only by lido contract
    * @param _relayGenesisTs relaychain genesis timestamp
    * @param _relaySecondsPerEra relaychain era duratation in seconds
    */
    function setRelayParams(uint64 _relayGenesisTs, uint64 _relaySecondsPerEra) external onlyLido {
        RELAY_GENESIS_TIMESTAMP = _relayGenesisTs;
        RELAY_SECONDS_PER_ERA = _relaySecondsPerEra;
    }

    /**
    * @notice Set the number of exactly the same reports needed to finalize the era
              allowed to call only by ROLE_ORACLE_QUORUM_MANAGER
    * @param _quorum new value of quorum threshold
    */
    function setQuorum(uint8 _quorum) external auth(ROLE_ORACLE_QUORUM_MANAGER) {
        require(0 != _quorum, "OM: QUORUM_WONT_BE_MADE");
        uint8 oldQuorum = QUORUM;
        QUORUM = _quorum;

        // If the QUORUM value lowered, check existing reports whether it is time to push
        if (oldQuorum > _quorum) {
            address[] memory ledgers = ILido(LIDO).getLedgerAddresses();
            uint256 _length = ledgers.length;
            for (uint256 i = 0; i < _length; ++i) {
                address oracle = oracleForLedger[ledgers[i]];
                if (oracle != address(0)) {
                    IOracle(oracle).softenQuorum(_quorum, eraId);
                }
            }
        }
        emit QuorumChanged(_quorum);
    }

    /**
    * @notice Return oracle contract for the given ledger
    * @param  _ledger ledger contract address
    * @return linked oracle address
    */
    function getOracle(address _ledger) external view returns (address) {
        return oracleForLedger[_ledger];
    }

    /**
    * @notice Return current Era according to relay chain spec
    * @return current era id
    */
    function getCurrentEraId() public view returns (uint64) {
        return _getCurrentEraId();
    }

    /**
    * @notice Return relay chain stash account addresses
    * @return Array of bytes32 relaychain stash accounts
    */
    function getStashAccounts() external view returns (bytes32[] memory) {
        return ILido(LIDO).getStashAccounts();
    }

    /**
    * @notice Return last reported era and oracle is already reported indicator
    * @param _oracleMember - oracle member address
    * @param _stash - stash account id
    * @return lastEra - last reported era
    * @return isReported - true if oracle member already reported for given stash, else false
    */
    function isReportedLastEra(address _oracleMember, bytes32 _stash)
        external
        view
        returns (
            uint64 lastEra,
            bool isReported
        )
    {
        uint64 lastEra = eraId;

        uint256 memberIdx = _getMemberId(_oracleMember);
        if (memberIdx == MEMBER_NOT_FOUND) {
            return (lastEra, false);
        }

        address ledger = ILido(LIDO).findLedger(_stash);
        if (ledger == address(0)) {
            return (lastEra, false);
        }

        return (lastEra, IOracle(oracleForLedger[ledger]).isReported(memberIdx));
    }

    /**
    * @notice Stop pool routine operations (reportRelay), allowed to call only by ROLE_ORACLE_MANAGER
    */
    function pause() external auth(ROLE_ORACLE_MANAGER) {
        _pause();
    }

    /**
    * @notice Resume pool routine operations (reportRelay), allowed to call only by ROLE_ORACLE_MANAGER
    */
    function resume() external auth(ROLE_ORACLE_MANAGER) {
        _unpause();
    }

    /**
    * @notice Add new member to the oracle member committee list, allowed to call only by ROLE_ORACLE_MEMBERS_MANAGER
    * @param _member proposed member address
    */
    function addOracleMember(address _member) external auth(ROLE_ORACLE_MEMBERS_MANAGER) {
        require(address(0) != _member, "OM: BAD_ARGUMENT");
        require(MEMBER_NOT_FOUND == _getMemberId(_member), "OM: MEMBER_EXISTS");
        require(members.length < 254, "OM: MEMBERS_TOO_MANY");

        members.push(_member);
        require(members.length < MAX_MEMBERS, "OM: TOO_MANY_MEMBERS");
        emit MemberAdded(_member);
    }

    /**
    * @notice Remove `_member` from the oracle member committee list, allowed to call only by ROLE_ORACLE_MEMBERS_MANAGER
    */
    function removeOracleMember(address _member) external auth(ROLE_ORACLE_MEMBERS_MANAGER) {
        uint256 index = _getMemberId(_member);
        require(index != MEMBER_NOT_FOUND, "OM: MEMBER_NOT_FOUND");
        uint256 last = members.length - 1;
        if (index != last) members[index] = members[last];
        members.pop();
        emit MemberRemoved(_member);

        // delete the data for the last eraId, let remained oracles report it again
        _clearReporting();
    }

    /**
    * @notice Add ledger to oracle set, allowed to call only by lido contract
    * @param _ledger Ledger contract
    */
    function addLedger(address _ledger) external onlyLido {
        require(ORACLE_CLONE != address(0), "OM: ORACLE_CLONE_UNINITIALIZED");
        IOracle newOracle = IOracle(ORACLE_CLONE.cloneDeterministic(bytes32(uint256(uint160(_ledger)) << 96)));
        newOracle.initialize(address(this), _ledger);
        oracleForLedger[_ledger] = address(newOracle);
    }

    /**
    * @notice Remove ledger from oracle set, allowed to call only by lido contract
    * @param _ledger ledger contract
    */
    function removeLedger(address _ledger) external onlyLido {
        oracleForLedger[_ledger] = address(0);
    }

    /**
    * @notice Accept oracle committee member reports from the relay side
    * @param _eraId relaychain era
    * @param _report relaychain data report
    */
    function reportRelay(uint64 _eraId, Types.OracleData calldata _report) external whenNotPaused {
        require(_report.isConsistent(), "OM: INCORRECT_REPORT");

        uint256 memberIndex = _getMemberId(msg.sender);
        require(memberIndex != MEMBER_NOT_FOUND, "OM: MEMBER_NOT_FOUND");

        address ledger = ILido(LIDO).findLedger(_report.stashAccount);
        address oracle = oracleForLedger[ledger];
        require(oracle != address(0), "OM: ORACLE_FOR_LEDGER_NOT_FOUND");
        require(_eraId >= eraId, "OM: ERA_TOO_OLD");

        // new era
        if (_eraId > eraId) {
            require(_eraId <= _getCurrentEraId(), "OM: UNEXPECTED_NEW_ERA");
            eraId = _eraId;
            _clearReporting();
            ILido(LIDO).flushStakes();
        }

        IOracle(oracle).reportRelay(memberIndex, QUORUM, _eraId, _report);
    }

    /**
    * @notice Return oracle instance index in the member array
    * @param _member member address
    * @return member index
    */
    function _getMemberId(address _member) internal view returns (uint256) {
        uint256 length = members.length;
        for (uint256 i = 0; i < length; ++i) {
            if (members[i] == _member) {
                return i;
            }
        }
        return MEMBER_NOT_FOUND;
    }

    /**
    * @notice Calculate current expected era id
    * @dev Calculation based on relaychain genesis timestamp and era duratation
    * @return current era id
    */
    function _getCurrentEraId() internal view returns (uint64) {
        return (uint64(block.timestamp) - RELAY_GENESIS_TIMESTAMP ) / RELAY_SECONDS_PER_ERA;
    }

    /**
    * @notice Delete interim data for current Era, free storage memory for each oracle
    */
    function _clearReporting() internal {
        address[] memory ledgers = ILido(LIDO).getLedgerAddresses();
        uint256 _length = ledgers.length;
        for (uint256 i = 0; i < _length; ++i) {
            address oracle = oracleForLedger[ledgers[i]];
            if (oracle != address(0)) {
                IOracle(oracle).clearReporting();
            }
        }
    }
}
