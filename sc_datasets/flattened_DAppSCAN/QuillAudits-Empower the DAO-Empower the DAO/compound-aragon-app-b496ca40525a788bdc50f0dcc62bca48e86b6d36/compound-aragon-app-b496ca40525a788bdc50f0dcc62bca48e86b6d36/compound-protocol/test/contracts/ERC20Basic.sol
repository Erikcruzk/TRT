// File: ../sc_datasets/DAppSCAN/QuillAudits-Empower the DAO-Empower the DAO/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-protocol/test/contracts/ERC20Basic.sol

pragma solidity ^0.5.8;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}
