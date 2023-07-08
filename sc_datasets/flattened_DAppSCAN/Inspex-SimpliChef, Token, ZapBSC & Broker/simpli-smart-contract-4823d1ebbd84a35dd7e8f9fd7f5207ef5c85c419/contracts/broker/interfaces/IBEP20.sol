// File: ../sc_datasets/DAppSCAN/Inspex-SimpliChef, Token, ZapBSC & Broker/simpli-smart-contract-4823d1ebbd84a35dd7e8f9fd7f5207ef5c85c419/contracts/broker/interfaces/IBEP20.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
