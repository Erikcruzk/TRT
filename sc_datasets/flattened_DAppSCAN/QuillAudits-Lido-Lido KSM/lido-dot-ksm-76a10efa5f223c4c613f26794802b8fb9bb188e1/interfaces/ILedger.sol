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