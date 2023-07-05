// File: ../sc_datasets/DAppSCAN/SlowMist-Starcrazy Smart Contract Security Audit Report/starcrazy-contracts-e9e11d234ac065726e108a73dfcd5efbad26f2c5/contract/token/IERC223.sol

pragma solidity <0.6.0 >=0.4.21;

interface IERC223 {
    function transfer(
        address to,
        uint256 amount,
        bytes calldata data
    ) external returns (bool ok);

    function transferFrom(
        address from,
        address to,
        uint256 amount,
        bytes calldata data
    ) external returns (bool ok);

    event ERC223Transfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data
    );
}
