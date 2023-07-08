// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/predeployed/SkaleFeatures.sol

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/predeployed/OwnableForSchain.sol

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/predeployed/PermissionsForSchain.sol

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

// File: @openzeppelin/contracts-ethereum-package/contracts/introspection/IERC165.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.6.2;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either {approve} or {setApprovalForAll}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either {approve} or {setApprovalForAll}.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721Metadata.sol

pragma solidity ^0.6.2;

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/predeployed/ERC721ModuleForSchain.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   ERC721ModuleForSchain.sol - SKALE Interchain Messaging Agent
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


interface ITokenFactoryForERC721 {
    function createERC721(string memory name, string memory symbol)
        external
        returns (address payable);
}

interface ILockAndDataERC721S {
    function erc721Tokens(uint256 index) external returns (address);
    function erc721Mapper(address contractERC721) external returns (uint256);
    function addERC721Token(address contractERC721, uint256 contractPosition) external;
    function sendERC721(address contractHere, address to, uint256 tokenId) external returns (bool);
    function receiveERC721(address contractHere, uint256 tokenId) external returns (bool);
}


contract ERC721ModuleForSchain is PermissionsForSchain {

    event ERC721TokenCreated(uint256 indexed contractPosition, address tokenAddress);


    constructor(address newLockAndDataAddress) public PermissionsForSchain(newLockAndDataAddress) {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Allows TokenManager to receive ERC721 tokens.
     * 
     * Requirements:
     * 
     * - ERC721 token contract must exist in LockAndDataForSchainERC721.
     * - ERC721 token must be received by LockAndDataForSchainERC721.
     */
    function receiveERC721(
        address contractHere,
        address to,
        uint256 tokenId,
        bool isRAW) external allow("TokenManager") returns (bytes memory data)
        {
        address lockAndDataERC721 = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("LockAndDataERC721")));
        if (!isRAW) {
            uint256 contractPosition = ILockAndDataERC721S(lockAndDataERC721).erc721Mapper(contractHere);
            require(contractPosition > 0, "ERC721 contract does not exist on SKALE chain");
            require(
                ILockAndDataERC721S(lockAndDataERC721).receiveERC721(contractHere, tokenId),
                "Could not receive ERC721 Token"
            );
            data = _encodeData(
                contractHere,
                contractPosition,
                to,
                tokenId);
            return data;
        } else {
            data = _encodeRawData(to, tokenId);
            return data;
        }
    }

    /**
     * @dev Allows TokenManager to send ERC721 tokens.
     *  
     * Emits a {ERC721TokenCreated} event if to address = 0.
     */
    function sendERC721(address to, bytes calldata data) external allow("TokenManager") returns (bool) {
        address lockAndDataERC721 = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("LockAndDataERC721")));
        uint256 contractPosition;
        address contractAddress;
        address receiver;
        uint256 tokenId;
        if (to == address(0)) {
            (contractPosition, receiver, tokenId) = _fallbackDataParser(data);
            contractAddress = ILockAndDataERC721S(lockAndDataERC721).erc721Tokens(contractPosition);
            if (contractAddress == address(0)) {
                contractAddress = _sendCreateERC721Request(data);
                emit ERC721TokenCreated(contractPosition, contractAddress);
                ILockAndDataERC721S(lockAndDataERC721).addERC721Token(contractAddress, contractPosition);
            }
        } else {
            (receiver, tokenId) = _fallbackRawDataParser(data);
            contractAddress = to;
        }
        return ILockAndDataERC721S(lockAndDataERC721).sendERC721(contractAddress, receiver, tokenId);
    }

    /**
     * @dev Returns the receiver address.
     */
    function getReceiver(address to, bytes calldata data) external pure returns (address receiver) {
        uint256 contractPosition;
        uint256 tokenId;
        if (to == address(0)) {
            (contractPosition, receiver, tokenId) = _fallbackDataParser(data);
        } else {
            (receiver, tokenId) = _fallbackRawDataParser(data);
        }
    }

    function _sendCreateERC721Request(bytes calldata data) internal returns (address) {
        string memory name;
        string memory symbol;
        (name, symbol) = _fallbackDataCreateERC721Parser(data);
        address tokenFactoryAddress = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("TokenFactory")));
        return ITokenFactoryForERC721(tokenFactoryAddress).createERC721(name, symbol);
    }

    /**
     * @dev Returns encoded creation data.
     */
    function _encodeData(
        address contractHere,
        uint256 contractPosition,
        address to,
        uint256 tokenId
    )
        private
        view
        returns (bytes memory data)
    {
        string memory name = IERC721Metadata(contractHere).name();
        string memory symbol = IERC721Metadata(contractHere).symbol();
        data = abi.encodePacked(
            bytes1(uint8(5)),
            bytes32(contractPosition),
            bytes32(bytes20(to)),
            bytes32(tokenId),
            bytes(name).length,
            name,
            bytes(symbol).length,
            symbol
        );
    }

    /**
     * @dev Returns encoded raw data.
     */
    function _encodeRawData(address to, uint256 tokenId) private pure returns (bytes memory data) {
        data = abi.encodePacked(
            bytes1(uint8(21)),
            bytes32(bytes20(to)),
            bytes32(tokenId)
        );
    }

    /**
     * @dev Returns fallback data.
     */
    function _fallbackDataParser(bytes memory data)
        private
        pure
        returns (uint256, address payable, uint256)
    {
        bytes32 contractIndex;
        bytes32 to;
        bytes32 token;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            contractIndex := mload(add(data, 33))
            to := mload(add(data, 65))
            token := mload(add(data, 97))
        }
        return (
            uint256(contractIndex), address(bytes20(to)), uint256(token)
        );
    }

    /**
     * @dev Returns fallback data.
     */
    function _fallbackRawDataParser(bytes memory data)
        private
        pure
        returns (address payable, uint256)
    {
        bytes32 to;
        bytes32 token;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            to := mload(add(data, 33))
            token := mload(add(data, 65))
        }
        return (address(bytes20(to)), uint256(token));
    }

    function _fallbackDataCreateERC721Parser(bytes memory data)
        private
        pure
        returns (
            string memory name,
            string memory symbol
        )
    {
        bytes32 nameLength;
        bytes32 symbolLength;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            nameLength := mload(add(data, 129))
        }
        name = new string(uint256(nameLength));
        for (uint256 i = 0; i < uint256(nameLength); i++) {
            bytes(name)[i] = data[129 + i];
        }
        uint256 lengthOfName = uint256(nameLength);
        // solhint-disable-next-line no-inline-assembly
        assembly {
            symbolLength := mload(add(data, add(161, lengthOfName)))
        }
        symbol = new string(uint256(symbolLength));
        for (uint256 i = 0; i < uint256(symbolLength); i++) {
            bytes(symbol)[i] = data[161 + lengthOfName + i];
        }
    }
}
