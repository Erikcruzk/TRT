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
