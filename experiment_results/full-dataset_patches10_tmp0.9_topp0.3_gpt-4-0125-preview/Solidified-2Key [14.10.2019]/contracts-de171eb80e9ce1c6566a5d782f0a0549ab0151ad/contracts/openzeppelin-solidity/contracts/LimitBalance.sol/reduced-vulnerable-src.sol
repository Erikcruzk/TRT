

pragma solidity ^0.4.24;








contract LimitBalance {

  uint256 public limit;

  



  constructor(uint256 _limit) public {
    limit = _limit;
  }

  


  modifier limitedPayable() {
    require(address(this).balance <= limit);
    _;

  }

}