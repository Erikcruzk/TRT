

















pragma solidity 0.5.12;

interface ILocatorWhitelist {

  function has(
    bytes32 locator
  ) external view returns (bool);

}