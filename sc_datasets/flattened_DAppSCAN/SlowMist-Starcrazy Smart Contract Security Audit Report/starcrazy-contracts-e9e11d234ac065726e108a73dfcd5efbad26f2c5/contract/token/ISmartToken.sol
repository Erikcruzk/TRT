// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/ISmartToken.sol

pragma solidity <0.6.0 >=0.4.21;

interface ISmartToken {
    function transferOwnership(address newOwner_) external;

    function acceptOwnership() external;

    function disableTransfers(bool disable_) external;

    function issue(address to_, uint256 amount_) external;
}
