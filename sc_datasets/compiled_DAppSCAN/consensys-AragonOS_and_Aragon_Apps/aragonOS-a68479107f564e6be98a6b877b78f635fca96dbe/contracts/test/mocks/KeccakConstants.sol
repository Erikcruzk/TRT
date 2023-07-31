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

// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/test/mocks/KeccakConstants.sol

pragma solidity 0.4.24;

contract KeccakConstants is APMNamehash {
    // Note: we can't use APMNamehash.apmNamehash() for constants, starting from pragma 0.5 :(

    // Kernel
    bytes32 public constant CORE_NAMESPACE = keccak256(abi.encodePacked("core"));
    bytes32 public constant APP_BASES_NAMESPACE = keccak256(abi.encodePacked("base"));
    bytes32 public constant APP_ADDR_NAMESPACE = keccak256(abi.encodePacked("app"));

    bytes32 public constant KERNEL_APP_ID = keccak256(abi.encodePacked(APM_NODE, keccak256("kernel")));
    bytes32 public constant ACL_APP_ID = keccak256(abi.encodePacked(APM_NODE, keccak256("acl")));

    bytes32 public constant APP_MANAGER_ROLE = keccak256(abi.encodePacked("APP_MANAGER_ROLE"));

    bytes32 public constant DEFAULT_VAULT_APP_ID = keccak256(abi.encodePacked(APM_NODE, keccak256("vault")));

    // ENS
    bytes32 public constant ENS_ROOT = bytes32(0);
    bytes32 public constant ETH_TLD_LABEL = keccak256(abi.encodePacked("eth"));
    bytes32 public constant ETH_TLD_NODE = keccak256(abi.encodePacked(ENS_ROOT, ETH_TLD_LABEL));
    bytes32 public constant PUBLIC_RESOLVER_LABEL = keccak256(abi.encodePacked("resolver"));
    bytes32 public constant PUBLIC_RESOLVER_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, PUBLIC_RESOLVER_LABEL));

    // ACL
    bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256(abi.encodePacked("CREATE_PERMISSIONS_ROLE"));
    bytes32 public constant EMPTY_PARAM_HASH = keccak256(abi.encodePacked(uint256(0)));

    // APMRegistry
    bytes32 public constant CREATE_REPO_ROLE = keccak256(abi.encodePacked("CREATE_REPO_ROLE"));

    // ENSSubdomainRegistrar
    bytes32 public constant CREATE_NAME_ROLE = keccak256(abi.encodePacked("CREATE_NAME_ROLE"));
    bytes32 public constant DELETE_NAME_ROLE = keccak256(abi.encodePacked("DELETE_NAME_ROLE"));
    bytes32 public constant POINT_ROOTNODE_ROLE = keccak256(abi.encodePacked("POINT_ROOTNODE_ROLE"));

    // EVMScriptRegistry
    bytes32 public constant EVMSCRIPT_REGISTRY_APP_ID = keccak256(abi.encodePacked(APM_NODE, keccak256("evmreg")));
    bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
    bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256(abi.encodePacked("REGISTRY_MANAGER_ROLE"));

    // EVMScriptExecutor types
    bytes32 public constant EVMSCRIPT_EXECUTOR_CALLS_SCRIPT = keccak256(abi.encodePacked("CALLS_SCRIPT"));

    // Repo
    bytes32 public constant CREATE_VERSION_ROLE = keccak256(abi.encodePacked("CREATE_VERSION_ROLE"));

    // Unstructured storage
    bytes32 public constant initializationBlockPosition = keccak256(abi.encodePacked("aragonOS.initializable.initializationBlock"));
    bytes32 public constant depositablePosition = keccak256(abi.encodePacked("aragonOS.depositableStorage.depositable"));
    bytes32 public constant kernelPosition = keccak256(abi.encodePacked("aragonOS.appStorage.kernel"));
    bytes32 public constant appIdPosition = keccak256(abi.encodePacked("aragonOS.appStorage.appId"));
    bytes32 public constant pinnedCodePosition = keccak256(abi.encodePacked("aragonOS.appStorage.pinnedCode"));
}
