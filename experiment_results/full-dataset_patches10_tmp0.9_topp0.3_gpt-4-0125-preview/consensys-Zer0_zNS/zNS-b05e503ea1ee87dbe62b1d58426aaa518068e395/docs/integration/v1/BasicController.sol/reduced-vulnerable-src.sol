


pragma solidity ^0.7.3;










interface IERC165Upgradeable {
  







  function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IBasicController is IERC165Upgradeable {
  event RegisteredDomain(
    string name,
    uint256 indexed id,
    address indexed owner,
    address indexed creator
  );

  event RegisteredSubdomain(
    string name,
    uint256 indexed id,
    uint256 indexed parent,
    address indexed owner,
    address creator
  );

  




  function registerDomain(string memory domain, address owner) external;

  





  function registerSubdomain(
    uint256 parentId,
    string memory label,
    address owner
  ) external;
}