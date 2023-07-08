// File: ../sc_datasets/DAppSCAN/QuillAudits-Alium Finance Smart Contract/alium-farm-e37d6af39af68049c2684085f025385407b4bd55/contracts/interfaces/IOwnable.sol

// SPDX-License-Identifier: MIT

pragma solidity =0.6.12;

interface IOwnable {
    function owner() external view returns (address);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
}
