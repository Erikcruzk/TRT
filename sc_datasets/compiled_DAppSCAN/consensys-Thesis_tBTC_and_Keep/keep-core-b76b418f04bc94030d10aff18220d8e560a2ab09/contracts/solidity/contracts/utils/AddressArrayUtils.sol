// File: ../sc_datasets/DAppSCAN/consensys-Thesis_tBTC_and_Keep/keep-core-b76b418f04bc94030d10aff18220d8e560a2ab09/contracts/solidity/contracts/utils/AddressArrayUtils.sol

pragma solidity ^0.5.4;


library AddressArrayUtils {

    function contains(address[] memory self, address _address)
        internal
        pure
        returns (bool)
    {
        for (uint i = 0; i < self.length; i++) {
            if (_address == self[i]) {
                return true;
            }
        }
        return false;
    }

    function removeAddress(address[] storage self, address _addressToRemove)
        internal
        returns (address[] storage)
    {
        for (uint i = 0; i < self.length; i++) {
            // If address is found in array.
            if (_addressToRemove == self[i]) {
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