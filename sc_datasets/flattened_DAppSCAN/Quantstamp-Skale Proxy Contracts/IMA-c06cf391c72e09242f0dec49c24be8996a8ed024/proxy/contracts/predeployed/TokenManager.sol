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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/interfaces/IMessageProxy.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   MessageProxy.sol - SKALE Interchain Messaging Agent
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

interface IMessageProxy {
    function postOutgoingMessage(
        string calldata dstChainID,
        address dstContract,
        uint256 amount,
        address to,
        bytes calldata data
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/interfaces/IERC20Module.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   IERC20Module.sol - SKALE Interchain Messaging Agent
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

interface IERC20Module {
    function receiveERC20(
        address contractHere,
        address to,
        uint256 amount,
        bool isRaw) external returns (bytes memory);
    function sendERC20(address to, bytes calldata data) external returns (bool);
    function getReceiver(bytes calldata data) external pure returns (address);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/interfaces/IERC721Module.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   IERC721Module.sol - SKALE Interchain Messaging Agent
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


interface IERC721Module {
    function receiveERC721(
        address contractHere,
        address to,
        uint256 tokenId,
        bool isRaw) external returns (bytes memory);
    function sendERC721(address to, bytes calldata data) external returns (bool);
    function getReceiver(address to, bytes calldata data) external pure returns (address);
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/predeployed/TokenManager.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   TokenManager.sol - SKALE Interchain Messaging Agent
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






interface ILockAndDataTM {
    function setContract(string calldata contractName, address newContract) external;
    function tokenManagerAddresses(bytes32 schainHash) external returns (address);
    function sendEth(address to, uint256 amount) external returns (bool);
    function receiveEth(address sender, uint256 amount) external returns (bool);
    function approveTransfer(address to, uint256 amount) external;
    function ethCosts(address to) external returns (uint256);
    function addGasCosts(address to, uint256 amount) external;
    function reduceGasCosts(address to, uint256 amount) external returns (bool);
    function removeGasCosts(address to) external returns (uint256);
}

// This contract runs on schains and accepts messages from main net creates ETH clones.
// When the user exits, it burns them

/**
 * @title Token Manager
 * @dev Runs on SKALE Chains, accepts messages from mainnet, and instructs
 * TokenFactory to create clones. TokenManager mints tokens via
 * LockAndDataForSchain*. When a user exits a SKALE chain, TokenFactory
 * burns tokens.
 */
contract TokenManager is PermissionsForSchain {


    enum TransactionOperation {
        transferETH,
        transferERC20,
        transferERC721,
        rawTransferERC20,
        rawTransferERC721
    }

    // ID of this schain,
    string private _chainID;
    address private _proxyForSchainAddress;

    uint256 public constant GAS_AMOUNT_POST_MESSAGE = 200000;
    uint256 public constant AVERAGE_TX_PRICE = 10000000000;

    modifier rightTransaction(string memory schainID) {
        bytes32 schainHash = keccak256(abi.encodePacked(schainID));
        address schainTokenManagerAddress = ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(schainHash);
        require(
            schainHash != keccak256(abi.encodePacked("Mainnet")),
            "This function is not for transfering to Mainnet"
        );
        require(schainTokenManagerAddress != address(0), "Incorrect Token Manager address");
        _;
    }

    modifier receivedEth(uint256 amount) {
        require(amount >= GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE, "Null Amount");
        require(ILockAndDataTM(getLockAndDataAddress()).receiveEth(msg.sender, amount), "Could not receive ETH Clone");
        _;
    }


    /// Create a new token manager

    constructor(
        string memory newChainID,
        address newProxyAddress,
        address newLockAndDataAddress
    )
        public
        PermissionsForSchain(newLockAndDataAddress)
    {
        _chainID = newChainID;
        _proxyForSchainAddress = newProxyAddress;
    }

    fallback() external payable {
        revert("Not allowed. in TokenManager");
    }

    function exitToMainWithoutData(address to, uint256 amount) external {
        exitToMain(to, amount);
    }

    function transferToSchainWithoutData(string calldata schainID, address to, uint256 amount) external {
        transferToSchain(schainID, to, amount);
    }

    /**
     * @dev Adds ETH cost to perform exit transaction.
     */
    function addEthCostWithoutAddress(uint256 amount) external {
        addEthCost(amount);
    }

    /**
     * @dev Deducts ETH cost to perform exit transaction.
     */
    function removeEthCost() external {
        uint256 returnBalance = ILockAndDataTM(getLockAndDataAddress()).removeGasCosts(msg.sender);
        require(ILockAndDataTM(getLockAndDataAddress()).sendEth(msg.sender, returnBalance), "Not sent");
    }

    function exitToMainERC20(address contractHere, address to, uint256 amount) external {
        address lockAndDataERC20 = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("LockAndDataERC20")));
        address erc20Module = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("ERC20Module")));
        require(
            IERC20(contractHere).allowance(
                msg.sender,
                address(this)
            ) >= amount,
            "Not allowed ERC20 Token"
        );
        require(
            IERC20(contractHere).transferFrom(
                msg.sender,
                lockAndDataERC20,
                amount
            ),
            "Could not transfer ERC20 Token"
        );
        require(
            ILockAndDataTM(getLockAndDataAddress()).reduceGasCosts(
                msg.sender,
                GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE),
            "Not enough gas sent");
        bytes memory data = IERC20Module(erc20Module).receiveERC20(
            contractHere,
            to,
            amount,
            false);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            "Mainnet",
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE,
            address(0),
            data
        );
    }

    function rawExitToMainERC20(
        address contractHere,
        address contractThere,
        address to,
        uint256 amount) external
        {
        address lockAndDataERC20 = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("LockAndDataERC20")));
        address erc20Module = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("ERC20Module")));
        require(
            IERC20(contractHere).allowance(
                msg.sender,
                address(this)
            ) >= amount,
            "Not allowed ERC20 Token"
        );
        require(
            IERC20(contractHere).transferFrom(
                msg.sender,
                lockAndDataERC20,
                amount
            ),
            "Could not transfer ERC20 Token"
        );
        require(
            ILockAndDataTM(getLockAndDataAddress()).reduceGasCosts(
                msg.sender,
                GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE),
            "Not enough gas sent");
        bytes memory data = IERC20Module(erc20Module).receiveERC20(
            contractHere,
            to,
            amount,
            true);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            "Mainnet",
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE,
            contractThere,
            data
        );
    }

    function transferToSchainERC20(
        string calldata schainID,
        address contractHere,
        address to,
        uint256 amount) external
        {
        address lockAndDataERC20 = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("LockAndDataERC20")));
        address erc20Module = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("ERC20Module")));
        require(
            IERC20(contractHere).allowance(
                msg.sender,
                address(this)
            ) >= amount,
            "Not allowed ERC20 Token"
        );
        require(
            IERC20(contractHere).transferFrom(
                msg.sender,
                lockAndDataERC20,
                amount
            ),
            "Could not transfer ERC20 Token"
        );
        bytes memory data = IERC20Module(erc20Module).receiveERC20(
            contractHere,
            to,
            amount,
            false);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            schainID,
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            0,
            address(0),
            data
        );
    }

    function rawTransferToSchainERC20(
        string calldata schainID,
        address contractHere,
        address contractThere,
        address to,
        uint256 amount) external
        {
        address lockAndDataERC20 = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("LockAndDataERC20")));
        address erc20Module = IContractManagerForSchain(
            getLockAndDataAddress()
        ).permitted(keccak256(abi.encodePacked("ERC20Module")));
        require(
            IERC20(contractHere).allowance(
                msg.sender,
                address(this)
            ) >= amount,
            "Not allowed ERC20 Token"
        );
        require(
            IERC20(contractHere).transferFrom(
                msg.sender,
                lockAndDataERC20,
                amount
            ),
            "Could not transfer ERC20 Token"
        );
        bytes memory data = IERC20Module(erc20Module).receiveERC20(
            contractHere,
            to,
            amount,
            true);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            schainID,
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            0,
            contractThere,
            data
        );
    }

    function exitToMainERC721(address contractHere, address to, uint256 tokenId) external {
        address lockAndDataERC721 = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("LockAndDataERC721")));
        address erc721Module = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("ERC721Module")));
        require(IERC721(contractHere).ownerOf(tokenId) == address(this), "Not allowed ERC721 Token");
        IERC721(contractHere).transferFrom(address(this), lockAndDataERC721, tokenId);
        require(IERC721(contractHere).ownerOf(tokenId) == lockAndDataERC721, "Did not transfer ERC721 token");
        require(
            ILockAndDataTM(getLockAndDataAddress()).reduceGasCosts(
                msg.sender,
                GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE),
            "Not enough gas sent");
        bytes memory data = IERC721Module(erc721Module).receiveERC721(
            contractHere,
            to,
            tokenId,
            false);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            "Mainnet",
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE,
            address(0),
            data
        );
    }

    function rawExitToMainERC721(
        address contractHere,
        address contractThere,
        address to,
        uint256 tokenId) external
        {
        address lockAndDataERC721 = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("LockAndDataERC721")));
        address erc721Module = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("ERC721Module")));
        require(IERC721(contractHere).ownerOf(tokenId) == address(this), "Not allowed ERC721 Token");
        IERC721(contractHere).transferFrom(address(this), lockAndDataERC721, tokenId);
        require(IERC721(contractHere).ownerOf(tokenId) == lockAndDataERC721, "Did not transfer ERC721 token");
        require(
            ILockAndDataTM(getLockAndDataAddress()).reduceGasCosts(
                msg.sender,
                GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE),
            "Not enough gas sent");
        bytes memory data = IERC721Module(erc721Module).receiveERC721(
            contractHere,
            to,
            tokenId,
            true);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            "Mainnet",
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            GAS_AMOUNT_POST_MESSAGE * AVERAGE_TX_PRICE,
            contractThere,
            data
        );
    }

    function transferToSchainERC721(
        string calldata schainID,
        address contractHere,
        address to,
        uint256 tokenId) external
        {
        address lockAndDataERC721 = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("LockAndDataERC721")));
        address erc721Module = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("ERC721Module")));
        require(IERC721(contractHere).ownerOf(tokenId) == address(this), "Not allowed ERC721 Token");
        IERC721(contractHere).transferFrom(address(this), lockAndDataERC721, tokenId);
        require(IERC721(contractHere).ownerOf(tokenId) == lockAndDataERC721, "Did not transfer ERC721 token");
        bytes memory data = IERC721Module(erc721Module).receiveERC721(
            contractHere,
            to,
            tokenId,
            false);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            schainID,
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            0,
            address(0),
            data
        );
    }

    function rawTransferToSchainERC721(
        string calldata schainID,
        address contractHere,
        address contractThere,
        address to,
        uint256 tokenId) external
        {
        address lockAndDataERC721 = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("LockAndDataERC721")));
        address erc721Module = IContractManagerForSchain(getLockAndDataAddress()).
            permitted(keccak256(abi.encodePacked("ERC721Module")));
        require(IERC721(contractHere).ownerOf(tokenId) == address(this), "Not allowed ERC721 Token");
        IERC721(contractHere).transferFrom(address(this), lockAndDataERC721, tokenId);
        require(IERC721(contractHere).ownerOf(tokenId) == lockAndDataERC721, "Did not transfer ERC721 token");
        bytes memory data = IERC721Module(erc721Module).receiveERC721(
            contractHere,
            to,
            tokenId,
            true);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            schainID,
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            0,
            contractThere,
            data
        );
    }

    /**
     * @dev Allows MessageProxy to post operational message from mainnet
     * or SKALE chains.
     * 
     * Emits an {Error} event upon failure.
     *
     * Requirements:
     * 
     * - MessageProxy must be the sender.
     * - `fromSchainID` must exist in TokenManager addresses.
     */
    function postMessage(
        address sender,
        string calldata fromSchainID,
        address to,
        uint256 amount,
        bytes calldata data
    )
        external
    {
        require(data.length != 0, "Invalid data");
        require(msg.sender == getProxyForSchainAddress(), "Not a sender");
        bytes32 schainHash = keccak256(abi.encodePacked(fromSchainID));
        require(
            schainHash != keccak256(abi.encodePacked(getChainID())) && 
            sender == ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(schainHash),
            "Receiver chain is incorrect"
        );

        TransactionOperation operation = _fallbackOperationTypeConvert(data);
        if (operation == TransactionOperation.transferETH) {
            require(to != address(0), "Incorrect receiver");
            require(ILockAndDataTM(getLockAndDataAddress()).sendEth(to, amount), "Not Sent");
        } else if ((operation == TransactionOperation.transferERC20 && to == address(0)) ||
                  (operation == TransactionOperation.rawTransferERC20 && to != address(0))) {
            address erc20Module = IContractManagerForSchain(
                getLockAndDataAddress()
            ).permitted(keccak256(abi.encodePacked("ERC20Module")));
            require(IERC20Module(erc20Module).sendERC20(to, data), "Failed to send ERC20");
            address receiver = IERC20Module(erc20Module).getReceiver(data);
            require(ILockAndDataTM(getLockAndDataAddress()).sendEth(receiver, amount), "Not Sent");
        } else if ((operation == TransactionOperation.transferERC721 && to == address(0)) ||
                  (operation == TransactionOperation.rawTransferERC721 && to != address(0))) {
            address erc721Module = IContractManagerForSchain(
                getLockAndDataAddress()
            ).permitted(keccak256(abi.encodePacked("ERC721Module")));
            require(IERC721Module(erc721Module).sendERC721(to, data), "Failed to send ERC721");
            address receiver = IERC721Module(erc721Module).getReceiver(to, data);
            require(ILockAndDataTM(getLockAndDataAddress()).sendEth(receiver, amount), "Not Sent");
        }
    }

    /**
     * @dev Performs an exit (post outgoing message) to Mainnet.
     */
    function exitToMain(address to, uint256 amount) public {
        bytes memory empty = "";
        exitToMain(to, amount, empty);
    }

    /**
     * @dev Performs an exit (post outgoing message) to Mainnet.
     */
    function exitToMain(address to, uint256 amount, bytes memory data) public receivedEth(amount) {
        bytes memory newData;
        newData = abi.encodePacked(bytes1(uint8(1)), data);
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            "Mainnet",
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked("Mainnet"))),
            amount,
            to,
            newData
        );
    }

    function transferToSchain(string memory schainID, address to, uint256 amount) public {
        bytes memory data = "";
        transferToSchain(
            schainID,
            to,
            amount,
            data);
    }

    function transferToSchain(
        string memory schainID,
        address to,
        uint256 amount,
        bytes memory data
    )
        public
        rightTransaction(schainID)
        receivedEth(amount)
    {
        IMessageProxy(getProxyForSchainAddress()).postOutgoingMessage(
            schainID,
            ILockAndDataTM(getLockAndDataAddress()).tokenManagerAddresses(keccak256(abi.encodePacked(schainID))),
            amount,
            to,
            data
        );
    }

    /**
     * @dev Adds ETH cost for `msg.sender` exit transaction.
     */
    function addEthCost(uint256 amount) public {
        addEthCost(msg.sender, amount);
    }

    /**
     * @dev Adds ETH cost for user's exit transaction.
     */
    function addEthCost(address sender, uint256 amount) public receivedEth(amount) {
        ILockAndDataTM(getLockAndDataAddress()).addGasCosts(sender, amount);
    }

    /**
     * @dev Returns chain ID.
     */
    function getChainID() public view returns ( string memory cID ) {
        if ((keccak256(abi.encodePacked(_chainID))) == (keccak256(abi.encodePacked(""))) ) {
            return SkaleFeatures(0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2)
                .getConfigVariableString("skaleConfig.sChain.schainID");
        }
        return _chainID;
    }

    /**
     * @dev Returns MessageProxy address.
     */
    function getProxyForSchainAddress() public view returns ( address ow ) { // l_sergiy: added
        if (_proxyForSchainAddress == address(0) ) {
            return SkaleFeatures(0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2).getConfigVariableAddress(
                "skaleConfig.contractSettings.IMA.messageProxyAddress"
            );
        }
        return _proxyForSchainAddress;
    }

    /**
     * @dev Converts the first byte of data to an operation.
     * 
     * 0x01 - transfer ETH
     * 0x03 - transfer ERC20 token
     * 0x05 - transfer ERC721 token
     * 0x13 - transfer ERC20 token - raw mode
     * 0x15 - transfer ERC721 token - raw mode
     * 
     * Requirements:
     * 
     * - Operation must be one of the possible types.
     */
    function _fallbackOperationTypeConvert(bytes memory data)
        private
        pure
        returns (TransactionOperation)
    {
        bytes1 operationType;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            operationType := mload(add(data, 0x20))
        }
        require(
            operationType == 0x01 ||
            operationType == 0x03 ||
            operationType == 0x05 ||
            operationType == 0x13 ||
            operationType == 0x15,
            "Operation type is not identified"
        );
        if (operationType == 0x01) {
            return TransactionOperation.transferETH;
        } else if (operationType == 0x03) {
            return TransactionOperation.transferERC20;
        } else if (operationType == 0x05) {
            return TransactionOperation.transferERC721;
        } else if (operationType == 0x13) {
            return TransactionOperation.rawTransferERC20;
        } else if (operationType == 0x15) {
            return TransactionOperation.rawTransferERC721;
        }
    }

}
