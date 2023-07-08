// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/Domain.sol

// SPDX-License-Identifier: MIT
// Based on code and smartness by Ross Campbell and Keno
// Uses immutable to store the domain separator to reduce gas usage
// If the chain id changes due to a fork, the forked chain will calculate on the fly.
pragma solidity ^0.8.0;

// solhint-disable no-inline-assembly

contract Domain {
    bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
    // See https://eips.ethereum.org/EIPS/eip-191
    string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";

    // solhint-disable var-name-mixedcase
    bytes32 private immutable _DOMAIN_SEPARATOR;
    uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;

    /// @dev Calculate the DOMAIN_SEPARATOR
    function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
        return keccak256(abi.encode(DOMAIN_SEPARATOR_SIGNATURE_HASH, chainId, address(this)));
    }

    constructor() {
        _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = block.chainid);
    }

    /// @dev Return the DOMAIN_SEPARATOR
    // It's named internal to allow making it public from the contract that uses it by creating a simple view function
    // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
    // solhint-disable-next-line func-name-mixedcase
    function _domainSeparator() internal view returns (bytes32) {
        return block.chainid == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(block.chainid);
    }

    function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
        digest = keccak256(abi.encodePacked(EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA, _domainSeparator(), dataHash));
    }
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-Furucombo-project2/BoringSolidity-master/contracts/BoringCooker.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

// solhint-disable no-inline-assembly
// solhint-disable avoid-low-level-calls
// solhint-disable not-rely-on-time

// This is a work in progress

contract CookTarget {
    function onCook(address, bytes calldata) public payable virtual returns (bool success, bytes memory result) {
        // Check that msg.sender is the BoringCooker. If so, you can trust sender to be verified.
        return (true, "");
    }
}

contract BoringCooker is Domain {
    mapping(address => uint256) public nonces;

    /// @dev Helper function to extract a useful revert message from a failed call.
    /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
    function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
        // If the _res length is less than 68, then the transaction failed silently (without a revert message)
        if (_returnData.length < 68) return "Transaction reverted silently";

        assembly {
            // Slice the sighash.
            _returnData := add(_returnData, 0x04)
        }
        return abi.decode(_returnData, (string)); // All that remains is the revert string
    }

    uint8 private constant ACTION_CALL = 1;
    uint8 private constant ACTION_COOK = 2;
    uint8 private constant ACTION_SIGNED_COOK = 3;

    // keccak256("Cook(address sender,address target,bytes data,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 private constant COOK_SIGNATURE_HASH = 0x22efff3742eba32ab114c316a3e6dae791aea24d5d74f889a8f67bc7d4054f24;

    // Verify that the cook call was signed and pass on the cook call params. Split out for stack reasons.
    function _verifySignature(bytes memory data)
        internal
        returns (
            address,
            CookTarget,
            bytes memory,
            uint256
        )
    {
        (address sender, CookTarget target, bytes memory data_, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) =
            abi.decode(data, (address, CookTarget, bytes, uint256, uint256, uint8, bytes32, bytes32));

        require(sender != address(0), "Cooker: Sender cannot be 0");
        require(block.timestamp < deadline, "Cooker: Expired");
        require(
            ecrecover(_getDigest(keccak256(abi.encode(COOK_SIGNATURE_HASH, data_, sender, nonces[sender]++, deadline))), v, r, s) == sender,
            "Cooker: Invalid Signature"
        );
        return (sender, target, data_, value);
    }

    function cook(uint8[] calldata actions, bytes[] calldata datas) external payable {
        bytes memory result;
        for (uint256 i = 0; i < actions.length; i++) {
            uint8 action = actions[i];
            if (action == ACTION_CALL) {
                // Do any call. msg.sender will be the Cooker.
                (address target, bytes4 signature, bytes memory data, uint256 value) = abi.decode(datas[i], (address, bytes4, bytes, uint256));
                require(signature != CookTarget.onCook.selector, "Use action cook");
                (bool success, bytes memory localResult) = target.call{value: value}(abi.encodePacked(signature, data));
                if (!success) {
                    revert(_getRevertMsg(localResult));
                }
                result = localResult;
            } else if (action == ACTION_COOK) {
                // Contracts that support cooking can accept the passed in sender as the verified msg.sender.
                (CookTarget target, bytes memory data, uint256 value) = abi.decode(datas[i], (CookTarget, bytes, uint256));
                (bool success, bytes memory localResult) = target.onCook{value: value}(msg.sender, data);
                if (!success) {
                    revert(_getRevertMsg(localResult));
                }
                result = localResult;
            } else if (action == ACTION_SIGNED_COOK) {
                // Contracts that support cooking can accept the passed in sender as the verified msg.sender (here verified by signed message).
                (address sender, CookTarget target, bytes memory data, uint256 value) = _verifySignature(datas[i]);
                (bool success, bytes memory localResult) = target.onCook{value: value}(sender, data);
                if (!success) {
                    revert(_getRevertMsg(localResult));
                }
                result = localResult;
            }
        }
    }
}
