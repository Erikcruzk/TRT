// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-ada048bdf6aa28da51affab574286493ada75893/solidity/nomad-core/interfaces/IMessageRecipient.sol

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-ada048bdf6aa28da51affab574286493ada75893/solidity/nomad-core/contracts/test/bad-recipient/BadRecipient6.sol

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

contract BadRecipient6 is IMessageRecipient {
    function handle(
        uint32,
        uint32,
        bytes32,
        bytes memory
    ) external pure override {
        require(false); // solhint-disable-line reason-string
    }
}
