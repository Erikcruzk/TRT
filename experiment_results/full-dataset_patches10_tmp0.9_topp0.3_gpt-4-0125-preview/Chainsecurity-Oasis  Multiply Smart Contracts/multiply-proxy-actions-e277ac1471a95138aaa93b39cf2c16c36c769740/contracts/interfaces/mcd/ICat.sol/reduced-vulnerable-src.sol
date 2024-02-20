



pragma solidity ^0.7.0;

abstract contract ICat {
  struct Ilk {
    address flip; 
    uint256 chop; 
    uint256 lump; 
  }

  mapping(bytes32 => Ilk) public ilks;
}