// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/IMerkleVerifier.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

abstract contract IMerkleVerifier {
    uint256 internal constant MAX_N_MERKLE_VERIFIER_QUERIES = 128;

    // The size of a SLOT in the verifyMerkle queue.
    // Every slot holds a (index, hash) pair.
    uint256 internal constant MERKLE_SLOT_SIZE_IN_BYTES = 0x40;

    function verifyMerkle(
        uint256 channelPtr,
        uint256 queuePtr,
        bytes32 root,
        uint256 n
    ) internal view virtual returns (bytes32 hash);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/MerkleVerifier.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract MerkleVerifier is IMerkleVerifier {
    // Commitments are masked to 160bit using the following mask to save gas costs.
    uint256 internal constant COMMITMENT_MASK = (
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000
    );

    // The size of a commitment. We use 32 bytes (rather than 20 bytes) per commitment as it
    // simplifies the code.
    uint256 internal constant COMMITMENT_SIZE_IN_BYTES = 0x20;

    // The size of two commitments.
    uint256 internal constant TWO_COMMITMENTS_SIZE_IN_BYTES = 0x40;

    // The size of and index in the verifyMerkle queue.
    uint256 internal constant INDEX_SIZE_IN_BYTES = 0x20;

    /*
      Verifies a Merkle tree decommitment for n leaves in a Merkle tree with N leaves.

      The inputs data sits in the queue at queuePtr.
      Each slot in the queue contains a 32 bytes leaf index and a 32 byte leaf value.
      The indices need to be in the range [N..2*N-1] and strictly incrementing.
      Decommitments are read from the channel in the ctx.

      The input data is destroyed during verification.
    */
    function verifyMerkle(
        uint256 channelPtr,
        uint256 queuePtr,
        bytes32 root,
        uint256 n
    ) internal view virtual override returns (bytes32 hash) {
        require(n <= MAX_N_MERKLE_VERIFIER_QUERIES, "TOO_MANY_MERKLE_QUERIES");

        assembly {
            // queuePtr + i * MERKLE_SLOT_SIZE_IN_BYTES gives the i'th index in the queue.
            // hashesPtr + i * MERKLE_SLOT_SIZE_IN_BYTES gives the i'th hash in the queue.
            let hashesPtr := add(queuePtr, INDEX_SIZE_IN_BYTES)
            let queueSize := mul(n, MERKLE_SLOT_SIZE_IN_BYTES)

            // The items are in slots [0, n-1].
            let rdIdx := 0
            let wrIdx := 0 // = n % n.

            // Iterate the queue until we hit the root.
            let index := mload(add(rdIdx, queuePtr))
            let proofPtr := mload(channelPtr)

            // while(index > 1).
            for {

            } gt(index, 1) {

            } {
                let siblingIndex := xor(index, 1)
                // sibblingOffset := COMMITMENT_SIZE_IN_BYTES * lsb(siblingIndex).
                let sibblingOffset := mulmod(
                    siblingIndex,
                    COMMITMENT_SIZE_IN_BYTES,
                    TWO_COMMITMENTS_SIZE_IN_BYTES
                )

                // Store the hash corresponding to index in the correct slot.
                // 0 if index is even and 0x20 if index is odd.
                // The hash of the sibling will be written to the other slot.
                mstore(xor(0x20, sibblingOffset), mload(add(rdIdx, hashesPtr)))
                rdIdx := addmod(rdIdx, MERKLE_SLOT_SIZE_IN_BYTES, queueSize)

                // Inline channel operation:
                // Assume we are going to read a new hash from the proof.
                // If this is not the case add(proofPtr, COMMITMENT_SIZE_IN_BYTES) will be reverted.
                let newHashPtr := proofPtr
                proofPtr := add(proofPtr, COMMITMENT_SIZE_IN_BYTES)

                // Push index/2 into the queue, before reading the next index.
                // The order is important, as otherwise we may try to read from an empty queue (in
                // the case where we are working on one item).
                // wrIdx will be updated after writing the relevant hash to the queue.
                mstore(add(wrIdx, queuePtr), div(index, 2))

                // Load the next index from the queue and check if it is our sibling.
                index := mload(add(rdIdx, queuePtr))
                if eq(index, siblingIndex) {
                    // Take sibling from queue rather than from proof.
                    newHashPtr := add(rdIdx, hashesPtr)
                    // Revert reading from proof.
                    proofPtr := sub(proofPtr, COMMITMENT_SIZE_IN_BYTES)
                    rdIdx := addmod(rdIdx, MERKLE_SLOT_SIZE_IN_BYTES, queueSize)

                    // Index was consumed, read the next one.
                    // Note that the queue can't be empty at this point.
                    // The index of the parent of the current node was already pushed into the
                    // queue, and the parent is never the sibling.
                    index := mload(add(rdIdx, queuePtr))
                }

                mstore(sibblingOffset, mload(newHashPtr))

                // Push the new hash to the end of the queue.
                mstore(
                    add(wrIdx, hashesPtr),
                    and(COMMITMENT_MASK, keccak256(0x00, TWO_COMMITMENTS_SIZE_IN_BYTES))
                )
                wrIdx := addmod(wrIdx, MERKLE_SLOT_SIZE_IN_BYTES, queueSize)
            }
            hash := mload(add(rdIdx, hashesPtr))

            // Update the proof pointer in the context.
            mstore(channelPtr, proofPtr)
        }
        // emit LogBool(hash == root);
        require(hash == root, "INVALID_MERKLE_PROOF");
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/PrimeFieldElement0.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract PrimeFieldElement0 {
    uint256 internal constant K_MODULUS =
        0x800000000000011000000000000000000000000000000000000000000000001;
    uint256 internal constant K_MONTGOMERY_R =
        0x7fffffffffffdf0ffffffffffffffffffffffffffffffffffffffffffffffe1;
    uint256 internal constant K_MONTGOMERY_R_INV =
        0x40000000000001100000000000012100000000000000000000000000000000;
    uint256 internal constant GENERATOR_VAL = 3;
    uint256 internal constant ONE_VAL = 1;

    function fromMontgomery(uint256 val) internal pure returns (uint256 res) {
        // uint256 res = fmul(val, kMontgomeryRInv);
        assembly {
            res := mulmod(val, K_MONTGOMERY_R_INV, K_MODULUS)
        }
        return res;
    }

    function fromMontgomeryBytes(bytes32 bs) internal pure returns (uint256) {
        // Assuming bs is a 256bit bytes object, in Montgomery form, it is read into a field
        // element.
        uint256 res = uint256(bs);
        return fromMontgomery(res);
    }

    function toMontgomeryInt(uint256 val) internal pure returns (uint256 res) {
        //uint256 res = fmul(val, kMontgomeryR);
        assembly {
            res := mulmod(val, K_MONTGOMERY_R, K_MODULUS)
        }
        return res;
    }

    function fmul(uint256 a, uint256 b) internal pure returns (uint256 res) {
        //uint256 res = mulmod(a, b, kModulus);
        assembly {
            res := mulmod(a, b, K_MODULUS)
        }
        return res;
    }

    function fadd(uint256 a, uint256 b) internal pure returns (uint256 res) {
        // uint256 res = addmod(a, b, kModulus);
        assembly {
            res := addmod(a, b, K_MODULUS)
        }
        return res;
    }

    function fsub(uint256 a, uint256 b) internal pure returns (uint256 res) {
        // uint256 res = addmod(a, kModulus - b, kModulus);
        assembly {
            res := addmod(a, sub(K_MODULUS, b), K_MODULUS)
        }
        return res;
    }

    function fpow(uint256 val, uint256 exp) internal view returns (uint256) {
        return expmod(val, exp, K_MODULUS);
    }

    function expmod(
        uint256 base,
        uint256 exponent,
        uint256 modulus
    ) internal view returns (uint256 res) {
        assembly {
            let p := mload(0x40)
            mstore(p, 0x20) // Length of Base.
            mstore(add(p, 0x20), 0x20) // Length of Exponent.
            mstore(add(p, 0x40), 0x20) // Length of Modulus.
            mstore(add(p, 0x60), base) // Base.
            mstore(add(p, 0x80), exponent) // Exponent.
            mstore(add(p, 0xa0), modulus) // Modulus.
            // Call modexp precompile.
            if iszero(staticcall(gas(), 0x05, p, 0xc0, p, 0x20)) {
                revert(0, 0)
            }
            res := mload(p)
        }
    }

    function inverse(uint256 val) internal view returns (uint256) {
        return expmod(val, K_MODULUS - 2, K_MODULUS);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/FriTransform.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  The FRI transform for a coset of size 2 (x, -x) takes the inputs
  x, f(x), f(-x) and evalPoint
  and returns
  (f(x) + f(-x) + evalPoint*(f(x) - f(-x))/x) / 2.

  The implementation here modifies this transformation slightly:
  1. Since dividing by 2 does not affect the degree, it is omitted here (and in the prover).
  2. The division by x is replaced by multiplication by x^-1, x^-1 is passed as input to the
     transform and (x^-1)^2 is returned as it will be needed in the next layer.

  To apply the transformation on a larger coset the transformation above is used multiple times
  with the evaluation points: evalPoint, evalPoint^2, evalPoint^4, ...
  see for example do2FriSteps.
*/
contract FriTransform is PrimeFieldElement0 {
    // The largest power of 2 multiple of K_MODULUS that fits in a uint256.
    // The value is given as a constant because "Only direct number constants and references to such
    // constants are supported by inline assembly."
    // This constant is used in places where we delay the module operation to reduce gas usage.
    uint256 internal constant K_MODULUS_TIMES_16 = (
        0x8000000000000110000000000000000000000000000000000000000000000010
    );

    /*
      Applies 2 + 1 FRI transformations to a coset of size 2^4.

      evaluations on coset:                    f0 f1  f2 f3
      ----------------------------------------  \ / -- \ / -----------
                                                 f0    f2
      ------------------------------------------- \ -- / -------------
      nextLayerValue:                               f0

      For more detail, see description of the FRI transformations at the top of this file.
    */
    function do2FriSteps(
        uint256 friHalfInvGroupPtr,
        uint256 evaluationsOnCosetPtr,
        uint256 cosetOffset_,
        uint256 friEvalPoint
    ) internal pure returns (uint256 nextLayerValue, uint256 nextXInv) {
        assembly {
            let friEvalPointDivByX := mulmod(friEvalPoint, cosetOffset_, K_MODULUS)

            let f0 := mload(evaluationsOnCosetPtr)
            {
                let f1 := mload(add(evaluationsOnCosetPtr, 0x20))

                // f0 < 3P ( = 1 + 1 + 1).
                f0 := add(
                    add(f0, f1),
                    mulmod(
                        friEvalPointDivByX,
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS, f1)
                        ),
                        K_MODULUS
                    )
                )
            }

            let f2 := mload(add(evaluationsOnCosetPtr, 0x40))
            {
                let f3 := mload(add(evaluationsOnCosetPtr, 0x60))
                f2 := addmod(
                    add(f2, f3),
                    mulmod(
                        add(
                            f2,
                            // -fMinusX
                            sub(K_MODULUS, f3)
                        ),
                        mulmod(mload(add(friHalfInvGroupPtr, 0x20)), friEvalPointDivByX, K_MODULUS),
                        K_MODULUS
                    ),
                    K_MODULUS
                )
            }

            {
                let newXInv := mulmod(cosetOffset_, cosetOffset_, K_MODULUS)
                nextXInv := mulmod(newXInv, newXInv, K_MODULUS)
            }

            // f0 + f2 < 4P ( = 3 + 1).
            nextLayerValue := addmod(
                add(f0, f2),
                mulmod(
                    mulmod(friEvalPointDivByX, friEvalPointDivByX, K_MODULUS),
                    add(
                        f0,
                        // -fMinusX
                        sub(K_MODULUS, f2)
                    ),
                    K_MODULUS
                ),
                K_MODULUS
            )
        }
    }

    /*
      Applies 4 + 2 + 1 FRI transformations to a coset of size 2^3.

      For more detail, see description of the FRI transformations at the top of this file.
    */
    function do3FriSteps(
        uint256 friHalfInvGroupPtr,
        uint256 evaluationsOnCosetPtr,
        uint256 cosetOffset_,
        uint256 friEvalPoint
    ) internal pure returns (uint256 nextLayerValue, uint256 nextXInv) {
        assembly {
            let f0 := mload(evaluationsOnCosetPtr)

            let friEvalPointDivByX := mulmod(friEvalPoint, cosetOffset_, K_MODULUS)
            let friEvalPointDivByXSquared := mulmod(
                friEvalPointDivByX,
                friEvalPointDivByX,
                K_MODULUS
            )
            let imaginaryUnit := mload(add(friHalfInvGroupPtr, 0x20))

            {
                let f1 := mload(add(evaluationsOnCosetPtr, 0x20))

                // f0 < 3P ( = 1 + 1 + 1).
                f0 := add(
                    add(f0, f1),
                    mulmod(
                        friEvalPointDivByX,
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS, f1)
                        ),
                        K_MODULUS
                    )
                )
            }
            {
                let f2 := mload(add(evaluationsOnCosetPtr, 0x40))
                {
                    let f3 := mload(add(evaluationsOnCosetPtr, 0x60))

                    // f2 < 3P ( = 1 + 1 + 1).
                    f2 := add(
                        add(f2, f3),
                        mulmod(
                            add(
                                f2,
                                // -fMinusX
                                sub(K_MODULUS, f3)
                            ),
                            mulmod(friEvalPointDivByX, imaginaryUnit, K_MODULUS),
                            K_MODULUS
                        )
                    )
                }

                // f0 < 7P ( = 3 + 3 + 1).
                f0 := add(
                    add(f0, f2),
                    mulmod(
                        friEvalPointDivByXSquared,
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS_TIMES_16, f2)
                        ),
                        K_MODULUS
                    )
                )
            }
            {
                let f4 := mload(add(evaluationsOnCosetPtr, 0x80))
                {
                    let friEvalPointDivByX2 := mulmod(
                        friEvalPointDivByX,
                        mload(add(friHalfInvGroupPtr, 0x40)),
                        K_MODULUS
                    )
                    {
                        let f5 := mload(add(evaluationsOnCosetPtr, 0xa0))

                        // f4 < 3P ( = 1 + 1 + 1).
                        f4 := add(
                            add(f4, f5),
                            mulmod(
                                friEvalPointDivByX2,
                                add(
                                    f4,
                                    // -fMinusX
                                    sub(K_MODULUS, f5)
                                ),
                                K_MODULUS
                            )
                        )
                    }

                    let f6 := mload(add(evaluationsOnCosetPtr, 0xc0))
                    {
                        let f7 := mload(add(evaluationsOnCosetPtr, 0xe0))

                        // f6 < 3P ( = 1 + 1 + 1).
                        f6 := add(
                            add(f6, f7),
                            mulmod(
                                add(
                                    f6,
                                    // -fMinusX
                                    sub(K_MODULUS, f7)
                                ),
                                // friEvalPointDivByX2 * imaginaryUnit ==
                                // friEvalPointDivByX * mload(add(friHalfInvGroupPtr, 0x60)).
                                mulmod(friEvalPointDivByX2, imaginaryUnit, K_MODULUS),
                                K_MODULUS
                            )
                        )
                    }

                    // f4 < 7P ( = 3 + 3 + 1).
                    f4 := add(
                        add(f4, f6),
                        mulmod(
                            mulmod(friEvalPointDivByX2, friEvalPointDivByX2, K_MODULUS),
                            add(
                                f4,
                                // -fMinusX
                                sub(K_MODULUS_TIMES_16, f6)
                            ),
                            K_MODULUS
                        )
                    )
                }

                // f0, f4 < 7P -> f0 + f4 < 14P && 9P < f0 + (K_MODULUS_TIMES_16 - f4) < 23P.
                nextLayerValue := addmod(
                    add(f0, f4),
                    mulmod(
                        mulmod(friEvalPointDivByXSquared, friEvalPointDivByXSquared, K_MODULUS),
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS_TIMES_16, f4)
                        ),
                        K_MODULUS
                    ),
                    K_MODULUS
                )
            }

            {
                let xInv2 := mulmod(cosetOffset_, cosetOffset_, K_MODULUS)
                let xInv4 := mulmod(xInv2, xInv2, K_MODULUS)
                nextXInv := mulmod(xInv4, xInv4, K_MODULUS)
            }
        }
    }

    /*
      Applies 8 + 4 + 2 + 1 FRI transformations to a coset of size 2^4.
      to obtain a single element.

      For more detail, see description of the FRI transformations at the top of this file.
    */
    function do4FriSteps(
        uint256 friHalfInvGroupPtr,
        uint256 evaluationsOnCosetPtr,
        uint256 cosetOffset_,
        uint256 friEvalPoint
    ) internal pure returns (uint256 nextLayerValue, uint256 nextXInv) {
        assembly {
            let friEvalPointDivByXTessed
            let f0 := mload(evaluationsOnCosetPtr)

            let friEvalPointDivByX := mulmod(friEvalPoint, cosetOffset_, K_MODULUS)
            let imaginaryUnit := mload(add(friHalfInvGroupPtr, 0x20))

            {
                let f1 := mload(add(evaluationsOnCosetPtr, 0x20))

                // f0 < 3P ( = 1 + 1 + 1).
                f0 := add(
                    add(f0, f1),
                    mulmod(
                        friEvalPointDivByX,
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS, f1)
                        ),
                        K_MODULUS
                    )
                )
            }
            {
                let f2 := mload(add(evaluationsOnCosetPtr, 0x40))
                {
                    let f3 := mload(add(evaluationsOnCosetPtr, 0x60))

                    // f2 < 3P ( = 1 + 1 + 1).
                    f2 := add(
                        add(f2, f3),
                        mulmod(
                            add(
                                f2,
                                // -fMinusX
                                sub(K_MODULUS, f3)
                            ),
                            mulmod(friEvalPointDivByX, imaginaryUnit, K_MODULUS),
                            K_MODULUS
                        )
                    )
                }
                {
                    let friEvalPointDivByXSquared := mulmod(
                        friEvalPointDivByX,
                        friEvalPointDivByX,
                        K_MODULUS
                    )
                    friEvalPointDivByXTessed := mulmod(
                        friEvalPointDivByXSquared,
                        friEvalPointDivByXSquared,
                        K_MODULUS
                    )

                    // f0 < 7P ( = 3 + 3 + 1).
                    f0 := add(
                        add(f0, f2),
                        mulmod(
                            friEvalPointDivByXSquared,
                            add(
                                f0,
                                // -fMinusX
                                sub(K_MODULUS_TIMES_16, f2)
                            ),
                            K_MODULUS
                        )
                    )
                }
            }
            {
                let f4 := mload(add(evaluationsOnCosetPtr, 0x80))
                {
                    let friEvalPointDivByX2 := mulmod(
                        friEvalPointDivByX,
                        mload(add(friHalfInvGroupPtr, 0x40)),
                        K_MODULUS
                    )
                    {
                        let f5 := mload(add(evaluationsOnCosetPtr, 0xa0))

                        // f4 < 3P ( = 1 + 1 + 1).
                        f4 := add(
                            add(f4, f5),
                            mulmod(
                                friEvalPointDivByX2,
                                add(
                                    f4,
                                    // -fMinusX
                                    sub(K_MODULUS, f5)
                                ),
                                K_MODULUS
                            )
                        )
                    }

                    let f6 := mload(add(evaluationsOnCosetPtr, 0xc0))
                    {
                        let f7 := mload(add(evaluationsOnCosetPtr, 0xe0))

                        // f6 < 3P ( = 1 + 1 + 1).
                        f6 := add(
                            add(f6, f7),
                            mulmod(
                                add(
                                    f6,
                                    // -fMinusX
                                    sub(K_MODULUS, f7)
                                ),
                                // friEvalPointDivByX2 * imaginaryUnit ==
                                // friEvalPointDivByX * mload(add(friHalfInvGroupPtr, 0x60)).
                                mulmod(friEvalPointDivByX2, imaginaryUnit, K_MODULUS),
                                K_MODULUS
                            )
                        )
                    }

                    // f4 < 7P ( = 3 + 3 + 1).
                    f4 := add(
                        add(f4, f6),
                        mulmod(
                            mulmod(friEvalPointDivByX2, friEvalPointDivByX2, K_MODULUS),
                            add(
                                f4,
                                // -fMinusX
                                sub(K_MODULUS_TIMES_16, f6)
                            ),
                            K_MODULUS
                        )
                    )
                }

                // f0 < 15P ( = 7 + 7 + 1).
                f0 := add(
                    add(f0, f4),
                    mulmod(
                        friEvalPointDivByXTessed,
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS_TIMES_16, f4)
                        ),
                        K_MODULUS
                    )
                )
            }
            {
                let f8 := mload(add(evaluationsOnCosetPtr, 0x100))
                {
                    let friEvalPointDivByX4 := mulmod(
                        friEvalPointDivByX,
                        mload(add(friHalfInvGroupPtr, 0x80)),
                        K_MODULUS
                    )
                    {
                        let f9 := mload(add(evaluationsOnCosetPtr, 0x120))

                        // f8 < 3P ( = 1 + 1 + 1).
                        f8 := add(
                            add(f8, f9),
                            mulmod(
                                friEvalPointDivByX4,
                                add(
                                    f8,
                                    // -fMinusX
                                    sub(K_MODULUS, f9)
                                ),
                                K_MODULUS
                            )
                        )
                    }

                    let f10 := mload(add(evaluationsOnCosetPtr, 0x140))
                    {
                        let f11 := mload(add(evaluationsOnCosetPtr, 0x160))
                        // f10 < 3P ( = 1 + 1 + 1).
                        f10 := add(
                            add(f10, f11),
                            mulmod(
                                add(
                                    f10,
                                    // -fMinusX
                                    sub(K_MODULUS, f11)
                                ),
                                // friEvalPointDivByX4 * imaginaryUnit ==
                                // friEvalPointDivByX * mload(add(friHalfInvGroupPtr, 0xa0)).
                                mulmod(friEvalPointDivByX4, imaginaryUnit, K_MODULUS),
                                K_MODULUS
                            )
                        )
                    }

                    // f8 < 7P ( = 3 + 3 + 1).
                    f8 := add(
                        add(f8, f10),
                        mulmod(
                            mulmod(friEvalPointDivByX4, friEvalPointDivByX4, K_MODULUS),
                            add(
                                f8,
                                // -fMinusX
                                sub(K_MODULUS_TIMES_16, f10)
                            ),
                            K_MODULUS
                        )
                    )
                }
                {
                    let f12 := mload(add(evaluationsOnCosetPtr, 0x180))
                    {
                        let friEvalPointDivByX6 := mulmod(
                            friEvalPointDivByX,
                            mload(add(friHalfInvGroupPtr, 0xc0)),
                            K_MODULUS
                        )
                        {
                            let f13 := mload(add(evaluationsOnCosetPtr, 0x1a0))

                            // f12 < 3P ( = 1 + 1 + 1).
                            f12 := add(
                                add(f12, f13),
                                mulmod(
                                    friEvalPointDivByX6,
                                    add(
                                        f12,
                                        // -fMinusX
                                        sub(K_MODULUS, f13)
                                    ),
                                    K_MODULUS
                                )
                            )
                        }

                        let f14 := mload(add(evaluationsOnCosetPtr, 0x1c0))
                        {
                            let f15 := mload(add(evaluationsOnCosetPtr, 0x1e0))

                            // f14 < 3P ( = 1 + 1 + 1).
                            f14 := add(
                                add(f14, f15),
                                mulmod(
                                    add(
                                        f14,
                                        // -fMinusX
                                        sub(K_MODULUS, f15)
                                    ),
                                    // friEvalPointDivByX6 * imaginaryUnit ==
                                    // friEvalPointDivByX * mload(add(friHalfInvGroupPtr, 0xe0)).
                                    mulmod(friEvalPointDivByX6, imaginaryUnit, K_MODULUS),
                                    K_MODULUS
                                )
                            )
                        }

                        // f12 < 7P ( = 3 + 3 + 1).
                        f12 := add(
                            add(f12, f14),
                            mulmod(
                                mulmod(friEvalPointDivByX6, friEvalPointDivByX6, K_MODULUS),
                                add(
                                    f12,
                                    // -fMinusX
                                    sub(K_MODULUS_TIMES_16, f14)
                                ),
                                K_MODULUS
                            )
                        )
                    }

                    // f8 < 15P ( = 7 + 7 + 1).
                    f8 := add(
                        add(f8, f12),
                        mulmod(
                            mulmod(friEvalPointDivByXTessed, imaginaryUnit, K_MODULUS),
                            add(
                                f8,
                                // -fMinusX
                                sub(K_MODULUS_TIMES_16, f12)
                            ),
                            K_MODULUS
                        )
                    )
                }

                // f0, f8 < 15P -> f0 + f8 < 30P && 16P < f0 + (K_MODULUS_TIMES_16 - f8) < 31P.
                nextLayerValue := addmod(
                    add(f0, f8),
                    mulmod(
                        mulmod(friEvalPointDivByXTessed, friEvalPointDivByXTessed, K_MODULUS),
                        add(
                            f0,
                            // -fMinusX
                            sub(K_MODULUS_TIMES_16, f8)
                        ),
                        K_MODULUS
                    ),
                    K_MODULUS
                )
            }

            {
                let xInv2 := mulmod(cosetOffset_, cosetOffset_, K_MODULUS)
                let xInv4 := mulmod(xInv2, xInv2, K_MODULUS)
                let xInv8 := mulmod(xInv4, xInv4, K_MODULUS)
                nextXInv := mulmod(xInv8, xInv8, K_MODULUS)
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/FriLayer.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;


/*
  The main component of FRI is the FRI step which takes
  the i-th layer evaluations on a coset c*<g> and produces a single evaluation in layer i+1.

  To this end we have a friCtx that holds the following data:
  evaluations:    holds the evaluations on the coset we are currently working on.
  group:          holds the group <g> in bit reversed order.
  halfInvGroup:   holds the group <g^-1>/<-1> in bit reversed order.
                  (We only need half of the inverse group)

  Note that due to the bit reversed order, a prefix of size 2^k of either group
  or halfInvGroup has the same structure (but for a smaller group).
*/
contract FriLayer is MerkleVerifier, FriTransform {
    event LogGas(string name, uint256 val);

    uint256 internal constant FRI_MAX_STEP_SIZE = 4;
    uint256 internal constant MAX_COSET_SIZE = 2**FRI_MAX_STEP_SIZE;
    // Generator of the group of size MAX_COSET_SIZE: GENERATOR_VAL**((K_MODULUS - 1)/MAX_COSET_SIZE).
    uint256 internal constant FRI_GROUP_GEN =
        0x5ec467b88826aba4537602d514425f3b0bdf467bbf302458337c45f6021e539;

    uint256 internal constant FRI_GROUP_SIZE = 0x20 * MAX_COSET_SIZE;
    uint256 internal constant FRI_CTX_TO_COSET_EVALUATIONS_OFFSET = 0;
    uint256 internal constant FRI_CTX_TO_FRI_GROUP_OFFSET = FRI_GROUP_SIZE;
    uint256 internal constant FRI_CTX_TO_FRI_HALF_INV_GROUP_OFFSET =
        FRI_CTX_TO_FRI_GROUP_OFFSET + FRI_GROUP_SIZE;

    uint256 internal constant FRI_CTX_SIZE =
        FRI_CTX_TO_FRI_HALF_INV_GROUP_OFFSET + (FRI_GROUP_SIZE / 2);

    /*
      Gathers the "cosetSize" elements that belong the coset of the first element in the FRI queue.
      The elements are written to the evaluation section in the fri context i.e.
      friCtx[FRI_CTX_TO_COSET_EVALUATIONS_OFFSET:].

      The coset elements are read either from the FriQueue or from the verifier channel
      depending on whether the required element are in queue or not.

      Returns
        friQueueHead - friQueueHead_ + 0x60  * (# elements that were taken from the queue).
        cosetIdx - the start index of the coset that was gathered.
        cosetOffset - the xInv field element that corresponds to cosetIdx.
    */
    function gatherCosetInputs(
        uint256 channelPtr,
        uint256 friCtx,
        uint256 friQueueHead_,
        uint256 cosetSize
    )
        internal
        pure
        returns (
            uint256 friQueueHead,
            uint256 cosetIdx,
            uint256 cosetOffset
        )
    {
        uint256 evaluationsOnCosetPtr = friCtx + FRI_CTX_TO_COSET_EVALUATIONS_OFFSET;
        uint256 friGroupPtr = friCtx + FRI_CTX_TO_FRI_GROUP_OFFSET;

        friQueueHead = friQueueHead_;
        assembly {
            let queueItemIdx := mload(friQueueHead)
            // The coset index is represented by the most significant bits of the queue item index.
            cosetIdx := and(queueItemIdx, not(sub(cosetSize, 1)))
            let nextCosetIdx := add(cosetIdx, cosetSize)

            // Get the algebraic coset offset:
            // I.e. given c*g^(-k) compute c, where
            //      g is the generator of the coset group.
            //      k is bitReverse(offsetWithinCoset, log2(cosetSize)).
            //
            // To do this we multiply the algebraic coset offset at the top of the queue (c*g^(-k))
            // by the group element that corresponds to the index inside the coset (g^k).
            cosetOffset := mulmod(
                // (c*g^(-k))=
                mload(add(friQueueHead, 0x40)),
                // (g^k)=
                mload(
                    add(
                        friGroupPtr,
                        mul(
                            // offsetWithinCoset=
                            sub(queueItemIdx, cosetIdx),
                            0x20
                        )
                    )
                ),
                K_MODULUS
            )

            let proofPtr := mload(channelPtr)

            for {
                let index := cosetIdx
            } lt(index, nextCosetIdx) {
                index := add(index, 1)
            } {
                // Inline channel operation:
                // Assume we are going to read the next element from the proof.
                // If this is not the case add(proofPtr, 0x20) will be reverted.
                let fieldElementPtr := proofPtr
                proofPtr := add(proofPtr, 0x20)

                // Load the next index from the queue and check if it is our sibling.
                if eq(index, queueItemIdx) {
                    // Take element from the queue rather than from the proof
                    // and convert it back to Montgomery form for Merkle verification.
                    fieldElementPtr := add(friQueueHead, 0x20)

                    // Revert the read from proof.
                    proofPtr := sub(proofPtr, 0x20)

                    // Reading the next index here is safe due to the
                    // delimiter after the queries.
                    friQueueHead := add(friQueueHead, 0x60)
                    queueItemIdx := mload(friQueueHead)
                }

                // Note that we apply the modulo operation to convert the field elements we read
                // from the proof to canonical representation (in the range [0, K_MODULUS - 1]).
                mstore(evaluationsOnCosetPtr, mod(mload(fieldElementPtr), K_MODULUS))
                evaluationsOnCosetPtr := add(evaluationsOnCosetPtr, 0x20)
            }

            mstore(channelPtr, proofPtr)
        }
    }

    /*
      Returns the bit reversal of num assuming it has the given number of bits.
      For example, if we have numberOfBits = 6 and num = (0b)1101 == (0b)001101,
      the function will return (0b)101100.
    */
    function bitReverse(uint256 num, uint256 numberOfBits)
        internal
        pure
        returns (uint256 numReversed)
    {
        assert((numberOfBits == 256) || (num < 2**numberOfBits));
        uint256 n = num;
        uint256 r = 0;
        for (uint256 k = 0; k < numberOfBits; k++) {
            r = (r * 2) | (n % 2);
            n = n / 2;
        }
        return r;
    }

    /*
      Initializes the FRI group and half inv group in the FRI context.
    */
    function initFriGroups(uint256 friCtx) internal view {
        uint256 friGroupPtr = friCtx + FRI_CTX_TO_FRI_GROUP_OFFSET;
        uint256 friHalfInvGroupPtr = friCtx + FRI_CTX_TO_FRI_HALF_INV_GROUP_OFFSET;

        // FRI_GROUP_GEN is the coset generator.
        // Raising it to the (MAX_COSET_SIZE - 1) power gives us the inverse.
        uint256 genFriGroup = FRI_GROUP_GEN;

        uint256 genFriGroupInv = fpow(genFriGroup, (MAX_COSET_SIZE - 1));

        uint256 lastVal = ONE_VAL;
        uint256 lastValInv = ONE_VAL;
        assembly {
            // ctx[mmHalfFriInvGroup + 0] = ONE_VAL;
            mstore(friHalfInvGroupPtr, lastValInv)
            // ctx[mmFriGroup + 0] = ONE_VAL;
            mstore(friGroupPtr, lastVal)
            // ctx[mmFriGroup + 1] = fsub(0, ONE_VAL);
            mstore(add(friGroupPtr, 0x20), sub(K_MODULUS, lastVal))
        }

        // To compute [1, -1 (== g^n/2), g^n/4, -g^n/4, ...]
        // we compute half the elements and derive the rest using negation.
        uint256 halfCosetSize = MAX_COSET_SIZE / 2;
        for (uint256 i = 1; i < halfCosetSize; i++) {
            lastVal = fmul(lastVal, genFriGroup);
            lastValInv = fmul(lastValInv, genFriGroupInv);
            uint256 idx = bitReverse(i, FRI_MAX_STEP_SIZE - 1);

            assembly {
                // ctx[mmHalfFriInvGroup + idx] = lastValInv;
                mstore(add(friHalfInvGroupPtr, mul(idx, 0x20)), lastValInv)
                // ctx[mmFriGroup + 2*idx] = lastVal;
                mstore(add(friGroupPtr, mul(idx, 0x40)), lastVal)
                // ctx[mmFriGroup + 2*idx + 1] = fsub(0, lastVal);
                mstore(add(friGroupPtr, add(mul(idx, 0x40), 0x20)), sub(K_MODULUS, lastVal))
            }
        }
    }

    /*
      Operates on the coset of size friFoldedCosetSize that start at index.

      It produces 3 outputs:
        1. The field elements that result from doing FRI reductions on the coset.
        2. The pointInv elements for the location that corresponds to the first output.
        3. The root of a Merkle tree for the input layer.

      The input is read either from the queue or from the proof depending on data availability.
      Since the function reads from the queue it returns an updated head pointer.
    */
    function doFriSteps(
        uint256 friCtx,
        uint256 friQueueTail,
        uint256 cosetOffset_,
        uint256 friEvalPoint,
        uint256 friCosetSize,
        uint256 index,
        uint256 merkleQueuePtr
    ) internal pure {
        uint256 friValue;

        uint256 evaluationsOnCosetPtr = friCtx + FRI_CTX_TO_COSET_EVALUATIONS_OFFSET;
        uint256 friHalfInvGroupPtr = friCtx + FRI_CTX_TO_FRI_HALF_INV_GROUP_OFFSET;

        // Compare to expected FRI step sizes in order of likelihood, step size 3 being most common.
        if (friCosetSize == 8) {
            (friValue, cosetOffset_) = do3FriSteps(
                friHalfInvGroupPtr,
                evaluationsOnCosetPtr,
                cosetOffset_,
                friEvalPoint
            );
        } else if (friCosetSize == 4) {
            (friValue, cosetOffset_) = do2FriSteps(
                friHalfInvGroupPtr,
                evaluationsOnCosetPtr,
                cosetOffset_,
                friEvalPoint
            );
        } else if (friCosetSize == 16) {
            (friValue, cosetOffset_) = do4FriSteps(
                friHalfInvGroupPtr,
                evaluationsOnCosetPtr,
                cosetOffset_,
                friEvalPoint
            );
        } else {
            require(false, "Only step sizes of 2, 3 or 4 are supported.");
        }

        assembly {
            let indexInNextStep := div(index, friCosetSize)
            mstore(merkleQueuePtr, indexInNextStep)
            mstore(
                add(merkleQueuePtr, 0x20),
                and(COMMITMENT_MASK, keccak256(evaluationsOnCosetPtr, mul(0x20, friCosetSize)))
            )

            mstore(friQueueTail, indexInNextStep)
            mstore(add(friQueueTail, 0x20), friValue)
            mstore(add(friQueueTail, 0x40), cosetOffset_)
        }
    }

    /*
      Computes the FRI step with eta = log2(friCosetSize) for all the live queries.

      friQueuePtr points to an array of triplets:
          (query index, FRI value, FRI inversed point)

      The inputs for the current layer are read from the FRI queue and the inputs
      for the next layer are written to the same queue (overwriting the input).

      The function returns the number of live queries remaining after computing the FRI step.

      The number of live queries decreases whenever multiple query points in the same
      coset are reduced to a single query in the next FRI layer.

      As the function computes the next layer it also collects that data from
      the previous layer for Merkle verification.
    */
    function computeNextLayer(
        uint256 channelPtr,
        uint256 friQueuePtr,
        uint256 merkleQueuePtr,
        uint256 nQueries,
        uint256 friEvalPoint,
        uint256 friCosetSize,
        uint256 friCtx
    ) internal pure returns (uint256 nLiveQueries) {
        uint256 merkleQueueTail = merkleQueuePtr;

        // The inputs are read from the Fri queue and the result is written same queue.
        // The inputs are never overwritten since gatherCosetInputs reads at least one element and
        // doFriSteps writes exactly one element.
        uint256 inputPtr = friQueuePtr;
        uint256 ouputPtr = friQueuePtr;

        uint256 InputEnd = inputPtr + (0x60 * nQueries);

        do {
            uint256 cosetOffset;
            uint256 index;
            (inputPtr, index, cosetOffset) = gatherCosetInputs(
                channelPtr,
                friCtx,
                inputPtr,
                friCosetSize
            );

            doFriSteps(
                friCtx,
                ouputPtr,
                cosetOffset,
                friEvalPoint,
                friCosetSize,
                index,
                merkleQueueTail
            );
            merkleQueueTail += MERKLE_SLOT_SIZE_IN_BYTES;
            ouputPtr += 0x60;
        } while (inputPtr < InputEnd);

        // Return the current number of live queries.
        return (ouputPtr - friQueuePtr) / 0x60;
    }
}
