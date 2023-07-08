// File: ../sc_datasets/DAppSCAN/Inspex-Token/iAM-Admin-Poll-Token-0f8bb7a04c439286a5dffa223c3b30265acb4b5c/interfaces/IAdminManage.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IAdminManage {
  function isSuperAdmin(address _address) external view returns (bool);

  function getSuperAdminList() external view returns (address[] memory);

  function addSuperAdmin(address _address) external;

  function removeSuperAdmin(address _address) external;

  function isAdmin(address _address) external view returns (bool);

  function getAdminList() external view returns (address[] memory);

  function addAdmin(address _address) external;

  function removeAdmin(address _address) external;
}
