


pragma solidity ^0.7.3;










interface IERC165Upgradeable {
  







  function supportsInterface(bytes4 interfaceId) external view returns (bool);
}




interface IERC721Upgradeable is IERC165Upgradeable {
  


  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  


  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );

  


  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  


  function balanceOf(address owner) external view returns (uint256 balance);

  






  function ownerOf(uint256 tokenId) external view returns (address owner);

  













  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  













  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  












  function approve(address to, uint256 tokenId) external;

  






  function getApproved(uint256 tokenId)
    external
    view
    returns (address operator);

  









  function setApprovalForAll(address operator, bool _approved) external;

  




  function isApprovedForAll(address owner, address operator)
    external
    view
    returns (bool);

  












  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata data
  ) external;
}




interface IERC721Upgradeable is IERC165Upgradeable {
  


  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  


  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );

  


  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  


  function balanceOf(address owner) external view returns (uint256 balance);

  






  function ownerOf(uint256 tokenId) external view returns (address owner);

  













  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  













  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  












  function approve(address to, uint256 tokenId) external;

  






  function getApproved(uint256 tokenId)
    external
    view
    returns (address operator);

  









  function setApprovalForAll(address operator, bool _approved) external;

  




  function isApprovedForAll(address owner, address operator)
    external
    view
    returns (bool);

  












  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata data
  ) external;
}





interface IERC721EnumerableUpgradeable is IERC721Upgradeable {
  


  function totalSupply() external view returns (uint256);

  



  function tokenOfOwnerByIndex(address owner, uint256 index)
    external
    view
    returns (uint256 tokenId);

  



  function tokenByIndex(uint256 index) external view returns (uint256);
}





interface IERC721MetadataUpgradeable is IERC721Upgradeable {
  


  function name() external view returns (string memory);

  


  function symbol() external view returns (string memory);

  


  function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IRegistrar is
  IERC721MetadataUpgradeable,
  IERC721EnumerableUpgradeable
{
  
  event ControllerAdded(address indexed controller);

  
  event ControllerRemoved(address indexed controller);

  
  event DomainCreated(
    uint256 indexed id,
    string name,
    uint256 indexed nameHash,
    uint256 indexed parent,
    address creator,
    address controller
  );

  
  event MetadataLocked(uint256 indexed id, address locker);

  
  event MetadataUnlocked(uint256 indexed id);

  
  event MetadataChanged(uint256 indexed id, string uri);

  
  event RoyaltiesAmountChanged(uint256 indexed id, uint256 amount);

  
  function addController(address controller) external;

  
  function removeController(address controller) external;

  
  function registerDomain(
    uint256 parentId,
    string memory name,
    address domainOwner,
    address creator
  ) external returns (uint256);

  
  function lockDomainMetadata(uint256 id) external;

  
  function unlockDomainMetadata(uint256 id) external;

  
  function setDomainMetadataUri(uint256 id, string memory uri) external;

  
  function setDomainRoyaltyAmount(uint256 id, uint256 amount) external;

  
  function domainExists(uint256 id) external view returns (bool);

  
  function isAvailable(uint256 id) external view returns (bool);

  
  function creatorOf(uint256 id) external view returns (address);

  
  function isDomainMetadataLocked(uint256 id) external view returns (bool);

  
  function domainMetadataLockedBy(uint256 id) external view returns (address);

  
  function domainController(uint256 id) external view returns (address);

  
  function domainRoyaltyAmount(uint256 id) external view returns (uint256);
}