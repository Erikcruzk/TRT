// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit for Patientory (PTOY) Token ICO/smart-contracts-master/contracts/security-token/AnnouncementInterface.sol

/**
 * @dev Interface for general announcements about the security.
 *
 * Announcements can be for instance for dividend sharing, voting, or
 * just for general announcements.
 */

interface Announcement {
  function announcementName() public view returns (bytes32);
  function announcementURI() public view returns (bytes32);
  function announcementType() public view returns (uint256);
  function announcementHash() public view returns (uint256);
}
