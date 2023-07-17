// File: ../sc_datasets/DAppSCAN/Chainsulting-GSPI Club-project1/openzeppelin-contracts-2.0.1/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.4.24;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: ../sc_datasets/DAppSCAN/Chainsulting-GSPI Club-project1/openzeppelin-contracts-2.0.1/contracts/drafts/ERC1046/TokenMetadata.sol

pragma solidity ^0.4.24;

/**
 * @title ERC-1047 Token Metadata
 * @dev See https://eips.ethereum.org/EIPS/eip-1046
 * @dev tokenURI must respond with a URI that implements https://eips.ethereum.org/EIPS/eip-1047
 * @dev TODO - update https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/IERC721.sol#L17 when 1046 is finalized
 */
contract ERC20TokenMetadata is IERC20 {
  function tokenURI() external view returns (string);
}

contract ERC20WithMetadata is ERC20TokenMetadata {
  string private _tokenURI;

  constructor(string tokenURI)
    public
  {
    _tokenURI = tokenURI;
  }

  function tokenURI() external view returns (string) {
    return _tokenURI;
  }
}
