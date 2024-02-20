


pragma solidity ^0.8.8;




interface IERC2981 {
  
  
  
  
  
  
  function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
    external
    view
    returns (address receiver, uint256 royaltyAmount);
}