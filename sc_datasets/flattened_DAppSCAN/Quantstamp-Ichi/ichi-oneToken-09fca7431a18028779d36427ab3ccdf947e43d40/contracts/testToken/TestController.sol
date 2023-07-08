// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IController.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IController {
    
    function oneTokenFactory() external returns(address);
    function description() external returns(string memory);
    function init() external;
    function periodic() external;
    function MODULE_TYPE() external view returns(bytes32);    
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/InterfaceCommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;
pragma abicoder v2;

interface InterfaceCommon {

    enum ModuleType { Version, Controller, Strategy, MintMaster, Oracle }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IOneTokenFactory.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;
pragma abicoder v2;

interface IOneTokenFactory is InterfaceCommon {

    function oneTokenProxyAdmins(address) external returns(address);
    function deployOneTokenProxy(
        string memory name,
        string memory symbol,
        address governance, 
        address version,
        address controller,
        address mintMaster,              
        address memberToken, 
        address collateral,
        address oneTokenOracle
    ) 
        external 
        returns(address newOneTokenProxy, address proxyAdmin);

    function admitModule(address module, ModuleType moduleType, string memory name, string memory url) external;
    function updateModule(address module, string memory name, string memory url) external;
    function removeModule(address module) external;

    function admitForeignToken(address foreignToken, bool collateral, address oracle) external;
    function updateForeignToken(address foreignToken, bool collateral) external;
    function removeForeignToken(address foreignToken) external;

    function assignOracle(address foreignToken, address oracle) external;
    function removeOracle(address foreignToken, address oracle) external; 

    /**
     * View functions
     */
    
    function MODULE_TYPE() external view returns(bytes32);

    function oneTokenCount() external view returns(uint);
    function oneTokenAtIndex(uint index) external view returns(address);
    function isOneToken(address oneToken) external view returns(bool);
 
    // modules

    function moduleCount() external view returns(uint);
    function moduleAtIndex(uint index) external view returns(address module);
    function moduleInfo(address module) external view returns(string memory name, string memory url, ModuleType moduleType);
    function isModule(address module) external view returns(bool);
    function isValidModuleType(address module, ModuleType moduleType) external view returns(bool);

    // foreign tokens

    function foreignTokenCount() external view returns(uint);
    function foreignTokenAtIndex(uint index) external view returns(address);
    function foreignTokenInfo(address foreignToken) external view returns(bool collateral, uint oracleCount);
    function foreignTokenOracleCount(address foreignToken) external view returns(uint);
    function foreignTokenOracleAtIndex(address foreignToken, uint index) external view returns(address);
    function isOracle(address foreignToken, address oracle) external view returns(bool);
    function isForeignToken(address foreignToken) external view returns(bool);
    function isCollateral(address foreignToken) external view returns(bool);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/controller/ControllerCommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


abstract contract ControllerCommon is IController {

    bytes32 constant public override MODULE_TYPE = keccak256(abi.encodePacked("ICHI V1 Controller"));

    address public override oneTokenFactory;
    string public override description;

    event ControllerDeployed(address sender, address oneTokenFactory, string description);
    event ControllerInitialized(address sender);
    event ControllerPeriodic(address sender);

    modifier onlyKnownToken {
        require(IOneTokenFactory(oneTokenFactory).isOneToken(msg.sender), "ICHIModuleCommon: msg.sender is not a known oneToken");
        _;
    }

    /**
     @notice Controllers rebalance funds and may execute strategies periodically.
     */
    
    
    /**
     @notice controllers are bound to factories at deployment time
     @param oneTokenFactory_ factory to bind to
     @param description_ human-readable, description only
     */ 
    constructor(address oneTokenFactory_, string memory description_) {
        oneTokenFactory = oneTokenFactory_;
        description = description_;
        emit ControllerDeployed(msg.sender, oneTokenFactory_, description);
    }    
    
    /**
     @notice oneTokens invoke periodic() to trigger periodic processes. Can be trigger externally.
     @dev Acceptable access control will vary by implementation. 
     */  
    function periodic() external virtual override {
        emit ControllerPeriodic(msg.sender);
    }  
        
    /**
     @notice OneTokenBase (msg.sender) calls this when the controller is assigned. Must be re-initializeable.
     */
    function init() external onlyKnownToken virtual override {
        emit ControllerInitialized(msg.sender);
    }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IICHIOwnable.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IICHIOwnable {
    
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function owner() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IICHICommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


interface IICHICommon is IICHIOwnable, InterfaceCommon {}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_openzeppelin/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IERC20Extended.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IERC20Extended is IERC20 {
    
    function decimals() external view returns(uint8);
    function symbol() external view returns(string memory);
    function name() external view returns(string memory);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IOneTokenV1Base.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;
pragma abicoder v2;


interface IOneTokenV1Base is IICHICommon, IERC20 {
    
    function init(string memory name_, string memory symbol_, address oneTokenOracle_, address controller_,  address mintMaster_, address memberToken_, address collateral_) external;
    function changeController(address controller_) external;
    function changeMintMaster(address mintMaster_, address oneTokenOracle) external;
    function addAsset(address token, address oracle) external;
    function removeAsset(address token) external;
    function setStrategy(address token, address strategy, uint allowance) external;
    function executeStrategy(address token) external;
    function removeStrategy(address token) external;
    function closeStrategy(address token) external;
    function setStrategyAllowance(address token, uint amount) external;
    function setFactory(address newFactory) external;

    function MODULE_TYPE() external view returns(bytes32);
    function oneTokenFactory() external view returns(address);
    function controller() external view returns(address);
    function mintMaster() external view returns(address);
    function memberToken() external view returns(address);
    function assets(address) external view returns(address, address);
    function balances(address token) external view returns(uint inVault, uint inStrategy);
    function collateralTokenCount() external view returns(uint);
    function collateralTokenAtIndex(uint index) external view returns(address);
    function isCollateral(address token) external view returns(bool);
    function otherTokenCount() external view  returns(uint);
    function otherTokenAtIndex(uint index) external view returns(address); 
    function isOtherToken(address token) external view returns(bool);
    function assetCount() external view returns(uint);
    function assetAtIndex(uint index) external view returns(address); 
    function isAsset(address token) external view returns(bool);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IModule.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


interface IModule is IICHICommon { 
       
    function oneTokenFactory() external view returns(address);
    function updateDescription(string memory description) external;
    function moduleDescription() external view returns(string memory);
    function MODULE_TYPE() external view returns(bytes32);
    function moduleType() external view returns(ModuleType);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IStrategy.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IStrategy is IModule {
    
    function init() external;
    function execute() external;
    function setAllowance(address token, uint amount) external;
    function toVault(address token, uint amount) external;
    function fromVault(address token, uint amount) external;
    function closeAllPositions() external returns(bool);
    function oneToken() external view returns(address);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/testToken/TestController.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;



contract TestController is ControllerCommon {


    /**
     @notice this controller implementation supports the interface and add functions needed for testings
     @dev the controller implementation can be extended but must implement the minimum interface
     */

    constructor(address oneTokenFactory_)
       ControllerCommon(oneTokenFactory_, "Test Controller")
     {} 

    function executeStrategy(address oneToken, address token) external {
        IOneTokenV1Base(oneToken).executeStrategy(token);
    }

    function testDirectExecute(address strategy) external {
        IStrategy(strategy).execute();
    }
      
}
