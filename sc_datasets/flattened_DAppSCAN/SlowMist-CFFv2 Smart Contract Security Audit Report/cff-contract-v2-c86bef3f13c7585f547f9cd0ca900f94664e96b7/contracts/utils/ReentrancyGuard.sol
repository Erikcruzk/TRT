// File: ../sc_datasets/DAppSCAN/SlowMist-CFFv2 Smart Contract Security Audit Report/cff-contract-v2-c86bef3f13c7585f547f9cd0ca900f94664e96b7/contracts/utils/ReentrancyGuard.sol

pragma solidity >=0.4.21 <0.6.0;

contract ReentrancyGuard {
    uint256 private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}
