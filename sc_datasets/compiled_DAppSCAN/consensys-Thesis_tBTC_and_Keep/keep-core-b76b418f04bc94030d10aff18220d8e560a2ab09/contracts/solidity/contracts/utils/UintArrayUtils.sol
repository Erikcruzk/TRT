// File: ../sc_datasets/DAppSCAN/consensys-Thesis_tBTC_and_Keep/keep-core-b76b418f04bc94030d10aff18220d8e560a2ab09/contracts/solidity/contracts/utils/UintArrayUtils.sol

pragma solidity ^0.5.4;


library UintArrayUtils {

    function removeValue(uint256[] storage self, uint256 _value) 
        internal
        returns(uint256[] storage)
    {
        for (uint i = 0; i < self.length; i++) {
            // If value is found in array.
            if (_value == self[i]) {
                // Delete element at index and shift array.
                for (uint j = i; j < self.length-1; j++) {
                    self[j] = self[j+1];
                }
                self.length--;
                i--;
            }
        }
        return self;
    }
}
