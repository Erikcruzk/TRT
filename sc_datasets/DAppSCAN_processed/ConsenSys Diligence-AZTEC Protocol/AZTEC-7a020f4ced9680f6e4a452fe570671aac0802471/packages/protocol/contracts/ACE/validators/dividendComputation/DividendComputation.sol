// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/ACE/validators/dividendComputation/DividendComputationABIEncoder.sol

pragma solidity >=0.5.0 <0.6.0;

/**
 * @title Library to ABI encode the output of a dividend computation proof verification operation
 * @author AZTEC
 * @dev Don't include this as an internal library. This contract uses a static memory table to cache
 * elliptic curve primitives and hashes.
 * Calling this internally from another function will lead to memory mutation and undefined behaviour.
 * The intended use case is to call this externally via `staticcall`.
 * External calls to OptimizedAZTEC can be treated as pure functions as this contract contains no
 * storage and makes no external calls (other than to precompiles)
 * Copyright Spilsbury Holdings Ltd 2019. All rights reserved.
 **/

library DividendComputationABIEncoder {
    /**
    * New calldata map
    * 0x04:0x24      = calldata location of proofData byte array  // proof data byte array
    * 0x24:0x44      = message sender // address
    * 0x44:0x64      = h_x     // crs
    * 0x64:0x84      = h_y     // crs
    * 0x84:0xa4      = t2_x0   // crs
    * 0xa4:0xc4      = t2_x1   // crs
    * 0xc4:0xe4      = t2_y0   // crs
    * 0xe4:0x104     = t2_y1   // crs
    * 0x104:0x124    = length of proofData byte array
    * 0x124:0x144    = challenge
    * 0x144:0x164    = za
    * 0x164:0x184    = zb
    * 0x184:0x1a4    = offset in byte array to notes
    * 0x1a4:0x1c4    = offset in byte array to inputOwners
    * 0x1c4:0x1e4    = offset in byte array to outputOwners
    * 0x1e4:0x204    = offset in byte array to metadata
    */ 
    function encodeAndExit() internal pure {
        assembly {
            // set up initial variables
            let notes := add(0x104, calldataload(0x184))
            let n := calldataload(notes)
            let m := 1
            let inputOwners := add(0x124, calldataload(0x1a4)) // one word after outputOwners = 1st
            let outputOwners := add(0x124, calldataload(0x1c4)) // one word after outputOwners = 1st
            let metadata := add(0x144, calldataload(0x1e4)) // two words after metadata = 1st

            // `returndata` starts at 0x160
            // `proofOutputs` starts at 0x180
            // 0x160 - 0x180 = relative offset in returndata to first bytes argument (0x20)
            // 0x180 - 0x1a0 = byte length of `proofOutputs`
            // 0x1a0 - 0x1c0 = number of `proofOutputs` entries (1)
            // 0x1c0 - 0x1e0 = relative memory offset between `v` and start of `proofOutput`

            // `proofOutput` - t, starts at 0x1e0
            // 0x1e0 - 0x200 = length of `proofOutput`
            // 0x200 - 0x220 = relative offset between `t` and `inputNotes`
            // 0x220 - 0x240 = relative offset between `t` and `outputNotes`
            // 0x240 - 0x260 = `publicOwner`
            // 0x260 - 0x280 = `publicValue`

            // `inputNotes` starts at 0x280
            // structure of `inputNotes` and `outputNotes`
            // 0x00 - 0x20 = byte length of notes array
            // 0x20 - 0x40 = number of notes `i`
            // the next `i` consecutive blocks of 0x20-sized memory contain relative offset between
            // start of notes array and the location of the `note`

            // structure of a `note`
            // 0x00 - 0x20 = size of `note`
            // 0x20 - 0x40 = `noteType`
            // 0x40 - 0x60 = `owner`
            // 0x60 - 0x80 = `noteHash`
            // 0x80 - 0xa0 = size of note `data`
            // 0xa0 - 0xc0 = compressed note coordinate `gamma` (part of `data`)
            // 0xc0 - 0xe0 = compressed note coordinate `sigma` (part of `data`)
            // 0xe0 - ???? = remaining note metadata

            // `proofOutputs` must form a monolithic block of memory that we can return.
            // `s` points to the memory location of the start of the current note
            // `inputPtr` points to the start of the current `notes` dynamic bytes array

            // length of proofOutputs is at s
            mstore(0x1a0, 0x01)                            // number of proofs
            mstore(0x1c0, 0x60)                            // offset to 1st proof
            // length of proofOutput is at s + 0x60
            mstore(0x200, 0xc0)                            // location of inputNotes
            // location of outputNotes is at s + 0xc0
            mstore(0x240, 0x00)             // publicOwner
            // store kPublic. If kPublic is negative, store correct signed representation,
            // relative to 2^256, not to the order of the bn128 group
            let kPublic := 0
            mstore(0x260, kPublic)

            // 0x280 = challenge
            mstore(0x280, calldataload(0x124))

            let inputPtr := 0x2a0                                 // point to inputNotes
            mstore(add(inputPtr, 0x20), m)                        // number of input notes
            // set note pointer, offsetting lookup indices for each input note
            let s := add(0x2e0, mul(m, 0x20))

            for { let i := 0 } lt(i, m) { i := add(i, 0x01) } {
                let noteIndex := add(add(notes, 0x20), mul(i, 0xc0))
                // copy note data to 0x00 - 0x80
                mstore(0x00, 0x01) // store note type at 0x00
                calldatacopy(0x20, add(noteIndex, 0x40), 0x80) // get gamma, sigma


                // store note length in `s`
                mstore(s, 0xc0)
                // store note type (UXTO = 1) in `s+0x20`
                mstore(add(s, 0x20), 0x01)
                // store note owner in `s + 0x20`
                mstore(add(s, 0x40), calldataload(inputOwners))
            
                // store note hash in `s + 0x60`
                mstore(add(s, 0x60), keccak256(0x00, 0xa0))

                // store note metadata length in `s + 0x80` (just the coordinates)
                mstore(add(s, 0x80), 0x40)
                // store compressed note coordinate gamma in `s + 0x80`
                mstore(
                    add(s, 0xa0),
                    or(
                        calldataload(add(noteIndex, 0x40)),
                        mul(
                            and(calldataload(add(noteIndex, 0x60)), 0x01),
                            0x8000000000000000000000000000000000000000000000000000000000000000
                        )
                    )
                )
                // store compressed note coordinate sigma in `s + 0xa0`
                mstore(
                    add(s, 0xc0),
                    or(
                        calldataload(add(noteIndex, 0x80)),
                        mul(
                            and(calldataload(add(noteIndex, 0xa0)), 0x01),
                            0x8000000000000000000000000000000000000000000000000000000000000000
                        )
                    )
                )
                // compute the relative offset to index this note in our returndata
                mstore(add(add(inputPtr, 0x40), mul(i, 0x20)), sub(s, inputPtr)) // relative offset to note
        
                // increase s by note length
                s := add(s, 0xe0)
            }

            // transition between input and output notes
            // store total length of inputNotes at first index of inputNotes 
            mstore(inputPtr, sub(sub(s, inputPtr), 0x20))
            mstore(0x220, add(0xc0, sub(s, inputPtr))) // store relative memory offset to outputNotes
            inputPtr := s
            mstore(add(inputPtr, 0x20), sub(n, m)) // store number of output notes
            s := add(s, add(0x40, mul(sub(n, m), 0x20)))

            // output notes
            for { let i := m } lt(i, n) { i := add(i, 0x01) } {
                // get note index
                let noteIndex := add(add(notes, 0x20), mul(i, 0xc0))
                // get pointer to metadata
                let metadataIndex := calldataload(add(metadata, mul(sub(i, m), 0x20)))
                // get size of metadata
                let metadataLength := calldataload(add(sub(metadata, 0x40), metadataIndex))

                mstore(0x00, 0x01) // store note type at 0x00
                // copy note data to 0x20 - 0xa0
                calldatacopy(0x20, add(noteIndex, 0x40), 0x80) // get gamma, sigma

                // store note length in `s`
                mstore(s, add(0xc0, metadataLength))
                // store note type (UXTO = 1) in `s+0x20`
                mstore(add(s, 0x20), 0x01)
                // store the owner of the note in `s + 0x20`
                mstore(add(s, 0x40), calldataload(add(outputOwners, mul(sub(i, m), 0x20))))
                // store note hash
                mstore(add(s, 0x60), keccak256(0x00, 0xa0))
                // store note metadata length if `s + 0x60`
                mstore(add(s, 0x80), add(0x40, metadataLength))
                // store compressed note coordinate gamma in `s + 0x80`
                mstore(
                    add(s, 0xa0),
                    or(
                        mload(0x20),
                        mul(
                            and(mload(0x40), 0x01),
                            0x8000000000000000000000000000000000000000000000000000000000000000
                        )
                    )
                )
                // store compressed note coordinate sigma in `s + 0xa0`
                mstore(
                add(s, 0xc0),
                or(
                    mload(0x60),
                    mul(
                        and(mload(0x80), 0x01),
                        0x8000000000000000000000000000000000000000000000000000000000000000
                    )
                )
                )
                // copy metadata into `s + 0xc0`
                calldatacopy(add(s, 0xe0), add(metadataIndex, sub(metadata, 0x20)), metadataLength)
                // compute the relative offset to index this note in our returndata
                mstore(add(add(inputPtr, 0x40), mul(sub(i, m), 0x20)), sub(s, inputPtr)) // relative offset to note

                // increase s by note length
                s := add(s, add(mload(s), 0x20))
            }

            // cleanup. the length of the outputNotes = s - inputPtr
            mstore(inputPtr, sub(sub(s, inputPtr), 0x20)) // store length of outputNotes at start of outputNotes
            let notesLength := sub(s, 0x2a0)
            // store length of proofOutput at 0x160. 0xa0 comes from:
            // (offset to input notes, offset to output notes, publicOwner, publicValue, challenge)
            mstore(0x1e0, add(0xa0, notesLength))
            mstore(0x180, add(0x100, notesLength)) // store length of proofOutputs at 0x100

            mstore(0x160, 0x20)
            return(0x160, add(0x140, notesLength)) // return the final byte array
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/interfaces/DividendComputationInterface.sol

pragma solidity >=0.5.0 <0.6.0;

library DividendComputationInterface {
    function validateDividendComputation(
        bytes calldata,
        address,
        uint[6] calldata
    ) 
        external
        pure
        returns (bytes memory) 
    {}
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/ACE/validators/dividendComputation/DividendComputation.sol

pragma solidity >=0.5.0 <0.6.0;


/**
 * @title Library to validate AZTEC dividend computation proofs
 * @author AZTEC
 * @dev Don't include this as an internal library. This contract uses a static memory table 
 * to cache elliptic curve primitives and hashes.
 * Calling this internally from another function will lead to memory mutation and undefined behaviour.
 * The intended use case is to call this externally via `staticcall`. External calls to OptimizedAZTEC 
 * can be treated as pure functions as this contract contains no storage and makes no external calls 
 * (other than to precompiles).
 * Copyright Spilbury Holdings Ltd 2019. All rights reserved.
 **/
contract DividendComputation {
    /**
     * @dev This will take any dividend calculation proof data and attempt to verify it in zero-knowledge
     * If the proof is not valid, the transaction will throw.
     * @notice See DividendComputationInterface for how method calls should be constructed.
     * DividendComputation is written in YUL to enable manual memory management and for other efficiency savings.
     **/
    // solhint-disable payable-fallback
    function() external {
        assembly {

            // We don't check for function signatures, there's only one function 
            // that ever gets called: validateDividendComputation()
            // We still assume calldata is offset by 4 bytes so that we can 
            // represent this contract through a compatible ABI
            validateDividendComputation()

            // if we get to here, the proof is valid. We now 'fall through' the assembly block
            // and into DividendComputationABIEncoder.encodeAndExit()
            // reset the free memory pointer because we're touching Solidity code again
            mstore(0x40, 0x60)

            /**
             * New calldata map
             * 0x04:0x24      = calldata location of proofData byte array  // proof data byte array
             * 0x24:0x44      = message sender // address
             * 0x44:0x64      = h_x     // crs
             * 0x64:0x84      = h_y     // crs
             * 0x84:0xa4      = t2_x0   // crs
             * 0xa4:0xc4      = t2_x1   // crs
             * 0xc4:0xe4      = t2_y0   // crs
             * 0xe4:0x104     = t2_y1   // crs
             * 0x104:0x124    = length of proofData byte array
             * 0x124:0x144    = challenge
             * 0x144:0x164    = za
             * 0x164:0x184    = zb
             * 0x184:0x1a4    = offset in byte array to notes
             * 0x1a4:0x1c4    = offset in byte array to inputOwners
             * 0x1c4:0x1e4    = offset in byte array to outputOwners
             * 0x1e4:0x204    = offset in byte array to metadata
             */ 

            function validateDividendComputation() {
                
                /*
                ///////////////////////////////////////////  SETUP  //////////////////////////////////////////////
                */
                mstore(0x80, calldataload(0x44))
                mstore(0xa0, calldataload(0x64))
                let notes := add(0x104, calldataload(0x184))
                let n := calldataload(notes)
                let gen_order := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001                
                let challenge := mod(calldataload(0x124), gen_order)

                let za := mod(calldataload(0x144), gen_order)
                let zb := mod(calldataload(0x164), gen_order)


                // Check that za < kMax
                if gt(za, 1048576) {
                    mstore(0x00, 400)
                    revert(0x00, 0x20)
                }

                // Check that zb < kMax
                if gt(zb, 1048576) {
                    mstore(0x00, 400)
                    revert(0x00, 0x20)
                }

                /*
                m is the deliminator between input and output notes. 
                We only have one input note, and then the next two are output notes.

                m = 0 and n = 3

                Variables not defined and instead hard-coded, to save on stack depth
                */

                // add caller, za and zb to final hash table
                mstore(0x2a0, calldataload(0x24))
                mstore(0x2c0, za)
                mstore(0x2e0, zb)

                hashCommitments(notes, n) 
                let b := add(0x300, mul(n, 0x80)) 

                /*
                ///////////////////////////  CALCULATE BLINDING FACTORS  /////////////////////////////////////
                */

                // Iterate over every note and calculate the blinding factor B_i = \gamma_i^{kBar}h^{aBar}\sigma_i^{-c}.
                // We use the AZTEC protocol pairing optimization to reduce the number of pairing comparisons to 1.
                // This adds some minor alterations
                for { let i := 0 } lt(i, 3) { i := add(i, 0x01) } {

                    // Get the calldata index of this note - call data location of start of note
                    let noteIndex := add(add(notes, 0x20), mul(i, 0xc0))

                    // Define variables k, a and c.
                    // If i <= m then - input notes
                    //   k = kBar_i
                    //   a = aBar_i
                    //   c = challenge
                    // If i > m then we add a modification for the pairing optimization
                    //   k = kBar_i * x_i
                    //   a = aBar_i * x_i
                    //   c = challenge * x_i
                    // Set j = i - (m + 1). - index to count the output commitment
                    // x_0 = 1
                    // x_1 = keccak256(input string)
                    // all other x_{j} = keccak256(x_{j-1})
                    // The reason for doing this is that the point  \sigma_i^{-cx_j} can be re-used in the pairing check
                    // Instead of validating e(\gamma_i, t_2) == e(\sigma_i, g_2) for all i = [m+1,\ldots,n]
                    // We instead validate:
                    // e(\Pi_{i=m+1}^{n}\gamma_i^{-cx_j}, t_2) == e(\Pi_{i=m+1}^{n}\sigma_i^{cx_j}, g_2).
                    // x_j is a pseudorandom variable whose entropy source is the input string, allowing for
                    // a sum of commitment points to be evaluated in one pairing comparison

                    let k
                    let a := calldataload(add(noteIndex, 0x20))
                    let c := challenge

                    switch gt(i, 1)
                    case 1 { // output note
                        /*
                        Enforce the condition k_3 = (k_1)(z_b) - (k_2)(z_a)
                        */
                        k := addmod(
                                    mulmod(
                                        calldataload(sub(noteIndex, add(0xc0, 0xc0))),
                                        zb,
                                        gen_order), // k_1 * z_b
                                    mulmod(
                                        sub(gen_order, calldataload(sub(noteIndex, 0xc0))),
                                        za,
                                        gen_order), //-(k_2 * z_a)
                                    gen_order)       
                    }

                    case 0 { // input note
                        /*
                        Input commitments just have the k factors as according to the note data
                        */  
                        k := calldataload(noteIndex)
                    }


                    // Set k = kx_j, a = ax_j, c = cx_j, where j = i - (m+1)
                    let x := mod(mload(0x00), gen_order) // x is the kecca hash of the input commitments
                    k := mulmod(k, x, gen_order) // kx
                    a := mulmod(a, x, gen_order) // ax
                    c := mulmod(challenge, x, gen_order) // cx
                    // calculate x_{j+1}
                    mstore(0x00, keccak256(0x00, 0x20)) // rehashing the kecca hash, for use in the next x


                    // Check this commitment is well formed
                    validateCommitment(noteIndex, k, a)

                    // Calculate the G1 element \gamma_i^{k}h^{a}\sigma_i^{-c} = B_i - already has all x stuff
                    // Memory map:
                    // 0x20: \gamma_iX
                    // 0x40: \gamma_iY
                    // 0x60: k_i
                    // 0x80: hX
                    // 0xa0: hY
                    // 0xc0: a_i
                    // 0xe0: \sigma_iX
                    // 0x100: \sigma_iY
                    // 0x120: -c

                    // loading key variables into memory to be operated on later
                    calldatacopy(0xe0, add(noteIndex, 0x80), 0x40)  
                    calldatacopy(0x20, add(noteIndex, 0x40), 0x40)
                    mstore(0x120, sub(gen_order, c))
                    mstore(0x60, k) 
                    mstore(0xc0, a)

                    // Call bn128 scalar multiplication precompiles
                    // Represent point + multiplication scalar in 3 consecutive blocks of memory
                    // Store \sigma_i^{-c} at 0x1a0:0x200
                    // Store \gamma_i^{k} at 0x120:0x160
                    // Store h^{a} at 0x160:0x1a0
                    
                    // result is a boolean. It keeps track of whether the call to the pre-compile was 
                    // successful. True if it was, False if it wasn't
                    let result := staticcall(gas, 7, 0xe0, 0x60, 0x1a0, 0x40) // sigma_i^{-c}
                    result := and(result, staticcall(gas, 7, 0x20, 0x60, 0x120, 0x40)) // gamma_i^{k}
                    result := and(result, staticcall(gas, 7, 0x80, 0x60, 0x160, 0x40)) // h^{a}

                    // Call bn128 group addition precompiles
                    // \gamma_i^{k} and h^{a} in memory block 0x120:0x1a0
                    // Store result of addition at 0x160:0x1a0
                    result := and(result, staticcall(gas, 6, 0x120, 0x80, 0x160, 0x40))

                    // \gamma_i^{k}h^{a} and \sigma^{-c} in memory block 0x160:0x1e0
                    // Store resulting point B at memory index b
                    // index b points to the end of the block of memory containing commitments
                    // we're appending blinding factors to the end of the commitment block
                    result := and(result, staticcall(gas, 6, 0x160, 0x80, b, 0x40))

                    // We have \sigma^{-c} at 0x1a0:0x200
                    // And \sigma_{acc} at 0x1e0:0x200
                    // If i = m + 1 (i.e. first output note)
                    // then we set \gamma_{acc} and \sigma_{acc} to \gamma_i, -\sigma_i
                    // the accumulator is the variable that is used to condense the various pairing
                    // comparisons into a single one
                    if eq(i, 0) { // m = 0
                        mstore(0x260, mload(0x20))
                        mstore(0x280, mload(0x40))
                        mstore(0x1e0, mload(0xe0))
                        mstore(
                            0x200,
                            sub(0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47, mload(0x100))
                            )
                    }

                    // If i > m + 1 (i.e. subsequent output notes)
                    // then we add \sigma^{-c} and \sigma_{acc} and store result at \sigma_{acc} (0x1e0:0x200)
                    // we then calculate \gamma^{cx} and add into \gamma_{acc}
                    if gt(i, 0) { // m = 0
                        mstore(0x60, c)
                        result := and(result, staticcall(gas, 7, 0x20, 0x60, 0x220, 0x40))

                       // \gamma_i^{cx} now at 0x220:0x260, \gamma_{acc} is at 0x260:0x2a0
                        result := and(result, staticcall(gas, 6, 0x220, 0x80, 0x260, 0x40))

                       // add \sigma_i^{-cx} and \sigma_{acc} into \sigma_{acc} at 0x1e0
                        result := and(result, staticcall(gas, 6, 0x1a0, 0x80, 0x1e0, 0x40))
                    }

                    // throw transaction if any calls to precompiled contracts failed
                    if iszero(result) { mstore(0x00, 400) revert(0x00, 0x20) }
                    b := add(b, 0x40) // increase B pointer by 2 words
                }
                

                    validatePairing(0x84)

                // We now have the message sender, z_a, z_b, note commitments and the 
                // calculated blinding factors in a block of memory starting at 0x2a0, of size (b - 0x2a0).
                // Hash this block to reconstruct the initial challenge and validate that they match
                let expected := mod(keccak256(0x2a0, sub(b, 0x2a0)), gen_order)


                if iszero(eq(expected, challenge)) {
                    
                    // Proof failed
                    mstore(0x00, 404)
                    revert(0x00, 0x20)
                }
            }

            /**        
             * @dev evaluate if e(P1, t2) . e(P2, g2) == 0.
             * @notice we don't hard-code t2 so that contracts that call this library can use different trusted setups.
             **/
            function validatePairing(t2) {
                let field_order := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                let t2_x_1 := calldataload(t2)
                let t2_x_2 := calldataload(add(t2, 0x20))
                let t2_y_1 := calldataload(add(t2, 0x40))
                let t2_y_2 := calldataload(add(t2, 0x60))

                // check provided setup pubkey is not zero or g2
                if or(or(or(or(or(or(or(
                    iszero(t2_x_1),
                    iszero(t2_x_2)),
                    iszero(t2_y_1)),
                    iszero(t2_y_2)),
                    eq(t2_x_1, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)),
                    eq(t2_x_2, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2)),
                    eq(t2_y_1, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)),
                    eq(t2_y_2, 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b))
                {
                    mstore(0x00, 400)
                    revert(0x00, 0x20)
                }

                // store coords in memory
                // indices are a bit off, scipr lab's libff limb ordering (c0, c1) is opposite
                // to what precompile expects. We can overwrite the memory we used previously as this function
                // is called at the end of the validation routine.
                mstore(0x20, mload(0x1e0)) // sigma accumulator x
                mstore(0x40, mload(0x200)) // sigma accumulator y
                mstore(0x80, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)
                mstore(0x60, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2)
                mstore(0xc0, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)
                mstore(0xa0, 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b)
                mstore(0xe0, mload(0x260)) // gamma accumulator x
                mstore(0x100, mload(0x280)) // gamma accumulator y
                mstore(0x140, t2_x_1)
                mstore(0x120, t2_x_2)
                mstore(0x180, t2_y_1)
                mstore(0x160, t2_y_2)

                let success := staticcall(gas, 8, 0x20, 0x180, 0x20, 0x20)

                if or(iszero(success), iszero(mload(0x20))) {
                    mstore(0x00, 400)
                    revert(0x00, 0x20)
                }
            }

            /**
             * @dev check that this note's points are on the altbn128 curve(y^2 = x^3 + 3)
             * and that signatures 'k' and 'a' are modulo the order of the curve. 
             * Transaction will throw if this is not the case.
             * @param note the calldata loation of the note
             **/
            function validateCommitment(note, k, a) {
                let gen_order := 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
                let field_order := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
                let gammaX := calldataload(add(note, 0x40))
                let gammaY := calldataload(add(note, 0x60))
                let sigmaX := calldataload(add(note, 0x80))
                let sigmaY := calldataload(add(note, 0xa0))
                if iszero(
                    and(
                        and(
                            and(
                                eq(mod(a, gen_order), a), // a is modulo generator order?
                                gt(a, 1)                  // can't be 0 or 1 either!
                            ),
                            and(
                                eq(mod(k, gen_order), k), // k is modulo generator order?
                                gt(k, 1)                  // and not 0 or 1
                            )
                        ),
                        and(
                            eq( // y^2 ?= x^3 + 3
                                addmod(
                                    mulmod(mulmod(sigmaX, sigmaX, field_order), sigmaX, field_order), 
                                    3, 
                                    field_order),
                                mulmod(sigmaY, sigmaY, field_order)
                            ),
                            eq( // y^2 ?= x^3 + 3
                                addmod(
                                    mulmod(mulmod(gammaX, gammaX, field_order), gammaX, field_order),
                                    3,
                                    field_order),
                                mulmod(gammaY, gammaY, field_order)
                            )
                        )
                    )
                ) {
                    mstore(0x00, 400)
                    revert(0x00, 0x20)
                }
            }

            /**
             * @dev Calculate the keccak256 hash of the commitments for both input notes and output notes.
             * This is used both as an input to validate the challenge `c` and also 
             * to generate pseudorandom relationships between commitments for different outputNotes, so 
             * that we can combine them into a single multi-exponentiation for the purposes of 
             * validating the bilinear pairing relationships.
             * @param notes calldata location of notes
             * @param n number of notes
             * 
             * @notice
             */

            function hashCommitments(notes, n) {
                for { let i := 0 } lt(i, n) { i := add(i, 0x01) } { 
                    let index := add(add(notes, mul(i, 0xc0)), 0x60) 
                    calldatacopy(add(0x300, mul(i, 0x80)), index, 0x80)
                }
                mstore(0x00, keccak256(0x300, mul(n, 0x80)))
            }
        }

        DividendComputationABIEncoder.encodeAndExit();
    }
}
