// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/ens/ENSConstants.sol

/*
 * SPDX-License-Identitifer:    MIT
 */

pragma solidity ^0.4.24;


contract ENSConstants {
    bytes32 public constant ENS_ROOT = bytes32(0);
    bytes32 public constant ETH_TLD_LABEL = keccak256("eth");
    bytes32 public constant ETH_TLD_NODE = keccak256(abi.encodePacked(ENS_ROOT, ETH_TLD_LABEL));
    bytes32 public constant PUBLIC_RESOLVER_LABEL = keccak256("resolver");
    bytes32 public constant PUBLIC_RESOLVER_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL));
}

// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/apm/APMNamehash.sol

/*
 * SPDX-License-Identitifer:    MIT
 */

pragma solidity ^0.4.24;

contract APMNamehash is ENSConstants {
    bytes32 public constant APM_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, keccak256("aragonpm")));

    function apmNamehash(string name) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(APM_NODE, keccak256(bytes(name))));
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/test/mocks/APMNamehashWrapper.sol

pragma solidity 0.4.24;

contract APMNamehashWrapper is APMNamehash {
    function getAPMNamehash(string name) external pure returns (bytes32) {
        return apmNamehash(name);
    }
}