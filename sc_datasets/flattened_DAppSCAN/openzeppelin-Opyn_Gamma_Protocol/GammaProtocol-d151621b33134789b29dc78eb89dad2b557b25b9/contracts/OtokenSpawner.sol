// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/packages/Spawn.sol

/* solhint-disable avoid-low-level-calls, indent, no-inline-assembly */
/* This contract is copied from Spawner package: https://github.com/0age/Spawner */
pragma solidity =0.6.10;

/**
 * @title Spawn
 * @author 0age
 * @notice This contract provides creation code that is used by Spawner in order
 * to initialize and deploy eip-1167 minimal proxies for a given logic contract.
 * SPDX-License-Identifier: MIT
 */
contract Spawn {
    constructor(address logicContract, bytes memory initializationCalldata) public payable {
        // delegatecall into the logic contract to perform initialization.
        (bool ok, ) = logicContract.delegatecall(initializationCalldata);
        if (!ok) {
            // pass along failure message from delegatecall and revert.
            assembly {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }

        // place eip-1167 runtime code in memory.
        bytes memory runtimeCode = abi.encodePacked(
            bytes10(0x363d3d373d3d3d363d73),
            logicContract,
            bytes15(0x5af43d82803e903d91602b57fd5bf3)
        );

        // return eip-1167 code to write it to spawned contract runtime.
        assembly {
            return(add(0x20, runtimeCode), 45) // eip-1167 runtime code, length
        }
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/packages/oz/Create2.sol

// SPDX-License-Identifier: MIT
/* solhint-disable */

pragma solidity =0.6.10;

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
    function deploy(
        uint256 amount,
        bytes32 salt,
        bytes memory bytecode
    ) internal returns (address) {
        address addr;
        require(address(this).balance >= amount, "Create2: insufficient balance");
        require(bytecode.length != 0, "Create2: bytecode length is zero");
        // solhint-disable-next-line no-inline-assembly
        assembly {
            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
        }
        require(addr != address(0), "Create2: Failed on deploy");
        return addr;
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
    function computeAddress(
        bytes32 salt,
        bytes32 bytecodeHash,
        address deployer
    ) internal pure returns (address) {
        bytes32 _data = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash));
        return address(uint256(_data));
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Opyn_Gamma_Protocol/GammaProtocol-d151621b33134789b29dc78eb89dad2b557b25b9/contracts/OtokenSpawner.sol

/* SPDX-License-Identifier: UNLICENSED */

pragma solidity =0.6.10;


/**
 * @title OtokenSpawner
 * @author Opyn Team
 * @notice This contract spawns and initializes eip-1167 minimal proxies that
 * point to existing logic contracts.
 * @notice This contract was modified from Spawner.sol
 * https://github.com/0age/Spawner/blob/master/contracts/Spawner.sol to fit into OtokenFactory
 */
contract OtokenSpawner {
    // fixed salt value because we will only deploy an oToken with the same init value once
    bytes32 private constant SALT = 0;

    /**
     * @notice internal function for spawning an eip-1167 minimal proxy using `CREATE2`
     * @param logicContract address of the logic contract
     * @param initializationCalldata calldata that will be supplied to the `DELEGATECALL`
     * from the spawned contract to the logic contract during contract creation
     * @return spawnedContract the address of the newly-spawned contract
     */
    function _spawn(address logicContract, bytes memory initializationCalldata) internal returns (address) {
        // place the creation code and constructor args of the contract to spawn in memory
        bytes memory initCode = abi.encodePacked(
            type(Spawn).creationCode,
            abi.encode(logicContract, initializationCalldata)
        );

        // spawn the contract using `CREATE2`
        return Create2.deploy(0, SALT, initCode);
    }

    /**
     * @notice internal view function for finding the address of the standard
     * eip-1167 minimal proxy created using `CREATE2` with a given logic contract
     * and initialization calldata payload
     * @param logicContract address of the logic contract
     * @param initializationCalldata calldata that will be supplied to the `DELEGATECALL`
     * from the spawned contract to the logic contract during contract creation
     * @return target address of the next spawned minimal proxy contract with the
     * given parameters.
     */
    function _computeAddress(address logicContract, bytes memory initializationCalldata)
        internal
        view
        returns (address target)
    {
        // place the creation code and constructor args of the contract to spawn in memory
        bytes memory initCode = abi.encodePacked(
            type(Spawn).creationCode,
            abi.encode(logicContract, initializationCalldata)
        );
        // get target address using the constructed initialization code
        bytes32 initCodeHash = keccak256(initCode);

        target = Create2.computeAddress(SALT, initCodeHash);
    }
}
