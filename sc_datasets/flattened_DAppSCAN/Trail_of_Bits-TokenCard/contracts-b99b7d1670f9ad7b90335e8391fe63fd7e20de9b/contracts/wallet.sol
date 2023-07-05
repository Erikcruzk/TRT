// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/externals/SafeMath.sol

/**
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Smart Contract Solutions, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/externals/ERC20.sol

pragma solidity ^0.4.25;

/// @title ERC20 interface is a subset of the ERC20 specification.
interface ERC20 {
    function approve(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint);
    function transfer(address, uint) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/ownable.sol

/**
 *  Ownable - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;


/// @title Ownable has an owner address and provides basic authorization control functions.
/// This contract is modified version of the MIT OpenZepplin Ownable contract
/// This contract allows for the transferOwnership operation to be made impossible
/// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
contract Ownable {
    event TransferredOwnership(address _from, address _to);
    event LockedOwnership(address _locked);

    address private _owner;
    bool private _isTransferable;

    /// @notice Constructor sets the original owner of the contract and whether or not it is one time transferable.
    constructor(address _account_, bool _transferable_) internal {
        _owner = _account_;
        _isTransferable = _transferable_;
        // Emit the LockedOwnership event if no longer transferable.
        if (!_isTransferable) {
            emit LockedOwnership(_account_);
        }
        emit TransferredOwnership(address(0), _account_);
    }

    /// @notice Reverts if called by any account other than the owner.
    modifier onlyOwner() {
        require(_isOwner(msg.sender), "sender is not an owner");
        _;
    }

    /// @notice Allows the current owner to transfer control of the contract to a new address.
    /// @param _account address to transfer ownership to.
    /// @param _transferable indicates whether to keep the ownership transferable.
    function transferOwnership(address _account, bool _transferable) external onlyOwner {
        // Require that the ownership is transferable.
        require(_isTransferable, "ownership is not transferable");
        // Require that the new owner is not the zero address.
        require(_account != address(0), "owner cannot be set to zero address");
        // Set the transferable flag to the value _transferable passed in.
        _isTransferable = _transferable;
        // Emit the LockedOwnership event if no longer transferable.
        if (!_transferable) {
            emit LockedOwnership(_account);
        }
        // Emit the ownership transfer event.
        emit TransferredOwnership(_owner, _account);
        // Set the owner to the provided address.
        _owner = _account;
    }

    /// @notice check if the ownership is transferable.
    /// @return true if the ownership is transferable.
    function isTransferable() external view returns (bool) {
        return _isTransferable;
    }

    /// @notice Allows the current owner to relinquish control of the contract.
    /// @dev Renouncing to ownership will leave the contract without an owner and unusable.
    /// @dev It will not be possible to call the functions with the `onlyOwner` modifier anymore.
    function renounceOwnership() external onlyOwner {
        // Require that the ownership is transferable.
        require(_isTransferable, "ownership is not transferable");
        // note that this could be terminal
        _owner = address(0);

        emit TransferredOwnership(_owner, address(0));
    }

    /// @notice Find out owner address
    /// @return address of the owner.
    function owner() public view returns (address) {
        return _owner;
    }

    /// @notice Check if owner address
    /// @return true if sender is the owner of the contract.
    function _isOwner(address _address) internal view returns (bool) {
        return _address == _owner;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/claimable.sol

/**
 *  Claimable - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;

/// @title Claimable, allowing contract to withdraw tokens accidentally sent to itself
contract Claimable {

    event Claimed(address _to, address _asset, uint _amount);

    /// @dev This function is used to move tokens sent accidentally to this contract method.
    /// @dev The owner can chose the new destination address
    /// @param _to is the recipient's address.
    /// @param _asset is the address of an ERC20 token or 0x0 for ether.
    /// @param _amount is the amount to be transferred in base units.
    function _claim(address _to, address _asset, uint _amount) internal {
        // address(0) is used to denote ETH
        if (_asset == address(0)) {
            _to.transfer(_amount);
        } else {
            require(ERC20(_asset).transfer(_to, _amount), "ERC20 token transfer was unsuccessful");
        }

        emit Claimed(_to, _asset, _amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/licence.sol

// SWC-Code With No Effects: L1 - L248
/**
 *  Licence - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;




/// @title ILicence interface describes methods for loading a TokenCard and updating licence amount.
interface ILicence {
    function load(address, uint) external payable;
    function updateLicenceAmount(uint) external;
}


/// @title Licence loads the TokenCard and transfers the licence amout to the TKN Holder Contract.
/// @notice the rest of the amount gets sent to the CryptoFloat
contract Licence is Claimable, Ownable {

    using SafeMath for uint256;

    /*******************/
    /*     Events     */
    /*****************/

    event Received(address _from, uint _amount);

    event UpdatedLicenceDAO(address _newDAO);
    event UpdatedCryptoFloat(address _newFloat);
    event UpdatedTokenHolder(address _newHolder);
    event UpdatedTKNContractAddress(address _newTKN);
    event UpdatedLicenceAmount(uint _newAmount);

    event TransferredToTokenHolder(address _from, address _to, address _asset, uint _amount);
    event TransferredToCryptoFloat(address _from, address _to, address _asset, uint _amount);

    event LogTokenTransfer(address _asset, address _to, uint _amount);

    /// @notice This is 100% scaled up by a factor of 10 to give us an extra 1 decimal place of precision
    uint constant public MAX_AMOUNT_SCALE = 1000;

    address private _tknContractAddress = 0xaAAf91D9b90dF800Df4F55c205fd6989c977E73a; // solium-disable-line uppercase

    address private _cryptoFloat;
    address private _tokenHolder;
    address private _licenceDAO;

    bool private _lockedCryptoFloat;
    bool private _lockedTokenHolder;
    bool private _lockedLicenceDAO;
    bool private _lockedTKNContractAddress;

    /// @notice This is the _licenceAmountScaled by a factor of 10
    /// @dev i.e. 1% is 10 _licenceAmountScaled, 0.1% is 1 _licenceAmountScaled
    uint private _licenceAmountScaled;

    /// @notice Reverts if called by any address other than the DAO contract.
    modifier onlyDAO() {
        require(msg.sender == _licenceDAO, "the sender isn't the DAO");
        _;
    }

    /// @notice Constructor initializes the card licence contract.
    /// @param _owner_ is the owner account of the wallet contract.
    /// @param _transferable_ indicates whether the contract ownership can be transferred.
    /// @param _licence_ is the initial card licence amount. this number is scaled 10 = 1%, 9 = 0.9%
    /// @param _float_ is the address of the multi-sig cryptocurrency float contract.
    /// @param _holder_ is the address of the token holder contract
    constructor(address _owner_, bool _transferable_, uint _licence_, address _float_, address _holder_, address _tknAddress_) Ownable(_owner_, _transferable_) public {
        _licenceAmountScaled = _licence_;
        _cryptoFloat = _float_;
        _tokenHolder = _holder_;
        if (_tknAddress_ != address(0)) {
            _tknContractAddress = _tknAddress_;
        }
    }

    /// @notice Ether can be deposited from any source, so this contract should be payable by anyone.
    function() external payable {
        require(msg.data.length == 0, "msg data length should be 0");
        emit Received(msg.sender, msg.value);
    }

    /// @notice this allows for people to see the scaled licence amount
    /// @return the scaled licence amount, used to calculate the split when loading.
    function licenceAmountScaled() external view returns (uint) {
        return _licenceAmountScaled;
    }

    /// @notice allows one to see the address of the CryptoFloat
    /// @return the address of the multi-sig cryptocurrency float contract.
    function cryptoFloat() external view returns (address) {
        return _cryptoFloat;
    }

    /// @notice allows one to see the address TKN holder contract
    /// @return the address of the token holder contract.
    function tokenHolder() external view returns (address) {
        return _tokenHolder;
    }

    /// @notice allows one to see the address of the DAO
    /// @return the address of the DAO contract.
    function licenceDAO() external view returns (address) {
        return _licenceDAO;
    }

    /// @notice The address of the TKN token
    /// @return the address of the TKN contract.
    function tknContractAddress() external view returns (address) {
        return _tknContractAddress;
    }

    /// @notice This locks the cryptoFloat address
    /// @dev so that it can no longer be updated
    function lockFloat() external onlyOwner {
        _lockedCryptoFloat = true;
    }

    /// @notice This locks the TokenHolder address
    /// @dev so that it can no longer be updated
    function lockHolder() external onlyOwner {
        _lockedTokenHolder = true;
    }

    /// @notice This locks the DAO address
    /// @dev so that it can no longer be updated
    function lockLicenceDAO() external onlyOwner {
        _lockedLicenceDAO = true;
    }

    /// @notice This locks the TKN address
    /// @dev so that it can no longer be updated
    function lockTKNContractAddress() external onlyOwner {
        _lockedTKNContractAddress = true;
    }

    /// @notice Updates the address of the cyptoFloat.
    /// @param _newFloat This is the new address for the CryptoFloat
    function updateFloat(address _newFloat) external onlyOwner {
        require(!floatLocked(), "float is locked");
        _cryptoFloat = _newFloat;
        emit UpdatedCryptoFloat(_newFloat);
    }

    /// @notice Updates the address of the Holder contract.
    /// @param _newHolder This is the new address for the TokenHolder
    function updateHolder(address _newHolder) external onlyOwner {
        require(!holderLocked(), "holder contract is locked");
        _tokenHolder = _newHolder;
        emit UpdatedTokenHolder(_newHolder);
    }

    /// @notice Updates the address of the DAO contract.
    /// @param _newDAO This is the new address for the Licence DAO
    function updateLicenceDAO(address _newDAO) external onlyOwner {
        require(!licenceDAOLocked(), "DAO is locked");
        _licenceDAO = _newDAO;
        emit UpdatedLicenceDAO(_newDAO);
    }

    /// @notice Updates the address of the TKN contract.
    /// @param _newTKN This is the new address for the TKN contract
    function updateTKNContractAddress(address _newTKN) external onlyOwner {
        require(!tknContractAddressLocked(), "TKN is locked");
        _tknContractAddress = _newTKN;
        emit UpdatedTKNContractAddress(_newTKN);
    }

    /// @notice Updates the TKN licence amount
    /// @param _newAmount is a number between 1 and MAX_AMOUNT_SCALE
    function updateLicenceAmount(uint _newAmount) external onlyDAO {
        require(1 <= _newAmount && _newAmount <= MAX_AMOUNT_SCALE, "licence amount out of range");
        _licenceAmountScaled = _newAmount;
        emit UpdatedLicenceAmount(_newAmount);
    }

    /// @notice Load the holder and float contracts based on the licence amount and asset amount.
    /// @param _asset is the address of an ERC20 token or 0x0 for ether.
    /// @param _amount is the amount of assets to be transferred including the licence amount.
    function load(address _asset, uint _amount) external payable {
        uint loadAmount = _amount;
        // If TKN then no licence to be paid
        if (_asset == _tknContractAddress) {
            require(ERC20(_asset).transferFrom(msg.sender, _cryptoFloat, loadAmount), "TKN transfer from external account was unsuccessful");
        } else {
            loadAmount = _amount.mul(MAX_AMOUNT_SCALE).div(_licenceAmountScaled + MAX_AMOUNT_SCALE);
            uint licenceAmount = _amount.sub(loadAmount);

            if (_asset != address(0)) {
                require(ERC20(_asset).transferFrom(msg.sender, _tokenHolder, licenceAmount), "ERC20 licenceAmount transfer from external account was unsuccessful");
                require(ERC20(_asset).transferFrom(msg.sender, _cryptoFloat, loadAmount), "ERC20 token transfer from external account was unsuccessful");
            } else {
                require(msg.value == _amount, "ETH sent is not equal to amount");
                _tokenHolder.transfer(licenceAmount);
                _cryptoFloat.transfer(loadAmount);
            }

            emit TransferredToTokenHolder(msg.sender, _tokenHolder, _asset, licenceAmount);
        }

        emit TransferredToCryptoFloat(msg.sender, _cryptoFloat, _asset, loadAmount);
    }

    //// @notice Withdraw tokens from the smart contract to the specified account.
    function claim(address _to, address _asset, uint _amount) external onlyOwner {
        _claim(_to, _asset, _amount);
    }

    /// @notice returns whether or not the CryptoFloat address is locked
    function floatLocked() public view returns (bool) {
        return _lockedCryptoFloat;
    }

    /// @notice returns whether or not the TokenHolder address is locked
    function holderLocked() public view returns (bool) {
        return _lockedTokenHolder;
    }

    /// @notice returns whether or not the Licence DAO address is locked
    function licenceDAOLocked() public view returns (bool) {
        return _lockedLicenceDAO;
    }

    /// @notice returns whether or not the TKN address is locked
    function tknContractAddressLocked() public view returns (bool) {
        return _lockedTKNContractAddress;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/controller.sol

/**
 *  Controller - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;


/// @title The IController interface provides access to the isController check.
interface IController {
    function isController(address) external view returns (bool);
}


/// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
/// @notice The Controller implements a hierarchy of concepts, Owner, Admin, and the Controllers.
/// @dev Owner can change the Admins
/// @dev Admins and can the Controllers
/// @dev Controllers are used by the application.
contract Controller is IController, Ownable, Claimable {

    event AddedController(address _sender, address _controller);
    event RemovedController(address _sender, address _controller);

    event AddedAdmin(address _sender, address _admin);
    event RemovedAdmin(address _sender, address _admin);

    mapping (address => bool) private _isAdmin;
    uint private _adminCount;

    mapping (address => bool) private _isController;
    uint private _controllerCount;

    /// @notice Constructor initializes the owner with the provided address.
    /// @param _ownerAddress_ address of the owner.
    /// @param _transferable_ indicates whether the contract ownership can be transferred.
    constructor(address _ownerAddress_, bool _transferable_) Ownable(_ownerAddress_, _transferable_) public { }

    /// @notice Checks if message sender is an admin.
    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "sender is not an admin");
        _;
    }

    /// @notice Checks if message sender is a controller.
    modifier onlyController() {
        require(isController(msg.sender), "sender is not a controller");
        _;
    }

    /// @notice Add a new admin to the list of admins.
    /// @param _account address to add to the list of admins.
    function addAdmin(address _account) external onlyOwner {
        _addAdmin(_account);
    }

    /// @notice Remove a admin from the list of admins.
    /// @param _account address to remove from the list of admins.
    function removeAdmin(address _account) external onlyOwner {
        _removeAdmin(_account);
    }

    /// @return the current number of admins.
    function adminCount() external view returns (uint) {
        return _adminCount;
    }

    /// @notice Add a new controller to the list of controllers.
    /// @param _account address to add to the list of controllers.
    function addController(address _account) external onlyAdmin {
        _addController(_account);
    }

    /// @notice Remove a controller from the list of controllers.
    /// @param _account address to remove from the list of controllers.
    function removeController(address _account) external onlyAdmin {
        _removeController(_account);
    }

    /// @notice count the Controllers
    /// @return the current number of controllers.
    function controllerCount() external view returns (uint) {
        return _controllerCount;
    }

    /// @notice is an address an Admin?
    /// @return true if the provided account is an admin.
    function isAdmin(address _account) public view returns (bool) {
        return _isAdmin[_account];
    }

    /// @notice is an address a Controller?
    /// @return true if the provided account is a controller.
    function isController(address _account) public view returns (bool) {
        return _isController[_account];
    }

    /// @notice Internal-only function that adds a new admin.
    function _addAdmin(address _account) private {
        require(!_isAdmin[_account], "provided account is already an admin");
        require(!_isController[_account], "provided account is already a controller");
        require(!_isOwner(_account), "provided account is already the owner");
        require(_account != address(0), "provided account is the zero address");
        _isAdmin[_account] = true;
        _adminCount++;
        emit AddedAdmin(msg.sender, _account);
    }

    /// @notice Internal-only function that removes an existing admin.
    function _removeAdmin(address _account) private {
        require(_isAdmin[_account], "provided account is not an admin");
        _isAdmin[_account] = false;
        _adminCount--;
        emit RemovedAdmin(msg.sender, _account);
    }

    /// @notice Internal-only function that adds a new controller.
    function _addController(address _account) private {
        require(!_isAdmin[_account], "provided account is already an admin");
        require(!_isController[_account], "provided account is already a controller");
        require(!_isOwner(_account), "provided account is already the owner");
        require(_account != address(0), "provided account is the zero address");
        _isController[_account] = true;
        _controllerCount++;
        emit AddedController(msg.sender, _account);
    }

    /// @notice Internal-only function that removes an existing controller.
    function _removeController(address _account) private {
        require(_isController[_account], "provided account is not a controller");
        _isController[_account] = false;
        _controllerCount--;
        emit RemovedController(msg.sender, _account);
    }

    //// @notice Withdraw tokens from the smart contract to the specified account.
    function claim(address _to, address _asset, uint _amount) external onlyOwner {
        _claim(_to, _asset, _amount);
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/externals/ens/ENS.sol

/**
 * BSD 2-Clause License
 *
 * Copyright (c) 2018, True Names Limited
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
pragma solidity >=0.4.24;

interface ENS {

    // Logged when the owner of a node assigns a new owner to a subnode.
    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);

    // Logged when the owner of a node transfers ownership to a new account.
    event Transfer(bytes32 indexed node, address owner);

    // Logged when the resolver for a node changes.
    event NewResolver(bytes32 indexed node, address resolver);

    // Logged when the TTL of a node changes
    event NewTTL(bytes32 indexed node, uint64 ttl);


    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
    function setResolver(bytes32 node, address resolver) external;
    function setOwner(bytes32 node, address owner) external;
    function setTTL(bytes32 node, uint64 ttl) external;
    function owner(bytes32 node) external view returns (address);
    function resolver(bytes32 node) external view returns (address);
    function ttl(bytes32 node) external view returns (uint64);

}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/externals/ens/PublicResolver.sol

/**
 * BSD 2-Clause License
 * 
 * Copyright (c) 2018, True Names Limited
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

pragma solidity ^0.4.24;

/**
 * A simple resolver anyone can use; only allows the owner of a node to set its
 * address.
 */
contract PublicResolver {

    bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
    bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
    bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
    bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
    bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
    bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
    bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
    bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;

    event AddrChanged(bytes32 indexed node, address a);
    event ContentChanged(bytes32 indexed node, bytes32 hash);
    event NameChanged(bytes32 indexed node, string name);
    event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
    event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
    event TextChanged(bytes32 indexed node, string indexedKey, string key);
    event MultihashChanged(bytes32 indexed node, bytes hash);

    struct PublicKey {
        bytes32 x;
        bytes32 y;
    }

    struct Record {
        address addr;
        bytes32 content;
        string name;
        PublicKey pubkey;
        mapping(string=>string) text;
        mapping(uint256=>bytes) abis;
        bytes multihash;
    }

    ENS ens;

    mapping (bytes32 => Record) records;

    modifier only_owner(bytes32 node) {
        require(ens.owner(node) == msg.sender);
        _;
    }

    /**
     * Constructor.
     * @param ensAddr The ENS registrar contract.
     */
    constructor(ENS ensAddr) public {
        ens = ensAddr;
    }

    /**
     * Sets the address associated with an ENS node.
     * May only be called by the owner of that node in the ENS registry.
     * @param node The node to update.
     * @param addr The address to set.
     */
    function setAddr(bytes32 node, address addr) public only_owner(node) {
        records[node].addr = addr;
        emit AddrChanged(node, addr);
    }

    /**
     * Sets the content hash associated with an ENS node.
     * May only be called by the owner of that node in the ENS registry.
     * Note that this resource type is not standardized, and will likely change
     * in future to a resource type based on multihash.
     * @param node The node to update.
     * @param hash The content hash to set
     */
    function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
        records[node].content = hash;
        emit ContentChanged(node, hash);
    }

    /**
     * Sets the multihash associated with an ENS node.
     * May only be called by the owner of that node in the ENS registry.
     * @param node The node to update.
     * @param hash The multihash to set
     */
    function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
        records[node].multihash = hash;
        emit MultihashChanged(node, hash);
    }
    
    /**
     * Sets the name associated with an ENS node, for reverse records.
     * May only be called by the owner of that node in the ENS registry.
     * @param node The node to update.
     * @param name The name to set.
     */
    function setName(bytes32 node, string name) public only_owner(node) {
        records[node].name = name;
        emit NameChanged(node, name);
    }

    /**
     * Sets the ABI associated with an ENS node.
     * Nodes may have one ABI of each content type. To remove an ABI, set it to
     * the empty string.
     * @param node The node to update.
     * @param contentType The content type of the ABI
     * @param data The ABI data.
     */
    function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
        // Content types must be powers of 2
        require(((contentType - 1) & contentType) == 0);
        
        records[node].abis[contentType] = data;
        emit ABIChanged(node, contentType);
    }
    
    /**
     * Sets the SECP256k1 public key associated with an ENS node.
     * @param node The ENS node to query
     * @param x the X coordinate of the curve point for the public key.
     * @param y the Y coordinate of the curve point for the public key.
     */
    function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
        records[node].pubkey = PublicKey(x, y);
        emit PubkeyChanged(node, x, y);
    }

    /**
     * Sets the text data associated with an ENS node and key.
     * May only be called by the owner of that node in the ENS registry.
     * @param node The node to update.
     * @param key The key to set.
     * @param value The text data value to set.
     */
    function setText(bytes32 node, string key, string value) public only_owner(node) {
        records[node].text[key] = value;
        emit TextChanged(node, key, key);
    }

    /**
     * Returns the text data associated with an ENS node and key.
     * @param node The ENS node to query.
     * @param key The text data key to query.
     * @return The associated text data.
     */
    function text(bytes32 node, string key) public view returns (string) {
        return records[node].text[key];
    }

    /**
     * Returns the SECP256k1 public key associated with an ENS node.
     * Defined in EIP 619.
     * @param node The ENS node to query
     * @return x, y the X and Y coordinates of the curve point for the public key.
     */
    function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
        return (records[node].pubkey.x, records[node].pubkey.y);
    }

    /**
     * Returns the ABI associated with an ENS node.
     * Defined in EIP205.
     * @param node The ENS node to query
     * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
     * @return contentType The content type of the return value
     * @return data The ABI data
     */
    function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
        Record storage record = records[node];
        for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
            if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
                data = record.abis[contentType];
                return;
            }
        }
        contentType = 0;
    }

    /**
     * Returns the name associated with an ENS node, for reverse records.
     * Defined in EIP181.
     * @param node The ENS node to query.
     * @return The associated name.
     */
    function name(bytes32 node) public view returns (string) {
        return records[node].name;
    }

    /**
     * Returns the content hash associated with an ENS node.
     * Note that this resource type is not standardized, and will likely change
     * in future to a resource type based on multihash.
     * @param node The ENS node to query.
     * @return The associated content hash.
     */
    function content(bytes32 node) public view returns (bytes32) {
        return records[node].content;
    }

    /**
     * Returns the multihash associated with an ENS node.
     * @param node The ENS node to query.
     * @return The associated multihash.
     */
    function multihash(bytes32 node) public view returns (bytes) {
        return records[node].multihash;
    }

    /**
     * Returns the address associated with an ENS node.
     * @param node The ENS node to query.
     * @return The associated address.
     */
    function addr(bytes32 node) public view returns (address) {
        return records[node].addr;
    }

    /**
     * Returns true if the resolver implements the interface specified by the provided hash.
     * @param interfaceID The ID of the interface to check for.
     * @return True if the contract implements the requested interface.
     */
    function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
        return interfaceID == ADDR_INTERFACE_ID ||
        interfaceID == CONTENT_INTERFACE_ID ||
        interfaceID == NAME_INTERFACE_ID ||
        interfaceID == ABI_INTERFACE_ID ||
        interfaceID == PUBKEY_INTERFACE_ID ||
        interfaceID == TEXT_INTERFACE_ID ||
        interfaceID == MULTIHASH_INTERFACE_ID ||
        interfaceID == INTERFACE_META_ID;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/ensResolvable.sol

/**
 *  ENSResolvable - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;


///@title ENSResolvable - Ethereum Name Service Resolver
///@notice contract should be used to get an address for an ENS nodeHash
contract ENSResolvable {
    /// @notice _ens is an instance of ENS
    ENS private _ens;

    /// @notice _ensRegistry points to the ENS registry smart contract.
    address private _ensRegistry;

    /// @param _ensReg_ is the ENS registry used
    constructor(address _ensReg_) internal {
        _ensRegistry = _ensReg_;
        _ens = ENS(_ensRegistry);
    }

    /// @notice this is used to that one can observe which ENS registry is being used
    function ensRegistry() external view returns (address) {
        return _ensRegistry;
    }

    /// @notice helper function used to get the address of a node Hash
    /// @param _nodeHash of the ENS entry that needs resolving
    /// @return the address of the said nodeHash
    function _ensResolve(bytes32 _nodeHash) internal view returns (address) {
        return PublicResolver(_ens.resolver(_nodeHash)).addr(_nodeHash);
    }

}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/controllable.sol

/**
 *  Controllable - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;


/// @title Controllable implements access control functionality of the Controller found via ENS.
contract Controllable is ENSResolvable {
    /// @dev Is the registered ENS node identifying the controller contract.
    bytes32 private _controllerNode;

    /// @notice Constructor initializes the controller contract object.
    /// @param _controllerNameHash_ is the ENS name hash of the Controller.
    constructor(bytes32 _controllerNameHash_) internal {
        _controllerNode = _controllerNameHash_;
    }

    /// @notice Checks if message sender is the controller.
    modifier onlyController() {
        require(_isController(msg.sender), "sender is not a controller");
        _;
    }

    /// @return the controller name hash registered in ENS.
    function controllerNode() external view returns (bytes32) {
        return _controllerNode;
    }

    /// @return true if the provided account is the controller.
    function _isController(address _account) internal view returns (bool) {
        return IController(_ensResolve(_controllerNode)).isController(_account);
    }

}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/externals/strings.sol

/*
 * Copyright 2016 Nick Johnson
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * @title String & slice utility library for Solidity contracts.
 * @author Nick Johnson <arachnid@notdot.net>
 *
 * @dev Functionality in this library is largely implemented using an
 *      abstraction called a 'slice'. A slice represents a part of a string -
 *      anything from the entire string to a single character, or even no
 *      characters at all (a 0-length slice). Since a slice only has to specify
 *      an offset and a length, copying and manipulating slices is a lot less
 *      expensive than copying and manipulating the strings they reference.
 *
 *      To further reduce gas costs, most functions on slice that need to return
 *      a slice modify the original one instead of allocating a new one; for
 *      instance, `s.split(".")` will return the text up to the first '.',
 *      modifying s to only contain the remainder of the string after the '.'.
 *      In situations where you do not want to modify the original slice, you
 *      can make a copy first with `.copy()`, for example:
 *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
 *      Solidity has no memory management, it will result in allocating many
 *      short-lived slices that are later discarded.
 *
 *      Functions that return two slices come in two versions: a non-allocating
 *      version that takes the second slice as an argument, modifying it in
 *      place, and an allocating version that allocates and returns the second
 *      slice; see `nextRune` for example.
 *
 *      Functions that have to copy string data will return strings rather than
 *      slices; these can be cast back to slices for further processing if
 *      required.
 *
 *      For convenience, some functions are provided with non-modifying
 *      variants that create a new slice and return both; for instance,
 *      `s.splitNew('.')` leaves s unmodified, and returns two values
 *      corresponding to the left and right parts of the string.
 */

pragma solidity ^0.4.14;

library strings {
    struct slice {
        uint _len;
        uint _ptr;
    }

    function memcpy(uint dest, uint src, uint len) private pure {
        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    /*
     * @dev Returns a slice containing the entire string.
     * @param self The string to make a slice from.
     * @return A newly allocated slice containing the entire string.
     */
    function toSlice(string memory self) internal pure returns (slice memory) {
        uint ptr;
        assembly {
            ptr := add(self, 0x20)
        }
        return slice(bytes(self).length, ptr);
    }

    /*
     * @dev Returns the length of a null-terminated bytes32 string.
     * @param self The value to find the length of.
     * @return The length of the string, from 0 to 32.
     */
    function len(bytes32 self) internal pure returns (uint) {
        uint ret;
        if (self == 0)
            return 0;
        if (self & 0xffffffffffffffffffffffffffffffff == 0) {
            ret += 16;
            self = bytes32(uint(self) / 0x100000000000000000000000000000000);
        }
        if (self & 0xffffffffffffffff == 0) {
            ret += 8;
            self = bytes32(uint(self) / 0x10000000000000000);
        }
        if (self & 0xffffffff == 0) {
            ret += 4;
            self = bytes32(uint(self) / 0x100000000);
        }
        if (self & 0xffff == 0) {
            ret += 2;
            self = bytes32(uint(self) / 0x10000);
        }
        if (self & 0xff == 0) {
            ret += 1;
        }
        return 32 - ret;
    }

    /*
     * @dev Returns a slice containing the entire bytes32, interpreted as a
     *      null-terminated utf-8 string.
     * @param self The bytes32 value to convert to a slice.
     * @return A new slice containing the value of the input argument up to the
     *         first null.
     */
    function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
        // Allocate space for `self` in memory, copy it there, and point ret at it
        assembly {
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            mstore(ptr, self)
            mstore(add(ret, 0x20), ptr)
        }
        ret._len = len(self);
    }

    /*
     * @dev Returns a new slice containing the same data as the current slice.
     * @param self The slice to copy.
     * @return A new slice containing the same data as `self`.
     */
    function copy(slice memory self) internal pure returns (slice memory) {
        return slice(self._len, self._ptr);
    }

    /*
     * @dev Copies a slice to a new string.
     * @param self The slice to copy.
     * @return A newly allocated string containing the slice's text.
     */
    function toString(slice memory self) internal pure returns (string memory) {
        string memory ret = new string(self._len);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        memcpy(retptr, self._ptr, self._len);
        return ret;
    }

    /*
     * @dev Returns the length in runes of the slice. Note that this operation
     *      takes time proportional to the length of the slice; avoid using it
     *      in loops, and call `slice.empty()` if you only need to know whether
     *      the slice is empty or not.
     * @param self The slice to operate on.
     * @return The length of the slice in runes.
     */
    function len(slice memory self) internal pure returns (uint l) {
        // Starting at ptr-31 means the LSB will be the byte we care about
        uint ptr = self._ptr - 31;
        uint end = ptr + self._len;
        for (l = 0; ptr < end; l++) {
            uint8 b;
            assembly { b := and(mload(ptr), 0xFF) }
            if (b < 0x80) {
                ptr += 1;
            } else if(b < 0xE0) {
                ptr += 2;
            } else if(b < 0xF0) {
                ptr += 3;
            } else if(b < 0xF8) {
                ptr += 4;
            } else if(b < 0xFC) {
                ptr += 5;
            } else {
                ptr += 6;
            }
        }
    }

    /*
     * @dev Returns true if the slice is empty (has a length of 0).
     * @param self The slice to operate on.
     * @return True if the slice is empty, False otherwise.
     */
    function empty(slice memory self) internal pure returns (bool) {
        return self._len == 0;
    }

    /*
     * @dev Returns a positive number if `other` comes lexicographically after
     *      `self`, a negative number if it comes before, or zero if the
     *      contents of the two slices are equal. Comparison is done per-rune,
     *      on unicode codepoints.
     * @param self The first slice to compare.
     * @param other The second slice to compare.
     * @return The result of the comparison.
     */
    function compare(slice memory self, slice memory other) internal pure returns (int) {
        uint shortest = self._len;
        if (other._len < self._len)
            shortest = other._len;

        uint selfptr = self._ptr;
        uint otherptr = other._ptr;
        for (uint idx = 0; idx < shortest; idx += 32) {
            uint a;
            uint b;
            assembly {
                a := mload(selfptr)
                b := mload(otherptr)
            }
            if (a != b) {
                // Mask out irrelevant bytes and check again
                uint256 mask = uint256(-1); // 0xffff...
                if(shortest < 32) {
                  mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
                }
                uint256 diff = (a & mask) - (b & mask);
                if (diff != 0)
                    return int(diff);
            }
            selfptr += 32;
            otherptr += 32;
        }
        return int(self._len) - int(other._len);
    }

    /*
     * @dev Returns true if the two slices contain the same text.
     * @param self The first slice to compare.
     * @param self The second slice to compare.
     * @return True if the slices are equal, false otherwise.
     */
    function equals(slice memory self, slice memory other) internal pure returns (bool) {
        return compare(self, other) == 0;
    }

    /*
     * @dev Extracts the first rune in the slice into `rune`, advancing the
     *      slice to point to the next rune and returning `self`.
     * @param self The slice to operate on.
     * @param rune The slice that will contain the first rune.
     * @return `rune`.
     */
    function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
        rune._ptr = self._ptr;

        if (self._len == 0) {
            rune._len = 0;
            return rune;
        }

        uint l;
        uint b;
        // Load the first byte of the rune into the LSBs of b
        assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
        if (b < 0x80) {
            l = 1;
        } else if(b < 0xE0) {
            l = 2;
        } else if(b < 0xF0) {
            l = 3;
        } else {
            l = 4;
        }

        // Check for truncated codepoints
        if (l > self._len) {
            rune._len = self._len;
            self._ptr += self._len;
            self._len = 0;
            return rune;
        }

        self._ptr += l;
        self._len -= l;
        rune._len = l;
        return rune;
    }

    /*
     * @dev Returns the first rune in the slice, advancing the slice to point
     *      to the next rune.
     * @param self The slice to operate on.
     * @return A slice containing only the first rune from `self`.
     */
    function nextRune(slice memory self) internal pure returns (slice memory ret) {
        nextRune(self, ret);
    }

    /*
     * @dev Returns the number of the first codepoint in the slice.
     * @param self The slice to operate on.
     * @return The number of the first codepoint in the slice.
     */
    function ord(slice memory self) internal pure returns (uint ret) {
        if (self._len == 0) {
            return 0;
        }

        uint word;
        uint length;
        uint divisor = 2 ** 248;

        // Load the rune into the MSBs of b
        assembly { word:= mload(mload(add(self, 32))) }
        uint b = word / divisor;
        if (b < 0x80) {
            ret = b;
            length = 1;
        } else if(b < 0xE0) {
            ret = b & 0x1F;
            length = 2;
        } else if(b < 0xF0) {
            ret = b & 0x0F;
            length = 3;
        } else {
            ret = b & 0x07;
            length = 4;
        }

        // Check for truncated codepoints
        if (length > self._len) {
            return 0;
        }

        for (uint i = 1; i < length; i++) {
            divisor = divisor / 256;
            b = (word / divisor) & 0xFF;
            if (b & 0xC0 != 0x80) {
                // Invalid UTF-8 sequence
                return 0;
            }
            ret = (ret * 64) | (b & 0x3F);
        }

        return ret;
    }

    /*
     * @dev Returns the keccak-256 hash of the slice.
     * @param self The slice to hash.
     * @return The hash of the slice.
     */
    function keccak(slice memory self) internal pure returns (bytes32 ret) {
        assembly {
            ret := keccak256(mload(add(self, 32)), mload(self))
        }
    }

    /*
     * @dev Returns true if `self` starts with `needle`.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return True if the slice starts with the provided text, false otherwise.
     */
    function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
        if (self._len < needle._len) {
            return false;
        }

        if (self._ptr == needle._ptr) {
            return true;
        }

        bool equal;
        assembly {
            let length := mload(needle)
            let selfptr := mload(add(self, 0x20))
            let needleptr := mload(add(needle, 0x20))
            equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
        }
        return equal;
    }

    /*
     * @dev If `self` starts with `needle`, `needle` is removed from the
     *      beginning of `self`. Otherwise, `self` is unmodified.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return `self`
     */
    function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
        if (self._len < needle._len) {
            return self;
        }

        bool equal = true;
        if (self._ptr != needle._ptr) {
            assembly {
                let length := mload(needle)
                let selfptr := mload(add(self, 0x20))
                let needleptr := mload(add(needle, 0x20))
                equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
            }
        }

        if (equal) {
            self._len -= needle._len;
            self._ptr += needle._len;
        }

        return self;
    }

    /*
     * @dev Returns true if the slice ends with `needle`.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return True if the slice starts with the provided text, false otherwise.
     */
    function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
        if (self._len < needle._len) {
            return false;
        }

        uint selfptr = self._ptr + self._len - needle._len;

        if (selfptr == needle._ptr) {
            return true;
        }

        bool equal;
        assembly {
            let length := mload(needle)
            let needleptr := mload(add(needle, 0x20))
            equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
        }

        return equal;
    }

    /*
     * @dev If `self` ends with `needle`, `needle` is removed from the
     *      end of `self`. Otherwise, `self` is unmodified.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return `self`
     */
    function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
        if (self._len < needle._len) {
            return self;
        }

        uint selfptr = self._ptr + self._len - needle._len;
        bool equal = true;
        if (selfptr != needle._ptr) {
            assembly {
                let length := mload(needle)
                let needleptr := mload(add(needle, 0x20))
                equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
            }
        }

        if (equal) {
            self._len -= needle._len;
        }

        return self;
    }

    // Returns the memory address of the first byte of the first occurrence of
    // `needle` in `self`, or the first byte after `self` if not found.
    function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
        uint ptr = selfptr;
        uint idx;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly { needledata := and(mload(needleptr), mask) }

                uint end = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly { ptrdata := and(mload(ptr), mask) }

                while (ptrdata != needledata) {
                    if (ptr >= end)
                        return selfptr + selflen;
                    ptr++;
                    assembly { ptrdata := and(mload(ptr), mask) }
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := keccak256(needleptr, needlelen) }

                for (idx = 0; idx <= selflen - needlelen; idx++) {
                    bytes32 testHash;
                    assembly { testHash := keccak256(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr;
                    ptr += 1;
                }
            }
        }
        return selfptr + selflen;
    }

    // Returns the memory address of the first byte after the last occurrence of
    // `needle` in `self`, or the address of `self` if not found.
    function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
        uint ptr;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly { needledata := and(mload(needleptr), mask) }

                ptr = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly { ptrdata := and(mload(ptr), mask) }

                while (ptrdata != needledata) {
                    if (ptr <= selfptr)
                        return selfptr;
                    ptr--;
                    assembly { ptrdata := and(mload(ptr), mask) }
                }
                return ptr + needlelen;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := keccak256(needleptr, needlelen) }
                ptr = selfptr + (selflen - needlelen);
                while (ptr >= selfptr) {
                    bytes32 testHash;
                    assembly { testHash := keccak256(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr + needlelen;
                    ptr -= 1;
                }
            }
        }
        return selfptr;
    }

    /*
     * @dev Modifies `self` to contain everything from the first occurrence of
     *      `needle` to the end of the slice. `self` is set to the empty slice
     *      if `needle` is not found.
     * @param self The slice to search and modify.
     * @param needle The text to search for.
     * @return `self`.
     */
    function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
        self._len -= ptr - self._ptr;
        self._ptr = ptr;
        return self;
    }

    /*
     * @dev Modifies `self` to contain the part of the string from the start of
     *      `self` to the end of the first occurrence of `needle`. If `needle`
     *      is not found, `self` is set to the empty slice.
     * @param self The slice to search and modify.
     * @param needle The text to search for.
     * @return `self`.
     */
    function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
        uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
        self._len = ptr - self._ptr;
        return self;
    }

    /*
     * @dev Splits the slice, setting `self` to everything after the first
     *      occurrence of `needle`, and `token` to everything before it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and `token` is set to the entirety of `self`.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @param token An output parameter to which the first token is written.
     * @return `token`.
     */
    function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = self._ptr;
        token._len = ptr - self._ptr;
        if (ptr == self._ptr + self._len) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
            self._ptr = ptr + needle._len;
        }
        return token;
    }

    /*
     * @dev Splits the slice, setting `self` to everything after the first
     *      occurrence of `needle`, and returning everything before it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and the entirety of `self` is returned.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @return The part of `self` up to the first occurrence of `delim`.
     */
    function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
        split(self, needle, token);
    }

    /*
     * @dev Splits the slice, setting `self` to everything before the last
     *      occurrence of `needle`, and `token` to everything after it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and `token` is set to the entirety of `self`.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @param token An output parameter to which the first token is written.
     * @return `token`.
     */
    function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
        uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = ptr;
        token._len = self._len - (ptr - self._ptr);
        if (ptr == self._ptr) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
        }
        return token;
    }

    /*
     * @dev Splits the slice, setting `self` to everything before the last
     *      occurrence of `needle`, and returning everything after it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and the entirety of `self` is returned.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @return The part of `self` after the last occurrence of `delim`.
     */
    function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
        rsplit(self, needle, token);
    }

    /*
     * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
     * @param self The slice to search.
     * @param needle The text to search for in `self`.
     * @return The number of occurrences of `needle` found in `self`.
     */
    function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
        while (ptr <= self._ptr + self._len) {
            cnt++;
            ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
        }
    }

    /*
     * @dev Returns True if `self` contains `needle`.
     * @param self The slice to search.
     * @param needle The text to search for in `self`.
     * @return True if `needle` is found in `self`, false otherwise.
     */
    function contains(slice memory self, slice memory needle) internal pure returns (bool) {
        return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
    }

    /*
     * @dev Returns a newly allocated string containing the concatenation of
     *      `self` and `other`.
     * @param self The first slice to concatenate.
     * @param other The second slice to concatenate.
     * @return The concatenation of the two strings.
     */
    function concat(slice memory self, slice memory other) internal pure returns (string memory) {
        string memory ret = new string(self._len + other._len);
        uint retptr;
        assembly { retptr := add(ret, 32) }
        memcpy(retptr, self._ptr, self._len);
        memcpy(retptr + self._len, other._ptr, other._len);
        return ret;
    }

    /*
     * @dev Joins an array of slices, using `self` as a delimiter, returning a
     *      newly allocated string.
     * @param self The delimiter to use.
     * @param parts A list of slices to join.
     * @return A newly allocated string containing all the slices in `parts`,
     *         joined with `self`.
     */
    function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
        if (parts.length == 0)
            return "";

        uint length = self._len * (parts.length - 1);
        for(uint i = 0; i < parts.length; i++)
            length += parts[i]._len;

        string memory ret = new string(length);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        for(i = 0; i < parts.length; i++) {
            memcpy(retptr, parts[i]._ptr, parts[i]._len);
            retptr += parts[i]._len;
            if (i < parts.length - 1) {
                memcpy(retptr, self._ptr, self._len);
                retptr += self._len;
            }
        }

        return ret;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/tokenWhitelist.sol

/**
 *  TokenWhitelist - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;





/// @title The ITokenWhitelist interface provides access to a whitelist of tokens.
interface ITokenWhitelist {
    function getTokenInfo(address) external view returns (string, uint256, uint256, bool, bool, bool, uint256);
    function getStablecoinInfo() external view returns (string, uint256, uint256, bool, bool, bool, uint256);
    function tokenAddressArray() external view returns (address[]);
    function updateTokenRate(address, uint, uint) external;
    function stablecoin() external view returns (address);
}


/// @title TokenWhitelist stores a list of tokens used by the Consumer Contract Wallet, the Oracle, the TKN Holder and the TKN Licence Contract
contract TokenWhitelist is ENSResolvable, Controllable, Ownable, Claimable {
    using strings for *;
    using SafeMath for uint256;

    event UpdatedTokenRate(address _sender, address _token, uint _rate);

    event AddedToken(address _sender, address _token, string _symbol, uint _magnitude, bool _loadable, bool _burnable);
    event RemovedToken(address _sender, address _token);

    struct Token {
        string symbol;    // Token symbol
        uint magnitude;   // 10^decimals
        uint rate;        // Token exchange rate in wei
        bool available;   // Flags if the token is available or not
        bool loadable;    // Flags if token is loadable to the TokenCard
        bool burnable;    // Flags if token is burnable in the TKN Holder contract
        uint lastUpdate;  // Time of the last rate update
    }

    mapping(address => Token) private _tokenInfoMap;
    address[] private _tokenAddressArray;

    modifier onlyControllerOrOracle() {
        address oracleAddress = _ensResolve(_oracleNode);
        require (_isController(msg.sender) || msg.sender == oracleAddress, "either oracle or controller");
        _;
    }

    /// @notice Address of the stablecoin.
    address private _stablecoin;

    /// @notice is registered ENS node hash identifying the oracle contract.
    bytes32 private _oracleNode;

    /// @notice Constructor initializes ENSResolvable, Controllable, and Ownable
    /// @param _oracleNameHash_ is the ENS name hash of the Oracle.
    /// @param _stabelcoinAddress_ is the address of the stablecoint used by the wallet
    constructor(address _ens_, bytes32 _oracleNameHash_, bytes32 _controllerNameHash_, address _owner_, bool _transferable_, address _stabelcoinAddress_) ENSResolvable(_ens_) Controllable(_controllerNameHash_) Ownable(_owner_, _transferable_) public {
        _oracleNode = _oracleNameHash_;
        _stablecoin = _stabelcoinAddress_;
    }

    /// @notice Add ERC20 tokens to the list of whitelisted tokens.
    /// @param _tokens ERC20 token contract addresses.
    /// @param _symbols ERC20 token names.
    /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.
    /// @param _loadable is a bool that states whether or not a token is loadable to the TokenCard.
    /// @param _burnable is a bool that states whether or not a token is burnable in the TKN Holder Contract.
    /// @param _lastUpdate is a unit representing an ISO datetime e.g. 20180913153211
    function addTokens(address[] _tokens, bytes32[] _symbols, uint[] _magnitude, bool[] _loadable, bool[] _burnable, uint _lastUpdate) external onlyController {
        // Require that all parameters have the same length.
        require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length && _tokens.length == _loadable.length && _tokens.length == _loadable.length, "parameter lengths do not match");
        // Add each token to the list of supported tokens.
        for (uint i = 0; i < _tokens.length; i++) {
            // Require that the token isn't already available.
            require(!_tokenInfoMap[_tokens[i]].available, "token already available");
            // Store the intermediate values.
            string memory symbol = _symbols[i].toSliceB32().toString();
            // Add the token to the token list.
            _tokenInfoMap[_tokens[i]] = Token({
                symbol : symbol,
                magnitude : _magnitude[i],
                rate : 0,
                available : true,
                loadable : _loadable[i],
                burnable: _burnable[i],
                lastUpdate : _lastUpdate
                });
            // Add the token address to the address list.
            _tokenAddressArray.push(_tokens[i]);
            // Emit token addition event.
            emit AddedToken(msg.sender, _tokens[i], symbol, _magnitude[i], _loadable[i], _burnable[i]);
        }
    }

    /// @notice Remove ERC20 tokens from the whitelist of tokens.
    /// @param _tokens ERC20 token contract addresses.
    function removeTokens(address[] _tokens) external onlyController {
        // Delete each token object from the list of supported tokens based on the addresses provided.
        for (uint i = 0; i < _tokens.length; i++) {
            //token must be available, reverts on duplicates as well
            require(_tokenInfoMap[_tokens[i]].available, "token is not available");
            // Store the token address.
            address token = _tokens[i];
            // Delete the token object.
            delete _tokenInfoMap[token];
            // Remove the token address from the address list.
            for (uint j = 0; j < _tokenAddressArray.length.sub(1); j++) {
                if (_tokenAddressArray[j] == token) {
                    _tokenAddressArray[j] = _tokenAddressArray[_tokenAddressArray.length.sub(1)];
                    break;
                }
            }
            _tokenAddressArray.length--;
            // Emit token removal event.
            emit RemovedToken(msg.sender, token);
        }
    }

    /// @notice Update ERC20 token exchange rate.
    /// @param _token ERC20 token contract address.
    /// @param _rate ERC20 token exchange rate in wei.
    /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
    function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyControllerOrOracle {
        // Require that the token exists.
        require(_tokenInfoMap[_token].available, "token is not available");
        // Update the token's rate.
        _tokenInfoMap[_token].rate = _rate;
        // Update the token's last update timestamp.
        _tokenInfoMap[_token].lastUpdate = _updateDate;
        // Emit the rate update event.
        emit UpdatedTokenRate(msg.sender, _token, _rate);
    }

    //// @notice Withdraw tokens from the smart contract to the specified account.
    function claim(address _to, address _asset, uint _amount) external onlyOwner {
        _claim(_to, _asset, _amount);
    }

    /// @notice This returns all of the fields for a given token
    /// @param _a is the address of a given token
    /// @return string of the token's symbol
    /// @return uint of the token's magnitude
    /// @return uint of the token's exchange rate to ETH
    /// @return bool whether the token is available
    /// @return bool whether the token is loadable to the TokenCard
    /// @return bool whether the token is burnable to the TKN Holder Contract
    /// @return uint of the lastUpdated time of the token's exchange rate
    function getTokenInfo(address _a) external view returns (string, uint256, uint256, bool, bool, bool, uint256) {
        Token storage tokenInfo = _tokenInfoMap[_a];
        return (tokenInfo.symbol, tokenInfo.magnitude, tokenInfo.rate, tokenInfo.available, tokenInfo.loadable, tokenInfo.burnable, tokenInfo.lastUpdate);
    }

    /// @notice This returns all of the fields for our StableCoin
    /// @return string of the token's symbol
    /// @return uint of the token's magnitude
    /// @return uint of the token's exchange rate to ETH
    /// @return bool whether the token is available
    /// @return bool whether the token is loadable to the TokenCard
    /// @return bool whether the token is burnable to the TKN Holder Contract
    /// @return uint of the lastUpdated time of the token's exchange rate
    function getStablecoinInfo() external view returns (string, uint256, uint256, bool, bool, bool, uint256) {
        Token storage stablecoinInfo = _tokenInfoMap[_stablecoin];
        return (stablecoinInfo.symbol, stablecoinInfo.magnitude, stablecoinInfo.rate, stablecoinInfo.available, stablecoinInfo.loadable, stablecoinInfo.burnable, stablecoinInfo.lastUpdate);
    }

    /// @notice This returns an array of our whitelisted address
    /// @return address[] of our whitelisted tokens
    function tokenAddressArray() external view returns (address[]) {
        return _tokenAddressArray;
    }

    /// @notice This returns the address of our stablecoin of choice
    /// @return the address of the stablecoin contract.
    function stablecoin() external view returns (address) {
        return _stablecoin;
    }

    /// @notice this returns the node hash of our Oracle
    /// @return the oracle node registered in ENS.
    function oracleNode() external view returns (bytes32) {
        return _oracleNode;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/internals/tokenWhitelistable.sol

/**
 *  TokenWhitelistable - The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;


/// @title TokenWhitelistable implements access to the TokenWhitelist located behind ENS.
contract TokenWhitelistable is ENSResolvable {

    /// @notice Is the registered ENS node identifying the tokenWhitelist contract.
    bytes32 private _tokenWhitelistNode;

    /// @notice Constructor initializes the TokenWhitelistable object.
    /// @param _tokenWhitelistNameHash_ is the ENS name hash of the TokenWhitelist.
    constructor(bytes32 _tokenWhitelistNameHash_) internal {
        _tokenWhitelistNode = _tokenWhitelistNameHash_;
    }

    /// @notice This shows what TokenWhitelist is being used
    /// @return the TokenWhitelist's name hash registered in ENS.
    function tokenWhitelistNode() external view returns (bytes32) {
        return _tokenWhitelistNode;
    }

    /// @notice This returns all of the fields for a given token
    /// @param _a is the address of a given token
    /// @return string of the token's symbol
    /// @return uint of the token's magnitude
    /// @return uint of the token's exchange rate to ETH
    /// @return bool whether the token is available
    /// @return bool whether the token is loadable to the TokenCard
    /// @return bool whether the token is burnable to the TKN Holder Contract
    /// @return uint of the lastUpdated time of the token's exchange rate
    function _getTokenInfo(address _a) internal view returns (string, uint256, uint256, bool, bool, bool, uint256) {
        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getTokenInfo(_a);
    }

    /// @notice This returns all of the fields for our stablecoin token
    /// @return string of the token's symbol
    /// @return uint of the token's magnitude
    /// @return uint of the token's exchange rate to ETH
    /// @return bool whether the token is available
    /// @return bool whether the token is loadable to the TokenCard
    /// @return bool whether the token is burnable to the TKN Holder Contract
    /// @return uint of the lastUpdated time of the token's exchange rate
    function _getStablecoinInfo() internal view returns (string, uint256, uint256, bool, bool, bool, uint256) {
        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getStablecoinInfo();
    }

    /// @notice This returns an array of our whitelisted address
    /// @return address[] of our whitelisted tokens
    function _tokenAddressArray() internal view returns (address[]) {
        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).tokenAddressArray();
    }

    /// @notice Update ERC20 token exchange rate.
    /// @param _token ERC20 token contract address.
    /// @param _rate ERC20 token exchange rate in wei.
    /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
    function _updateTokenRate(address _token, uint _rate, uint _updateDate) internal {
        ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).updateTokenRate(_token, _rate, _updateDate);
    }

    /// @notice Checks whether a token is available
    /// @return bool available or not
    function _isTokenAvailable(address _a) internal view returns (bool) {
        ( , , , bool available, , , ) = _getTokenInfo(_a);
        return available;
    }

    /// @notice Checks whether a token is burnable
    /// @return bool burnable or not
    function _isTokenBurnable(address _a) internal view returns (bool) {
        ( , , , , , bool burnable, ) = _getTokenInfo(_a);
        return burnable;
    }

    /// @notice Checks whether a token is loadable
    /// @return bool loadable or not
    function _isTokenLoadable(address _a) internal view returns (bool) {
        ( , , , , bool loadable, , ) = _getTokenInfo(_a);
        return loadable;
    }

    /// @notice This gets the address of the stablecoin
    /// @return the address of the stablecoin contract.
    function _stablecoin() internal view returns (address) {
        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).stablecoin();
    }

}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/externals/ERC165.sol

pragma solidity ^0.4.25;

/// @title ERC165 interface specifies a standard way of querying if a contract implements an interface.
interface ERC165 {
    function supportsInterface(bytes4) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-TokenCard/contracts-b99b7d1670f9ad7b90335e8391fe63fd7e20de9b/contracts/wallet.sol

// SWC-Code With No Effects: L1 - L792
/**
 *  The Consumer Contract Wallet
 *  Copyright (C) 2019 The Contract Wallet Company Limited
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

pragma solidity ^0.4.25;








/// @title ControllableOwnable combines Controllable and Ownable
/// @dev providing an additional modifier to check if Owner or Controller
contract ControllableOwnable is Controllable, Ownable {
    /// @dev Check if the sender is the Owner or one of the Controllers
    modifier onlyOwnerOrController() {
        require (_isOwner(msg.sender) || _isController(msg.sender), "either owner or controller");
        _;
    }
}


/// @title AddressWhitelist provides payee-whitelist functionality.
/// @dev This contract will allow the user to maintain a whitelist of addresses
/// @dev These addresses will live outside of the various spend limits
contract AddressWhitelist is ControllableOwnable {
    using SafeMath for uint256;

    event AddedToWhitelist(address _sender, address[] _addresses);
    event SubmittedWhitelistAddition(address[] _addresses, bytes32 _hash);
    event CancelledWhitelistAddition(address _sender, bytes32 _hash);

    event RemovedFromWhitelist(address _sender, address[] _addresses);
    event SubmittedWhitelistRemoval(address[] _addresses, bytes32 _hash);
    event CancelledWhitelistRemoval(address _sender, bytes32 _hash);

    mapping(address => bool) public whitelistMap;
    address[] public whitelistArray;
    address[] private _pendingWhitelistAddition;
    address[] private _pendingWhitelistRemoval;
    bool public submittedWhitelistAddition;
    bool public submittedWhitelistRemoval;
    bool public isSetWhitelist;

    /// @dev Check if the provided addresses contain the owner or the zero-address address.
    modifier hasNoOwnerOrZeroAddress(address[] _addresses) {
        for (uint i = 0; i < _addresses.length; i++) {
            require(!_isOwner(_addresses[i]), "provided whitelist contains the owner address");
            require(_addresses[i] != address(0), "provided whitelist contains the zero address");
        }
        _;
    }

    /// @dev Check that neither addition nor removal operations have already been submitted.
    modifier noActiveSubmission() {
        require(!submittedWhitelistAddition && !submittedWhitelistRemoval, "whitelist operation has already been submitted");
        _;
    }

    /// @dev Getter for pending addition array.
    function pendingWhitelistAddition() external view returns (address[]) {
        return _pendingWhitelistAddition;
    }

    /// @dev Getter for pending removal array.
    function pendingWhitelistRemoval() external view returns (address[]) {
        return _pendingWhitelistRemoval;
    }

    /// @dev Add initial addresses to the whitelist.
    /// @param _addresses are the Ethereum addresses to be whitelisted.
    function setWhitelist(address[] _addresses) external onlyOwner hasNoOwnerOrZeroAddress(_addresses) {
        // Require that the whitelist has not been initialized.
        require(!isSetWhitelist, "whitelist has already been initialized");
        // Add each of the provided addresses to the whitelist.
        for (uint i = 0; i < _addresses.length; i++) {
            // adds to the whitelist mapping
            whitelistMap[_addresses[i]] = true;
            // adds to the whitelist array
            whitelistArray.push(_addresses[i]);
        }
        isSetWhitelist = true;
        // Emit the addition event.
        emit AddedToWhitelist(msg.sender, _addresses);
    }

    /// @dev Add addresses to the whitelist.
    /// @param _addresses are the Ethereum addresses to be whitelisted.
    function submitWhitelistAddition(address[] _addresses) external onlyOwner noActiveSubmission hasNoOwnerOrZeroAddress(_addresses) {
        // Require that the whitelist has been initialized.
        require(isSetWhitelist, "whitelist has not been initialized");
        // Require this array of addresses not empty
        require(_addresses.length > 0, "pending whitelist addition is empty");
        // Set the provided addresses to the pending addition addresses.
        _pendingWhitelistAddition = _addresses;
        // Flag the operation as submitted.
        submittedWhitelistAddition = true;
        // Emit the submission event.
        emit SubmittedWhitelistAddition(_addresses, calculateHash(_addresses));
    }

    /// @dev Confirm pending whitelist addition.
    /// @dev This will only ever be applied post 2FA, by one of the Controllers
    /// @param _hash is the hash of the pending whitelist array, a form of lamport lock
    function confirmWhitelistAddition(bytes32 _hash) external onlyController {
        // Require that the whitelist addition has been submitted.
        require(submittedWhitelistAddition, "whitelist addition has not been submitted");
        // Require that confirmation hash and the hash of the pending whitelist addition match
        require(_hash == calculateHash(_pendingWhitelistAddition), "hash of the pending whitelist addition do not match");
        // Whitelist pending addresses.
        for (uint i = 0; i < _pendingWhitelistAddition.length; i++) {
            // check if it doesn't exist already.
            if (!whitelistMap[_pendingWhitelistAddition[i]]) {
                 // add to the Map and the Array
                whitelistMap[_pendingWhitelistAddition[i]] = true;
                whitelistArray.push(_pendingWhitelistAddition[i]);
            }
        }
        // Emit the addition event.
        emit AddedToWhitelist(msg.sender, _pendingWhitelistAddition);
        // Reset pending addresses.
        delete _pendingWhitelistAddition;
        // Reset the submission flag.
        submittedWhitelistAddition = false;
    }

    /// @dev Cancel pending whitelist addition.
    function cancelWhitelistAddition(bytes32 _hash) external onlyOwnerOrController {
        // Check if operation has been submitted.
        require(submittedWhitelistAddition, "whitelist addition has not been submitted");
        // Require that confirmation hash and the hash of the pending whitelist addition match
        require(_hash == calculateHash(_pendingWhitelistAddition), "hash of the pending whitelist addition does not match");
        // Reset pending addresses.
        delete _pendingWhitelistAddition;
        // Reset the submitted operation flag.
        submittedWhitelistAddition = false;
        // Emit the cancellation event.
        emit CancelledWhitelistAddition(msg.sender, _hash);
    }

    /// @dev Remove addresses from the whitelist.
    /// @param _addresses are the Ethereum addresses to be removed.
    function submitWhitelistRemoval(address[] _addresses) external onlyOwner noActiveSubmission {
        // Require that the whitelist has been initialized.
        require(isSetWhitelist, "whitelist has not been initialized");
        // Require that the array of addresses is not empty
        require(_addresses.length > 0, "pending whitelist removal is empty");
        // Add the provided addresses to the pending addition list.
        _pendingWhitelistRemoval = _addresses;
        // Flag the operation as submitted.
        submittedWhitelistRemoval = true;
        // Emit the submission event.
        emit SubmittedWhitelistRemoval(_addresses, calculateHash(_addresses));
    }

    /// @dev Confirm pending removal of whitelisted addresses.
    function confirmWhitelistRemoval(bytes32 _hash) external onlyController {
        // Require that the pending whitelist is not empty and the operation has been submitted.
        require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
        // Require that confirmation hash and the hash of the pending whitelist removal match
        require(_hash == calculateHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match the confirmed hash");
        // Remove pending addresses.
        for (uint i = 0; i < _pendingWhitelistRemoval.length; i++) {
            // check if it exists
            if (whitelistMap[_pendingWhitelistRemoval[i]]) {
                whitelistMap[_pendingWhitelistRemoval[i]] = false;
                for (uint j = 0; j < whitelistArray.length.sub(1); j++) {
                    if (whitelistArray[j] == _pendingWhitelistRemoval[i]) {
                        whitelistArray[j] = whitelistArray[whitelistArray.length - 1];
                        break;
                    }
                }
                whitelistArray.length--;
            }
        }
        // Emit the removal event.
        emit RemovedFromWhitelist(msg.sender, _pendingWhitelistRemoval);
        // Reset pending addresses.
        delete _pendingWhitelistRemoval;
        // Reset the submission flag.
        submittedWhitelistRemoval = false;
    }

    /// @dev Cancel pending removal of whitelisted addresses.
    function cancelWhitelistRemoval(bytes32 _hash) external onlyOwnerOrController {
        // Check if operation has been submitted.
        require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
        // Require that confirmation hash and the hash of the pending whitelist removal match
        require(_hash == calculateHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal do not match");
        // Reset pending addresses.
        delete _pendingWhitelistRemoval;
        // Reset pending addresses.
        submittedWhitelistRemoval = false;
        // Emit the cancellation event.
        emit CancelledWhitelistRemoval(msg.sender, _hash);
    }

    /// @dev Method used to hash our whitelist address arrays.
    function calculateHash(address[] _addresses) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_addresses));
    }
}


/// @title DailyLimitTrait This trait allows for daily limits to be included in other contracts.
/// This contract will allow for a DailyLimit object to be instantiated and used.
contract DailyLimitTrait {
    using SafeMath for uint256;

    struct DailyLimit {
        uint value;
        uint available;
        uint limitDay;
        uint pending;
        bool set;
    }

    /// @dev Returns the available daily balance - accounts for daily limit reset.
    /// @return amount of available to spend within the current day in base units.
    function _getAvailableLimit(DailyLimit storage dl) internal view returns (uint) {
        if (now > dl.limitDay + 24 hours) {
            return dl.value;
        } else {
            return dl.available;
        }
    }

    /// @dev Use up amount within the daily limit. Will fail if amount is larger than daily limit.
    function _enforceLimit(DailyLimit storage dl, uint _amount) internal {
        // Account for the spend limit daily reset.
        _updateAvailableLimit(dl);
        require(dl.available >= _amount, "available has to be greater or equal to use amount");
        dl.available = dl.available.sub(_amount);
    }

    /// @dev Set the daily limit.
    /// @param _amount is the daily limit amount in base units.
    function _setLimit(DailyLimit storage dl, uint _amount) internal {
        // Require that the spend limit has not been set yet.
        require(!dl.set, "daily limit has already been set");
        // Modify spend limit based on the provided value.
        _modifyLimit(dl, _amount);
        // Flag the operation as set.
        dl.set = true;
    }

    /// @dev Submit a daily limit update, needs to be confirmed.
    /// @param _amount is the daily limit amount in base units.
    function _submitLimitUpdate(DailyLimit storage dl, uint _amount) internal {
        // Require that the spend limit has been set.
        require(dl.set, "limit has not been set");
        // Assign the provided amount to pending daily limit.
        dl.pending = _amount;
    }

    /// @dev Confirm pending set daily limit operation.
    function _confirmLimitUpdate(DailyLimit storage dl, uint _amount) internal {
        // Require that pending and confirmed spend limit are the same
        require(dl.pending == _amount, "confirmed and submitted limits dont match");
        // Modify spend limit based on the pending value.
        _modifyLimit(dl, dl.pending);
    }

    /// @dev Update available spend limit based on the daily reset.
    function _updateAvailableLimit(DailyLimit storage dl) private {
        if (now > dl.limitDay.add(24 hours)) {
            // Advance the current day by how many days have passed.
            uint extraDays = now.sub(dl.limitDay).div(24 hours);
            dl.limitDay = dl.limitDay.add(extraDays.mul(24 hours));
            // Set the available limit to the current spend limit.
            dl.available = dl.value;
        }
    }

    /// @dev Modify the spend limit and spend available based on the provided value.
    /// @dev _amount is the daily limit amount in wei.
    function _modifyLimit(DailyLimit storage dl, uint _amount) private {
        // Account for the spend limit daily reset.
        _updateAvailableLimit(dl);
        // Set the daily limit to the provided amount.
        dl.value = _amount;
        // Lower the available limit if it's higher than the new daily limit.
        if (dl.available > dl.value) {
            dl.available = dl.value;
        }
    }
}


/// @title  it provides daily spend limit functionality.
contract SpendLimit is ControllableOwnable, DailyLimitTrait {
    event SetSpendLimit(address _sender, uint _amount);
    event SubmittedSpendLimitUpdate(uint _amount);

    DailyLimit internal _spendLimit;

    /// @dev Constructor initializes the daily spend limit in wei.
    constructor(uint _limit_) internal {
        _spendLimit = DailyLimit(_limit_, _limit_, now, 0, false);
    }

    /// @dev Sets the initial daily spend (aka transfer) limit for non-whitelisted addresses.
    /// @param _amount is the daily limit amount in wei.
    function setSpendLimit(uint _amount) external onlyOwner {
        _setLimit(_spendLimit, _amount);
        emit SetSpendLimit(msg.sender, _amount);
    }

    /// @dev Submit a daily transfer limit update for non-whitelisted addresses.
    /// @param _amount is the daily limit amount in wei.
    function submitSpendLimitUpdate(uint _amount) external onlyOwner {
        _submitLimitUpdate(_spendLimit, _amount);
        emit SubmittedSpendLimitUpdate(_amount);
    }

    /// @dev Confirm pending set daily limit operation.
    function confirmSpendLimitUpdate(uint _amount) external onlyController {
        _confirmLimitUpdate(_spendLimit, _amount);
        emit SetSpendLimit(msg.sender, _amount);
    }

    function spendLimitAvailable() external view returns (uint) {
        return _getAvailableLimit(_spendLimit);
    }

    function spendLimitValue() external view returns (uint) {
        return _spendLimit.value;
    }

    function spendLimitSet() external view returns (bool) {
        return _spendLimit.set;
    }

    function spendLimitPending() external view returns (uint) {
        return _spendLimit.pending;
    }
}


//// @title GasTopUpLimit provides daily limit functionality.
contract GasTopUpLimit is ControllableOwnable, DailyLimitTrait {

    event SetGasTopUpLimit(address _sender, uint _amount);
    event SubmittedGasTopUpLimitUpdate(uint _amount);

    uint constant private _MINIMUM_GAS_TOPUP_LIMIT = 1 finney;
    uint constant private _MAXIMUM_GAS_TOPUP_LIMIT = 500 finney;

    DailyLimit internal _gasTopUpLimit;

    /// @dev Constructor initializes the daily gas topup limit in wei.
    constructor() internal {
        _gasTopUpLimit = DailyLimit(_MAXIMUM_GAS_TOPUP_LIMIT, _MAXIMUM_GAS_TOPUP_LIMIT, now, 0, false);
    }

    /// @dev Sets the daily gas top up limit.
    /// @param _amount is the gas top up amount in wei.
    function setGasTopUpLimit(uint _amount) external onlyOwner {
        require(_MINIMUM_GAS_TOPUP_LIMIT <= _amount && _amount <= _MAXIMUM_GAS_TOPUP_LIMIT, "gas top up amount is outside the min/max range");
        _setLimit(_gasTopUpLimit, _amount);
        emit SetGasTopUpLimit(msg.sender, _amount);
    }

    /// @dev Submit a daily gas top up limit update.
    /// @param _amount is the daily top up gas limit amount in wei.
    function submitGasTopUpLimitUpdate(uint _amount) external onlyOwner {
        require(_MINIMUM_GAS_TOPUP_LIMIT <= _amount && _amount <= _MAXIMUM_GAS_TOPUP_LIMIT, "gas top up amount is outside the min/max range");
        _submitLimitUpdate(_gasTopUpLimit, _amount);
        emit SubmittedGasTopUpLimitUpdate(_amount);
    }

    /// @dev Confirm pending set top up gas limit operation.
    function confirmGasTopUpLimitUpdate(uint _amount) external onlyController {
        _confirmLimitUpdate(_gasTopUpLimit, _amount);
        emit SetGasTopUpLimit(msg.sender, _amount);
    }

    function gasTopUpLimitAvailable() external view returns (uint) {
        return _getAvailableLimit(_gasTopUpLimit);
    }

    function gasTopUpLimitValue() external view returns (uint) {
        return _gasTopUpLimit.value;
    }

    function gasTopUpLimitSet() external view returns (bool) {
        return _gasTopUpLimit.set;
    }

    function gasTopUpLimitPending() external view returns (uint) {
        return _gasTopUpLimit.pending;
    }
}


/// @title LoadLimit provides daily load limit functionality.
contract LoadLimit is ControllableOwnable, DailyLimitTrait {

    event SetLoadLimit(address _sender, uint _amount);
    event SubmittedLoadLimitUpdate(uint _amount);

    uint constant private _MINIMUM_LOAD_LIMIT = 1 finney;
    uint private _maximumLoadLimit;

    DailyLimit internal _loadLimit;

    /// @dev Sets a daily card load limit.
    /// @param _amount is the card load amount in current stablecoin base units.
    function setLoadLimit(uint _amount) external onlyOwner {
        require(_MINIMUM_LOAD_LIMIT <= _amount && _amount <= _maximumLoadLimit, "card load amount is outside the min/max range");
        _setLimit(_loadLimit, _amount);
        emit SetLoadLimit(msg.sender, _amount);
    }

    /// @dev Submit a daily load limit update.
    /// @param _amount is the daily load limit amount in wei.
    function submitLoadLimitUpdate(uint _amount) external onlyOwner {
        require(_MINIMUM_LOAD_LIMIT <= _amount && _amount <= _maximumLoadLimit, "card load amount is outside the min/max range");
        _submitLimitUpdate(_loadLimit, _amount);
        emit SubmittedLoadLimitUpdate(_amount);
    }

    /// @dev Confirm pending set load limit operation.
    function confirmLoadLimitUpdate(uint _amount) external onlyController {
        _confirmLimitUpdate(_loadLimit, _amount);
        emit SetLoadLimit(msg.sender, _amount);
    }

    function loadLimitAvailable() external view returns (uint) {
        return _getAvailableLimit(_loadLimit);
    }

    function loadLimitValue() external view returns (uint) {
        return _loadLimit.value;
    }

    function loadLimitSet() external view returns (bool) {
        return _loadLimit.set;
    }

    function loadLimitPending() external view returns (uint) {
        return _loadLimit.pending;
    }

    /// @dev initializes the daily load limit.
    /// @param _maxLimit is the maximum load limit amount in stablecoin base units.
    function _initializeLoadLimit(uint _maxLimit) internal {
        _maximumLoadLimit = _maxLimit;
        _loadLimit = DailyLimit(_maximumLoadLimit, _maximumLoadLimit, now, 0, false);
    }
}


//// @title Asset store with extra security features.
contract Vault is AddressWhitelist, SpendLimit, ERC165, TokenWhitelistable {

    using SafeMath for uint256;

    event Received(address _from, uint _amount);
    event Transferred(address _to, address _asset, uint _amount);

    /// @dev Supported ERC165 interface ID.
    bytes4 private constant _ERC165_INTERFACE_ID = 0x01ffc9a7; // solium-disable-line uppercase

    /// @dev Constructor initializes the vault with an owner address and spend limit. It also sets up the controllable and tokenWhitelist contracts with the right name registered in ENS.
    /// @param _owner_ is the owner account of the wallet contract.
    /// @param _transferable_ indicates whether the contract ownership can be transferred.
    /// @param _tokenWhitelistNameHash_ is the ENS name hash of the Token whitelist.
    /// @param _controllerNameHash_ is the ENS name hash of the controller.
    /// @param _spendLimit_ is the initial spend limit.
    constructor(address _owner_, bool _transferable_, bytes32 _tokenWhitelistNameHash_, bytes32 _controllerNameHash_, uint _spendLimit_) SpendLimit(_spendLimit_) Ownable(_owner_, _transferable_) Controllable(_controllerNameHash_) TokenWhitelistable(_tokenWhitelistNameHash_) public {}

    /// @dev Checks if the value is not zero.
    modifier isNotZero(uint _value) {
        require(_value != 0, "provided value cannot be zero");
        _;
    }

    /// @dev Ether can be deposited from any source, so this contract must be payable by anyone.
    function() external payable {
        require(msg.data.length == 0, "msg data needs to be empty");
        emit Received(msg.sender, msg.value);
    }

    /// @dev Returns the amount of an asset owned by the contract.
    /// @param _asset address of an ERC20 token or 0x0 for ether.
    /// @return balance associated with the wallet address in wei.
    function balance(address _asset) external view returns (uint) {
        if (_asset != address(0)) {
            return ERC20(_asset).balanceOf(this);
        } else {
            return address(this).balance;
        }
    }

    /// @dev Transfers the specified asset to the recipient's address.
    /// @param _to is the recipient's address.
    /// @param _asset is the address of an ERC20 token or 0x0 for ether.
    /// @param _amount is the amount of assets to be transferred in base units.
    function transfer(address _to, address _asset, uint _amount) external onlyOwner isNotZero(_amount) {
        // Checks if the _to address is not the zero-address
        require(_to != address(0), "_to address cannot be set to 0x0");

        // If address is not whitelisted, take daily limit into account.
        if (!whitelistMap[_to]) {
            //initialize ether value in case the asset is ETH
            uint etherValue = _amount;
            // Convert token amount to ether value if asset is an ERC20 token.
            if (_asset != address(0)) {
                etherValue = convertToEther(_asset, _amount);
            }
            // Check against the daily spent limit and update accordingly
            // Check against the daily spent limit and update accordingly, require that the value is under remaining limit.
            _enforceLimit(_spendLimit, etherValue);
        }
        // Transfer token or ether based on the provided address.
        if (_asset != address(0)) {
            require(ERC20(_asset).transfer(_to, _amount), "ERC20 token transfer was unsuccessful");
        } else {
            _to.transfer(_amount);
        }
        // Emit the transfer event.
        emit Transferred(_to, _asset, _amount);
    }

    /// @dev Checks for interface support based on ERC165.
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == _ERC165_INTERFACE_ID;
    }

    /// @dev Convert ERC20 token amount to the corresponding ether amount.
    /// @param _token ERC20 token contract address.
    /// @param _amount amount of token in base units.
    function convertToEther(address _token, uint _amount) public view returns (uint) {
        // Store the token in memory to save map entry lookup gas.
        (,uint256 magnitude, uint256 rate, bool available, , , ) = _getTokenInfo(_token);
        // If the token exists require that its rate is not zero.
        if (available) {
            require(rate != 0, "token rate is 0");
            // Safely convert the token amount to ether based on the exchange rate.
            // SWC-Integer Overflow and Underflow: L562
            return _amount.mul(rate).div(magnitude);
        }
        return 0;
    }
}


//// @title Asset wallet with extra security features, gas top up management and card integration.
contract Wallet is ENSResolvable, Vault, GasTopUpLimit, LoadLimit {

    event ToppedUpGas(address _sender, address _owner, uint _amount);
    event LoadedTokenCard(address _asset, uint _amount);
    event ExecutedTransaction(address _destination, uint _value, bytes _data);

    uint constant private _DEFAULT_MAX_STABLECOIN_LOAD_LIMIT = 10000; //10,000 USD

    /// @dev Is the registered ENS node identifying the licence contract.
    bytes32 private _licenceNode;

    /// @dev these are needed to allow for the executeTransaction method
    uint32 private constant _TRANSFER= 0xa9059cbb;
    uint32 private constant _APPROVE = 0x095ea7b3;

    /// @dev Constructor initializes the wallet top up limit and the vault contract.
    /// @param _owner_ is the owner account of the wallet contract.
    /// @param _transferable_ indicates whether the contract ownership can be transferred.
    /// @param _ens_ is the address of the ENS registry.
    /// @param _tokenWhitelistNameHash_ is the ENS name hash of the Token whitelist.
    /// @param _controllerNameHash_ is the ENS name hash of the Controller contract.
    /// @param _licenceNameHash_ is the ENS name hash of the Licence contract.
    /// @param _spendLimit_ is the initial spend limit.
    constructor(address _owner_, bool _transferable_, address _ens_, bytes32 _tokenWhitelistNameHash_, bytes32 _controllerNameHash_, bytes32 _licenceNameHash_, uint _spendLimit_) ENSResolvable(_ens_) Vault(_owner_, _transferable_, _tokenWhitelistNameHash_, _controllerNameHash_, _spendLimit_) public {
        // Get the stablecoin's magnitude.
        ( ,uint256 stablecoinMagnitude, , , , , ) = _getStablecoinInfo();
        require(stablecoinMagnitude > 0, "stablecoin not set");
        _initializeLoadLimit(_DEFAULT_MAX_STABLECOIN_LOAD_LIMIT * stablecoinMagnitude);
        _licenceNode = _licenceNameHash_;
    }

    /// @dev Refill owner's gas balance, revert if the transaction amount is too large
    /// @param _amount is the amount of ether to transfer to the owner account in wei.
    function topUpGas(uint _amount) external isNotZero(_amount) onlyOwnerOrController {
        // Check against the daily spent limit and update accordingly, require that the value is under remaining limit.
        _enforceLimit(_gasTopUpLimit, _amount);
        // Then perform the transfer
        owner().transfer(_amount);
        // Emit the gas top up event.
        emit ToppedUpGas(msg.sender, owner(), _amount);
    }

    /// @dev Load a token card with the specified asset amount.
    /// @dev the amount send should be inclusive of the percent licence.
    /// @param _asset is the address of an ERC20 token or 0x0 for ether.
    /// @param _amount is the amount of assets to be transferred in base units.
    function loadTokenCard(address _asset, uint _amount) external payable onlyOwner {
        //check if token is allowed to be used for loading the card
        require(_isTokenLoadable(_asset), "token not loadable");
        // Convert token amount to stablecoin value.
        uint stablecoinValue = convertToStablecoin(_asset, _amount);
        // Check against the daily spent limit and update accordingly, require that the value is under remaining limit.
        _enforceLimit(_loadLimit, stablecoinValue);
        // Get the TKN licenceAddress from ENS
        address licenceAddress = _ensResolve(_licenceNode);
        if (_asset != address(0)) {
            require(ERC20(_asset).approve(licenceAddress, _amount), "ERC20 token approval was unsuccessful");
            ILicence(licenceAddress).load(_asset, _amount);
        } else {
            ILicence(licenceAddress).load.value(_amount)(_asset, _amount);
        }

        emit LoadedTokenCard(_asset, _amount);

    }

    /// @dev This function allows for the owner to send transaction from the Wallet to arbitrary addresses
    /// @param _destination address of the transaction
    /// @param _value ETH amount in wei
    /// @param _data transaction payload binary
    function executeTransaction(address _destination, uint _value, bytes _data) external onlyOwner {
        // Check if there exists at least a method signature in the transaction payload
        if (_data.length >= 4) {
            // Get method signature
            uint32 signature = _bytesToUint32(_data, 0);

            // Check if method is either ERC20 transfer or approve
            if (signature == _TRANSFER || signature == _APPROVE) {
                require(_data.length >= 4 + 32 + 32, "invalid transfer / approve transaction data");
                uint amount = _sliceUint(_data, 4 + 32);
                // The "toOrSpender" is the '_to' address for a ERC20 transfer or the '_spender; in ERC20 approve
                // + 12 because address 20 bytes and this is padded to 32
                address toOrSpender = _bytesToAddress(_data, 4 + 12);

                // Check if the toOrSpender is in the whitelist
                if (!whitelistMap[toOrSpender]) {
                    // If the address (of the token contract, e.g) is not in the TokenWhitelist used by
                    // the convert method, then etherValue will be zero
                    uint etherValue = convertToEther(_destination, amount);
                    _enforceLimit(_spendLimit, etherValue);
                }
            }
        }

        // If value is send across as a part of this executeTransaction, this will be sent to any payable
        // destination. As a result enforceLimit if destination is not whitelisted.
        if (!whitelistMap[_destination]) {
            _enforceLimit(_spendLimit, _value);
        }

        require(_externalCall(_destination, _value, _data.length, _data), "executing transaction failed");

        emit ExecutedTransaction(_destination, _value, _data);
    }

    /// @return licence contract node registered in ENS.
    function licenceNode() external view returns (bytes32) {
        return _licenceNode;
    }

    /// @dev Convert ether or ERC20 token amount to the corresponding stablecoin amount.
    /// @param _token ERC20 token contract address.
    /// @param _amount amount of token in base units.
    function convertToStablecoin(address _token, uint _amount) public view returns (uint) {
        //avoid the unnecessary calculations if the token to be loaded is the stablecoin itself
        if (_token == _stablecoin()) {
            return _amount;
        }
        //0x0 represents ether
        if (_token != address(0)) {
            //convert to eth first, same as convertToEther()
            // Store the token in memory to save map entry lookup gas.
            (,uint256 magnitude, uint256 rate, bool available, , , ) = _getTokenInfo(_token);
            // require that token both exists in the whitelist and its rate is not zero.
            require(available, "token is not available");
            require(rate != 0, "token rate is 0");
            // Safely convert the token amount to ether based on the exchange rate.
            _amount = _amount.mul(rate).div(magnitude);
        }
        //_amount now is in ether
        // Get the stablecoin's magnitude and its current rate.
        ( ,uint256 stablecoinMagnitude, uint256 stablecoinRate, bool stablecoinAvailable, , , ) = _getStablecoinInfo();
            // Check if the stablecoin rate is set.
        require(stablecoinAvailable, "token is not available");
        require(stablecoinRate != 0, "stablecoin rate is 0");
        // Safely convert the token amount to stablecoin based on its exchange rate and the stablecoin exchange rate.
        // SWC-Integer Overflow and Underflow: L707
        return _amount.mul(stablecoinMagnitude).div(stablecoinRate);
    }

    /// @dev This function is taken from the Gnosis MultisigWallet: https://github.com/gnosis/MultiSigWallet/
    /// @dev License: https://github.com/gnosis/MultiSigWallet/blob/master/LICENSE
    /// @dev thanks :)
    /// @dev This calls proxies arbitrary transactions to addresses
    /// @param _destination address of the transaction
    /// @param _value ETH amount in wei
    /// @param _dataLength length of the transaction data
    /// @param _data transaction payload binary
    // call has been separated into its own function in order to take advantage
    // of the Solidity's code generator to produce a loop that copies tx.data into memory.
    function _externalCall(address _destination, uint _value, uint _dataLength, bytes _data) private returns (bool) {
        bool result;
        assembly {
            let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
            let d := add(_data, 32) // First 32 bytes are the padded length of data, so exclude that
            result := call(
                sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
                                   // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
                                   // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
                _destination,
                _value,
                d,
                _dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
                x,
                0                  // Output is ignored, therefore the output size is zero
            )
        }

        return result;
    }

    /// @dev This function converts to an address
    /// @param _bts bytes
    /// @param _from start position
    function _bytesToAddress(bytes _bts, uint _from) private pure returns (address) {
        require(_bts.length >= _from + 20, "slicing out of range");

        uint160 m = 0;
        uint160 b = 0;

        for (uint8 i = 0; i < 20; i++) {
            m *= 256;
            b = uint160 (_bts[_from + i]);
            m += (b);
        }

        return address(m);
    }

    /// @dev This function slicing bytes into uint32
    /// @param _bts some bytes
    /// @param _from  a start position
    function _bytesToUint32(bytes _bts, uint _from) private pure returns (uint32) {
        require(_bts.length >= _from + 4, "slicing out of range");

        uint32 m = 0;
        uint32 b = 0;

        for (uint8 i = 0; i < 4; i++) {
            m *= 256;
            b = uint32 (_bts[_from + i]);
            m += (b);
        }

        return m;
    }

    /// @dev This function slices a uint
    /// @param _bts some bytes
    /// @param _from  a start position
    // credit to https://ethereum.stackexchange.com/questions/51229/how-to-convert-bytes-to-uint-in-solidity
    // and Nick Johnson https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity/4177#4177
    function _sliceUint(bytes _bts, uint _from) private pure returns (uint) {
        require(_bts.length >= _from + 32, "slicing out of range");

        uint x;
        assembly {
            x := mload(add(_bts, add(0x20, _from)))
        }

        return x;
    }

}
