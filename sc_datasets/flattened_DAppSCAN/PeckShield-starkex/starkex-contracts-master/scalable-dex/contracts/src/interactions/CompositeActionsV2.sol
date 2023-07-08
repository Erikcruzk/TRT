// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MDeposits.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MDeposits {
    function depositERC20(
        // NOLINT external-function.
        uint256 starkKey,
        uint256 assetType,
        uint256 vaultId,
        uint256 quantizedAmount
    ) public virtual;

    function depositEth(
        // NOLINT external-function.
        uint256 starkKey,
        uint256 assetType,
        uint256 vaultId
    ) public payable virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/MUsersV2.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract MUsersV2 {
    function registerUser(
        // NOLINT external-function.
        address ethKey,
        uint256 starkKey,
        bytes calldata signature
    ) public virtual;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interactions/CompositeActionsV2.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


abstract contract CompositeActionsV2 is MDeposits, MUsersV2 {
    function registerAndDepositERC20(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external {
        registerUser(ethKey, starkKey, signature);
        depositERC20(starkKey, assetType, vaultId, quantizedAmount);
    }

    // NOLINTNEXTLINE locked-ether.
    function registerAndDepositEth(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 vaultId
    ) external payable {
        registerUser(ethKey, starkKey, signature);
        depositEth(starkKey, assetType, vaultId);
    }
}
