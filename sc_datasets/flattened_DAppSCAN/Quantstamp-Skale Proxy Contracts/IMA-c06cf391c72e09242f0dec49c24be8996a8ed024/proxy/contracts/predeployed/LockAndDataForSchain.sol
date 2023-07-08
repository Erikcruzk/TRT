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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Skale Proxy Contracts/IMA-c06cf391c72e09242f0dec49c24be8996a8ed024/proxy/contracts/predeployed/LockAndDataForSchain.sol

// SPDX-License-Identifier: AGPL-3.0-only

/**
 *   LockAndDataForSchain.sol - SKALE Interchain Messaging Agent
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

interface IETHERC20 {
    function allowance(address from, address to) external returns (uint256);
    function mint(address account, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function burnFrom(address from, uint256 amount) external;
}

/**
 * @title Lock and Data For SKALE chain
 * @dev Runs on SKALE chains, holds deposited ETH, and contains mappings and
 * balances of ETH tokens received through DepositBox.
 */
contract LockAndDataForSchain is OwnableForSchain {

    address private _ethERC20Address;

    mapping(bytes32 => address) public permitted;

    mapping(bytes32 => address) public tokenManagerAddresses;

    mapping(address => uint256) public ethCosts;

    mapping(address => bool) public authorizedCaller;

    bool private _isCustomDeploymentMode = false;

    modifier allow(string memory contractName) {
        require(
            _checkPermitted(contractName,msg.sender) ||
            getOwner() == msg.sender, "Not allowed LockAndDataForSchain");
        _;
    }

    constructor() public {
        _isCustomDeploymentMode = true;
        authorizedCaller[msg.sender] = true;
    }

    /**
     * @dev Allows Owner to set a EthERC20 contract address.
     */
    function setEthERC20Address(address newEthERC20Address) external onlyOwner {
        _ethERC20Address = newEthERC20Address;
    }

    /**
     * @dev Allows Owner to set a new contract address.
     *
     * Requirements:
     *
     * - New contract address must be non-zero.
     * - New contract address must not already be added.
     * - Contract must contain code.
     */
    function setContract(string calldata contractName, address newContract) external onlyOwner {
        require(newContract != address(0), "New address is equal zero");

        bytes32 contractId = keccak256(abi.encodePacked(contractName));
        require(!_checkPermitted(contractName,newContract), "Contract is already added");

        uint256 length;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            length := extcodesize(newContract)
        }
        require(length > 0, "Given contract address does not contain code");
        permitted[contractId] = newContract;
    }

    /**
     * @dev Checks whether LockAndDataForSchain is connected to a SKALE chain.
     */
    function hasSchain( string calldata schainID ) external view returns (bool) {
        bytes32 schainHash = keccak256(abi.encodePacked(schainID));
        if ( tokenManagerAddresses[schainHash] == address(0) ) {
            return false;
        }
        return true;
    }

    /**
     * @dev Adds a SKALE chain and its TokenManager address to
     * LockAndDataForSchain.
     *
     * Requirements:
     *
     * - `msg.sender` must be authorized caller.
     * - SKALE chain must not already be added.
     * - TokenManager address must be non-zero.
     */
    function addSchain(string calldata schainID, address tokenManagerAddress) external {
        require(authorizedCaller[msg.sender] || getOwner() == msg.sender, "Not authorized caller");
        bytes32 schainHash = keccak256(abi.encodePacked(schainID));
        require(tokenManagerAddresses[schainHash] == address(0), "SKALE chain is already set");
        require(tokenManagerAddress != address(0), "Incorrect Token Manager address");
        tokenManagerAddresses[schainHash] = tokenManagerAddress;
    }

    /**
     * @dev Allows Owner to remove a SKALE chain from LockAndDataForSchain.
     *
     * Requirements:
     *
     * - SKALE chain must already be set.
     */
    function removeSchain(string calldata schainID) external onlyOwner {
        bytes32 schainHash = keccak256(abi.encodePacked(schainID));
        require(tokenManagerAddresses[schainHash] != address(0), "SKALE chain is not set");
        delete tokenManagerAddresses[schainHash];
    }

    /**
     * @dev Checks whether LockAndDataForSchain is connected to a DepositBox.
     */
    function hasDepositBox() external view returns(bool) {
        bytes32 depositBoxHash = keccak256(abi.encodePacked("Mainnet"));
        if ( tokenManagerAddresses[depositBoxHash] == address(0) ) {
            return false;
        }
        return true;
    }

    /**
     * @dev Adds a DepositBox address to LockAndDataForSchain.
     *
     * Requirements:
     *
     * - `msg.sender` must be authorized caller.
     * - DepositBox must not already be added.
     * - DepositBox address must be non-zero.
     */
    function addDepositBox(address depositBoxAddress) external {
        require(authorizedCaller[msg.sender] || getOwner() == msg.sender, "Not authorized caller");
        require(depositBoxAddress != address(0), "Incorrect Deposit Box address");
        require(
            tokenManagerAddresses[
                keccak256(abi.encodePacked("Mainnet"))
            ] != depositBoxAddress,
            "Deposit Box is already set"
        );
        tokenManagerAddresses[
            keccak256(abi.encodePacked("Mainnet"))
        ] = depositBoxAddress;
    }

    /**
     * @dev Allows Owner to remove a DepositBox from LockAndDataForSchain.
     *
     * Requirements:
     *
     * - DepositBox must already be set.
     */
    function removeDepositBox() external onlyOwner {
        require(
            tokenManagerAddresses[
                keccak256(abi.encodePacked("Mainnet"))
            ] != address(0),
            "Deposit Box is not set"
        );
        delete tokenManagerAddresses[keccak256(abi.encodePacked("Mainnet"))];
    }

    /**
     * @dev Allows Owner to add an authorized caller.
     */
    function addAuthorizedCaller(address caller) external onlyOwner {
        authorizedCaller[caller] = true;
    }

    /**
     * @dev Allows Owner to remove an authorized caller.
     */
    function removeAuthorizedCaller(address caller) external onlyOwner {
        authorizedCaller[caller] = false;
    }

    /**
     * @dev Allows TokenManager to add gas costs to LockAndDataForSchain.
     */
    function addGasCosts(address to, uint256 amount) external allow("TokenManager") {
        ethCosts[to] += amount;
    }

    /**
     * @dev Allows TokenManager to reduce gas costs from LockAndDataForSchain.
     */
    function reduceGasCosts(address to, uint256 amount) external allow("TokenManager") returns (bool) {
        if (ethCosts[to] >= amount) {
            ethCosts[to] -= amount;
            return true;
        } else if (ethCosts[address(0)] >= amount) {
            ethCosts[address(0)] -= amount;
            return true;
        }
        return false;
    }

    /**
     * @dev Allows TokenManager to remove gas costs from LockAndDataForSchain.
     */
    function removeGasCosts(address to) external allow("TokenManager") returns (uint256 balance) {
        balance = ethCosts[to];
        delete ethCosts[to];
    }

    /**
     * @dev Allows TokenManager to send (mint) ETH from LockAndDataForSchain.
     */
    function sendEth(address to, uint256 amount) external allow("TokenManager") returns (bool) {
        require(IETHERC20(getEthERC20Address()).mint(to, amount), "Mint error");
        return true;
    }

    /**
     * @dev Allows TokenManager to receive (burn) ETH to LockAndDataForSchain.
     */
    function receiveEth(address sender, uint256 amount) external allow("TokenManager") returns (bool) {
        IETHERC20(getEthERC20Address()).burnFrom(sender, amount);
        return true;
    }

    /**
     * @dev Returns EthERC20 contract address.
     */
    function getEthERC20Address() public view returns (address addressOfEthERC20) {
        if (_ethERC20Address == address(0) && (!_isCustomDeploymentMode)) {
            return SkaleFeatures(0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2).getConfigVariableAddress(
                "skaleConfig.contractSettings.IMA.ethERC20Address"
            );
        }
        addressOfEthERC20 = _ethERC20Address;
    }

    /**
     * @dev Checks whether contract name and adress are permitted.
     */
    function _checkPermitted(string memory contractName, address contractAddress) 
        private
        view
        returns
        (bool permission)
    {
        require(contractAddress != address(0), "contract address required to check permitted status");
        bytes32 contractId = keccak256(abi.encodePacked(contractName));
        bool isPermitted = (permitted[contractId] == contractAddress) ? true : false;
        if ((isPermitted) ) {
            permission = true;
        } else {
            if (!_isCustomDeploymentMode) {
                string memory fullContractPath = SkaleFeatures(
                    0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2
                ).concatenateStrings(
                    "skaleConfig.contractSettings.IMA.variables.LockAndDataForSchain.permitted.",
                    contractName
                );
                address contractAddressInStorage = SkaleFeatures(
                    0x00c033b369416c9ecd8e4a07aafa8b06b4107419e2
                ).getConfigVariableAddress(fullContractPath);
                if (contractAddressInStorage == contractAddress) {
                    permission = true;
                } else {
                    permission = false;
                }
            } else {
                permission = false;
            }
        }
    }

}
