// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/kernel/KernelConstants.sol

/*
 * SPDX-License-Identitifer:    MIT
 */

pragma solidity ^0.4.24;


contract KernelConstants {
    /*
    bytes32 public constant CORE_NAMESPACE = keccak256("core");
    bytes32 public constant APP_BASES_NAMESPACE = keccak256("base");
    bytes32 public constant APP_ADDR_NAMESPACE = keccak256("app");

    bytes32 public constant KERNEL_APP_ID = apmNamehash("kernel");
    bytes32 public constant ACL_APP_ID = apmNamehash("acl");
    */
    bytes32 public constant CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
    bytes32 public constant APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
    bytes32 public constant APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;

    bytes32 public constant KERNEL_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
    bytes32 public constant ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
}

// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/kernel/KernelStorage.sol

pragma solidity 0.4.24;

contract KernelStorage is KernelConstants {
    mapping (bytes32 => mapping (bytes32 => address)) public apps;
    bytes32 public recoveryVaultAppId;
}
