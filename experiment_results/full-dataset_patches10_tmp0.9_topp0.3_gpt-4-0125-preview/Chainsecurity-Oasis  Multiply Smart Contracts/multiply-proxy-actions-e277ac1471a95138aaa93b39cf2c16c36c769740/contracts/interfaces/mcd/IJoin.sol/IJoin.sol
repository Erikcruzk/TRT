// File: ../sc_datasets/DAppSCAN/Chainsecurity-Oasis  Multiply Smart Contracts/multiply-proxy-actions-e277ac1471a95138aaa93b39cf2c16c36c769740/contracts/interfaces/mcd/IGem.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IGem {
  function dec() public virtual returns (uint256);

  function gem() public virtual returns (IGem);

  function join(address, uint256) public payable virtual;

  function exit(address, uint256) public virtual;

  function approve(address, uint256) public virtual;

  function transfer(address, uint256) public virtual returns (bool);

  function transferFrom(
    address,
    address,
    uint256
  ) public virtual returns (bool);

  function deposit() public payable virtual;

  function withdraw(uint256) public virtual;

  function allowance(address, address) public virtual returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Oasis  Multiply Smart Contracts/multiply-proxy-actions-e277ac1471a95138aaa93b39cf2c16c36c769740/contracts/interfaces/mcd/IJoin.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IJoin {
  bytes32 public ilk;

  function dec() public view virtual returns (uint256);

  function gem() public view virtual returns (IGem);

  function join(address, uint256) public payable virtual;

  function exit(address, uint256) public virtual;
}