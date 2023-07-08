// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IOwned.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Owned contract interface
*/
interface IOwned {
    // this function isn't since the compiler emits automatically generated getter functions as external
    function owner() external view returns (address);

    function transferOwnership(address _newOwner) external;
    function acceptOwnership() external;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Owned.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Provides support and utilities for contract ownership
*/
contract Owned is IOwned {
    address public override owner;
    address public newOwner;

    /**
      * @dev triggered when the owner is updated
      *
      * @param _prevOwner previous owner
      * @param _newOwner  new owner
    */
    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);

    /**
      * @dev initializes a new Owned instance
    */
    constructor() public {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        _ownerOnly();
        _;
    }

    // error message binary size optimization
    function _ownerOnly() internal view {
        require(msg.sender == owner, "ERR_ACCESS_DENIED");
    }

    /**
      * @dev allows transferring the contract ownership
      * the new owner still needs to accept the transfer
      * can only be called by the contract owner
      *
      * @param _newOwner    new contract owner
    */
    function transferOwnership(address _newOwner) public override ownerOnly {
        require(_newOwner != owner, "ERR_SAME_OWNER");
        newOwner = _newOwner;
    }

    /**
      * @dev used by a new owner to accept an ownership transfer
    */
    function acceptOwnership() override public {
        require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Utils.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/**
  * @dev Utilities & Common Modifiers
*/
contract Utils {
    // verifies that a value is greater than zero
    modifier greaterThanZero(uint256 _value) {
        _greaterThanZero(_value);
        _;
    }

    // error message binary size optimization
    function _greaterThanZero(uint256 _value) internal pure {
        require(_value > 0, "ERR_ZERO_VALUE");
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        _validAddress(_address);
        _;
    }

    // error message binary size optimization
    function _validAddress(address _address) internal pure {
        require(_address != address(0), "ERR_INVALID_ADDRESS");
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        _notThis(_address);
        _;
    }

    // error message binary size optimization
    function _notThis(address _address) internal view {
        require(_address != address(this), "ERR_ADDRESS_IS_SELF");
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/interfaces/IWhitelist.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;

/*
    Whitelist interface
*/
interface IWhitelist {
    function isWhitelisted(address _address) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Zer0 - zBanc/zBanc-master/solidity/contracts/utility/Whitelist.sol

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;



/**
  * @dev The contract manages a list of whitelisted addresses
*/
contract Whitelist is IWhitelist, Owned, Utils {
    mapping (address => bool) private whitelist;

    /**
      * @dev triggered when an address is added to the whitelist
      *
      * @param _address address that's added from the whitelist
    */
    event AddressAddition(address indexed _address);

    /**
      * @dev triggered when an address is removed from the whitelist
      *
      * @param _address address that's removed from the whitelist
    */
    event AddressRemoval(address indexed _address);

    /**
      * @dev returns true if a given address is whitelisted, false if not
      *
      * @param _address address to check
      *
      * @return true if the address is whitelisted, false if not
    */
    function isWhitelisted(address _address) public view override returns (bool) {
        return whitelist[_address];
    }

    /**
      * @dev adds a given address to the whitelist
      *
      * @param _address address to add
    */
    function addAddress(address _address)
        ownerOnly
        validAddress(_address)
        public
    {
        if (whitelist[_address]) // checks if the address is already whitelisted
            return;

        whitelist[_address] = true;
        emit AddressAddition(_address);
    }

    /**
      * @dev adds a list of addresses to the whitelist
      *
      * @param _addresses addresses to add
    */
    function addAddresses(address[] memory _addresses) public {
        for (uint256 i = 0; i < _addresses.length; i++) {
            addAddress(_addresses[i]);
        }
    }

    /**
      * @dev removes a given address from the whitelist
      *
      * @param _address address to remove
    */
    function removeAddress(address _address) ownerOnly public {
        if (!whitelist[_address]) // checks if the address is actually whitelisted
            return;

        whitelist[_address] = false;
        emit AddressRemoval(_address);
    }

    /**
      * @dev removes a list of addresses from the whitelist
      *
      * @param _addresses addresses to remove
    */
    function removeAddresses(address[] memory _addresses) public {
        for (uint256 i = 0; i < _addresses.length; i++) {
            removeAddress(_addresses[i]);
        }
    }
}
