// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/set/interfaces/ISetToken.sol

// SPDX-License-Identifier: GPL-2.0-only
pragma solidity >=0.6.10 <=0.8.10;
pragma experimental ABIEncoderV2;

interface ISetToken is IERC20 {
    /* ============ Enums ============ */

    enum ModuleState {
        NONE,
        PENDING,
        INITIALIZED
    }

    /* ============ Structs ============ */
    /**
     * The base definition of a SetToken Position
     *
     * @param component           Address of token in the Position
     * @param module              If not in default state, the address of associated module
     * @param unit                Each unit is the # of components per 10^18 of a SetToken
     * @param positionState       Position ENUM. Default is 0; External is 1
     * @param data                Arbitrary data
     */
    struct Position {
        address component;
        address module;
        int256 unit;
        uint8 positionState;
        bytes data;
    }

    /**
     * A struct that stores a component's cash position details and external positions
     * This data structure allows O(1) access to a component's cash position units and
     * virtual units.
     *
     * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
     *                                  updating all units at once via the position multiplier. Virtual units are achieved
     *                                  by dividing a "real" value by the "positionMultiplier"
     * @param componentIndex
     * @param externalPositionModules   List of external modules attached to each external position. Each module
     *                                  maps to an external position
     * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
     */
    struct ComponentPosition {
        int256 virtualUnit;
        address[] externalPositionModules;
        mapping(address => ExternalPosition) externalPositions;
    }

    /**
     * A struct that stores a component's external position details including virtual unit and any
     * auxiliary data.
     *
     * @param virtualUnit       Virtual value of a component's EXTERNAL position.
     * @param data              Arbitrary data
     */
    struct ExternalPosition {
        int256 virtualUnit;
        bytes data;
    }

    /* ============ Functions ============ */

    function addComponent(address _component) external;

    function removeComponent(address _component) external;

    function editDefaultPositionUnit(address _component, int256 _realUnit) external;

    function addExternalPositionModule(address _component, address _positionModule) external;

    function removeExternalPositionModule(address _component, address _positionModule) external;

    function editExternalPositionUnit(
        address _component,
        address _positionModule,
        int256 _realUnit
    ) external;

    function editExternalPositionData(
        address _component,
        address _positionModule,
        bytes calldata _data
    ) external;

    function invoke(
        address _target,
        uint256 _value,
        bytes calldata _data
    ) external returns (bytes memory);

    function editPositionMultiplier(int256 _newMultiplier) external;

    function mint(address _account, uint256 _quantity) external;

    function burn(address _account, uint256 _quantity) external;

    function lock() external;

    function unlock() external;

    function addModule(address _module) external;

    function removeModule(address _module) external;

    function initializeModule() external;

    function setManager(address _manager) external;

    function manager() external view returns (address);

    function moduleStates(address _module) external view returns (ModuleState);

    function getModules() external view returns (address[] memory);

    function getDefaultPositionRealUnit(address _component) external view returns (int256);

    function getExternalPositionRealUnit(address _component, address _positionModule) external view returns (int256);

    function getComponents() external view returns (address[] memory);

    function getExternalPositionModules(address _component) external view returns (address[] memory);

    function getExternalPositionData(address _component, address _positionModule) external view returns (bytes memory);

    function isExternalPositionModule(address _component, address _module) external view returns (bool);

    function isComponent(address _component) external view returns (bool);

    function positionMultiplier() external view returns (int256);

    function getPositions() external view returns (Position[] memory);

    function getTotalComponentRealUnits(address _component) external view returns (int256);

    function isInitializedModule(address _module) external view returns (bool);

    function isPendingModule(address _module) external view returns (bool);

    function isLocked() external view returns (bool);
}
