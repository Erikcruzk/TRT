// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/libraries/Authorizable.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.7.0;

contract Authorizable {
    // This contract allows a flexible authorization scheme

    // The owner who can change authorization status
    address public owner;
    // A mapping from an address to its authorization status
    mapping(address => bool) public authorized;

    /// @dev We set the deployer to the owner
    constructor() {
        owner = msg.sender;
    }

    /// @dev This modifier checks if the msg.sender is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender not owner");
        _;
    }

    /// @dev This modifier checks if an address is authorized
    modifier onlyAuthorized() {
        require(isAuthorized(msg.sender), "Sender not Authorized");
        _;
    }

    /// @dev Returns true if an address is authorized
    /// @param who the address to check
    /// @return true if authorized false if not
    function isAuthorized(address who) public view returns (bool) {
        return authorized[who];
    }

    /// @dev Privileged function authorize an address
    /// @param who the address to authorize
    function authorize(address who) external onlyOwner() {
        _authorize(who);
    }

    /// @dev Privileged function to de authorize an address
    /// @param who The address to remove authorization from
    function deauthorize(address who) external onlyOwner() {
        authorized[who] = false;
    }

    /// @dev Function to change owner
    /// @param who The new owner address
    function setOwner(address who) public onlyOwner() {
        owner = who;
    }

    /// @dev Inheritable function which authorizes someone
    /// @param who the address to authorize
    function _authorize(address who) internal {
        authorized[who] = true;
    }
}

// File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)

pragma solidity ^0.8.0;

/**
 * @dev These functions deal with verification of Merkle Tree proofs.
 *
 * The tree and the proofs can be generated using our
 * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
 * You will find a quickstart guide in the readme.
 *
 * WARNING: You should avoid using leaf values that are 64 bytes long prior to
 * hashing, or use a hash function other than keccak256 for hashing leaves.
 * This is because the concatenation of a sorted pair of internal nodes in
 * the merkle tree could be reinterpreted as a leaf value.
 * OpenZeppelin's JavaScript library generates merkle trees that are safe
 * against this attack out of the box.
 */
library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Calldata version of {verify}
     *
     * _Available since v4.7._
     */
    function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProofCalldata(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     *
     * _Available since v4.4._
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Calldata version of {processProof}
     *
     * _Available since v4.7._
     */
    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
     * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function multiProofVerify(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProof(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Calldata version of {multiProofVerify}
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function multiProofVerifyCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProofCalldata(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
     * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
     * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
     * respectively.
     *
     * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
     * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
     * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
     *
     * _Available since v4.7._
     */
    function processMultiProof(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 proofLen = proof.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i]
                ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
                : proof[proofPos++];
            hashes[i] = _hashPair(a, b);
        }

        if (totalHashes > 0) {
            require(proofPos == proofLen, "MerkleProof: invalid multiproof");
            unchecked {
                return hashes[totalHashes - 1];
            }
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    /**
     * @dev Calldata version of {processMultiProof}.
     *
     * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
     *
     * _Available since v4.7._
     */
    function processMultiProofCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 proofLen = proof.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i]
                ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
                : proof[proofPos++];
            hashes[i] = _hashPair(a, b);
        }

        if (totalHashes > 0) {
            require(proofPos == proofLen, "MerkleProof: invalid multiproof");
            unchecked {
                return hashes[totalHashes - 1];
            }
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IERC20 {
    function symbol() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    // Note this is non standard but nearly all ERC20 have exposed decimal functions
    function decimals() external view returns (uint8);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/interfaces/ILockingVault.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;

interface ILockingVault {
    function deposit(
        address fundedAccount,
        uint256 amount,
        address firstDelegation
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/libraries/MerkleRewards.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;



contract MerkleRewards {
    // The merkle root with deposits encoded into it as hash [address, amount]
    // Assumed to be a node sorted tree
    bytes32 public rewardsRoot;
    // The token to pay out
    IERC20 public immutable token;
    // The historic user claims
    mapping(address => uint256) public claimed;
    // The locking gov vault
    ILockingVault public lockingVault;

    /// @notice Constructs the contract and sets state and immutable variables
    /// @param _rewardsRoot The root a keccak256 merkle tree with leaves which are address amount pairs
    /// @param _token The erc20 contract which will be sent to the people with claims on the contract
    /// @param _lockingVault The governance vault which this deposits to on behalf of users
    constructor(
        bytes32 _rewardsRoot,
        IERC20 _token,
        ILockingVault _lockingVault
    ) {
        rewardsRoot = _rewardsRoot;
        token = _token;
        lockingVault = _lockingVault;
        // We approve the locking vault so that it we can deposit on behalf of users
        _token.approve(address(lockingVault), type(uint256).max);
    }

    /// @notice Claims an amount of tokens which are in the tree and moves them directly into
    ///         governance
    /// @param amount The amount of tokens to claim
    /// @param delegate The address the user will delegate to, WARNING - should not be zero
    /// @param totalGrant The total amount of tokens the user was granted
    /// @param merkleProof The merkle de-commitment which proves the user is in the merkle root
    /// @param destination The address which will be credited with funds
    function claimAndDelegate(
        uint256 amount,
        address delegate,
        uint256 totalGrant,
        bytes32[] calldata merkleProof,
        address destination
    ) external {
        // Validate the withdraw
        _validateWithdraw(amount, totalGrant, merkleProof);
        // Deposit for this sender into governance locking vault
        lockingVault.deposit(destination, amount, delegate);
    }

    /// @notice Claims an amount of tokens which are in the tree and send them to the user
    /// @param amount The amount of tokens to claim
    /// @param totalGrant The total amount of tokens the user was granted
    /// @param merkleProof The merkle de-commitment which proves the user is in the merkle root
    /// @param destination The address which will be credited with funds
    function claim(
        uint256 amount,
        uint256 totalGrant,
        bytes32[] calldata merkleProof,
        address destination
    ) external {
        // Validate the withdraw
        _validateWithdraw(amount, totalGrant, merkleProof);
        // Transfer to the user
        token.transfer(destination, amount);
    }

    /// @notice Validate a withdraw attempt by checking merkle proof and ensuring the user has not
    ///         previously withdrawn
    /// @param amount The amount of tokens being claimed
    /// @param totalGrant The total amount of tokens the user was granted
    /// @param merkleProof The merkle de-commitment which proves the user is in the merkle root
    function _validateWithdraw(
        uint256 amount,
        uint256 totalGrant,
        bytes32[] memory merkleProof
    ) internal {
        // Hash the user plus the total grant amount
        bytes32 leafHash = keccak256(abi.encodePacked(msg.sender, totalGrant));

        // Verify the proof for this leaf
        require(
            MerkleProof.verify(merkleProof, rewardsRoot, leafHash),
            "Invalid Proof"
        );
        // Check that this claim won't give them more than the total grant then
        // increase the stored claim amount
        require(claimed[msg.sender] + amount <= totalGrant, "Claimed too much");
        claimed[msg.sender] += amount;
    }
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/features/Airdrop.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;


// A merkle rewards contract with an expiration time

contract Airdrop is MerkleRewards, Authorizable {
    // The time after which the token cannot be claimed
    uint256 public immutable expiration;

    /// @notice Constructs the contract and sets state and immutable variables
    /// @param _governance The address which can withdraw funds when the drop expires
    /// @param _merkleRoot The root a keccak256 merkle tree with leaves which are address amount pairs
    /// @param _token The erc20 contract which will be sent to the people with claims on the contract
    /// @param _expiration The unix second timestamp when the airdrop expires
    /// @param _lockingVault The governance vault which this deposits to on behalf of users
    constructor(
        address _governance,
        bytes32 _merkleRoot,
        IERC20 _token,
        uint256 _expiration,
        ILockingVault _lockingVault
    ) MerkleRewards(_merkleRoot, _token, _lockingVault) {
        // Set expiration immutable and governance to the owner
        expiration = _expiration;
        setOwner(_governance);
    }

    /// @notice Allows governance to remove the funds in this contract once the airdrop is over.
    ///         Claims aren't blocked the airdrop ending at expiration is optional and gov has to
    ///         manually end it.
    /// @param destination The treasury contract which will hold the freed tokens
    function reclaim(address destination) external onlyOwner {
        require(block.timestamp > expiration, "Not expired");
        uint256 unclaimed = token.balanceOf(address(this));
        token.transfer(destination, unclaimed);
    }
}
