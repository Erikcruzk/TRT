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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/Prng.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract Prng is PrimeFieldElement0 {
    function storePrng(
        uint256 prngPtr,
        bytes32 digest,
        uint256 counter
    ) internal pure {
        assembly {
            mstore(prngPtr, digest)
            mstore(add(prngPtr, 0x20), counter)
        }
    }

    function loadPrng(uint256 prngPtr) internal pure returns (bytes32, uint256) {
        bytes32 digest;
        uint256 counter;

        assembly {
            digest := mload(prngPtr)
            counter := mload(add(prngPtr, 0x20))
        }

        return (digest, counter);
    }

    function initPrng(uint256 prngPtr, bytes32 publicInputHash) internal pure {
        storePrng(
            prngPtr,
            // keccak256(publicInput)
            publicInputHash,
            0
        );
    }

    /*
      Auxiliary function for getRandomBytes.
    */
    function getRandomBytesInner(bytes32 digest, uint256 counter)
        internal
        pure
        returns (
            bytes32,
            uint256,
            bytes32
        )
    {
        // returns 32 bytes (for random field elements or four queries at a time).
        bytes32 randomBytes = keccak256(abi.encodePacked(digest, counter));

        return (digest, counter + 1, randomBytes);
    }

    /*
      Returns 32 bytes. Used for a random field element, or for 4 query indices.
    */
    function getRandomBytes(uint256 prngPtr) internal pure returns (bytes32 randomBytes) {
        bytes32 digest;
        uint256 counter;
        (digest, counter) = loadPrng(prngPtr);

        // returns 32 bytes (for random field elements or four queries at a time).
        (digest, counter, randomBytes) = getRandomBytesInner(digest, counter);

        storePrng(prngPtr, digest, counter);
        return randomBytes;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/VerifierChannel.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

/*
  Implements the communication channel from the verifier to the prover in the non-interactive case
  (See the BCS16 paper for more details).

  The state of the channel is stored in a uint256[3] as follows:
    [0] proof pointer.
    [1] prng digest.
    [2] prng counter.
*/
contract VerifierChannel is Prng {
    event LogValue(bytes32 val);

    event SendRandomnessEvent(uint256 val);

    event ReadFieldElementEvent(uint256 val);

    event ReadHashEvent(bytes32 val);

    function getPrngPtr(uint256 channelPtr) internal pure returns (uint256) {
        return channelPtr + 0x20;
    }

    function initChannel(
        uint256 channelPtr,
        uint256 proofPtr,
        bytes32 publicInputHash
    ) internal pure {
        assembly {
            // Skip 0x20 bytes length at the beginning of the proof.
            mstore(channelPtr, add(proofPtr, 0x20))
        }

        initPrng(getPrngPtr(channelPtr), publicInputHash);
    }

    /*
      Sends a field element through the verifier channel.

      Note that the logic of this function is inlined in many places throughout the code to reduce
      gas costs.
    */
    function sendFieldElements(
        uint256 channelPtr,
        uint256 nElements,
        uint256 targetPtr
    ) internal pure {
        require(nElements < 0x1000000, "Overflow protection failed.");
        assembly {
            // 31 * PRIME.
            let BOUND := 0xf80000000000020f00000000000000000000000000000000000000000000001f
            let digestPtr := add(channelPtr, 0x20)
            let counterPtr := add(channelPtr, 0x40)

            let endPtr := add(targetPtr, mul(nElements, 0x20))
            for {

            } lt(targetPtr, endPtr) {
                targetPtr := add(targetPtr, 0x20)
            } {
                // *targetPtr = getRandomFieldElement(getPrngPtr(channelPtr));

                let fieldElement := BOUND
                // while (fieldElement >= 31 * K_MODULUS).
                for {

                } iszero(lt(fieldElement, BOUND)) {

                } {
                    // keccak256(abi.encodePacked(digest, counter));
                    fieldElement := keccak256(digestPtr, 0x40)
                    // *counterPtr += 1;
                    mstore(counterPtr, add(mload(counterPtr), 1))
                }
                // *targetPtr = fromMontgomery(fieldElement);
                mstore(targetPtr, mulmod(fieldElement, K_MONTGOMERY_R_INV, K_MODULUS))
                // emit ReadFieldElementEvent(fieldElement);
                // log1(targetPtr, 0x20, 0x4bfcc54f35095697be2d635fb0706801e13637312eff0cedcdfc254b3b8c385e);
            }
        }
    }

    /*
      Sends random queries and returns an array of queries sorted in ascending order.
      Generates count queries in the range [0, mask] and returns the number of unique queries.
      Note that mask is of the form 2^k-1 (for some k <= 64).

      Note that queriesOutPtr may be (and is) interleaved with other arrays. The stride parameter
      is passed to indicate the distance between every two entries in the queries array, i.e.
      stride = 0x20*(number of interleaved arrays).
    */
    function sendRandomQueries(
        uint256 channelPtr,
        uint256 count,
        uint256 mask,
        uint256 queriesOutPtr,
        uint256 stride
    ) internal pure returns (uint256) {
        require(mask < 2**64, "mask must be < 2**64.");

        uint256 val;
        uint256 shift = 0;
        uint256 endPtr = queriesOutPtr;
        for (uint256 i = 0; i < count; i++) {
            if (shift == 0) {
                val = uint256(getRandomBytes(getPrngPtr(channelPtr)));
                shift = 0x100;
            }
            shift -= 0x40;
            uint256 queryIdx = (val >> shift) & mask;
            uint256 ptr = endPtr;

            // Initialize 'curr' to -1 to make sure the condition 'queryIdx != curr' is satisfied
            // on the first iteration.
            uint256 curr = uint256(-1);

            // Insert new queryIdx in the correct place like insertion sort.
            while (ptr > queriesOutPtr) {
                assembly {
                    curr := mload(sub(ptr, stride))
                }

                if (queryIdx >= curr) {
                    break;
                }

                assembly {
                    mstore(ptr, curr)
                }
                ptr -= stride;
            }

            if (queryIdx != curr) {
                assembly {
                    mstore(ptr, queryIdx)
                }
                endPtr += stride;
            } else {
                // Revert right shuffling.
                while (ptr < endPtr) {
                    assembly {
                        mstore(ptr, mload(add(ptr, stride)))
                        ptr := add(ptr, stride)
                    }
                }
            }
        }

        return (endPtr - queriesOutPtr) / stride;
    }

    function readBytes(uint256 channelPtr, bool mix) internal pure returns (bytes32) {
        uint256 proofPtr;
        bytes32 val;

        assembly {
            proofPtr := mload(channelPtr)
            val := mload(proofPtr)
            mstore(channelPtr, add(proofPtr, 0x20))
        }
        if (mix) {
            // Mix the bytes that were read into the state of the channel.
            assembly {
                let digestPtr := add(channelPtr, 0x20)
                let counterPtr := add(digestPtr, 0x20)

                // digest += 1.
                mstore(digestPtr, add(mload(digestPtr), 1))
                mstore(counterPtr, val)
                // prng.digest := keccak256(digest + 1||val), nonce was written earlier.
                mstore(digestPtr, keccak256(digestPtr, 0x40))
                // prng.counter := 0.
                mstore(counterPtr, 0)
            }
        }

        return val;
    }

    function readHash(uint256 channelPtr, bool mix) internal pure returns (bytes32) {
        bytes32 val = readBytes(channelPtr, mix);
        // emit ReadHashEvent(val);

        return val;
    }

    /*
      Reads a field element from the verifier channel (that is, the proof in the non-interactive
      case).
      The field elements on the channel are in Montgomery form and this function converts
      them to the standard representation.

      Note that the logic of this function is inlined in many places throughout the code to reduce
      gas costs.
    */
    function readFieldElement(uint256 channelPtr, bool mix) internal pure returns (uint256) {
        uint256 val = fromMontgomery(uint256(readBytes(channelPtr, mix)));

        return val;
    }

    function verifyProofOfWork(uint256 channelPtr, uint256 proofOfWorkBits) internal pure {
        if (proofOfWorkBits == 0) {
            return;
        }

        uint256 proofOfWorkDigest;
        assembly {
            // [0:0x29) := 0123456789abcded || digest     || workBits.
            //             8 bytes          || 0x20 bytes || 1 byte.
            mstore(0, 0x0123456789abcded000000000000000000000000000000000000000000000000)
            let digest := mload(add(channelPtr, 0x20))
            mstore(0x8, digest)
            mstore8(0x28, proofOfWorkBits)
            mstore(0, keccak256(0, 0x29))

            let proofPtr := mload(channelPtr)
            mstore(0x20, mload(proofPtr))
            // proofOfWorkDigest:= keccak256(keccak256(0123456789abcded || digest || workBits) || nonce).
            proofOfWorkDigest := keccak256(0, 0x28)

            mstore(0, add(digest, 1))
            // prng.digest := keccak256(digest + 1||nonce), nonce was written earlier.
            mstore(add(channelPtr, 0x20), keccak256(0, 0x28))
            // prng.counter := 0.
            mstore(add(channelPtr, 0x40), 0)

            mstore(channelPtr, add(proofPtr, 0x8))
        }

        uint256 proofOfWorkThreshold = uint256(1) << (256 - proofOfWorkBits);
        require(proofOfWorkDigest < proofOfWorkThreshold, "Proof of work check failed.");
    }
}
