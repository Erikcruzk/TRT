// File: ../sc_datasets/DAppSCAN/Quantstamp-Stake Technologies Lockdrop/lockdrop-ui-e6d8357ebfb7c3ed5125b3c9e79fd1e41a9885ed/contracts/Lock.sol

pragma solidity ^0.5.0;

contract Lock {
    // address owner; slot #0
    // address unlockTime; slot #1
    constructor (address owner, uint256 unlockTime) public payable {
        assembly {
            sstore(0x00, owner)
            sstore(0x01, unlockTime)
        }
    }

    /**
    * @dev        Withdraw function once timestamp has passed unlock time
    */
    function () external payable { // payable so solidity doesn't add unnecessary logic
        assembly {
            switch gt(timestamp, sload(0x01))
            case 0 { revert(0, 0) }
            case 1 {
                switch call(gas, sload(0x00), balance(address), 0, 0, 0, 0)
                case 0 { revert(0, 0) }
            }
        }
    }
}