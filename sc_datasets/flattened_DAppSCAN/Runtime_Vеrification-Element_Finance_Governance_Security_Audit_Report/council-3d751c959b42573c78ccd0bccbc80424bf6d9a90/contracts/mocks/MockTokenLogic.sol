// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/libraries/Storage.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;

// This library allows for secure storage pointers across proxy implementations
// It will return storage pointers based on a hashed name and type string.
library Storage {
    // This library follows a pattern which if solidity had higher level
    // type or macro support would condense quite a bit.

    // Each basic type which does not support storage locations is encoded as
    // a struct of the same name capitalized and has functions 'load' and 'set'
    // which load the data and set the data respectively.

    // All types will have a function of the form 'typename'Ptr('name') -> storage ptr
    // which will return a storage version of the type with slot which is the hash of
    // the variable name and type string. This pointer allows easy state management between
    // upgrades and overrides the default solidity storage slot system.

    /// @dev The address type container
    struct Address {
        address data;
    }

    /// @notice A function which turns a variable name for a storage address into a storage
    ///         pointer for its container.
    /// @param name the variable name
    /// @return data the storage pointer
    function addressPtr(string memory name)
        internal
        pure
        returns (Address storage data)
    {
        bytes32 typehash = keccak256("address");
        bytes32 offset = keccak256(abi.encodePacked(typehash, name));
        assembly {
            data.slot := offset
        }
    }

    /// @notice A function to load an address from the container struct
    /// @param input the storage pointer for the container
    /// @return the loaded address
    function load(Address storage input) internal view returns (address) {
        return input.data;
    }

    /// @notice A function to set the internal field of an address container
    /// @param input the storage pointer to the container
    /// @param to the address to set the container to
    function set(Address storage input, address to) internal {
        input.data = to;
    }

    /// @dev The uint256 type container
    struct Uint256 {
        uint256 data;
    }

    /// @notice A function which turns a variable name for a storage uint256 into a storage
    ///         pointer for its container.
    /// @param name the variable name
    /// @return data the storage pointer
    function uint256Ptr(string memory name)
        internal
        pure
        returns (Uint256 storage data)
    {
        bytes32 typehash = keccak256("uint256");
        bytes32 offset = keccak256(abi.encodePacked(typehash, name));
        assembly {
            data.slot := offset
        }
    }

    /// @notice A function to load an uint256 from the container struct
    /// @param input the storage pointer for the container
    /// @return the loaded uint256
    function load(Uint256 storage input) internal view returns (uint256) {
        return input.data;
    }

    /// @notice A function to set the internal field of a unit256 container
    /// @param input the storage pointer to the container
    /// @param to the address to set the container to
    function set(Uint256 storage input, uint256 to) internal {
        input.data = to;
    }

    /// @notice Returns the storage pointer for a named mapping of address to uint256
    /// @param name the variable name for the pointer
    /// @return data the mapping pointer
    function mappingAddressToUnit256Ptr(string memory name)
        internal
        pure
        returns (mapping(address => uint256) storage data)
    {
        bytes32 typehash = keccak256("mapping(address => uint256)");
        bytes32 offset = keccak256(abi.encodePacked(typehash, name));
        assembly {
            data.slot := offset
        }
    }

    /// @notice Returns the storage pointer for a named mapping of address to uint256[]
    /// @param name the variable name for the pointer
    /// @return data the mapping pointer
    function mappingAddressToUnit256ArrayPtr(string memory name)
        internal
        pure
        returns (mapping(address => uint256[]) storage data)
    {
        bytes32 typehash = keccak256("mapping(address => uint256[])");
        bytes32 offset = keccak256(abi.encodePacked(typehash, name));
        assembly {
            data.slot := offset
        }
    }

    /// @notice Allows external users to calculate the slot given by this lib
    /// @param typeString the string which encodes the type
    /// @param name the variable name
    /// @return the slot assigned by this lib
    function getPtr(string memory typeString, string memory name)
        external
        pure
        returns (uint256)
    {
        bytes32 typehash = keccak256(abi.encodePacked(typeString));
        bytes32 offset = keccak256(abi.encodePacked(typehash, name));
        return (uint256)(offset);
    }

    // A struct which represents 1 packed storage location with a compressed
    // address and uint96 pair
    struct AddressUint {
        address who;
        uint96 amount;
    }

    /// @notice Returns the storage pointer for a named mapping of address to uint256[]
    /// @param name the variable name for the pointer
    /// @return data the mapping pointer
    function mappingAddressToPackedAddressUint(string memory name)
        internal
        pure
        returns (mapping(address => AddressUint) storage data)
    {
        bytes32 typehash = keccak256("mapping(address => AddressUint)");
        bytes32 offset = keccak256(abi.encodePacked(typehash, name));
        assembly {
            data.slot := offset
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/mocks/StorageRead.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;

contract ReadAndWriteAnyStorage {
    function readStorage(uint256 slot) public view returns (bytes32 data) {
        assembly {
            data := sload(slot)
        }
    }

    function writeStorage(uint256 slot, bytes32 data) public {
        assembly {
            sstore(slot, data)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/mocks/MockTokenLogic.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;


contract MockTokenLogic is ReadAndWriteAnyStorage {
    // This contract is an implementation target for the proxy so uses the
    // proxy storage lib for safe portable slotting cross upgrades.
    using Storage for *;

    // We don't declare them but the following are our state variables
    // uint256 totalSupply
    // address owner
    // mapping(address => balance) balances
    // Access functions which prevent us from typo-ing the variable name below
    function _getOwner() internal pure returns (Storage.Address storage) {
        return Storage.addressPtr("owner");
    }

    function _getTotalSupply() internal pure returns (Storage.Uint256 storage) {
        return Storage.uint256Ptr("totalSupply");
    }

    function _getBalancesMapping()
        internal
        pure
        returns (mapping(address => uint256) storage)
    {
        return Storage.mappingAddressToUnit256Ptr("balances");
    }

    constructor(address _owner) {
        Storage.Address storage owner = Storage.addressPtr("owner");
        owner.set(_owner);
    }

    function transfer(address to, uint256 amount) external {
        mapping(address => uint256) storage balances = _getBalancesMapping();

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function balanceOf(address who) external view returns (uint256) {
        mapping(address => uint256) storage balances = _getBalancesMapping();
        return (balances[who]);
    }

    function totalSupply() external view returns (uint256) {
        Storage.Uint256 storage totalSupply = _getTotalSupply();
        return (totalSupply.load());
    }

    modifier onlyOwner {
        Storage.Address storage owner = _getOwner();
        require(msg.sender == owner.load(), "unauthorized");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner() {
        Storage.Uint256 storage totalSupply = _getTotalSupply();
        mapping(address => uint256) storage balances = _getBalancesMapping();

        balances[to] += amount;
        uint256 localTotalSupply = totalSupply.load();
        totalSupply.set(localTotalSupply + amount);
    }

    // A function purely for testing which is a totally unrestricted mint
    function increaseBalance(address to, uint256 amount) external {
        Storage.Uint256 storage totalSupply = _getTotalSupply();
        mapping(address => uint256) storage balances = _getBalancesMapping();

        balances[to] += amount;
        uint256 localTotalSupply = totalSupply.load();
        totalSupply.set(localTotalSupply + amount);
    }
}
