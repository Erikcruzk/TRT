// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/interfaces/IVotingVault.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.3;

interface IVotingVault {
    /// @notice Attempts to load the voting power of a user
    /// @param user The address we want to load the voting power of
    /// @param blockNumber the block number we want the user's voting power at
    /// @param extraData Abi encoded optional extra data used by some vaults, such as merkle proofs
    /// @return the number of votes
    function queryVotePower(
        address user,
        uint256 blockNumber,
        bytes calldata extraData
    ) external returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-Element_Finance_Governance_Security_Audit_Report/council-3d751c959b42573c78ccd0bccbc80424bf6d9a90/contracts/mocks/MockVotingVault.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract MockVotingVault is IVotingVault {
    mapping(address => uint256) public votingPower;

    function setVotingPower(address _user, uint256 _amount) public {
        votingPower[_user] = _amount;
    }

    function queryVotePower(
        address _user,
        uint256 blockNumber,
        bytes calldata
    ) public view override returns (uint256) {
        blockNumber;
        return votingPower[_user];
    }
}
