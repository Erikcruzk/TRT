// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-8ba748426e10bdcd3bcf1e5adf3b97a22f55422f/proxy/contracts/predeployed/SkaleFeatures.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   SkaleFeatures.sol - SKALE Interchain Messaging Agent
 *   Copyright (C) 2019-Present SKALE Labs
 *   @author Sergiy Lavrynenko
 *
 *   SKALE IMA is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published
 *   by the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   SKALE IMA is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with SKALE IMA.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity 0.6.12;


contract SkaleFeatures {

    uint256 public constant FREE_MEM_PTR = 0x40;
    uint256 public constant FN_NUM_LOG_TEXT_MESSAGE = 0x12;
    uint256 public constant FN_NUM_GET_CONFIG_VARIABLE_UINT256 = 0x13;
    uint256 public constant FN_NUM_GET_CONFIG_VARIABLE_ADDRESS = 0x14;
    uint256 public constant FN_NUM_GET_CONFIG_VARIABLE_STRING = 0x15;
    uint256 public constant FN_NUM_CONCATENATE_STRINGS = 0x16;
    uint256 public constant FN_NUM_GET_CONFIG_PERMISSION_FLAG = 0x17;

    function logTextMessage( uint256 messageType, string memory strTextMessage ) public view returns ( uint256 rv ) {
        uint256 fmp = FREE_MEM_PTR;
        uint256 fnc = FN_NUM_LOG_TEXT_MESSAGE;
        address who = msg.sender;
        uint256 blocks = (bytes(strTextMessage).length + 31) / 32 + 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let p := mload(fmp)
            let ptr := p
            // who
            mstore(ptr, who)
            ptr := add(ptr, 32)
            // type
            mstore(ptr, messageType )
            ptr := add(ptr, 32)
            // message
            for { let i := 0 } lt( i, blocks ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add( strTextMessage, mul(32, i)))
                mstore(where, what)
            }
            rv := staticcall(not(0), fnc, p, add( 64, mul(blocks, 32) ), p, 32)
        }
    }

    function logMessage( string memory strMessage ) public view returns  (uint256 rv) {
        rv = logTextMessage(0, strMessage);
    }

    function logDebug  ( string memory strMessage ) public view returns  (uint256 rv) {
        rv = logTextMessage(1, strMessage);
    }

    function logTrace  ( string memory strMessage ) public view returns  (uint256 rv) {
        rv = logTextMessage(2, strMessage);
    }

    function logWarning( string memory strMessage ) public view returns  (uint256 rv) {
        rv = logTextMessage(3, strMessage);
    }

    function logError  ( string memory strMessage ) public view returns  (uint256 rv) {
        rv = logTextMessage(4, strMessage);
    }

    function logFatal  ( string memory strMessage ) public view returns  (uint256 rv) {
        rv = logTextMessage(5, strMessage);
    }

    function getConfigVariableUint256( string memory strConfigVariableName ) public view returns ( uint256 rv ) {
        uint256 fmp = FREE_MEM_PTR;
        uint256 blocks = (bytes(strConfigVariableName).length + 31) / 32 + 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let ptr := mload(fmp)
            for { let i := 0 } lt( i, blocks ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add(strConfigVariableName, mul(32, i)))
                mstore(where, what)
            }
            rv := mload(ptr)
        }
    }

    function getConfigVariableAddress( string memory strConfigVariableName ) public view returns ( address rv ) {
        uint256 fmp = FREE_MEM_PTR;
        uint256 blocks = (bytes(strConfigVariableName).length + 31) / 32 + 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let ptr := mload(fmp)
            for { let i := 0 } lt( i, blocks ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add(strConfigVariableName, mul(32, i)))
                mstore(where, what)
            }
            rv := mload(ptr)
        }
    }

    function getConfigVariableString( string memory strConfigVariableName ) public view returns ( string memory rv ) {
        uint256 fmp = FREE_MEM_PTR;
        uint256 blocks = (bytes(strConfigVariableName).length + 31) / 32 + 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let ptr := mload(fmp)
            for { let i := 0 } lt( i, blocks ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add(strConfigVariableName, mul(32, i)))
                mstore(where, what)
            }
        }
    }

    function concatenateStrings( string memory strA, string memory strB ) public view returns ( string memory rv ) {
        uint256 fmp = FREE_MEM_PTR;
        uint256 blocksA = (bytes(strA).length + 31) / 32 + 1;
        uint256 blocksB = (bytes(strB).length + 31) / 32 + 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let p := mload(fmp)
            let ptr := p
            for { let i := 0 } lt( i, blocksA ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add( strA, mul(32, i)))
                mstore(where, what)
            }
            ptr := add(ptr, mul( blocksA, 32) )
            for { let i := 0 } lt( i, blocksB ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add( strB, mul(32, i)))
                mstore(where, what)
            }
        }
    }

    function getConfigPermissionFlag(address a, string memory strConfigVariableName) public view returns (uint256 rv) {
        uint256 fmp = FREE_MEM_PTR;
        uint256 blocks = (bytes(strConfigVariableName).length + 31) / 32 + 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let p := mload(fmp)
            mstore(p, a)
            let ptr := add(p, 32)
            for { let i := 0 } lt( i, blocks ) { i := add(1, i) } {
                let where := add(ptr, mul(32, i))
                let what := mload(add(strConfigVariableName, mul(32, i)))
                mstore(where, what)
            }
            rv := mload(ptr)
        }
    }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-8ba748426e10bdcd3bcf1e5adf3b97a22f55422f/proxy/contracts/predeployed/OwnableForSchain.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   OwnableForSchain.sol - SKALE Interchain Messaging Agent
 *   Copyright (C) 2019-Present SKALE Labs
 *   @author Artem Payvin
 *
 *   SKALE IMA is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published
 *   by the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   SKALE IMA is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with SKALE IMA.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity 0.6.12;

/**
 * @title OwnableForSchain
 * @dev The OwnableForSchain contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract OwnableForSchain {

    /**
     * @dev _ownerAddress is only used after transferOwnership(). 
     * By default, value of "skaleConfig.contractSettings.IMA._ownerAddress" config variable is used
     */
    address private _ownerAddress;

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == getOwner(), "Only owner can execute this method");
        _;
    }

    /**
     * @dev The OwnableForSchain constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        _ownerAddress = msg.sender;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address payable newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner has to be set");
        setOwner(newOwner);
    }

    /**
     * @dev Sets new owner address.
     */
    function setOwner( address newAddressOwner ) public {
        _ownerAddress = newAddressOwner;
    }

    /**
     * @dev Returns owner address.
     */
    function getOwner() public view returns ( address ow ) {
        if ((_ownerAddress) == (address(0)) )
            return SkaleFeatures(0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2).getConfigVariableAddress(
                "skaleConfig.contractSettings.IMA._ownerAddress"
            );
        return _ownerAddress;
    }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-8ba748426e10bdcd3bcf1e5adf3b97a22f55422f/proxy/contracts/predeployed/PermissionsForSchain.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   PermissionsForSchain.sol - SKALE Interchain Messaging Agent
 *   Copyright (C) 2019-Present SKALE Labs
 *   @author Artem Payvin
 *
 *   SKALE IMA is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published
 *   by the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   SKALE IMA is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with SKALE IMA.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity 0.6.12;

interface IContractManagerForSchain {
    function permitted(bytes32 contractName) external view returns (address);
}


/**
 * @title PermissionsForSchain - connected module for Upgradeable approach, knows ContractManager
 * @author Artem Payvin
 */
contract PermissionsForSchain is OwnableForSchain {

    // address of ContractManager
    address public lockAndDataAddress_;

    /**
     * @dev constructor - sets current address of ContractManager
     * @param newContractsAddress - current address of ContractManager
     */
    constructor(address newContractsAddress) public {
        lockAndDataAddress_ = newContractsAddress;
    }

    /**
     * @dev allow - throws if called by any account and contract other than the owner
     * or `contractName` contract
     * @param contractName - human readable name of contract
     */
    modifier allow(string memory contractName) {
        require(
            IContractManagerForSchain(
                getLockAndDataAddress()
            ).permitted(keccak256(abi.encodePacked(contractName))) == msg.sender ||
            getOwner() == msg.sender, "Message sender is invalid"
        );
        _;
    }

    function getLockAndDataAddress() public view returns ( address a ) {
        if (lockAndDataAddress_ != address(0) )
            return lockAndDataAddress_;
        return SkaleFeatures(0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2).
            getConfigVariableAddress("skaleConfig.contractSettings.IMA.lockAndDataAddress");
    }

}
