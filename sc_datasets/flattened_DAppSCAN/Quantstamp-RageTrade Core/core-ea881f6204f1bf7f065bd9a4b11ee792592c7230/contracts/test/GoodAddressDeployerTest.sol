// File: @openzeppelin/contracts/utils/Create2.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Create2.sol)

pragma solidity ^0.8.0;

/**
 * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
 * `CREATE2` can be used to compute in advance the address where a smart
 * contract will be deployed, which allows for interesting new mechanisms known
 * as 'counterfactual interactions'.
 *
 * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
 * information.
 */
library Create2 {
    /**
     * @dev Deploys a contract using `CREATE2`. The address where the contract
     * will be deployed can be known in advance via {computeAddress}.
     *
     * The bytecode for a contract can be obtained from Solidity with
     * `type(contractName).creationCode`.
     *
     * Requirements:
     *
     * - `bytecode` must not be empty.
     * - `salt` must have not been used for `bytecode` already.
     * - the factory must have a balance of at least `amount`.
     * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
     */
    function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address addr) {
        require(address(this).balance >= amount, "Create2: insufficient balance");
        require(bytecode.length != 0, "Create2: bytecode length is zero");
        /// @solidity memory-safe-assembly
        assembly {
            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
        }
        require(addr != address(0), "Create2: Failed on deploy");
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
     * `bytecodeHash` or `salt` will result in a new destination address.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
        return computeAddress(salt, bytecodeHash, address(this));
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address addr) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40) // Get free memory pointer

            // |                   | ↓ ptr ...  ↓ ptr + 0x0B (start) ...  ↓ ptr + 0x20 ...  ↓ ptr + 0x40 ...   |
            // |-------------------|---------------------------------------------------------------------------|
            // | bytecodeHash      |                                                        CCCCCCCCCCCCC...CC |
            // | salt              |                                      BBBBBBBBBBBBB...BB                   |
            // | deployer          | 000000...0000AAAAAAAAAAAAAAAAAAA...AA                                     |
            // | 0xFF              |            FF                                                             |
            // |-------------------|---------------------------------------------------------------------------|
            // | memory            | 000000...00FFAAAAAAAAAAAAAAAAAAA...AABBBBBBBBBBBBB...BBCCCCCCCCCCCCC...CC |
            // | keccak(start, 85) |            ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ |

            mstore(add(ptr, 0x40), bytecodeHash)
            mstore(add(ptr, 0x20), salt)
            mstore(ptr, deployer) // Right-aligned with 12 preceding garbage bytes
            let start := add(ptr, 0x0b) // The hashed data starts at the final garbage byte which we will set to 0xff
            mstore8(start, 0xff)
            addr := keccak256(start, 85)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/libraries/GoodAddressDeployer.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

/// @title Deploys a new contract at a desirable address
library GoodAddressDeployer {
    /// @notice Deploys contract at an address such that the function isAddressGood(address) returns true
    /// @dev Use of CREATE2 is not to recompute address in future, but just to have the address good
    /// @param amount: constructor payable ETH amount
    /// @param bytecode: creation bytecode (should include constructor args)
    /// @param isAddressGood: boolean function that should return true for good addresses
    function deploy(
        uint256 amount,
        bytes memory bytecode,
        function(address) returns (bool) isAddressGood
    ) internal returns (address computed) {
        return deploy(amount, bytecode, isAddressGood, uint256(blockhash(block.number - 1)));
    }

    /// @notice Deploys contract at an address such that the function isAddressGood(address) returns true
    /// @dev Use of CREATE2 is not to recompute address in future, but just to have the address good
    /// @param amount: constructor payable ETH amount
    /// @param bytecode: creation bytecode (should include constructor args)
    /// @param isAddressGood: boolean function that should return true for good addresses
    /// @param salt: initial salt, should be pseudo-randomized so that there won't be more for loop iterations if
    ///     state used in isAddressGood is updated after deployment
    function deploy(
        uint256 amount,
        bytes memory bytecode,
        function(address) returns (bool) isAddressGood,
        uint256 salt
    ) internal returns (address computed) {
        bytes32 byteCodeHash = keccak256(bytecode);

        while (true) {
            computed = Create2.computeAddress(bytes32(salt), byteCodeHash);

            if (isAddressGood(computed)) {
                // we found good address, so stop the for loop and proceed
                break;
            } else {
                // since address is not what we'd like, using a different salt
                unchecked {
                    salt++;
                }
            }
        }

        address deployed = Create2.deploy(amount, bytes32(salt), bytecode);
        assert(computed == deployed);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-RageTrade Core/core-ea881f6204f1bf7f065bd9a4b11ee792592c7230/contracts/test/GoodAddressDeployerTest.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract GoodAddressDeployerTest {
    receive() external payable {}

    event Address(address val);

    function deploy(uint256 amount, bytes memory bytecode) external returns (address computed) {
        computed = GoodAddressDeployer.deploy(amount, bytecode, _isAddressGood);
        emit Address(computed);
    }

    // to be overriden using smock
    function isAddressGood(address) external pure returns (bool) {
        return false;
    }

    function _isAddressGood(address input) internal view returns (bool) {
        return this.isAddressGood(input);
    }
}
