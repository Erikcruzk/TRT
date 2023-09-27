// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-LiquityProtocolandStabilityPoolFinalReport/dev-8cec3fda04b8c71994dc14858386bf6a161164fc/packages/contracts/contracts/Interfaces/ISortedTroves.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

// Common interface for the SortedTroves Doubly Linked List.
interface ISortedTroves {

    // --- Events ---
    
    event SortedTrovesAddressChanged(address _sortedDoublyLLAddress);
    event BorrowerOperationsAddressChanged(address _borrowerOperationsAddress);

    // --- Functions ---
    
    function setParams(uint256 _size, address _TroveManagerAddress, address _borrowerOperationsAddress) external;

    function insert(address _id, uint256 _ICR, address _prevId, address _nextId) external;

    function remove(address _id) external;

    function reInsert(address _id, uint256 _newICR, address _prevId, address _nextId) external;

    function contains(address _id) external view returns (bool);

    function isFull() external view returns (bool);

    function isEmpty() external view returns (bool);

    function getSize() external view returns (uint256);

    function getMaxSize() external view returns (uint256);

    function getFirst() external view returns (address);

    function getLast() external view returns (address);

    function getNext(address _id) external view returns (address);

    function getPrev(address _id) external view returns (address);

    function validInsertPosition(uint256 _ICR, address _prevId, address _nextId) external view returns (bool);

    function findInsertPosition(uint256 _ICR, address _prevId, address _nextId) external view returns (address, address);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-LiquityProtocolandStabilityPoolFinalReport/dev-8cec3fda04b8c71994dc14858386bf6a161164fc/packages/contracts/contracts/TestContracts/SortedTrovesTester.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

contract SortedTrovesTester {
    ISortedTroves sortedTroves;

    function setSortedTroves(address _sortedTrovesAddress) external {
        sortedTroves = ISortedTroves(_sortedTrovesAddress);
    }

    function insert(address _id, uint256 _NICR, address _prevId, address _nextId) external {
        sortedTroves.insert(_id, _NICR, _prevId, _nextId);
    }

    function remove(address _id) external {
        sortedTroves.remove(_id);
    }

    function reInsert(address _id, uint256 _newNICR, address _prevId, address _nextId) external {
        sortedTroves.reInsert(_id, _newNICR, _prevId, _nextId);
    }

    function getNominalICR(address) external pure returns (uint) {
        return 1;
    }

    function getCurrentICR(address, uint) external pure returns (uint) {
        return 1;
    }
}