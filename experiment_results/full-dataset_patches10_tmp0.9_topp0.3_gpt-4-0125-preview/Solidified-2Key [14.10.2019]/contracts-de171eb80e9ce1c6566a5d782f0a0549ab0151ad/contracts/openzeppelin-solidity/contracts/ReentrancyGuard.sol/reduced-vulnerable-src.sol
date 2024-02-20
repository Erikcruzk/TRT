

pragma solidity ^0.4.24;








contract ReentrancyGuard {

  
  
  uint private constant REENTRANCY_GUARD_FREE = 1;

  
  uint private constant REENTRANCY_GUARD_LOCKED = 2;

  


  uint private reentrancyLock = REENTRANCY_GUARD_FREE;

  







  modifier nonReentrant() {
    require(reentrancyLock == REENTRANCY_GUARD_FREE);
    reentrancyLock = REENTRANCY_GUARD_LOCKED;
    _;
    reentrancyLock = REENTRANCY_GUARD_FREE;
  }

}