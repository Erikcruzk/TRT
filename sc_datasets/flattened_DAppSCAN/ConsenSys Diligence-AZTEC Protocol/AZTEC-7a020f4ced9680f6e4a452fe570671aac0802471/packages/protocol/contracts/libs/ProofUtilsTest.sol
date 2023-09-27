// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/libs/ProofUtils.sol

pragma solidity >= 0.5.0 <0.6.0;

/**
 * @title Library of proof utility functions
 * @author AZTEC
 * Copyright Spilbury Holdings Ltd 2019. All rights reserved.
 **/
library ProofUtils {

    /**
     * @dev We compress three uint8 numbers into only one uint24 to save gas.
     * Reverts if the category is not one of [1, 2, 3, 4].
     * @param proof The compressed uint24 number.
     * @return A tuple (uint8, uint8, uint8) representing the epoch, category and proofId.
     */
    function getProofComponents(uint24 proof) internal pure returns (uint8 epoch, uint8 category, uint8 id) {
        assembly {
            id := and(proof, 0xff)
            category := and(div(proof, 0x100), 0xff)
            epoch := and(div(proof, 0x10000), 0xff)
        }
        return (epoch, category, id);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-AZTEC Protocol/AZTEC-7a020f4ced9680f6e4a452fe570671aac0802471/packages/protocol/contracts/libs/ProofUtilsTest.sol

pragma solidity >= 0.5.0 <0.6.0;

/**
 * @title Library of proof utility functions
 * @author AZTEC
 * Copyright Spilbury Holdings Ltd 2019. All rights reserved.
 **/
contract ProofUtilsTest {
    using ProofUtils for uint24;

    /**
     * @dev We compress three uint8 numbers into only one uint24 to save gas.
     * Reverts if the category is not one of [1, 2, 3, 4].
     * @param proof The compressed uint24 number.
     * @return A tuple (uint8, uint8, uint8) representing the epoch, category and proofId.
     */
    function getProofComponents(uint24 proof) public pure returns (uint8 epoch, uint8 category, uint8 id) {
        return proof.getProofComponents();
    }
}