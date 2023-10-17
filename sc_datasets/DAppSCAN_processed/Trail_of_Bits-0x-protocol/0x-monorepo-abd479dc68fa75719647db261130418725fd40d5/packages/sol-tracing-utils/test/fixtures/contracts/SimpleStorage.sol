// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-0x-protocol/0x-monorepo-abd479dc68fa75719647db261130418725fd40d5/packages/sol-tracing-utils/test/fixtures/contracts/SimpleStorage.sol

pragma solidity ^0.4.21;

contract SimpleStorage {
    uint public storedData;
    function set(uint x) {
        storedData = x;
    }
    function get() constant returns (uint retVal) {
        return storedData;
    }
}