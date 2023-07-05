// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/interfaces/IExtsload.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;

/// @title This is an interface to read contract's state that supports extsload.
interface IExtsload {
    /// @notice Returns a value from the storage.
    /// @param slot to read from.
    /// @return value stored at the slot.
    function extsload(bytes32 slot) external view returns (bytes32 value);

    /// @notice Returns multiple values from storage.
    /// @param slots to read from.
    /// @return values stored at the slots.
    function extsload(bytes32[] memory slots) external view returns (bytes32[] memory);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/utils/Extsload.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

/// @notice Allows the inheriting contract make it's state accessable to other contracts
/// https://ethereum-magicians.org/t/extsload-opcode-proposal/2410/11
abstract contract Extsload is IExtsload {
    function extsload(bytes32 slot) external view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }

    function extsload(bytes32[] memory slots) external view returns (bytes32[] memory) {
        assembly {
            let end := add(0x20, add(slots, mul(mload(slots), 0x20)))
            for {
                let pointer := add(slots, 32)
            } lt(pointer, end) {

            } {
                let value := sload(mload(pointer))
                mstore(pointer, value)
                pointer := add(pointer, 0x20)
            }
        }

        return slots;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/test/ExtsloadTest.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract ExtsloadTest is Extsload {
    constructor() {
        assembly {
            sstore(3, 9)
            sstore(4, 16)
            sstore(5, 25)
        }
    }
}
