// File: ../sc_datasets/DAppSCAN/QuillAudits-Dfyn Smart Contract/dual-farm-f44a4dcbeb41f38a9c02cb877a8c95b92685f972/contracts/libraries/NativeMetaTransaction/Initializable.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.11;

contract Initializable {
    bool inited = false;

    modifier initializer() {
        require(!inited, 'already inited');
        _;
        inited = true;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Dfyn Smart Contract/dual-farm-f44a4dcbeb41f38a9c02cb877a8c95b92685f972/contracts/libraries/NativeMetaTransaction/EIP712Base.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.11;

contract EIP712Base is Initializable {
    struct EIP712Domain {
        string name;
        string version;
        address verifyingContract;
        bytes32 salt;
    }

    string public constant ERC712_VERSION = '1';

    bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
        keccak256(bytes('EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)'));
    bytes32 internal domainSeperator;

    // supposed to be called once while initializing.
    // one of the contractsa that inherits this contract follows proxy pattern
    // so it is not possible to do this in a constructor
    function _initializeEIP712(string memory name) internal initializer {
        _setDomainSeperator(name);
    }

    function _setDomainSeperator(string memory name) internal {
        domainSeperator = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes(ERC712_VERSION)),
                address(this),
                bytes32(getChainId())
            )
        );
    }

    function getDomainSeperator() public view returns (bytes32) {
        return domainSeperator;
    }

    function getChainId() public pure returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    /**
     * Accept message hash and returns hash message in EIP712 compatible form
     * So that it can be used to recover signer from signature signed using EIP712 formatted data
     * https://eips.ethereum.org/EIPS/eip-712
     * "\\x19" makes the encoding deterministic
     * "\\x01" is the version byte to make it compatible to EIP-191
     */
    function toTypedMessageHash(bytes32 messageHash) internal view returns (bytes32) {
        return keccak256(abi.encodePacked('\x19\x01', getDomainSeperator(), messageHash));
    }
}