// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/interfaces/MForcedWithdrawalActionState.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MForcedWithdrawalActionState {
    function forcedWithdrawActionHash(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) internal pure virtual returns (bytes32);

    function clearForcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) internal virtual;

    // NOLINTNEXTLINE: external-function.
    function getForcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) public view virtual returns (uint256 res);

    function setForcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount,
        bool premiumCost
    ) internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/libraries/LibConstants.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract LibConstants {
    // Durations for time locked mechanisms (in seconds).
    // Note that it is known that miners can manipulate block timestamps
    // up to a deviation of a few seconds.
    // This mechanism should not be used for fine grained timing.

    // The time required to cancel a deposit, in the case the operator does not move the funds
    // to the off-chain storage.
    uint256 public constant DEPOSIT_CANCEL_DELAY = 2 days;

    // The time required to freeze the exchange, in the case the operator does not execute a
    // requested full withdrawal.
    uint256 public constant FREEZE_GRACE_PERIOD = 7 days;

    // The time after which the exchange may be unfrozen after it froze. This should be enough time
    // for users to perform escape hatches to get back their funds.
    uint256 public constant UNFREEZE_DELAY = 365 days;

    // Maximal number of verifiers which may co-exist.
    uint256 public constant MAX_VERIFIER_COUNT = uint256(64);

    // The time required to remove a verifier in case of a verifier upgrade.
    uint256 public constant VERIFIER_REMOVAL_DELAY = FREEZE_GRACE_PERIOD + (21 days);

    address constant ZERO_ADDRESS = address(0x0);

    uint256 constant K_MODULUS = 0x800000000000011000000000000000000000000000000000000000000000001;

    uint256 constant K_BETA = 0x6f21413efbe40de150e596d72f7a8c5609ad26c15c915c1f4cdfcb99cee9e89;

    uint256 internal constant MASK_250 =
        0x03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    uint256 internal constant MASK_240 =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    uint256 public constant MAX_FORCED_ACTIONS_REQS_PER_BLOCK = 10;

    uint256 constant QUANTUM_UPPER_BOUND = 2**128;
    uint256 internal constant MINTABLE_ASSET_ID_FLAG = 1 << 250;

    // The 64th bit (indexed 63, counting from 0) is a flag indicating a rollup vault id.
    uint256 constant ROLLUP_VAULTS_BIT = 63;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/PerpetualConstants.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract PerpetualConstants is LibConstants {
    uint256 constant PERPETUAL_POSITION_ID_UPPER_BOUND = 2**64;
    uint256 constant PERPETUAL_AMOUNT_UPPER_BOUND = 2**64;
    uint256 constant PERPETUAL_TIMESTAMP_BITS = 32;
    uint256 constant PERPETUAL_ASSET_ID_UPPER_BOUND = 2**120;
    uint256 constant PERPETUAL_SYSTEM_TIME_LAG_BOUND = 7 days;
    uint256 constant PERPETUAL_SYSTEM_TIME_ADVANCE_BOUND = 4 hours;
    uint256 constant PERPETUAL_CONFIGURATION_DELAY = 0;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MFreezable.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MFreezable {
    /*
      Returns true if the exchange is frozen.
    */
    function isFrozen() public view virtual returns (bool); // NOLINT: external-function.

    /*
      Forbids calling the function if the exchange is frozen.
    */
    modifier notFrozen() {
        require(!isFrozen(), "STATE_IS_FROZEN");
        _;
    }

    function validateFreezeRequest(uint256 requestTime) internal virtual;

    /*
      Allows calling the function only if the exchange is frozen.
    */
    modifier onlyFrozen() {
        require(isFrozen(), "STATE_NOT_FROZEN");
        _;
    }

    /*
      Freezes the exchange.
    */
    function freeze() internal virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MKeyGetters.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MKeyGetters {
    // NOLINTNEXTLINE: external-function.
    function getEthKey(uint256 ownerKey) public view virtual returns (address);

    function strictGetEthKey(uint256 ownerKey) internal view virtual returns (address);

    function isMsgSenderKeyOwner(uint256 ownerKey) internal view virtual returns (bool);

    /*
      Allows calling the function only if ownerKey is registered to msg.sender.
    */
    modifier onlyKeyOwner(uint256 ownerKey) {
        // Require the calling user to own the stark key.
        require(msg.sender == strictGetEthKey(ownerKey), "MISMATCHING_STARK_ETH_KEYS");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/interactions/ForcedWithdrawals.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;




abstract contract ForcedWithdrawals is
    PerpetualConstants,
    MForcedWithdrawalActionState,
    MFreezable,
    MKeyGetters
{
    event LogForcedWithdrawalRequest(uint256 starkKey, uint256 vaultId, uint256 quantizedAmount);

    function forcedWithdrawalRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount,
        bool premiumCost
    ) external notFrozen onlyKeyOwner(starkKey) {
        // Verify vault ID in range.
        require(vaultId < PERPETUAL_POSITION_ID_UPPER_BOUND, "OUT_OF_RANGE_POSITION_ID");
        require(quantizedAmount < PERPETUAL_AMOUNT_UPPER_BOUND, "ILLEGAL_AMOUNT");

        // We cannot handle two identical forced withdraw request at the same time.
        // User can either wait for pending one to be cleared, or issue one with different amount.
        require(
            getForcedWithdrawalRequest(starkKey, vaultId, quantizedAmount) == 0,
            "REQUEST_ALREADY_PENDING"
        );

        // Start timer on escape request.
        setForcedWithdrawalRequest(starkKey, vaultId, quantizedAmount, premiumCost);

        // Log request.
        emit LogForcedWithdrawalRequest(starkKey, vaultId, quantizedAmount);
    }

    function freezeRequest(
        uint256 starkKey,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external notFrozen {
        // Verify vaultId in range.
        require(vaultId < PERPETUAL_POSITION_ID_UPPER_BOUND, "OUT_OF_RANGE_POSITION_ID");

        // Load request time.
        uint256 requestTime = getForcedWithdrawalRequest(starkKey, vaultId, quantizedAmount);

        validateFreezeRequest(requestTime);
        freeze();
    }
}
