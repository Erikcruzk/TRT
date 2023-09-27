// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-b1bbcf88cc3f49e5d67954003313ede4520ba00a/contracts/interfaces/IAddressResolver.sol

pragma solidity >=0.4.24;


interface IAddressResolver {
    function getAddress(bytes32 name) external view returns (address);

    function getSynth(bytes32 key) external view returns (address);

    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-b1bbcf88cc3f49e5d67954003313ede4520ba00a/contracts/ContractStorage.sol

pragma solidity ^0.5.16;

// Internal References

// https://docs.synthetix.io/contracts/source/contracts/ContractStorage
contract ContractStorage {
    IAddressResolver public resolverProxy;

    mapping(bytes32 => bytes32) public hashes;

    constructor(address _resolver) internal {
        // ReadProxyAddressResolver
        resolverProxy = IAddressResolver(_resolver);
    }

    /* ========== INTERNAL FUNCTIONS ========== */

    function _memoizeHash(bytes32 contractName) internal returns (bytes32) {
        bytes32 hashKey = hashes[contractName];
        if (hashKey == bytes32(0)) {
            // set to unique hash at the time of creation
            hashKey = keccak256(abi.encodePacked(msg.sender, contractName, block.number));
            hashes[contractName] = hashKey;
        }
        return hashKey;
    }

    /* ========== VIEWS ========== */

    /* ========== RESTRICTED FUNCTIONS ========== */

    function migrateContractKey(
        bytes32 fromContractName,
        bytes32 toContractName,
        bool removeAccessFromPreviousContract
    ) external onlyContract(fromContractName) {
        require(hashes[fromContractName] != bytes32(0), "Cannot migrate empty contract");

        hashes[toContractName] = hashes[fromContractName];

        if (removeAccessFromPreviousContract) {
            delete hashes[fromContractName];
        }

        emit KeyMigrated(fromContractName, toContractName, removeAccessFromPreviousContract);
    }

    /* ========== MODIFIERS ========== */

    modifier onlyContract(bytes32 contractName) {
        address callingContract = resolverProxy.requireAndGetAddress(
            contractName,
            "Cannot find contract in Address Resolver"
        );
        require(callingContract == msg.sender, "Can only be invoked by the configured contract");
        _;
    }

    /* ========== EVENTS ========== */

    event KeyMigrated(bytes32 fromContractName, bytes32 toContractName, bool removeAccessFromPreviousContract);
}

// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Fomalhaut Release Smart Contract Audit/synthetix-b1bbcf88cc3f49e5d67954003313ede4520ba00a/contracts/test-helpers/MockContractStorage.sol

pragma solidity ^0.5.16;

contract MockContractStorage is ContractStorage {
    struct SomeEntry {
        uint value;
        bool flag;
    }

    mapping(bytes32 => mapping(bytes32 => SomeEntry)) public entries;

    constructor(address _resolver) public ContractStorage(_resolver) {}

    function getEntry(bytes32 contractName, bytes32 record) external view returns (uint value, bool flag) {
        SomeEntry storage entry = entries[hashes[contractName]][record];
        return (entry.value, entry.flag);
    }

    function persistEntry(
        bytes32 contractName,
        bytes32 record,
        uint value,
        bool flag
    ) external onlyContract(contractName) {
        entries[_memoizeHash(contractName)][record].value = value;
        entries[_memoizeHash(contractName)][record].flag = flag;
    }
}