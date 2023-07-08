// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-CompliFi/complifi-protocol-v1-912e93014aa16a9b6987556d971ed2b599b8cba7/contracts/oracleIterators/IOracleIterator.sol

// "SPDX-License-Identifier: GPL-3.0-or-later"

pragma solidity 0.7.6;

interface IOracleIterator {
    /// @notice Proof of oracle iterator contract
    /// @dev Verifies that contract is a oracle iterator contract
    /// @return true if contract is a oracle iterator contract
    function isOracleIterator() external pure returns (bool);

    /// @notice Symbol of the oracle iterator
    /// @dev Should be resolved through OracleIteratorRegistry contract
    /// @return oracle iterator symbol
    function symbol() external pure returns (string memory);

    /// @notice Algorithm that, for the type of oracle used by the derivative,
    //  finds the value closest to a given timestamp
    /// @param _oracle iteratable oracle through
    /// @param _timestamp a given timestamp
    /// @param _roundHints specified rounds for a given timestamp
    /// @return the value closest to a given timestamp
    function getUnderlyingValue(
        address _oracle,
        uint256 _timestamp,
        uint256[] calldata _roundHints
    ) external view returns (int256);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-CompliFi/complifi-protocol-v1-912e93014aa16a9b6987556d971ed2b599b8cba7/contracts/oracleIterators/OracleIteratorDebugger.sol

// "SPDX-License-Identifier: GPL-3.0-or-later"

pragma solidity 0.7.6;

contract OracleIteratorDebugger {
    int256 public underlyingValue;

    function updateUnderlyingValue(
        address _oracleIterator,
        address _oracle,
        uint256 _timestamp,
        uint256[] memory _roundHints
    ) public {
        require(_timestamp > 0, "Zero timestamp");
        require(_oracle != address(0), "Zero oracle");
        require(_oracleIterator != address(0), "Zero oracle iterator");

        IOracleIterator oracleIterator = IOracleIterator(_oracleIterator);
        underlyingValue = oracleIterator.getUnderlyingValue(
            _oracle,
            _timestamp,
            _roundHints
        );
    }
}
