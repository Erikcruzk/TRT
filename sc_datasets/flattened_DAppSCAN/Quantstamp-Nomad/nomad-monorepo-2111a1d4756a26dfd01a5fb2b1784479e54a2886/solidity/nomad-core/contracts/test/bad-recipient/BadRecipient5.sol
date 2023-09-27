// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-2111a1d4756a26dfd01a5fb2b1784479e54a2886/solidity/nomad-core/interfaces/IMessageRecipient.sol

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-2111a1d4756a26dfd01a5fb2b1784479e54a2886/solidity/nomad-core/contracts/test/bad-recipient/BadRecipient5.sol

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

contract BadRecipient5 is IMessageRecipient {
    function handle(
        uint32,
        uint32,
        bytes32,
        bytes memory
    ) external pure override {
        require(false, "no can do");
    }
}