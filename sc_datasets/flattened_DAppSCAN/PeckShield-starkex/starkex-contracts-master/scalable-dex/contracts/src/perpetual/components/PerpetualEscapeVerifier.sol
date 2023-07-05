// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/IFactRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  The Fact Registry design pattern is a way to separate cryptographic verification from the
  business logic of the contract flow.

  A fact registry holds a hash table of verified "facts" which are represented by a hash of claims
  that the registry hash check and found valid. This table may be queried by accessing the
  isValid() function of the registry with a given hash.

  In addition, each fact registry exposes a registry specific function for submitting new claims
  together with their proofs. The information submitted varies from one registry to the other
  depending of the type of fact requiring verification.

  For further reading on the Fact Registry design pattern see this
  `StarkWare blog post <https://medium.com/starkware/the-fact-registry-a64aafb598b6>`_.
*/
interface IFactRegistry {
    /*
      Returns true if the given fact was previously registered in the contract.
    */
    function isValid(bytes32 fact) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/IQueryableFactRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Extends the IFactRegistry interface with a query method that indicates
  whether the fact registry has successfully registered any fact or is still empty of such facts.
*/
interface IQueryableFactRegistry is IFactRegistry {
    /*
      Returns true if at least one fact has been registered.
    */
    function hasRegisteredFact() external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/FactRegistry.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract FactRegistry is IQueryableFactRegistry {
    // Mapping: fact hash -> true.
    mapping(bytes32 => bool) private verifiedFact;

    // Indicates whether the Fact Registry has at least one fact registered.
    bool anyFactRegistered;

    /*
      Checks if a fact has been verified.
    */
    function isValid(bytes32 fact) external view override returns (bool) {
        return _factCheck(fact);
    }

    /*
      This is an internal method to check if the fact is already registered.
      In current implementation of FactRegistry it's identical to isValid().
      But the check is against the local fact registry,
      So for a derived referral fact registry, it's not the same.
    */
    function _factCheck(bytes32 fact) internal view returns (bool) {
        return verifiedFact[fact];
    }

    function registerFact(bytes32 factHash) internal {
        // This function stores the fact hash in the mapping.
        verifiedFact[factHash] = true;

        // Mark first time off.
        if (!anyFactRegistered) {
            anyFactRegistered = true;
        }
    }

    /*
      Indicates whether at least one fact was registered.
    */
    function hasRegisteredFact() external view override returns (bool) {
        return anyFactRegistered;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/components/PedersenMerkleVerifier.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract PedersenMerkleVerifier {
    // Note that those values are hardcoded in the assembly.
    uint256 internal constant N_TABLES = 63;

    address[N_TABLES] lookupTables;

    constructor(address[N_TABLES] memory tables) public {
        lookupTables = tables;

        assembly {
            if gt(lookupTables_slot, 0) {
                // The address of the lookupTables must be 0.
                // This is guaranteed by the ABI, as long as it is the first storage variable.
                // This is an assumption in the implementation, and can be removed if
                // the lookup table address is taken into account.
                revert(0, 0)
            }
        }
    }

    /**
      Verifies a merkle proof for a Merkle commitment.

      The Merkle commitment uses the Pedersen hash variation described next:

      - **Hash constants:** A sequence :math:`p_i` of 504 points on an elliptic curve and an additional :math:`ec_{shift}` point
      - **Input:** A vector of 504 bits :math:`b_i`
      - **Output:** The 252 bits x coordinate of :math:`(ec_{shift} + \sum_i b_i*p_i)`

      The following table describes the expected `merkleProof` format. Note that unlike a standard
      Merkle proof, the `merkleProof` contains both the nodes along the Merkle path and their
      siblings. The proof ends with the expected root and the ID of the vault for which the proof is
      submitted (which implies the location of the nodes within the Merkle tree).

          +-------------------------------+---------------------------+-----------+
          | left_node_0 (252)             | right_node_0 (252)        | zeros (8) |
          +-------------------------------+---------------------------+-----------+
          | ...                                                                   |
          +-------------------------------+---------------------------+-----------+
          | left_node_n (252)             | right_node_n (252)        | zeros (8) |
          +-------------------------------+-----------+---------------+-----------+
          | root (252)                    | zeros (4) | nodeIdx (248) | zeros (8) |
          +-------------------------------+-----------+---------------+-----------+


      Note that if the merkle leafs are computed using a hashchain as follows:
        hashchain_state = init_state
        for value in leaf_values:
            hashchain_state = pedersen_hash(hashchain_state, value)
        leaf_value = hashchain_state

      Then we may use this function to verify the leaf value by setting:
      nodeIdx = merkle_idx << hashchain_lengh and for every 0 <= i < hashchain_lengh.
      left_node_0 = hashchain_state_i
      right_node_i = leaf_values_i.

    */
    /*
      Implementation details:
      The EC sum required for the hash computation is computed using lookup tables and EC additions.
      There are 63 lookup tables and each table contains all the possible subset sums of the
      corresponding 8 EC points in the hash definition.

      Both the full subset sum and the tables are shifted to avoid a special case for the 0 point.
      lookupTables[0] uses the offset 2^62*ec_shift and lookupTables[k] for k > 0 uses
      the offset 2^(62-k)*(-ec_shift).
      Note that the sum of the shifts of all the tables is exactly the shift required for the
      hash. Moreover, the partial sums of those shifts are never 0.

      The calls to the lookup table contracts are batched to save on gas cost.
      We allocate a table of N_HASHES by N_TABLES EC elements.
      Fill the i'th row by calling the i'th lookup contract to lookup the i'th byte in each hash and
      then compute the j'th hash by summing the j'th column.

                  N_HASHES
              --------------
              |            |
              |            |
              |            |
              |            | N_TABLES
              |            |
              |            |
              |            |
              |            |
              --------------

      The batched lookup is facilitated by the fact that the merkleProof includes nodes along the
      Merkle path.
      However having this redundant information requires us to do consistency checks
      to ensure we indeed verify a coherent authentication path:

          hash((left_node_{i-1}, right_node_{i-1})) ==
            (nodeIdx & (1<<i)) == 0 ? left_node_i : right_node_i.
    */
    function verifyMerkle(uint256[] memory merkleProof) internal view {
        uint256 proofLength = merkleProof.length;

        // The minimal supported proof length is for a tree height of 1 in a 4 word representation as follows:
        // 1 word pairs representing the authentication path.
        // 1 word pair representing the root and the nodeIdx.
        require(proofLength >= 4, "Proof too short.");

        // The contract supports verification paths of lengths up to 200 in a 402 word representation as described above.
        // This limitation is imposed in order to avoid potential attacks.
        require(proofLength <= 402, "Proof too long.");

        // Ensure proofs are always a series of word pairs.
        require((proofLength & 1) == 0, "Proof length must be even.");

        // Each hash takes 2 256bit words and the last two words are the root and nodeIdx.
        uint256 height = (proofLength - 2) / 2; // NOLINT: divide-before-multiply.

        // Note that it is important to limit the range of vault id, to make sure
        // we use the left node (== merkle_root) in the last iteration of the loop below.

        uint256 nodeIdx = merkleProof[proofLength - 1] >> 8;
        require(nodeIdx < 2**height, "nodeIdx not in tree.");
        require((nodeIdx & 1) == 0, "nodeIdx must be even.");

        uint256 rowSize = (2 * height) * 0x20;
        uint256[] memory proof = merkleProof;
        assembly {
            // Skip the length of the proof array.
            proof := add(proof, 0x20)

            function raise_error(message, msg_len) {
                // Solidity generates reverts with reason that look as follows:
                // 1. 4 bytes with the constant 0x08c379a0 (== Keccak256(b'Error(string)')[:4]).
                // 2. 32 bytes offset bytes (typically 0x20).
                // 3. 32 bytes with the length of the revert reason.
                // 4. Revert reason string.

                mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(0x4, 0x20)
                mstore(0x24, msg_len)
                mstore(0x44, message)
                revert(0, add(0x44, msg_len))
            }

            let left_node := shr(4, mload(proof))
            let right_node := and(
                mload(add(proof, 0x1f)),
                0x0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            )

            let primeMinusOne := 0x800000000000011000000000000000000000000000000000000000000000000
            if or(gt(left_node, primeMinusOne), gt(right_node, primeMinusOne)) {
                raise_error("Bad starkKey or assetId.", 24)
            }

            let nodeSelectors := nodeIdx

            // Allocate EC points table with dimensions N_TABLES by N_HASHES.
            let table := mload(0x40)
            let tableEnd := add(
                table,
                mul(
                    rowSize,
                    // N_TABLES=
                    63
                )
            )

            // for i = 0..N_TABLES-1, fill the i'th row in the table.
            for {
                let i := 0
            } lt(i, 63) {
                i := add(i, 1)
            } {
                if iszero(
                    staticcall(
                        gas(),
                        sload(i),
                        add(proof, i),
                        rowSize,
                        add(table, mul(i, rowSize)),
                        rowSize
                    )
                ) {
                    returndatacopy(0, 0, returndatasize())
                    revert(0, returndatasize())
                }
            }

            // The following variables are allocated above PRIME to avoid the stack too deep error.
            // Byte offset used to access the table and proof.
            let offset := 0
            let ptr
            let aZ

            let PRIME := 0x800000000000011000000000000000000000000000000000000000000000001

            // For k = 0..HASHES-1, Compute the k'th hash by summing the k'th column in table.
            // Instead of k we use offset := k * sizeof(EC point).
            // Additonally we use ptr := offset + j * rowSize to ge over the EC points we want
            // to sum.
            for {

            } lt(offset, rowSize) {

            } {
                // Init (aX, aY, aZ) to the first value in the current column and sum over the
                // column.
                ptr := add(table, offset)
                aZ := 1
                let aX := mload(ptr)
                let aY := mload(add(ptr, 0x20))

                for {
                    ptr := add(ptr, rowSize)
                } lt(ptr, tableEnd) {
                    ptr := add(ptr, rowSize)
                } {
                    let bX := mload(ptr)
                    let bY := mload(add(ptr, 0x20))

                    // Set (aX, aY, aZ) to be the sum of the EC points (aX, aY, aZ) and (bX, bY, 1).
                    let minusAZ := sub(PRIME, aZ)
                    // Slope = sN/sD =  {(aY/aZ) - (bY/1)} / {(aX/aZ) - (bX/1)}.
                    // sN = aY - bY * aZ.
                    let sN := addmod(aY, mulmod(minusAZ, bY, PRIME), PRIME)

                    let minusAZBX := mulmod(minusAZ, bX, PRIME)
                    // sD = aX - bX * aZ.
                    let sD := addmod(aX, minusAZBX, PRIME)

                    let sSqrD := mulmod(sD, sD, PRIME)

                    // Compute the (affine) x coordinate of the result as xN/xD.

                    // (xN/xD) = ((sN)^2/(sD)^2) - (aX/aZ) - (bX/1).
                    // xN = (sN)^2 * aZ - aX * (sD)^2 - bX * (sD)^2 * aZ.
                    // = (sN)^2 * aZ + (sD^2) (bX * (-aZ) - aX).
                    let xN := addmod(
                        mulmod(mulmod(sN, sN, PRIME), aZ, PRIME),
                        mulmod(sSqrD, add(minusAZBX, sub(PRIME, aX)), PRIME),
                        PRIME
                    )

                    // xD = (sD)^2 * aZ.
                    let xD := mulmod(sSqrD, aZ, PRIME)

                    // Compute (aX', aY', aZ') for the next iteration and assigning them to (aX, aY, aZ).
                    // (y/z) = (sN/sD) * {(bX/1) - (xN/xD)} - (bY/1).
                    // aZ' = sD*xD.
                    aZ := mulmod(sD, xD, PRIME)
                    // aY' = sN*(bX * xD - xN) - bY*z = -bY * z + sN * (-xN + xD*bX).
                    aY := addmod(
                        sub(PRIME, mulmod(bY, aZ, PRIME)),
                        mulmod(sN, add(sub(PRIME, xN), mulmod(xD, bX, PRIME)), PRIME),
                        PRIME
                    )

                    // As the value of the affine x coordinate is xN/xD and z=sD*xD,
                    // the projective x coordinate is xN*sD.
                    aX := mulmod(xN, sD, PRIME)
                }

                // At this point proof[offset + 0x40] holds the next input to be hashed.
                // This input is typically in the form left_node||right_node||0 and
                // we need to extract the relevant node for the consistent check below.
                // Note that the same logic is reused for the leaf computation and
                // for the consistent check with the final root.
                offset := add(offset, 0x40)

                // Init expected_hash to left_node.
                // It will be replaced by right_node if necessary.
                let expected_hash := shr(4, mload(add(proof, offset)))

                let other_node := and(
                    // right_node
                    mload(add(proof, add(offset, 0x1f))),
                    0x0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                )

                // Make sure both nodes are in the range [0, PRIME - 1].
                if or(gt(expected_hash, primeMinusOne), gt(other_node, primeMinusOne)) {
                    raise_error("Value out of range.", 19)
                }

                nodeSelectors := shr(1, nodeSelectors)
                if and(nodeSelectors, 1) {
                    expected_hash := other_node
                }

                // Make sure the result is consistent with the Merkle path.
                // I.e (aX/aZ) == expected_hash,
                // where expected_hash = (nodeSelectors & 1) == 0 ? left_node : right_node.
                // We also make sure aZ is not 0. I.e. during the summation we never tried
                // to add two points with the same x coordinate.
                // This is not strictly necessary because knowing how to trigger this condition
                // implies knowing a non-trivial linear equation on the random points defining the
                // hash function.
                if iszero(aZ) {
                    raise_error("aZ is zero.", 11)
                }

                if sub(aX, mulmod(expected_hash, aZ, PRIME)) {
                    raise_error("Bad Merkle path.", 16)
                }
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/interfaces/Identity.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

interface Identity {
    /*
      Allows a caller, typically another contract,
      to ensure that the provided address is of the expected type and version.
    */
    function identify() external pure returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/ProgramOutputOffsets.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract ProgramOutputOffsets {
    // The following constants are offsets of data expected in the program output.
    // The offsets here are of the fixed fields.
    uint256 internal constant PROG_OUT_GENERAL_CONFIG_HASH = 0;
    uint256 internal constant PROG_OUT_N_ASSET_CONFIGS = 1;
    uint256 internal constant PROG_OUT_ASSET_CONFIG_HASHES = 2;

    /*
      Additional mandatory fields of a single word:
      - Previous state size         2
      - New state size              3
      - Vault tree height           4
      - Order tree height           5
      - Expiration timestamp        6
      - No. of Modifications        7.
    */
    uint256 internal constant PROG_OUT_N_WORDS_MIN_SIZE = 8;

    uint256 internal constant PROG_OUT_N_WORDS_PER_ASSET_CONFIG = 2;
    uint256 internal constant PROG_OUT_N_WORDS_PER_MODIFICATION = 3;

    uint256 internal constant ASSET_CONFIG_OFFSET_ASSET_ID = 0;
    uint256 internal constant ASSET_CONFIG_OFFSET_CONFIG_HASH = 1;

    uint256 internal constant MODIFICATIONS_OFFSET_STARKKEY = 0;
    uint256 internal constant MODIFICATIONS_OFFSET_POS_ID = 1;
    uint256 internal constant MODIFICATIONS_OFFSET_BIASED_DIFF = 2;

    uint256 internal constant STATE_OFFSET_VAULTS_ROOT = 0;
    uint256 internal constant STATE_OFFSET_VAULTS_HEIGHT = 1;
    uint256 internal constant STATE_OFFSET_ORDERS_ROOT = 2;
    uint256 internal constant STATE_OFFSET_ORDERS_HEIGHT = 3;
    uint256 internal constant STATE_OFFSET_N_FUNDING = 4;
    uint256 internal constant STATE_OFFSET_FUNDING = 5;

    // The following constants are offsets of data expected in the application data.
    uint256 internal constant APP_DATA_BATCH_ID_OFFSET = 0;
    uint256 internal constant APP_DATA_PREVIOUS_BATCH_ID_OFFSET = 1;
    uint256 internal constant APP_DATA_N_CONDITIONAL_TRANSFER = 2;
    uint256 internal constant APP_DATA_CONDITIONAL_TRANSFER_DATA_OFFSET = 3;
    uint256 internal constant APP_DATA_N_WORDS_PER_CONDITIONAL_TRANSFER = 2;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/scalable-dex/contracts/src/perpetual/components/PerpetualEscapeVerifier.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;




/*
  A PerpetualEscapeVerifier is a fact registry contract for claims of the form:
    The owner of 'publicKey' may withdraw 'withdrawalAmount' qunatized collateral units
    from 'positionId' assuming the hash of the shared state is 'sharedStateHash'

  The fact is encoded as:
    keccak256(abi.encodePacked(
        publicKey, withdrawalAmount, sharedStateHash, positionId).
*/
contract PerpetualEscapeVerifier is
    PedersenMerkleVerifier,
    FactRegistry,
    Identity,
    ProgramOutputOffsets
{
    event LogEscapeVerified(
        uint256 publicKey,
        int256 withdrawalAmount,
        bytes32 sharedStateHash,
        uint256 positionId
    );

    uint256 internal constant N_ASSETS_BITS = 16;
    uint256 internal constant BALANCE_BITS = 64;
    uint256 internal constant FUNDING_BITS = 64;
    uint256 internal constant BALANCE_BIAS = 2**63;
    uint256 internal constant FXP_BITS = 32;

    uint256 internal constant FUNDING_ENTRY_SIZE = 2;
    uint256 internal constant PRICE_ENTRY_SIZE = 2;

    constructor(address[N_TABLES] memory tables) public PedersenMerkleVerifier(tables) {}

    function identify() external pure virtual override returns (string memory) {
        return "StarkWare_PerpetualEscapeVerifier_2021_2";
    }

    /*
      Finds an entry corresponding to assetId in the slice array[startIdx:endIdx].
      Assumes that size of each entry is 2 and that the key is in offset 0 of an entry.
    */
    function findAssetId(
        uint256 assetId,
        uint256[] memory array,
        uint256 startIdx,
        uint256 endIdx
    ) internal pure returns (uint256 idx) {
        idx = startIdx;
        while (array[idx] != assetId) {
            idx += 2; // entry_size.
            require(idx < endIdx, "assetId not found.");
        }
    }

    /*
      Computes the balance of the position according to the sharedState.

      Assumes the position is given as
      [
       positionAsset_0, positionAsset_1, ..., positionAsset_{n_assets},
       publicKey, biasedBalance << N_ASSETS_BITS | nAssets,
      ]
      where positionAsset_{i} is encoded as
         assedId << 128 | cachedFunding << BALANCE_BITS | biased_asset_balance.

    */
    function computeFxpBalance(uint256[] memory position, uint256[] memory sharedState)
        internal
        pure
        returns (int256)
    {
        uint256 nAssets;
        uint256 fxpBalance;

        {
            // Decode collateral_balance and nAssets.
            uint256 lastWord = position[position.length - 1];
            nAssets = lastWord & ((1 << N_ASSETS_BITS) - 1);
            uint256 biasedBalance = lastWord >> N_ASSETS_BITS;

            require(position.length == nAssets + 2, "Bad number of assets.");
            require(biasedBalance < 2**BALANCE_BITS, "Bad balance.");

            fxpBalance = (biasedBalance - BALANCE_BIAS) << FXP_BITS;
        }

        uint256 fundingIndicesOffset = STATE_OFFSET_FUNDING;
        uint256 nFundingIndices = sharedState[fundingIndicesOffset - 1];

        uint256 fundingEnd = fundingIndicesOffset + FUNDING_ENTRY_SIZE * nFundingIndices;

        // Skip global_funding_indices.timestamp and nPrices.
        uint256 pricesOffset = fundingEnd + 2;
        uint256 nPrices = sharedState[pricesOffset - 1];
        uint256 pricesEnd = pricesOffset + PRICE_ENTRY_SIZE * nPrices;
        // Copy sharedState ptr to workaround stack too deep.
        uint256[] memory sharedStateCopy = sharedState;

        uint256 fundingTotal = 0;
        for (uint256 i = 0; i < nAssets; i++) {
            // Decodes a positionAsset (See encoding in the function description).
            uint256 positionAsset = position[i];
            uint256 assedId = positionAsset >> 128;

            // Note that the funding_indices in both the position and the shared state
            // are biased by the same amount.
            uint256 cachedFunding = (positionAsset >> BALANCE_BITS) & (2**FUNDING_BITS - 1);
            uint256 assetBalance = (positionAsset & (2**BALANCE_BITS - 1)) - BALANCE_BIAS;

            fundingIndicesOffset = findAssetId(
                assedId,
                sharedStateCopy,
                fundingIndicesOffset,
                fundingEnd
            );
            fundingTotal -=
                assetBalance *
                (sharedStateCopy[fundingIndicesOffset + 1] - cachedFunding);

            pricesOffset = findAssetId(assedId, sharedStateCopy, pricesOffset, pricesEnd);
            fxpBalance += assetBalance * sharedStateCopy[pricesOffset + 1];
        }

        uint256 truncatedFunding = fundingTotal & ~(2**FXP_BITS - 1);
        return int256(fxpBalance + truncatedFunding);
    }

    /*
      Extracts the position from the escapeProof.

      Assumes the position is encoded in the first (nAssets + 2) right nodes in the merkleProof.
      and that each pair of nodes is encoded in 2 256bits words as follows:
      +-------------------------------+---------------------------+-----------+
      | left_node_i (252)             | right_node_i (252)        | zeros (8) |
      +-------------------------------+---------------------------+-----------+

      See PedersenMerkleVerifier.sol for more details.
    */
    function extractPosition(uint256[] memory merkleProof, uint256 nAssets)
        internal
        pure
        returns (uint256 positionId, uint256[] memory position)
    {
        require((merkleProof[0] >> 8) == 0, "Position hash-chain must start with 0.");

        uint256 positionLength = nAssets + 2;
        position = new uint256[](positionLength);
        uint256 nodeIdx = merkleProof[merkleProof.length - 1] >> 8;

        // Check that the merkleProof starts with a hash_chain of 'positionLength' elements.
        require(
            (nodeIdx & ((1 << positionLength) - 1)) == 0,
            "merkleProof is inconsistent with nAssets."
        );
        positionId = nodeIdx >> positionLength;

        assembly {
            let positionPtr := add(position, 0x20)
            let positionEnd := add(positionPtr, mul(mload(position), 0x20))
            let proofPtr := add(merkleProof, 0x3f)

            for {

            } lt(positionPtr, positionEnd) {
                positionPtr := add(positionPtr, 0x20)
            } {
                mstore(
                    positionPtr,
                    and(
                        mload(proofPtr),
                        0x0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                    )
                )
                proofPtr := add(proofPtr, 0x40)
            }
        }
    }

    /*
      Verifies an escape and registers the corresponding fact as
        keccak256(abi.encodePacked(
            publicKey, withdrawalAmount, sharedStateHash, positionId)).

      The escape verification has two parts:
        a. verifying that a certain position belongs to the position tree in the shared state.
        b. computing the amount that may be withdrawan from that position.

      Part a is delegated to the PedersenMerkleVerifier.
      To this end the position is encoded in the prefix of the merkleProof and the node_selector at
      the end of the merkleProof is adjusted accordingly.
    */
    function verifyEscape(
        uint256[] calldata merkleProof,
        uint256 nAssets,
        uint256[] calldata sharedState
    ) external {
        (uint256 positionId, uint256[] memory position) = extractPosition(merkleProof, nAssets);

        int256 withdrawalAmount = computeFxpBalance(position, sharedState) >> FXP_BITS;

        // Each hash takes 2 256bit words and the last two words are the root and nodeIdx.
        uint256 nHashes = (merkleProof.length - 2) / 2; // NOLINT: divide-before-multiply.
        uint256 positionTreeHeight = nHashes - position.length;

        require(
            sharedState[STATE_OFFSET_VAULTS_ROOT] == (merkleProof[merkleProof.length - 2] >> 4),
            "merkleProof is inconsistent with the root in the sharedState."
        );

        require(
            sharedState[STATE_OFFSET_VAULTS_HEIGHT] == positionTreeHeight,
            "merkleProof is inconsistent with the height in the sharedState."
        );

        require(withdrawalAmount > 0, "Withdrawal amount must be positive.");
        bytes32 sharedStateHash = keccak256(abi.encodePacked(sharedState));

        uint256 publicKey = position[nAssets];
        emit LogEscapeVerified(publicKey, withdrawalAmount, sharedStateHash, positionId);
        bytes32 fact = keccak256(
            abi.encodePacked(publicKey, withdrawalAmount, sharedStateHash, positionId)
        );

        verifyMerkle(merkleProof);

        registerFact(fact);
    }
}
