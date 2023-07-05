// File: ../sc_datasets/DAppSCAN/Inspex-Admin & Poll/iAM-Admin-Poll-Token-main/interfaces/IAdminManage.sol

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

// File: ../sc_datasets/DAppSCAN/Inspex-Admin & Poll/iAM-Admin-Poll-Token-main/access/Adminnable.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

abstract contract Adminnable {
  IAdminManage internal adminManage;

  constructor(IAdminManage _adminManage) {
    adminManage = _adminManage;
  }

  modifier onlyAdmin() {
    bool isAdmin = adminManage.isAdmin(msg.sender);
    require(isAdmin, 'Adminnable: caller is not the admin');
    _;
  }

  function getAdminManage() public view returns (address) {
    return address(adminManage);
  }

  function admin(address _address) public view returns (bool) {
    return adminManage.isAdmin(_address);
  }
}
