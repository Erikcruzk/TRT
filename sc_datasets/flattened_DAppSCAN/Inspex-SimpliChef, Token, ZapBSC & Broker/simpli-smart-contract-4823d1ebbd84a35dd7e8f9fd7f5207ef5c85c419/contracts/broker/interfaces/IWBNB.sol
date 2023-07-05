// File: ../sc_datasets/DAppSCAN/Inspex-SimpliChef, Token, ZapBSC & Broker/simpli-smart-contract-4823d1ebbd84a35dd7e8f9fd7f5207ef5c85c419/contracts/broker/interfaces/IWBNB.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

interface IWBNB {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}
