// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/common/Uint256Helpers.sol

pragma solidity ^0.4.24;


library Uint256Helpers {
    uint256 public constant MAX_UINT64 = uint64(-1);

    string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";

    function toUint64(uint256 a) internal pure returns (uint64) {
        require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
        return uint64(a);
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragonOS-a68479107f564e6be98a6b877b78f635fca96dbe/contracts/test/mocks/Uint256Mock.sol

pragma solidity 0.4.24;

contract Uint256Mock {
    using Uint256Helpers for uint256;

    function convert(uint256 a) public pure returns (uint64) {
        return a.toUint64();
    }
}
