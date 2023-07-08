// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IICHIOwnable.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IICHIOwnable {
    
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
    function owner() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/InterfaceCommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;
pragma abicoder v2;

interface InterfaceCommon {

    enum ModuleType { Version, Controller, Strategy, MintMaster, Oracle }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IICHICommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


interface IICHICommon is IICHIOwnable, InterfaceCommon {}

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/interface/IOracle.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;

interface IOracle is IModule {

    /// @notice returns usd conversion rate with 18 decimal precision

    function init(address baseToken) external;
    function update(address token) external;
    function indexToken() external view returns(address);
    function read(address token, uint amount) external view returns(uint amountOut, uint volatility);
    function amountRequired(address token, uint amountUsd) external view returns(uint tokens, uint volatility);
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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_openzeppelin/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/oz_modified/ICHIOwnable.sol

// SPDX-License-Identifier: MIT

/**
 * @dev Constructor visibility has been removed from the original.
 * _transferOwnership() has been added to support proxied deployments.
 * Abstract tag removed from contract block.
 * Added interface inheritance and override modifiers.
 * Changed contract identifier in require error messages.
 */

pragma solidity >=0.6.0 <0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract ICHIOwnable is IICHIOwnable, Context {
    
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Throws if called by any account other than the owner.
     */
     
    modifier onlyOwner() {
        require(owner() == _msgSender(), "ICHIOwnable: caller is not the owner");
        _;
    }    

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     * Ineffective for proxied deployed. Use initOwnable.
     */
    constructor() {
        _transferOwnership(msg.sender);
    }

    /**
     @dev initialize proxied deployment
     */
    function initOwnable() internal {
        require(owner() == address(0), "ICHIOwnable: already initialized");
        _transferOwnership(msg.sender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual override returns (address) {
        return _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual override onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */

    function transferOwnership(address newOwner) public virtual override onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev be sure to call this in the initialization stage of proxied deployment or owner will not be set
     */

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "ICHIOwnable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/_openzeppelin/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2 <0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/oz_modified/ICHIInitializable.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

contract ICHIInitializable {

    bool private _initialized;
    bool private _initializing;

    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "ICHIInitializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    modifier initialized {
        require(_initialized, "ICHIInitializable: contract is not initialized");
        _;
    }

    function _isConstructor() private view returns (bool) {
        return !Address.isContract(address(this));
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/common/ICHICommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;




contract ICHICommon is IICHICommon, ICHIOwnable, ICHIInitializable {

    uint constant PRECISION = 10 ** 18;
    uint constant INFINITE = uint(0-1);
    address constant NULL_ADDRESS = address(0);
    
    // @dev internal fingerprints help prevent deployment-time governance errors

    bytes32 constant COMPONENT_CONTROLLER = keccak256(abi.encodePacked("ICHI V1 Controller"));
    bytes32 constant COMPONENT_VERSION = keccak256(abi.encodePacked("ICHI V1 OneToken Implementation"));
    bytes32 constant COMPONENT_STRATEGY = keccak256(abi.encodePacked("ICHI V1 Strategy Implementation"));
    bytes32 constant COMPONENT_MINTMASTER = keccak256(abi.encodePacked("ICHI V1 MintMaster Implementation"));
    bytes32 constant COMPONENT_ORACLE = keccak256(abi.encodePacked("ICHI V1 Oracle Implementation"));
    bytes32 constant COMPONENT_VOTERROLL = keccak256(abi.encodePacked("ICHI V1 VoterRoll Implementation"));
    bytes32 constant COMPONENT_FACTORY = keccak256(abi.encodePacked("ICHI OneToken Factory"));
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/common/ICHIModuleCommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;




abstract contract ICHIModuleCommon is IModule, ICHICommon {
    
    ModuleType public immutable override moduleType;
    string public override moduleDescription;
    address public immutable override oneTokenFactory;

    event ModuleDeployed(address sender, ModuleType moduleType, string description);
    event DescriptionUpdated(address sender, string description);
   
    modifier onlyKnownToken {
        require(IOneTokenFactory(oneTokenFactory).isOneToken(msg.sender), "ICHIModuleCommon: msg.sender is not a known oneToken");
        _;
    }
    
    modifier onlyTokenOwner (address oneToken) {
        require(msg.sender == IOneTokenV1Base(oneToken).owner(), "ICHIModuleCommon: msg.sender is not oneToken owner");
        _;
    }

    modifier onlyModuleOrFactory {
        if(!IOneTokenFactory(oneTokenFactory).isModule(msg.sender)) {
            require(msg.sender == oneTokenFactory, "ICHIModuleCommon: msg.sender is not module owner, token factory or registed module");
        }
        _;
    }
    
    /**
     @notice modules are bound to the factory at deployment time
     @param oneTokenFactory_ factory to bind to
     @param moduleType_ type number helps prevent governance errors
     @param description_ human-readable, descriptive only
     */    
    constructor (address oneTokenFactory_, ModuleType moduleType_, string memory description_) {
        require(oneTokenFactory_ != NULL_ADDRESS, "ICHIModuleCommon: oneTokenFactory cannot be empty");
        require(bytes(description_).length > 0, "ICHIModuleCommon: description cannot be empty");
        oneTokenFactory = oneTokenFactory_;
        moduleType = moduleType_;
        moduleDescription = description_;
        emit ModuleDeployed(msg.sender, moduleType_, description_);
    }

    /**
     @notice set a module description
     @param description new module desciption
     */
    function updateDescription(string memory description) external onlyOwner override {
        moduleDescription = description;
        emit DescriptionUpdated(msg.sender, description);
    }  
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/oracle/OracleCommon.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


abstract contract OracleCommon is IOracle, ICHIModuleCommon {

    bytes32 constant public override MODULE_TYPE = keccak256(abi.encodePacked("ICHI V1 Oracle Implementation"));
    address public override indexToken;

    event OracleDeployed(address sender, string description, address indexToken);
    event OracleInitialized(address sender, address baseToken, address indexToken);
    event OracleUpdated(address sender);
    
    /**
     @notice records the oracle description and the index that will be used for all quotes
     @dev oneToken implementations can share oracles
     @param description_ all modules have a description. No processing or validation. 
     */
    constructor(address oneTokenFactory_, string memory description_, address indexToken_) 
        ICHIModuleCommon(oneTokenFactory_, ModuleType.Oracle, description_) 
    { 
        indexToken = indexToken_;
        emit OracleDeployed(msg.sender, description_, indexToken_);
    }

    /**
     @notice oneTokens can share Oracles. Oracles must be re-initializable. They are initialized from the Factory.
     */
    function init(address baseToken) external onlyModuleOrFactory virtual override {
        emit OracleInitialized(msg.sender, baseToken, indexToken);
    }

}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Ichi/ichi-oneToken-09fca7431a18028779d36427ab3ccdf947e43d40/contracts/oracle/composite/ICHICompositeOracle.sol

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.7.6;


/**
 @notice Relies on external Oracles using any price quote methodology.
 */

contract ICHICompositeOracle is OracleCommon {

    address[] public oracleContracts;
    address[] public interimTokens;

    /**
     @notice addresses and oracles define a chain of currency conversions (e.g. through ETH) that will be executed in order of declation
     @dev output of oracles is used as input for the next oracle. 
     @param description_ human-readable name has no bearing on internal logic
     @param indexToken_ a registered usdToken to use for quote indexed
     @param oracles_ a sequential list of unregisted contracts that support the IOracle interface and return quotes in any currency
     */
    constructor(address oneTokenFactory_, string memory description_, address indexToken_, address[] memory interimTokens_, address[] memory oracles_)
        OracleCommon(oneTokenFactory_, description_, indexToken_)
    {
        require(interimTokens_.length == oracles_.length, 'ICHICompositeOracle: unequal interimTokens and Oracles list lengths');
        oracleContracts = oracles_;
        interimTokens = interimTokens_;
        indexToken = indexToken_;
    }

    /**
     @notice intialization is called when the factory assigns an oracle to an asset
     @dev there is nothing to do. Deploy separate instances configured for distinct baseTokens
     */
    function init(address baseToken) external onlyModuleOrFactory override {
        for(uint i=0; i<oracleContracts.length; i++) {
            IOracle(oracleContracts[i]).init(interimTokens[i]);
        }
        emit OracleInitialized(msg.sender, baseToken, indexToken);
    }

    /**
     @notice update is called when a oneToken wants to persist observations
     @dev chain length is constrained by gas
     */
    function update(address /* token */) external override {
        for(uint i=0; i<oracleContracts.length; i++) {
            IOracle(oracleContracts[i]).update(interimTokens[i]);
        }
        // no event, for gas optimization
    }

    /**
     @notice returns equivalent amount of index tokens for an amount of baseTokens and volatility metric
     @dev volatility is calculated by the final oracle
     */
    function read(address /* token */, uint amount) public view override returns(uint amountOut, uint volatility) {
        amountOut = amount;
        for(uint i=0; i<oracleContracts.length; i++) {
            ( amountOut, volatility ) = IOracle(oracleContracts[i]).read(interimTokens[i], amountOut);
        }
    }

    /**
     @notice returns the tokens needed to reach a target usd value
     */
    function amountRequired(address /* token */, uint amountUsd) external view override returns(uint tokens, uint volatility) {
        /// @notice it is always 1:1 with no volatility
        this; // silence visibility warning
        tokens = amountUsd;
        volatility = 0;
    }
}
