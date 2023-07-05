// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/InitializableOwnable.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract InitializableOwnable {
    address public _OWNER_;
    address public _NEW_OWNER_;
    bool internal _INITIALIZED_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier notInitialized() {
        require(!_INITIALIZED_, "DODO_INITIALIZED");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    function initOwner(address newOwner) public notInitialized {
        _INITIALIZED_ = true;
        _OWNER_ = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() public {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/SafeMath.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


/**
 * @title SafeMath
 * @author DODO Breeder
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = x / 2 + 1;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/DODOToken/Governance.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/
pragma solidity 0.6.9;


interface IVDODOMine {
    function balanceOf(address account) external view returns (uint256);
}

contract Governance is InitializableOwnable {
    using SafeMath for uint256;

    // ============ Storage ============
    address[] public _VDODO_MINE_LIST_;


    // ============ Event =============
    event AddMineContract(address mineContract);
    event RemoveMineContract(address mineContract);


    function getLockedvDODO(address account) external view returns (uint256 lockedvDODO) {
        uint256 len = _VDODO_MINE_LIST_.length;
        for(uint i = 0; i < len; i++){
            uint256 curLocked = IVDODOMine(_VDODO_MINE_LIST_[i]).balanceOf(account);
            lockedvDODO = lockedvDODO.add(curLocked);
        }
    }

    // =============== Ownable  ================

    function addMineContract(address[] memory mineContracts) external onlyOwner {
        for(uint i = 0; i < mineContracts.length; i++){
            require(mineContracts[i] != address(0),"ADDRESS_INVALID");
            _VDODO_MINE_LIST_.push(mineContracts[i]);
            emit AddMineContract(mineContracts[i]);
        }
    }

    function removeMineContract(address mineContract) external onlyOwner {
        uint256 len = _VDODO_MINE_LIST_.length;
        for (uint256 i = 0; i < len; i++) {
            if (mineContract == _VDODO_MINE_LIST_[i]) {
                _VDODO_MINE_LIST_[i] = _VDODO_MINE_LIST_[len - 1];
                _VDODO_MINE_LIST_.pop();
                emit RemoveMineContract(mineContract);
                break;
            }
        }
    }
}
