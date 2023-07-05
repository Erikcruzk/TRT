// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/types/SettingType.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

enum SettingType {
  UINT256,
  BOOL,
  ADDRESS,
  STRING,
  BYTES,
  BYTES32,
  INT256
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/interface/dao/protocol/RocketDAOProtocolProposalsInterface.sol

pragma solidity 0.7.6;
pragma abicoder v2;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAOProtocolProposalsInterface {
    function proposalSettingMulti(string[] memory _settingContractNames, string[] memory _settingPaths, SettingType[] memory _types, bytes[] memory _data) external;
    function proposalSettingUint(string memory _settingContractName, string memory _settingPath, uint256 _value) external;
    function proposalSettingBool(string memory _settingContractName, string memory _settingPath, bool _value) external;
    function proposalSettingAddress(string memory _settingContractName, string memory _settingPath, address _value) external;
    function proposalSettingRewardsClaimer(string memory _contractName, uint256 _perc) external;
    function proposalSpendTreasury(string memory _invoiceID, address _recipientAddress, uint256 _amount) external;
}
