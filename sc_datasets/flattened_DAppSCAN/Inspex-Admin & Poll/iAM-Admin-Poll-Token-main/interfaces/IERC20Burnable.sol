// File: ../sc_datasets/DAppSCAN/Inspex-Admin & Poll/iAM-Admin-Poll-Token-main/interfaces/IERC20Burnable.sol

// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IERC20Burnable {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function burn(uint256 amount) external;

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function adminTransfer(
    address,
    address,
    uint256
  ) external returns (bool);

  function transferOwnership(address) external;
}