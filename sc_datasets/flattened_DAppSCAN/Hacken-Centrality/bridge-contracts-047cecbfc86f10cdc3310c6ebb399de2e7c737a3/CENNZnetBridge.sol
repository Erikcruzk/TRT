// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Centrality/bridge-contracts-047cecbfc86f10cdc3310c6ebb399de2e7c737a3/CENNZnetBridge.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

// Proof of a witnessed event by CENNZnet validators
struct CENNZnetEventProof {
    // The Id (nonce) of the event
    uint256 eventId;
    // The validator set Id which witnessed the event
    uint32 validatorSetId;
    // v,r,s are sparse arrays expected to align w public key in 'validators'
    // i.e. v[i], r[i], s[i] matches the i-th validator[i]
    // v part of validator signatures
    uint8[] v;
    // r part of validator signatures
    bytes32[] r;
    // s part of validator signatures
    bytes32[] s;
}

// Provides methods for verifying messages from the CENNZnet validator set
contract CENNZnetBridge is Ownable {
    // map from validator set nonce to validator ECDSA addresses (i.e bridge session keys)
    // these should be in sorted order matching `pallet_session::Module<T>::validators()`
    // signatures from a threshold of these addresses are considered approved by the CENNZnet protocol
    mapping(uint => address[]) public validators;
    // Nonce for validator set changes
    uint32 public activeValidatorSetId;
    // Message nonces.
    // CENNZnet will only validate one message per nonce.
    // Claiming out of order is ok.
    mapping(uint => bool) public eventIds;
    // Fee for CENNZnet message verification
    // Offsets bridge upkeep costs i.e updating the validator set
    uint public verificationFee = 1e15;
    // Acceptance threshold in %
    uint public thresholdPercent = 61;
    // Number of eras before a bridge message will be considered expired
    uint public proofTTL = 3;
    // Whether the bridge is active or not
    bool public active = true;

    event SetValidators(address[], uint reward, uint32 validatorSetId);

    // Verify a message was authorised by CENNZnet validators.
    // Callable by anyone.
    // Caller must provide `verificationFee`.
    // Requires signatures from a threshold CENNZnet validators at proof.validatorSetId.
    // Requires proof is not older than `proofTTL` eras
    // Halts on failure
    //
    // Parameters:
    // - message: the unhashed message data packed wide w validatorSetId & eventId e.g. `abi.encode(arg0, arg2, validatorSetId, eventId);`
    // - proof: Signed witness material generated by CENNZnet proving 'message'
    function verifyMessage(bytes memory message, CENNZnetEventProof memory proof) payable external {
        require(active, "bridge inactive");
        uint256 eventId = proof.eventId;
        require(!eventIds[eventId], "eventId replayed");
        require(msg.value >= verificationFee || msg.sender == address(this), "must supply verification fee");
        uint32 validatorSetId = proof.validatorSetId;
        require(validatorSetId <= activeValidatorSetId, "future validator set");
        require(activeValidatorSetId - validatorSetId <= proofTTL, "expired proof");

        address[] memory _validators = validators[validatorSetId];

        // audit item #1
        require(_validators.length > 0, "invalid validator set");

        bytes32 digest = keccak256(message);
        uint acceptanceTreshold = (_validators.length * thresholdPercent / 100);
        uint witnessCount;
        bytes32 ommited;

        for (uint i; i < _validators.length; i++) {
            // check signature omitted == bytes32(0)
            if(proof.r[i] != ommited) {
                // check signature
                require(_validators[i] == ecrecover(digest, proof.v[i], proof.r[i], proof.s[i]), "signature invalid");
                witnessCount += 1;
                // have we got proven consensus?
                if(witnessCount >= acceptanceTreshold) {
                    break;
                }
            }
        }

        require(witnessCount >= acceptanceTreshold, "not enough signatures");
        eventIds[eventId] = true;
    }

    // Update the known CENNZnet validator set
    //
    // Requires signatures from a threshold of current CENNZnet validators
    // v,r,s are sparse arrays expected to align w addresses / public key in 'validators'
    // i.e. v[i], r[i], s[i] matches the i-th validator[i]
    // ~6,737,588 gas
//    SWC-Unprotected Ether Withdrawal：L99-120
    function setValidators(
        address[] memory newValidators,
        uint32 newValidatorSetId,
        CENNZnetEventProof memory proof
    ) external payable {
        require(newValidators.length > 0, "empty validator set");
        require(newValidatorSetId > activeValidatorSetId , "validator set id replayed");

        bytes memory message = abi.encode(newValidators, newValidatorSetId, proof.validatorSetId, proof.eventId);
        this.verifyMessage(message, proof);

        // update
        validators[newValidatorSetId] = newValidators;
        activeValidatorSetId = newValidatorSetId;

        // return any accumulated fees to the sender as a reward
        uint reward = address(this).balance;
        (bool sent, ) = msg.sender.call{value: reward}("");
        require(sent, "Failed to send Ether");

        emit SetValidators(newValidators, reward, newValidatorSetId);
    }

    // Admin functions

    // force set the active CENNZnet validator set
    function forceActiveValidatorSet(address[] memory _validators, uint32 validatorSetId) external onlyOwner {
        require(_validators.length > 0, "empty validator set");
        require(validatorSetId >= activeValidatorSetId, "set is historic");
        validators[validatorSetId] = _validators;
        activeValidatorSetId = validatorSetId;
    }

    // Force set a historic CENNZnet validator set
    // Sets older than proofTTL are not modifiable (since they cannot produce valid proofs any longer)
    function forceHistoricValidatorSet(address[] memory _validators, uint32 validatorSetId) external onlyOwner {
        require(_validators.length > 0, "empty validator set");
        require(validatorSetId + proofTTL > activeValidatorSetId, "set is inactive");
        validators[validatorSetId] = _validators;
    }

    // Set the TTL for historic validator set proofs
    function setProofTTL(uint newTTL) external onlyOwner {
        proofTTL = newTTL;
    }

    // Set the fee for verify messages
    function setVerificationFee(uint newFee) external onlyOwner {
        verificationFee = newFee;
    }

    // Set the threshold % required for proof verification
    function setThreshold(uint newThresholdPercent) external onlyOwner {
        thresholdPercent = newThresholdPercent;
    }

    // Activate/deactivate the bridge
    function setActive(bool active_) external onlyOwner {
        active = active_;
    }
}
