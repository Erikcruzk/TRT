// File: ../sc_datasets/DAppSCAN/Iosiro-Synthetix Shaula Release Smart Contract Audit/synthetix-83191da45aa03ef73fcc9715d777516ecc7c952f/contracts/test-helpers/MockFlagsInterface.sol

pragma solidity ^0.5.16;


interface FlagsInterface {
    function getFlag(address) external view returns (bool);

    function getFlags(address[] calldata) external view returns (bool[] memory);
}


contract MockFlagsInterface is FlagsInterface {
    mapping(address => bool) public flags;

    constructor() public {}

    function getFlag(address aggregator) external view returns (bool) {
        return flags[aggregator];
    }

    function getFlags(address[] calldata aggregators) external view returns (bool[] memory results) {
        results = new bool[](aggregators.length);

        for (uint i = 0; i < aggregators.length; i++) {
            results[i] = flags[aggregators[i]];
        }
    }

    function flagAggregator(address aggregator) external {
        flags[aggregator] = true;
    }

    function unflagAggregator(address aggregator) external {
        flags[aggregator] = false;
    }
}