


pragma solidity 0.8.7;






interface IACLManager {
  function POOL_ADMIN_ROLE() external view returns (bytes32);

  function EMERGENCY_ADMIN_ROLE() external view returns (bytes32);

  function RISK_ADMIN_ROLE() external view returns (bytes32);

  function FLASH_BORROWER_ROLE() external view returns (bytes32);

  function BRIDGE_ROLE() external view returns (bytes32);

  function ASSET_LISTING_ADMIN_ROLE() external view returns (bytes32);

  





  function setRoleAdmin(bytes32 role, bytes32 adminRole) external;

  



  function addPoolAdmin(address admin) external;

  



  function removePoolAdmin(address admin) external;

  




  function isPoolAdmin(address admin) external view returns (bool);

  



  function addEmergencyAdmin(address admin) external;

  



  function removeEmergencyAdmin(address admin) external;

  




  function isEmergencyAdmin(address admin) external view returns (bool);

  



  function addRiskAdmin(address admin) external;

  



  function removeRiskAdmin(address admin) external;

  




  function isRiskAdmin(address admin) external view returns (bool);

  



  function addFlashBorrower(address borrower) external;

  



  function removeFlashBorrower(address borrower) external;

  




  function isFlashBorrower(address borrower) external view returns (bool);

  



  function addBridge(address bridge) external;

  



  function removeBridge(address bridge) external;

  




  function isBridge(address bridge) external view returns (bool);

  



  function addAssetListingAdmin(address admin) external;

  



  function removeAssetListingAdmin(address admin) external;

  




  function isAssetListingAdmin(address admin) external view returns (bool);
}