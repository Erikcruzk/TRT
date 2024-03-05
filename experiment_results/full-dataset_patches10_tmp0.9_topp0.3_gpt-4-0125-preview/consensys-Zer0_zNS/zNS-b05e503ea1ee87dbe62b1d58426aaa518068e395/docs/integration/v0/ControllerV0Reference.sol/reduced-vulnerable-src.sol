


pragma solidity ^0.7.3;

interface ControllerV0Reference {
  
  
  function registerSubdomain(
    uint256 parentDomain,
    string memory domainName,
    address domainOwner
  ) external;
}