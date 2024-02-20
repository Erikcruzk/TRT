


pragma solidity ^0.7.3;





interface IERC721 {
  
  
  
  
  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );

  
  
  
  
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

  
  
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  
  
  
  
  
  function balanceOf(address _owner) external view returns (uint256);

  
  
  
  
  
  function ownerOf(uint256 _tokenId) external view returns (address);

  
  
  
  
  
  
  
  
  
  
  
  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory data
  ) external payable;

  
  
  
  
  
  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable;

  
  
  
  
  
  
  
  
  
  
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable;

  
  
  
  
  
  
  function approve(address _approved, uint256 _tokenId) external payable;

  
  
  
  
  
  
  function setApprovalForAll(address _operator, bool _approved) external;

  
  
  
  
  function getApproved(uint256 _tokenId) external view returns (address);

  
  
  
  
  function isApprovedForAll(address _owner, address _operator)
    external
    view
    returns (bool);
}

interface IERC721Metadata is IERC721 {
  


  function name() external view returns (string memory);

  


  function symbol() external view returns (string memory);

  


  function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC721Enumerable is IERC721 {
  


  function totalSupply() external view returns (uint256);

  



  function tokenOfOwnerByIndex(address owner, uint256 index)
    external
    view
    returns (uint256 tokenId);

  



  function tokenByIndex(uint256 index) external view returns (uint256);
}

interface RegistrarV0Reference is IERC721Metadata, IERC721Enumerable {
  
  event ControllerAdded(address indexed controller);

  
  event ControllerRemoved(address indexed controller);

  
  event DomainCreated(
    uint256 indexed id, 
    string name, 
    uint256 indexed nameHash, 
    uint256 indexed parent 
  );

  function domainExists(uint256 id) external view returns (bool);

  
  function addController(address controller) external;

  
  function removeController(address controller) external;

  
  function available(uint256 id) external view returns (bool);

  
  function creatorOf(uint256 id) external view returns (address);

  
  function lockDomainMetadata(uint256 id) external;

  
  function unlockDomainMetadata(uint256 id) external;

  
  function domainMetadataLocked(uint256 id) external view returns (bool);

  
  function domainMetadataLockedBy(uint256 id) external view returns (address);

  
  function registerDomain(
    uint256 parent,
    string memory name,
    address domainOwner
  ) external;
}