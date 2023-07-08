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

// File: ../sc_datasets/DAppSCAN/PeckShield-starkex/starkex-contracts-master/evm-verifier/solidity/contracts/HornerEvaluator.sol

// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.6.12;

contract HornerEvaluator is PrimeFieldElement0 {
    /*
      Computes the evaluation of a polynomial f(x) = sum(a_i * x^i) on the given point.
      The coefficients of the polynomial are given in
        a_0 = coefsStart[0], ..., a_{n-1} = coefsStart[n - 1]
      where n = nCoefs = friLastLayerDegBound. Note that coefsStart is not actually an array but
      a direct pointer.
      The function requires that n is divisible by 8.
    */
    function hornerEval(
        uint256 coefsStart,
        uint256 point,
        uint256 nCoefs
    ) internal pure returns (uint256) {
        uint256 result = 0;
        uint256 prime = PrimeFieldElement0.K_MODULUS;

        require(nCoefs % 8 == 0, "Number of polynomial coefficients must be divisible by 8");
        // Ensure 'nCoefs' is bounded from above as a sanity check
        // (the bound is somewhat arbitrary).
        require(nCoefs < 4096, "No more than 4096 coefficients are supported");

        assembly {
            let coefsPtr := add(coefsStart, mul(nCoefs, 0x20))
            for {

            } gt(coefsPtr, coefsStart) {

            } {
                // Reduce coefsPtr by 8 field elements.
                coefsPtr := sub(coefsPtr, 0x100)

                // Apply 4 Horner steps (result := result * point + coef).
                result := add(
                    mload(add(coefsPtr, 0x80)),
                    mulmod(
                        add(
                            mload(add(coefsPtr, 0xa0)),
                            mulmod(
                                add(
                                    mload(add(coefsPtr, 0xc0)),
                                    mulmod(
                                        add(
                                            mload(add(coefsPtr, 0xe0)),
                                            mulmod(result, point, prime)
                                        ),
                                        point,
                                        prime
                                    )
                                ),
                                point,
                                prime
                            )
                        ),
                        point,
                        prime
                    )
                )

                // Apply 4 additional Horner steps.
                result := add(
                    mload(coefsPtr),
                    mulmod(
                        add(
                            mload(add(coefsPtr, 0x20)),
                            mulmod(
                                add(
                                    mload(add(coefsPtr, 0x40)),
                                    mulmod(
                                        add(
                                            mload(add(coefsPtr, 0x60)),
                                            mulmod(result, point, prime)
                                        ),
                                        point,
                                        prime
                                    )
                                ),
                                point,
                                prime
                            )
                        ),
                        point,
                        prime
                    )
                )
            }
        }

        // Since the last operation was "add" (instead of "addmod"), we need to take result % prime.
        return result % prime;
    }
}
