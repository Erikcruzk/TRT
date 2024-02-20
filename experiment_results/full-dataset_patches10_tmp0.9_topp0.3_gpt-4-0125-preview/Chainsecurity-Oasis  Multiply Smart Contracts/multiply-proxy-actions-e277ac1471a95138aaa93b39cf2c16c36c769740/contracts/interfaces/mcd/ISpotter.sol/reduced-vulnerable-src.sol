



pragma solidity ^0.7.0;

abstract contract IPipInterface {
  function read() public virtual returns (bytes32);
}





pragma solidity ^0.7.0;

abstract contract ISpotter {
  struct Ilk {
    IPipInterface pip;
    uint256 mat;
  }

  mapping(bytes32 => Ilk) public ilks;

  uint256 public par;
}