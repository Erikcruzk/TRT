// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/access/legacy/libs/Roles.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;


/**
 * @title Roles
 * @author Francisco Giordano (@frangio)
 * @dev Library for managing addresses assigned to a Role.
 * See RBAC.sol for example usage.
 */
library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /**
     * @dev give an address access to this role
     */
    function add(Role storage _role, address _addr)
    internal
    {
        _role.bearer[_addr] = true;
    }

    /**
     * @dev remove an address" access to this role
     */
    function remove(Role storage _role, address _addr)
    internal
    {
        _role.bearer[_addr] = false;
    }

    /**
     * @dev check if an address has this role
     * // reverts
     */
    function check(Role storage _role, address _addr)
    internal
    view
    {
        require(has(_role, _addr));
    }

    /**
     * @dev check if an address has this role
     * @return bool
     */
    function has(Role storage _role, address _addr)
    internal
    view
    returns (bool)
    {
        return _role.bearer[_addr];
    }
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/access/legacy/libs/AccessControl.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// N:B - this has been copied into the project for legacy reasons only

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//
// NOTE: this is only a dummy contract with the same interface as the history older KO access controls
// NEVER DEPLOY THIS CONTRACT!!!!!
//
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/**
 * @title Based on OpenZeppelin Whitelist & RBCA contracts
 * @dev The AccessControl contract provides different access for addresses, and provides basic authorization control functions.
 */
contract AccessControl {

    using Roles for Roles.Role;

    uint8 public constant ROLE_KNOWN_ORIGIN = 1;
    uint8 public constant ROLE_MINTER = 2;
    uint8 public constant ROLE_UNDER_MINTER = 3;

    event RoleAdded(address indexed operator, uint8 role);
    event RoleRemoved(address indexed operator, uint8 role);

    address public owner;

    mapping(uint8 => Roles.Role) private roles;

    modifier onlyIfKnownOrigin() {
        require(msg.sender == owner || hasRole(msg.sender, ROLE_KNOWN_ORIGIN));
        _;
    }

    modifier onlyIfMinter() {
        require(msg.sender == owner || hasRole(msg.sender, ROLE_KNOWN_ORIGIN) || hasRole(msg.sender, ROLE_MINTER));
        _;
    }

    modifier onlyIfUnderMinter() {
        require(msg.sender == owner || hasRole(msg.sender, ROLE_KNOWN_ORIGIN) || hasRole(msg.sender, ROLE_UNDER_MINTER));
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    ////////////////////////////////////
    // Whitelist/RBCA Derived Methods //
    ////////////////////////////////////

    function addAddressToAccessControl(address _operator, uint8 _role)
    public
    onlyIfKnownOrigin
    {
        roles[_role].add(_operator);
        emit RoleAdded(_operator, _role);
    }

    function removeAddressFromAccessControl(address _operator, uint8 _role)
    public
    onlyIfKnownOrigin
    {
        roles[_role].remove(_operator);
        emit RoleRemoved(_operator, _role);
    }

    function checkRole(address _operator, uint8 _role)
    public
    view
    {
        roles[_role].check(_operator);
    }

    function hasRole(address _operator, uint8 _role)
    public
    view
    returns (bool)
    {
        return roles[_role].has(_operator);
    }

}
