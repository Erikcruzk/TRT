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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Nomad/nomad-monorepo-ada048bdf6aa28da51affab574286493ada75893/solidity/nomad-core/contracts/test/TestRecipient.sol

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.11;

contract TestRecipient is IMessageRecipient {
    bool public processed = false;

    // solhint-disable-next-line payable-fallback
    fallback() external {
        revert("Fallback");
    }

    function handle(
        uint32,
        uint32,
        bytes32,
        bytes memory
    ) external pure override {} // solhint-disable-line no-empty-blocks

    function receiveString(string calldata _str)
        public
        pure
        returns (string memory)
    {
        return _str;
    }

    function processCall(bool callProcessed) public {
        processed = callProcessed;
    }

    function message() public pure returns (string memory) {
        return "message received";
    }
}
