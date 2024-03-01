



pragma solidity >=0.6.0 <0.8.0;




interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}







pragma solidity ^0.5.0;


contract ERC1820Implementer {
  bytes32 constant ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

  mapping(bytes32 => bool) internal _interfaceHashes;

  function canImplementInterfaceForAddress(bytes32 interfaceHash, address ) 
    external
    view
    returns(bytes32)
  {
    if(_interfaceHashes[interfaceHash]) {
      return ERC1820_ACCEPT_MAGIC;
    } else {
      return "";
    }
  }

  function _setInterface(string memory interfaceLabel) internal {
    _interfaceHashes[keccak256(abi.encodePacked(interfaceLabel))] = true;
  }

}







pragma solidity ^0.5.0;





interface IERC1400  { 

  
  function getDocument(bytes32 name) external view returns (string memory, bytes32);
  function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external;

  
  function balanceOfByPartition(bytes32 partition, address tokenHolder) external view returns (uint256);
  function partitionsOf(address tokenHolder) external view returns (bytes32[] memory);

  
  function transferWithData(address to, uint256 value, bytes calldata data) external;
  function transferFromWithData(address from, address to, uint256 value, bytes calldata data) external;

  
  function transferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external returns (bytes32);
  function operatorTransferByPartition(bytes32 partition, address from, address to, uint256 value, bytes calldata data, bytes calldata operatorData) external returns (bytes32);

  
  function isControllable() external view returns (bool);
  
  

  
  function authorizeOperator(address operator) external;
  function revokeOperator(address operator) external;
  function authorizeOperatorByPartition(bytes32 partition, address operator) external;
  function revokeOperatorByPartition(bytes32 partition, address operator) external;

  
  function isOperator(address operator, address tokenHolder) external view returns (bool);
  function isOperatorForPartition(bytes32 partition, address operator, address tokenHolder) external view returns (bool);

  
  function isIssuable() external view returns (bool);
  function issue(address tokenHolder, uint256 value, bytes calldata data) external;
  function issueByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata data) external;

  
  function redeem(uint256 value, bytes calldata data) external;
  function redeemFrom(address tokenHolder, uint256 value, bytes calldata data) external;
  function redeemByPartition(bytes32 partition, uint256 value, bytes calldata data) external;
  function operatorRedeemByPartition(bytes32 partition, address tokenHolder, uint256 value, bytes calldata operatorData) external;

  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  event Document(bytes32 indexed name, string uri, bytes32 documentHash);

  
  event TransferByPartition(
      bytes32 indexed fromPartition,
      address operator,
      address indexed from,
      address indexed to,
      uint256 value,
      bytes data,
      bytes operatorData
  );

  event ChangedPartition(
      bytes32 indexed fromPartition,
      bytes32 indexed toPartition,
      uint256 value
  );

  
  event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
  event RevokedOperator(address indexed operator, address indexed tokenHolder);
  event AuthorizedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
  event RevokedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);

  
  event Issued(address indexed operator, address indexed to, uint256 value, bytes data);
  event Redeemed(address indexed operator, address indexed from, uint256 value, bytes data);
  event IssuedByPartition(bytes32 indexed partition, address indexed operator, address indexed to, uint256 value, bytes data, bytes operatorData);
  event RedeemedByPartition(bytes32 indexed partition, address indexed operator, address indexed from, uint256 value, bytes operatorData);

}






































pragma solidity ^0.5.0;





contract BatchBalanceReader is ERC1820Implementer {

  string constant internal BALANCE_READER = "BatchBalanceReader";

  constructor() public {
    ERC1820Implementer._setInterface(BALANCE_READER);
  }

  






  function balancesOfByPartition(
    address[] calldata tokenHolders,
    address[] calldata tokenAddresses,
    bytes32[] calldata partitions
  )
    external
    view
    returns (uint256[] memory)
  {
    uint256[] memory balances = new uint256[](tokenAddresses.length * partitions.length * tokenHolders.length);
    uint256 index;
    for (uint i = 0; i < tokenHolders.length; i++) {
        for (uint j = 0; j < tokenAddresses.length; j++) {
            for (uint k = 0; k < partitions.length; k++) {
                    index = i * (tokenAddresses.length * partitions.length) + j * partitions.length + k;
                    balances[index] = IERC1400(tokenAddresses[j]).balanceOfByPartition(partitions[k], tokenHolders[i]);
            }
        }
    }

    return balances;
  }

  





  function balancesOf(
    address[] calldata tokenHolders,
    address[] calldata tokenAddresses
  )
    external
    view
    returns (uint256[] memory)
  {
    uint256[] memory balances = new uint256[](tokenHolders.length * tokenAddresses.length);
    uint256 index;
    for (uint i = 0; i < tokenHolders.length; i++) {
      for (uint j = 0; j < tokenAddresses.length; j++) {
        index = i * tokenAddresses.length + j;
        balances[index] = IERC20(tokenAddresses[j]).balanceOf(tokenHolders[i]);
      }
    }
    return balances;
  }
}