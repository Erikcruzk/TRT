// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/monorepo-17f055736e36a4b5b98ea767067b33305f985a8a/packages/contracts-core/contracts/interfaces/IMessageRecipient.sol

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

interface IMessageRecipient {
    function handle(
        uint32 _origin,
        uint32 _nonce,
        bytes32 _sender,
        bytes memory _message
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/monorepo-17f055736e36a4b5b98ea767067b33305f985a8a/packages/contracts-core/contracts/test/bad-recipient/BadRecipient3.sol

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

contract BadRecipient3 is IMessageRecipient {
    function handle(
        uint32,
        uint32,
        bytes32,
        bytes memory
    ) external pure override {
        assembly {
            mstore(0, 0xabcdef)
            revert(0, 32)
        }
    }
}
