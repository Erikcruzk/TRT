// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/VersionedInitializable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title VersionedInitializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 *
 * @author Aave, SIGH Finance, inspired by the OpenZeppelin Initializable contract
 */
abstract contract VersionedInitializable {
    /**
   * @dev Indicates that the contract has been initialized.
   */
    uint256 private lastInitializedRevision = 0;

    /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
    bool private initializing;

    /**
   * @dev Modifier to use in the initializer function of a contract.
   */
    modifier initializer() {
        uint256 revision = getRevision();
        require(initializing || isConstructor() || revision > lastInitializedRevision, "Contract instance has already been initialized");

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            lastInitializedRevision = revision;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev returns the revision number of the contract.
    /// Needs to be defined in the inherited class as a constant.
    function getRevision() internal virtual pure returns(uint256);


    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        //solium-disable-next-line
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/Proxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title Proxy
 * @dev Implements delegation of calls to other contracts, with proper
 * forwarding of return values and bubbling of failures.
 * It defines a fallback function that delegates all calls to the address
 * returned by the abstract _implementation() internal function.
 */
abstract contract Proxy {
  /**
   * @dev Fallback function.
   * Implemented entirely in `_fallback`.
   */
  fallback() external payable {
    _fallback();
  }

  /**
   * @return The Address of the implementation.
   */
  function _implementation() internal virtual view returns (address);

  /**
   * @dev Delegates execution to an implementation contract.
   * This is a low level function that doesn't return to its internal call site.
   * It will return to the external caller whatever the implementation returns.
   * @param implementation Address to delegate.
   */
  function _delegate(address implementation) internal {
    //solium-disable-next-line
    assembly {
      // Copy msg.data. We take full control of memory in this inline assembly
      // block because it will not return to Solidity code. We overwrite the
      // Solidity scratch pad at memory position 0.
      calldatacopy(0, 0, calldatasize())

      // Call the implementation.
      // out and outsize are 0 because we don't know the size yet.
      let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

      // Copy the returned data.
      returndatacopy(0, 0, returndatasize())

      switch result
        // delegatecall returns 0 on error.
        case 0 {
          revert(0, returndatasize())
        }
        default {
          return(0, returndatasize())
        }
    }
  }

  /**
   * @dev Function that is run as the first thing in the fallback function.
   * Can be redefined in derived contracts to add functionality.
   * Redefinitions must call super._willFallback().
   */
  function _willFallback() internal virtual {}

  /**
   * @dev fallback implementation.
   * Extracted to enable manual triggering.
   */
  function _fallback() internal {
    _willFallback();
    _delegate(_implementation());
  }
  
   /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
     * is empty.
     */
    receive () external payable {
        _fallback();
    }  
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/BaseUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/**
 * @title BaseUpgradeabilityProxy
 * @dev This contract implements a proxy that allows to change the
 * implementation address to which it will delegate.
 * Such a change is called an implementation upgrade.
 */
contract BaseUpgradeabilityProxy is Proxy {
    /**
   * @dev Emitted when the implementation is upgraded.
   * @param implementation Address of the new implementation.
   */
    event Upgraded(address indexed implementation);

    /**
   * @dev Storage slot with the address of the current implementation.
   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is validated in the constructor.
   */
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
   * @dev Returns the current implementation.
   * @return impl Address of the current implementation
   */
    function _implementation() internal view override returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        //solium-disable-next-line
        assembly {
            impl := sload(slot)
        }
    }

    /**
   * @dev Upgrades the proxy to a new implementation.
   * @param newImplementation Address of the new implementation.
   */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
   * @dev Sets the implementation address of the proxy.
   * @param newImplementation Address of the new implementation.
   */
    function _setImplementation(address newImplementation) internal {
        require( Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
        bytes32 slot = IMPLEMENTATION_SLOT;

        //solium-disable-next-line
        assembly {
            sstore(slot, newImplementation)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/UpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title UpgradeabilityProxy
 * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
 * implementation and init data.
 */
contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
    /**
   * @dev Contract constructor.
   * @param _logic Address of the initial implementation.
   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
   */
    constructor(address _logic, bytes memory _data) payable {
        assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        _setImplementation(_logic);
        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/BaseAdminUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

/**
 * @title BaseAdminUpgradeabilityProxy
 * @dev This contract combines an upgradeability proxy with an authorization
 * mechanism for administrative tasks.
 * All external functions in this contract must be guarded by the
 * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
 * feature proposal that would enable this to be done automatically.
 */
contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
  /**
   * @dev Emitted when the administration has been transferred.
   * @param previousAdmin Address of the previous admin.
   * @param newAdmin Address of the new admin.
   */
  event AdminChanged(address previousAdmin, address newAdmin);

  /**
   * @dev Storage slot with the admin of the contract.
   * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
   * validated in the constructor.
   */
  bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

  /**
   * @dev Modifier to check whether the `msg.sender` is the admin.
   * If it is, it will run the function. Otherwise, it will delegate the call
   * to the implementation.
   */
  modifier ifAdmin() {
    if (msg.sender == _admin()) {
      _;
    } else {
      _fallback();
    }
  }

  /**
   * @return The address of the proxy admin.
   */
  function admin() external ifAdmin returns (address) {
    return _admin();
  }

  /**
   * @return The address of the implementation.
   */
  function implementation() external ifAdmin returns (address) {
    return _implementation();
  }

  /**
   * @dev Changes the admin of the proxy.
   * Only the current admin can call this function.
   * @param newAdmin Address to transfer proxy administration to.
   */
  function changeAdmin(address newAdmin) external ifAdmin {
    require(newAdmin != address(0), 'Cannot change the admin of a proxy to the zero address');
    emit AdminChanged(_admin(), newAdmin);
    _setAdmin(newAdmin);
  }

  /**
   * @dev Upgrade the backing implementation of the proxy.
   * Only the admin can call this function.
   * @param newImplementation Address of the new implementation.
   */
  function upgradeTo(address newImplementation) external ifAdmin {
    _upgradeTo(newImplementation);
  }

  /**
   * @dev Upgrade the backing implementation of the proxy and call a function
   * on the new implementation.
   * This is useful to initialize the proxied contract.
   * @param newImplementation Address of the new implementation.
   * @param data Data to send as msg.data in the low level call.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   */
  function upgradeToAndCall(address newImplementation, bytes calldata data)
    external
    payable
    ifAdmin
  {
    _upgradeTo(newImplementation);
    (bool success, ) = newImplementation.delegatecall(data);
    require(success);
  }

  /**
   * @return adm The admin slot.
   */
  function _admin() internal view returns (address adm) {
    bytes32 slot = ADMIN_SLOT;
    //solium-disable-next-line
    assembly {
      adm := sload(slot)
    }
  }

  /**
   * @dev Sets the address of the proxy admin.
   * @param newAdmin Address of the new proxy admin.
   */
  function _setAdmin(address newAdmin) internal {
    bytes32 slot = ADMIN_SLOT;
    //solium-disable-next-line
    assembly {
      sstore(slot, newAdmin)
    }
  }

  /**
   * @dev Only fall back when the sender is not the admin.
   */
  function _willFallback() internal virtual override {
    require(msg.sender != _admin(), 'Cannot call fallback function from the proxy admin');
    super._willFallback();
  }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/InitializableUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title InitializableUpgradeabilityProxy
 * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing implementation and init data.
 */
contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
    
    /**
   * @dev Contract initializer.
   * @param _logic Address of the initial implementation.
   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
   */
    function initialize(address _logic, bytes memory _data) public payable {
        require(_implementation() == address(0));
        assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        _setImplementation(_logic);
        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/InitializableAdminUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/**
 * @title InitializableAdminUpgradeabilityProxy
 * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for
 * initializing the implementation, admin, and init data.
 */
contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
  /**
   * Contract initializer.
   * @param logic address of the initial implementation.
   * @param admin Address of the proxy administrator.
   * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
   */
  function initialize(
    address logic,
    address admin,
    bytes memory data
  ) public payable {
    require(_implementation() == address(0));
    InitializableUpgradeabilityProxy.initialize(logic, data);
    assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
    _setAdmin(admin);
  }

  /**
   * @dev Only fall back when the sender is not the admin.
   */
  function _willFallback() internal override(BaseAdminUpgradeabilityProxy, Proxy) {
    BaseAdminUpgradeabilityProxy._willFallback();
  }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/GlobalAddressesProvider/IGlobalAddressesProvider.sol

// SPDX-License-Identifier: agpl-3.0

pragma solidity ^0.7.0;

/**
@title GlobalAddressesProvider interface
@notice provides the interface to fetch the LendingPoolCore address
 */

interface IGlobalAddressesProvider  {

// ########################################################################################
// #########  PROTOCOL MANAGERS ( LendingPool Manager and SighFinance Manager ) ###########
// ########################################################################################

    function getLendingPoolManager() external view returns (address);
    function getPendingLendingPoolManager() external view returns (address);

    function setPendingLendingPoolManager(address _pendinglendingPoolManager) external;
    function acceptLendingPoolManager() external;

    function getSIGHFinanceManager() external view returns (address);
    function getPendingSIGHFinanceManager() external view returns (address);

    function setPendingSIGHFinanceManager(address _PendingSIGHFinanceManager) external;
    function acceptSIGHFinanceManager() external;

// #########################################################################
// ####___________ LENDING POOL PROTOCOL CONTRACTS _____________############
// ########## 1. LendingPoolConfigurator (Upgradagble) #####################
// ########## 2. LendingPoolCore (Upgradagble) #############################
// ########## 3. LendingPool (Upgradagble) #################################
// ########## 4. LendingPoolDataProvider (Upgradagble) #####################
// ########## 5. LendingPoolParametersProvider (Upgradagble) ###############
// ########## 6. FeeProvider (Upgradagble) #################################
// ########## 7. LendingPoolLiqAndLoanManager (Directly Changed) ##########
// ########## 8. LendingRateOracle (Directly Changed) ######################
// #########################################################################

    function getLendingPoolConfigurator() external view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) external;

    function getLendingPool() external view returns (address);
    function setLendingPoolImpl(address _pool) external;

    function getFeeProvider() external view returns (address);
    function setFeeProviderImpl(address _feeProvider) external;

    function getLendingPoolLiqAndLoanManager() external view returns (address);
    function setLendingPoolLiqAndLoanManager(address _manager) external;

    function getLendingRateOracle() external view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) external;

// ####################################################################################
// ####___________ SIGH FINANCE RELATED CONTRACTS _____________########################
// ########## 1. SIGH (Initialized only once) #########################################
// ########## 2. SIGH Finance Configurator (Upgradagble) ################################
// ########## 2. SIGH Speed Controller (Initialized only once) ########################
// ########## 3. SIGH Treasury (Upgradagble) ###########################################
// ########## 4. SIGH Mechanism Handler (Upgradagble) ###################################
// ########## 5. SIGH Staking (Upgradagble) ###################################
// ####################################################################################

    function getSIGHAddress() external view returns (address);
    function setSIGHAddress(address sighAddress) external;

    function getSIGHNFTBoosters() external view returns (address) ;
    function setSIGHNFTBoosters(address _SIGHNFTBooster) external ;

    function getSIGHFinanceConfigurator() external view returns (address);
    function setSIGHFinanceConfiguratorImpl(address sighAddress) external;

    function getSIGHSpeedController() external view returns (address);
    function setSIGHSpeedController(address _SIGHSpeedController) external;

    function getSIGHTreasury() external view returns (address);                                 //  ADDED FOR SIGH FINANCE
    function setSIGHTreasuryImpl(address _SIGHTreasury) external;                                   //  ADDED FOR SIGH FINANCE

    function getSIGHVolatilityHarvester() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHVolatilityHarvesterImpl(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

    function getSIGHStaking() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHStaking(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

// #######################################################
// ####___________ PRICE ORACLE CONTRACT _____________####
// ####_____ SIGH FINANCE FEE COLLECTOR : ADDRESS ____####
// ####_____   SIGH PAYCOLLECTOR : ADDRESS        ____####
// #######################################################

    function getPriceOracle() external view returns (address);
    function setPriceOracle(address _priceOracle) external;


    // SIGH FINANCE FEE COLLECTOR - DEPOSIT / BORROWING / FLASH LOAN FEE TRANSERRED TO THIS ADDRESS
    function getSIGHFinanceFeeCollector() external view returns (address) ;
    function setSIGHFinanceFeeCollector(address _feeCollector) external ;

    function getSIGHPAYAggregator() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHPAYAggregator(address _SIGHPAYAggregator) external;             //  ADDED FOR SIGH FINANCE

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/types/DataTypes.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

library DataTypes {

  struct InstrumentData {

    InstrumentConfigurationMap configuration;      //stores the instrument configuration
    uint128 liquidityIndex;                     //the liquidity index. Expressed in ray
    uint128 variableBorrowIndex;                //variable borrow index. Expressed in ray

    uint128 currentLiquidityRate;               //the current supply rate. Expressed in ray
    uint128 currentVariableBorrowRate;          //the current variable borrow rate. Expressed in ray
    uint128 currentStableBorrowRate;            //the current stable borrow rate. Expressed in ray

    uint40 lastUpdateTimestamp;

    address iTokenAddress;                      //tokens addresses
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;

    address interestRateStrategyAddress;        //address of the interest rate strategy

    uint8 id;                                   //the id of the instrument. Represents the position in the list of the active instruments
    uint8 decimals;
  }

  struct InstrumentConfigurationMap {
    //bit 0-15: LTV
    //bit 16-31: Liq. threshold
    //bit 32-47: Liq. bonus
    //bit 48-55: Decimals
    //bit 56: Reserve is active
    //bit 57: reserve is frozen
    //bit 58: borrowing is enabled
    //bit 59: stable rate borrowing enabled
    //bit 60-63: reserved
    //bit 64-79: reserve factor
    uint256 data;
  }

  struct UserConfigurationMap {
    uint256 data;
  }

  enum InterestRateMode {NONE, STABLE, VARIABLE}
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ILendingPool.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;


interface ILendingPool {

    //######################################
    //############### EVENTS ###############
    //######################################

  /**
   * @dev Emitted on deposit()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   **/
  event Deposit(address indexed instrument, address indexed user,uint256 amount);

  /**
   * @dev Emitted on withdraw()
   * @param instrument The address of the underlyng asset being withdrawn
   * @param user The address initiating the withdrawal, owner of iTokens
   * @param to Address that will receive the underlying
   * @param amount The amount to be withdrawn
   **/
  event Withdraw(address indexed instrument, address indexed user, address indexed to, uint256 amount);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrument The address of the underlying asset being borrowed
   * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
   * initiator of the transaction on flashLoan()
   * @param onBehalfOf The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
   * @param borrowRate The numeric rate at which the user has borrowed
   **/
  event Borrow(address indexed instrument, address user, address indexed onBehalfOf, uint256 amount, uint256 borrowRateMode, uint256 borrowRate);

  /**
   * @dev Emitted on repay()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The beneficiary of the repayment, getting his debt reduced
   * @param repayer The address of the user initiating the repay(), providing the funds
   * @param loanRepaid The amount repaid
   * @param totalFeeRepaid The total Fee repaid
   **/
  event Repay(address indexed instrument, address indexed user, address indexed repayer, uint256 loanRepaid, uint256 totalFeeRepaid);

  /**
   * @dev Emitted on swapBorrowRateMode()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address of the user swapping his rate mode
   * @param rateMode The rate mode that the user wants to swap to
   **/
  event Swap(address indexed instrument, address indexed user, uint256 rateMode);

  /**
   * @dev Emitted on setUserUseInstrumentAsCollateral()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address of the user enabling the usage as collateral
   **/
  event InstrumentUsedAsCollateralEnabled(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on setUserUseInstrumentAsCollateral()
   * @param instrument The address of the underlying asset
   * @param user The address of the user enabling the usage as collateral
   **/
  event InstrumentUsedAsCollateralDisabled(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on rebalanceStableBorrowRate()
   * @param instrument The address of the underlying asset
   * @param user The address of the user for which the rebalance has been executed
   **/
  event RebalanceStableBorrowRate(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on flashLoan()
   * @param target The address of the flash loan receiver contract
   * @param initiator The address initiating the flash loan
   * @param asset The address of the asset being flash borrowed
   * @param amount The amount flash borrowed
   * @param premium The fee flash borrowed
   * @param boosterID  The boosterID of the Booster used to get a discount on the Fee
   **/
  event FlashLoan(address indexed target, address indexed initiator, address indexed asset, uint256 amount, uint256 premium, uint16 boosterID );

  event Paused();
  event Unpaused();

  /**
   * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
   * LendingPoolCollateral manager using a DELEGATECALL
   * This allows to have the events in the generated ABI for LendingPool.
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
   * @param liquidator The address of the liquidator
   * @param receiveIToken `true` if the liquidators wants to receive the collateral iTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  event LiquidationCall(address indexed collateralAsset, address indexed debtAsset, address indexed user, uint256 debtToCover, uint256 liquidatedCollateralAmount, address liquidator, bool receiveIToken);

  /**
   * @dev Emitted when the state of a instrument is updated. NOTE: This event is actually declared
   * in the InstrumentLogic library and emitted in the updateInterestRates() function. Since the function is internal,
   * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it gets added to the LendingPool ABI
   * @param instrument The address of the underlying asset
   * @param liquidityRate The new liquidity rate
   * @param stableBorrowRate The new stable borrow rate
   * @param variableBorrowRate The new variable borrow rate
   * @param liquidityIndex The new liquidity index
   * @param variableBorrowIndex The new variable borrow index
   **/
  event InstrumentDataUpdated(address indexed instrument, uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate, uint256 liquidityIndex, uint256 variableBorrowIndex);

  /**
   * @dev Emitted on deposit()
   * @param instrumentAddress The address of the underlying asset 
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/
  event depositFeeDeducted(address instrumentAddress, address user, uint amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);
  
  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/  
  event borrowFeeUpdated(address instrumentAddress, address user, uint256 amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address repaying the amount
   * @param onBehalfOf The user whose debt is being repaid
   * @param amount The amount borrowed out
   * @param platformFeePay Platform Fee paid
   * @param reserveFeePay Reserve Fee paid
   **/  
  event feeRepaid(address instrumentAddress, address user, address onBehalfOf, uint256 amount, uint256 platformFeePay, uint256 reserveFeePay);



    //#########################################
    //############### FUNCTIONS ###############
    //#########################################



  function refreshConfig() external;

  /**
   * @dev Deposits an `amount` of underlying asset, receiving in return overlying iTokens.
   * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
   * @param asset The address of the underlying asset to deposit
   * @param amount The amount to be deposited
   * @param boosterID of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   **/
  function deposit(address asset, uint256 amount, uint16 boosterID) external;

  /**
   * @dev Withdraws an `amount` of underlying asset, burning the equivalent iTokens owned
   * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
   * @param asset The address of the underlying asset to withdraw
   * @param amount The underlying amount to be withdrawn
   *   - Send the value type(uint256).max in order to withdraw the whole iToken balance
   * @param to Address that will receive the underlying, same as msg.sender if the user
   *   wants to receive it on his own wallet, or a different address if the beneficiary is a
   *   different wallet
   * @return The final amount withdrawn
   **/
  function withdraw(address asset, uint256 amount, address to) external returns (uint256);

  /**
   * @dev Allows users to borrow a specific `amount` of the underlying asset, provided that the borrower
   * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
   * corresponding debt token (StableDebtToken or VariableDebtToken)
   * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
   *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
   * @param asset The address of the underlying asset to borrow
   * @param amount The amount to be borrowed
   * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
   * @param boosterID of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
   * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
   * if he has been given credit delegation allowance
   **/
  function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 boosterID, address onBehalfOf) external;

  /**
   * @notice Repays a borrowed `amount`, burning the equivalent debt tokens owned
   * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
   * @param asset The address of the borrowed underlying asset previously borrowed
   * @param amount The amount to repay
   * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
   * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
   * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
   * user calling the function if he wants to reduce/remove his own debt, or the address of any other
   * other borrower whose debt should be removed
   * @return The final amount repaid
   **/
  function repay(address asset, uint256 amount, uint256 rateMode, address onBehalfOf) external returns (uint256);

  /**
   * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
   * @param asset The address of the underlying asset borrowed
   * @param rateMode The rate mode that the user wants to swap to
   **/
  function swapBorrowRateMode(address asset, uint256 rateMode) external;

  /**
   * @dev Rebalances the stable interest rate of a user to the current stable rate defined
   * - Users can be rebalanced if the following conditions are satisfied:
   *     1. Usage ratio is above 95%
   *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
   *        borrowed at a stable rate and depositors are not earning enough
   * @param asset The address of the underlying asset borrowed
   * @param user The address of the user to be rebalanced
   **/
  function rebalanceStableBorrowRate(address asset, address user) external;

  /**
   * @dev Allows depositors to enable/disable a specific deposited asset as collateral
   * @param asset The address of the underlying asset deposited
   * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
   **/
  function setUserUseInstrumentAsCollateral(address asset, bool useAsCollateral) external;

  /**
   * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
   * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
   *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param receiveIToken `true` if the liquidators wants to receive the collateral iTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  function liquidationCall(address collateralAsset, address debtAsset, address user, uint256 debtToCover, bool receiveIToken) external;

  /**
   * @dev Allows smartcontracts to access the liquidity of the pool within one transaction, as long as the amount taken plus a fee is returned.
   * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
   * @param asset The addresses of the assets being flash-borrowed
   * @param amount The amounts amounts being flash-borrowed
   * @param _params Variadic packed params to pass to the receiver as extra information
   * @param boosterId of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   **/
  function flashLoan( address receiverAddress, address asset, uint256 amount, bytes calldata _params, uint16 boosterId) external;

  /**
   * @dev Returns the user account data across all the instruments
   * @param user The address of the user
   * @return totalCollateralUSD the total collateral in USD of the user
   * @return totalDebtUSD the total debt in USD of the user
   * @return availableBorrowsUSD the borrowing power left of the user
   * @return currentLiquidationThreshold the liquidation threshold of the user
   * @return ltv the loan to value of the user
   * @return healthFactor the current health factor of the user
   **/
  function getUserAccountData(address user) external view returns (
      uint256 totalCollateralUSD,
      uint256 totalDebtUSD,
      uint256 availableBorrowsUSD,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );

  function getInstrumentConfiguration(address asset) external view returns ( DataTypes.InstrumentConfigurationMap memory );

  function initInstrument(address asset,address iTokenAddress, address stableDebtAddress, address variableDebtAddress, address interestRateStrategyAddress) external;

  function setInstrumentInterestRateStrategyAddress(address instrument, address rateStrategyAddress) external;

  function setConfiguration(address instrument, uint256 configuration) external;



  /**
   * @dev Returns the configuration of the user across all the instruments
   * @param user The user address
   * @return The configuration of the user
   **/
  function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);

  /**
   * @dev Returns the normalized income normalized income of the instrument
   * @param asset The address of the underlying asset
   * @return The instrument's normalized income
   */
  function getInstrumentNormalizedIncome(address asset) external view returns (uint256);

  /**
   * @dev Returns the normalized variable debt per unit of asset
   * @param asset The address of the underlying asset
   * @return The instrument normalized variable debt
   */
  function getInstrumentNormalizedVariableDebt(address asset) external view returns (uint256);

  /**
   * @dev Returns the state and configuration of the instrument
   * @param asset The address of the underlying asset
   * @return The state of the instrument
   **/
  function getInstrumentData(address asset) external view returns (DataTypes.InstrumentData memory);

  function finalizeTransfer(address asset, address from, address to, uint256 amount, uint256 balanceFromAfter, uint256 balanceToBefore) external;

  function getInstrumentsList() external view returns (address[] memory);

  function setPause(bool val) external;



}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20Detailed.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @dev Optional functions from the ERC20 standard.
 */
interface IERC20Detailed {


    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory) ;

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory) ;

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() external view returns (uint8) ;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ITokenConfiguration.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title ITokenConfiguration
 * @author Aave
 * @dev Common interface between aTokens and debt tokens to fetch the
 * token configuration
 **/
interface ITokenConfiguration {
  function UNDERLYING_ASSET_ADDRESS() external view returns (address);

  function POOL() external view returns (address);

  function balanceOf(address user) external view returns (uint);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/PercentageMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title PercentageMath library
 * @author Aave
 * @notice Provides functions to perform percentage calculations
 * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
 * @dev Operations are rounded half up
 **/

library PercentageMath {
    uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
    uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;

    /**
    * @dev Executes a percentage multiplication
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return The percentage of value
    **/
    function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
        if (value == 0 || percentage == 0) {
            return 0;
        }

        require(value <= (type(uint256).max - HALF_PERCENT) / percentage, "Percentage Math : Multiplication error" );
        return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
    }

    /**
    * @dev Executes a percentage division
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return The value divided the percentage
    **/
    function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
        require(percentage != 0, "MATH DIVISION BY ZERO");
        uint256 halfPercentage = percentage / 2;

        require( value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR, "Percentage Math : Division error" );
        return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/configuration/InstrumentConfiguration.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

  /**
  * @title InstrumentConfiguration library
  * @author Aave
  * @notice Implements the bitmap logic to handle the instrument configuration
  */
  library InstrumentConfiguration {

      uint256 constant LTV_MASK =                   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000; // prettier-ignore
      uint256 constant LIQUIDATION_THRESHOLD_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF; // prettier-ignore
      uint256 constant LIQUIDATION_BONUS_MASK =     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF; // prettier-ignore
      uint256 constant DECIMALS_MASK =              0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF; // prettier-ignore
      uint256 constant ACTIVE_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant FROZEN_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant BORROWING_MASK =             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant STABLE_BORROWING_MASK =      0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant RESERVE_FACTOR_MASK =        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF; // prettier-ignore

      /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
      uint256 constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
      uint256 constant LIQUIDATION_BONUS_START_BIT_POSITION = 32;
      uint256 constant INSTRUMENT_DECIMALS_START_BIT_POSITION = 48;
      uint256 constant IS_ACTIVE_START_BIT_POSITION = 56;
      uint256 constant IS_FROZEN_START_BIT_POSITION = 57;
      uint256 constant BORROWING_ENABLED_START_BIT_POSITION = 58;
      uint256 constant STABLE_BORROWING_ENABLED_START_BIT_POSITION = 59;
      uint256 constant RESERVE_FACTOR_START_BIT_POSITION = 64;

      uint256 constant MAX_VALID_LTV = 65535;
      uint256 constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
      uint256 constant MAX_VALID_LIQUIDATION_BONUS = 65535;
      uint256 constant MAX_VALID_DECIMALS = 255;
      uint256 constant MAX_VALID_RESERVE_FACTOR = 65535;

    /**
    * @dev Sets the Loan to Value of the instrument
    * @param self The instrument configuration
    * @param ltv the new ltv
    **/
    function setLtv(DataTypes.InstrumentConfigurationMap memory self, uint256 ltv) internal pure {
      require(ltv <= MAX_VALID_LTV, "LTV value needs to be less than 65535");

      self.data = (self.data & LTV_MASK) | ltv;
    }

    /**
    * @dev Gets the Loan to Value of the instrument
    * @param self The instrument configuration
    * @return The loan to value
    **/
    function getLtv(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return self.data & ~LTV_MASK;
    }

    /**
    * @dev Sets the liquidation threshold of the instrument
    * @param self The instrument configuration
    * @param threshold The new liquidation threshold
    **/
    function setLiquidationThreshold(DataTypes.InstrumentConfigurationMap memory self, uint256 threshold) internal pure {
      require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, "Liquidation Threshold value needs to be less than 65535");
      self.data = (self.data & LIQUIDATION_THRESHOLD_MASK) | (threshold << LIQUIDATION_THRESHOLD_START_BIT_POSITION);
    }

    /**
    * @dev Gets the liquidation threshold of the instrument
    * @param self The instrument configuration
    * @return The liquidation threshold
    **/
    function getLiquidationThreshold(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
    }

    /**
    * @dev Sets the liquidation bonus of the instrument
    * @param self The instrument configuration
    * @param bonus The new liquidation bonus
    **/
    function setLiquidationBonus(DataTypes.InstrumentConfigurationMap memory self, uint256 bonus) internal pure {
      require(bonus <= MAX_VALID_LIQUIDATION_BONUS, "Liquidation Bonus value needs to be less than 65535");
      self.data = (self.data & LIQUIDATION_BONUS_MASK) | (bonus << LIQUIDATION_BONUS_START_BIT_POSITION);
    }

    /**
    * @dev Gets the liquidation bonus of the instrument
    * @param self The instrument configuration
    * @return The liquidation bonus
    **/
    function getLiquidationBonus(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
    }

    /**
    * @dev Sets the decimals of the underlying asset of the instrument
    * @param self The instrument configuration
    * @param decimals The decimals
    **/
    function setDecimals(DataTypes.InstrumentConfigurationMap memory self, uint256 decimals) internal pure {
      require(decimals <= MAX_VALID_DECIMALS, "Decimals value needs to be less than 255");
      self.data = (self.data & DECIMALS_MASK) | (decimals << INSTRUMENT_DECIMALS_START_BIT_POSITION);
    }

    /**
    * @dev Gets the decimals of the underlying asset of the instrument
    * @param self The instrument configuration
    * @return The decimals of the asset
    **/
    function getDecimals(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~DECIMALS_MASK) >> INSTRUMENT_DECIMALS_START_BIT_POSITION;
    }

    /**
    * @dev Sets the active state of the instrument
    * @param self The instrument configuration
    * @param active The active state
    **/
    function setActive(DataTypes.InstrumentConfigurationMap memory self, bool active) internal pure {
      self.data = (self.data & ACTIVE_MASK) | (uint256(active ? 1 : 0) << IS_ACTIVE_START_BIT_POSITION);
    }

    /**
    * @dev Gets the active state of the instrument
    * @param self The instrument configuration
    * @return The active state
    **/
    function getActive(DataTypes.InstrumentConfigurationMap storage self) internal view returns (bool) {
      return (self.data & ~ACTIVE_MASK) != 0;
    }

    /**
    * @dev Sets the frozen state of the instrument
    * @param self The instrument configuration
    * @param frozen The frozen state
    **/
    function setFrozen(DataTypes.InstrumentConfigurationMap memory self, bool frozen) internal pure {
      self.data = (self.data & FROZEN_MASK) | (uint256(frozen ? 1 : 0) << IS_FROZEN_START_BIT_POSITION);
    }

    /**
    * @dev Gets the frozen state of the instrument
    * @param self The instrument configuration
    * @return The frozen state
    **/
    function getFrozen(DataTypes.InstrumentConfigurationMap storage self) internal view returns (bool) {
      return (self.data & ~FROZEN_MASK) != 0;
    }

    /**
    * @dev Enables or disables borrowing on the instrument
    * @param self The instrument configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
    **/
    function setBorrowingEnabled(DataTypes.InstrumentConfigurationMap memory self, bool enabled) internal pure {
      self.data = (self.data & BORROWING_MASK) | (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
    }

    /**
    * @dev Gets the borrowing state of the instrument
    * @param self The instrument configuration
    * @return The borrowing state
    **/
    function getBorrowingEnabled(DataTypes.InstrumentConfigurationMap storage self) internal view returns (bool) {
      return (self.data & ~BORROWING_MASK) != 0;
    }

    /**
    * @dev Enables or disables stable rate borrowing on the instrument
    * @param self The instrument configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
    **/
    function setStableRateBorrowingEnabled(DataTypes.InstrumentConfigurationMap memory self, bool enabled) internal  pure {
      self.data =  (self.data & STABLE_BORROWING_MASK) |  (uint256(enabled ? 1 : 0) << STABLE_BORROWING_ENABLED_START_BIT_POSITION);
    }

    /**
    * @dev Gets the stable rate borrowing state of the instrument
    * @param self The instrument configuration
    * @return The stable rate borrowing state
    **/
    function getStableRateBorrowingEnabled(DataTypes.InstrumentConfigurationMap storage self)  internal  view  returns (bool) {
      return (self.data & ~STABLE_BORROWING_MASK) != 0;
    }

    /**
    * @dev Sets the reserve factor of the instrument
    * @param self The instrument configuration
    * @param reserveFactor The reserve factor
    **/
    function setReserveFactor(DataTypes.InstrumentConfigurationMap memory self, uint256 reserveFactor) internal pure {
      require(reserveFactor <= MAX_VALID_RESERVE_FACTOR, "Reserve Factor value not valid. It needs to be less than 65535");
      self.data = (self.data & RESERVE_FACTOR_MASK) | (reserveFactor << RESERVE_FACTOR_START_BIT_POSITION);
    }

    /**
    * @dev Gets the reserve factor of the instrument
    * @param self The instrument configuration
    * @return The reserve factor
    **/
    function getReserveFactor(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
    }

    /**
    * @dev Gets the configuration flags of the instrument
    * @param self The instrument configuration
    **/
    function getFlags(DataTypes.InstrumentConfigurationMap storage self)  internal  view  returns (bool isActive,bool isFrozen,bool isBorrowingEnabled ,bool isStableBorrowingEnabled) {
        uint256 dataLocal = self.data;
        isActive = (dataLocal & ~ACTIVE_MASK) != 0;
        isFrozen = (dataLocal & ~FROZEN_MASK) != 0;
        isBorrowingEnabled = (dataLocal & ~BORROWING_MASK) != 0;
        isStableBorrowingEnabled = (dataLocal & ~STABLE_BORROWING_MASK) != 0;
    }

    /**
    * @dev Gets the configuration parameters of the instrument reserve
    * @param self The instrument configuration
    **/
    function getParams(DataTypes.InstrumentConfigurationMap storage self)  internal view  returns ( uint256 ltv,uint256 liquidation_threshold, uint256 liquidation_bonus , uint256 decimals, uint256 reserveFactor) {
      uint256 dataLocal = self.data;
      ltv = dataLocal & ~LTV_MASK;
      liquidation_threshold = (dataLocal & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
      liquidation_bonus = (dataLocal & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
      decimals = (dataLocal & ~DECIMALS_MASK) >> INSTRUMENT_DECIMALS_START_BIT_POSITION;
      reserveFactor = (dataLocal & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
    }

    /**
    * @dev Gets the configuration paramters of the instrument from a memory object
    * @param self The instrument configuration
    **/
    function getParamsMemory(DataTypes.InstrumentConfigurationMap memory self)  internal pure returns ( uint256 ltv,uint256 liquidation_threshold, uint256 liquidation_bonus , uint256 decimals, uint256 reserveFactor) {
      ltv = self.data & ~LTV_MASK;
      liquidation_threshold = (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
      liquidation_bonus = (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
      decimals = (self.data & ~DECIMALS_MASK) >> INSTRUMENT_DECIMALS_START_BIT_POSITION;
      reserveFactor = (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
    }

    /**
    * @dev Gets the configuration flags of the instrument from a memory object
    * @param self The instrument configuration
    **/
    function getFlagsMemory(DataTypes.InstrumentConfigurationMap memory self) internal pure returns (bool isActive,bool isFrozen,bool isBorrowingEnabled ,bool isStableBorrowingEnabled) {
        isActive = (self.data & ~ACTIVE_MASK) != 0;
        isFrozen = (self.data & ~FROZEN_MASK) != 0;
        isBorrowingEnabled = (self.data & ~BORROWING_MASK) != 0;
        isStableBorrowingEnabled = (self.data & ~STABLE_BORROWING_MASK) != 0;
    }

  }

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ISIGHHarvestDebtToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface ISIGHHarvestDebtToken {

  function setSIGHHarvesterAddress(address _SIGHHarvesterAddress) external  returns (bool) ;

  function claimSIGH(address[] memory users) external  ;
  function claimMySIGH() external ;

  function getSighAccured(address user)  external view  returns (uint) ;

//  ############################################
//  ######### FUNCTIONS RELATED TO FEE #########
//  ############################################

  function updatePlatformFee(address user, uint platformFeeIncrease, uint platformFeeDecrease) external  ;
  function updateReserveFee(address user, uint reserveFeeIncrease, uint reserveFeeDecrease) external  ;

  function getPlatformFee(address user) external view returns (uint) ;
  function getReserveFee(address user)  external view returns (uint) ;

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ISIGHVolatilityHarvesterLendingPool.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Distribution Handler Contract
 * @notice Handles the SIGH Loss Minimizing Mechanism for the Lending Protocol
 * @dev Accures SIGH for the supported markets based on losses made every 24 hours, along with Staking speeds. This accuring speed is updated every hour
 * @author SIGH Finance
 */

interface ISIGHVolatilityHarvesterLendingPool {

    function addInstrument( address _instrument, address _iTokenAddress,address _stableDebtToken,address _variableDebtToken, address _sighStreamAddress, uint8 _decimals ) external returns (bool);   // onlyLendingPool
    function updateSIGHSupplyIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPool
    function updateSIGHBorrowIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPool


}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/helpers/Errors.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Errors library
 * @author Aave
 * @notice Defines the error messages emitted by the different contracts of the Aave protocol
 * @dev Error messages prefix glossary:
 *  - VL = ValidationLogic
 *  - MATH = Math libraries
 *  - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
 *  - AT = AToken
 *  - SDT = StableDebtToken
 *  - VDT = VariableDebtToken
 *  - LP = LendingPool
 *  - LPAPR = LendingPoolAddressesProviderRegistry
 *  - LPC = LendingPoolConfiguration
 *  - RL = ReserveLogic
 *  - LPCM = LendingPoolCollateralManager
 *  - P = Pausable
 */
library Errors {
  //common errors

  string public constant MAX_INST_LIMIT = '1';
  string public constant PAUSED = '2';
  string public constant FAILED = '3';
  string public constant INVALID_RETURN = '4';
  string public constant NOT_ALLOWED = '5';
  string public constant NOT_CONTRACT = '6';
  string public constant VOL_HAR_INIT_FAIL = '7';
  string public constant IT_INIT_FAIL = '8';
  string public constant VT_INIT_FAIL = '9';
  string public constant ST_INIT_FAIL = '10';

  string public constant Already_Supported = '11';
  string public constant LR_INVALID = '12';
  string public constant SR_INVALID = '13';
  string public constant VR_INVALID = '14';

  string public constant CLI_OVRFLW = '15';
  string public constant LI_OVRFLW = '16';
  string public constant VI_OVRFLW = '17';  
  string public constant LIQUIDITY_NOT_AVAILABLE = '18'; 
  string public constant INCONCISTENT_BALANCE = '20'; 



  string public constant CALLER_NOT_POOL_ADMIN = '33'; // 'The caller must be the pool admin'
  string public constant BORROW_ALLOWANCE_NOT_ENOUGH = '59'; // User borrows on behalf, but allowance are too small

  //contract specific errors
  string public constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; // 'Health factor is not below the threshold'
  string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; // 'The collateral chosen cannot be liquidated'
  string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; // 'User did not borrow the specified currency'
  string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; // "There isn't enough liquidity available to liquidate"
  string public constant LPCM_NO_ERRORS = '46'; // 'No errors'

  enum CollateralManagerErrors {
    NO_ERROR,
    NO_COLLATERAL_AVAILABLE,
    COLLATERAL_CANNOT_BE_LIQUIDATED,
    CURRRENCY_NOT_BORROWED,
    HEALTH_FACTOR_ABOVE_THRESHOLD,
    NOT_ENOUGH_LIQUIDITY,
    NO_ACTIVE_INSTRUMENT,
    HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
    INVALID_EQUAL_ASSETS_TO_SWAP,
    FROZEN_INSTRUMENT
  }

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/LendingPoolConfigurator.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;












/**
* @title LendingPoolConfigurator contract
* @author Aave, SIGH Finance (modified by SIGH FINANCE)
* @notice Executes configuration methods on the LendingPoolCore contract. Allows to enable/disable instruments,
* and set different protocol parameters.
**/

contract LendingPoolConfigurator is VersionedInitializable  {

    using SafeMath for uint256;
    using PercentageMath for uint256;
    using InstrumentConfiguration for DataTypes.InstrumentConfigurationMap;

    IGlobalAddressesProvider public globalAddressesProvider;
    ILendingPool public pool;

    mapping (address => address) private sighHarvesterProxies;
// ######################
// ####### EVENTS #######
// ######################


    event InstrumentInitialized(address asset,address iTokenProxyAddress,address stableDebtTokenProxyAddress,address variableDebtTokenProxyAddress,address SIGHHarvesterProxyAddress,address interestRateStrategyAddress,uint8 underlyingAssetDecimals);

    event sighHarvesterImplUpdated(address asset, address newSighHarvesterImpl );
    event VariableDebtTokenUpgraded(address asset, address variableDebtProxyAddress, address variableDebtImplementation);
    event StableDebtTokenUpgraded(address asset, address stableDebtTokenProxyAddress, address stableDebtTokenImplementation);
    event ITokenUpgraded(address asset, address iTokenProxyAddress, address iTokenImplementation);

    /**
    * @dev emitted when a instrument is enabled as collateral.
    * @param _instrument the address of the instrument
    * @param _ltv the loan to value of the asset when used as collateral
    * @param _liquidationThreshold the threshold at which loans using this asset as collateral will be considered undercollateralized
    * @param _liquidationBonus the bonus liquidators receive to liquidate this asset
    **/
    event InstrumentEnabledAsCollateral(  address indexed _instrument,  uint256 _ltv,  uint256 _liquidationThreshold,  uint256 _liquidationBonus );
    event InstrumentDisabledAsCollateral(address indexed _instrument);         // emitted when a instrument is disabled as collateral

    event InstrumentDecimalsUpdated(address _instrument,uint256 decimals);
    event InstrumentCollateralParametersUpdated(address _instrument,uint256 _ltv,  uint256 _liquidationThreshold,  uint256 _liquidationBonus );

    event BorrowingOnInstrumentSwitched(address indexed _instrument, bool switch_ );
    event StableRateOnInstrumentSwitched(address indexed _instrument, bool isEnabled);          // emitted when stable rate borrowing is switched on a instrument
    event InstrumentActivationSwitched(address indexed _instrument, bool switch_ );
    event InstrumentFreezeSwitched(address indexed _instrument, bool isFreezed);                      // emitted when a instrument is freezed

    event ReserveFactorChanged(address _instrument, uint _reserveFactor);      // emitted when a _instrument interest strategy contract is updated
    event InstrumentInterestRateStrategyChanged(address _instrument, address _strategy);      // emitted when a _instrument interest strategy contract is updated
    event ProxyCreated(address instrument, address  sighStreamProxyAddress);

// #############################
// ####### PROXY RELATED #######
// #############################

    uint256 public constant CONFIGURATOR_REVISION = 0x2;

    function getRevision() internal override pure returns (uint256) {
        return CONFIGURATOR_REVISION;
    }

    function initialize(IGlobalAddressesProvider _globalAddressesProvider) public initializer {
        globalAddressesProvider = _globalAddressesProvider;
        pool = ILendingPool(globalAddressesProvider.getLendingPool());
    }

// ########################
// ####### MODIFIER #######
// ########################
    /**
    * @dev only the lending pool manager can call functions affected by this modifier
    **/
    modifier onlyLendingPoolManager {
        require( globalAddressesProvider.getLendingPoolManager() == msg.sender, "The caller must be a lending pool manager" );
        _;
    }

// ################################################################################################
// ####### INITIALIZE A NEW INSTRUMENT (Deploys a new IToken Contract for the INSTRUMENT) #########
// ################################################################################################
  /**
  * @dev Initializes an instrument reserve
  * @param iTokenImpl  The address of the iToken contract implementation
  * @param stableDebtTokenImpl The address of the stable debt token contract
  * @param variableDebtTokenImpl The address of the variable debt token contract
  * @param sighHarvesterAddressImpl The address of the SIGH Harvester contract
  * @param underlyingAssetDecimals The decimals of the reserve underlying asset
  * @param interestRateStrategyAddress The address of the interest rate strategy contract for this reserve
  **/
  function initInstrument(address iTokenImpl, address stableDebtTokenImpl, address variableDebtTokenImpl, address sighHarvesterAddressImpl, uint8 underlyingAssetDecimals, address interestRateStrategyAddress) public onlyLendingPoolManager {
    address asset = ITokenConfiguration(iTokenImpl).UNDERLYING_ASSET_ADDRESS();

    require(address(pool) == ITokenConfiguration(iTokenImpl).POOL(), "INVALID ITOKEN POOL ADDRESS");
    require(address(pool) == ITokenConfiguration(stableDebtTokenImpl).POOL(), "INVALID STABLE DEBT TOKEN POOL ADDRESS");
    require(address(pool) == ITokenConfiguration(variableDebtTokenImpl).POOL(), "INVALID VARIABLE DEBT TOKEN POOL ADDRESS");
    require(asset == ITokenConfiguration(stableDebtTokenImpl).UNDERLYING_ASSET_ADDRESS(), "INVALID STABLE DEBT TOKEN UNDERLYING ADDRESS");
    require(asset == ITokenConfiguration(variableDebtTokenImpl).UNDERLYING_ASSET_ADDRESS(), "INVALID VARIABLE DEBT TOKEN UNDERLYING ADDRESS");

    address iTokenProxyAddress = _initTokenWithProxy(iTokenImpl, underlyingAssetDecimals);                          // Create a proxy contract for IToken
    emit ITokenUpgraded(asset, iTokenProxyAddress, iTokenImpl);

    address stableDebtTokenProxyAddress = _initTokenWithProxy(stableDebtTokenImpl, underlyingAssetDecimals);        // Create a proxy contract for stable Debt Token
    emit StableDebtTokenUpgraded(asset, stableDebtTokenProxyAddress, stableDebtTokenImpl);

    address variableDebtTokenProxyAddress = _initTokenWithProxy(variableDebtTokenImpl, underlyingAssetDecimals);    // Create a proxy contract for variable Debt Token
    emit VariableDebtTokenUpgraded(asset, variableDebtTokenProxyAddress, variableDebtTokenImpl);

    address SIGHHarvesterProxyAddress = setSIGHHarvesterImplInternal(address(globalAddressesProvider),sighHarvesterAddressImpl, asset, iTokenProxyAddress, stableDebtTokenProxyAddress, variableDebtTokenProxyAddress );    // creates a Proxy Contract for the SIGH Harvester
    emit sighHarvesterImplUpdated(asset, sighHarvesterAddressImpl );

    pool.initInstrument(asset, iTokenProxyAddress, stableDebtTokenProxyAddress, variableDebtTokenProxyAddress, interestRateStrategyAddress);

    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setDecimals(underlyingAssetDecimals);
    currentConfig.setActive(true);
    currentConfig.setFrozen(false);
    pool.setConfiguration(asset, currentConfig.data);
    
    ISIGHVolatilityHarvesterLendingPool sighVolatilityHarvester = ISIGHVolatilityHarvesterLendingPool(globalAddressesProvider.getSIGHVolatilityHarvester());

    require( sighVolatilityHarvester.addInstrument( asset, iTokenProxyAddress, stableDebtTokenProxyAddress, variableDebtTokenProxyAddress, SIGHHarvesterProxyAddress, underlyingAssetDecimals ), Errors.VOL_HAR_INIT_FAIL ); // ADDED BY SIGH FINANCE
    require( ISIGHHarvestDebtToken(iTokenProxyAddress).setSIGHHarvesterAddress( SIGHHarvesterProxyAddress ), Errors.IT_INIT_FAIL );
    require( ISIGHHarvestDebtToken(variableDebtTokenProxyAddress).setSIGHHarvesterAddress( SIGHHarvesterProxyAddress ), Errors.VT_INIT_FAIL);
    require( ISIGHHarvestDebtToken(stableDebtTokenProxyAddress).setSIGHHarvesterAddress( SIGHHarvesterProxyAddress ), Errors.ST_INIT_FAIL );


    emit InstrumentInitialized(asset, iTokenProxyAddress, stableDebtTokenProxyAddress, variableDebtTokenProxyAddress, SIGHHarvesterProxyAddress, interestRateStrategyAddress, underlyingAssetDecimals);
  }
    
  /**
  * @dev Updates the iToken implementation for the instrument
  * @param asset The address of the underlying asset of the reserve to be updated
  * @param implementation The address of the new iToken implementation
  **/
  function updateIToken(address asset, address implementation) external onlyLendingPoolManager {
    DataTypes.InstrumentData memory instrumentData = pool.getInstrumentData(asset);
     _upgradeTokenImplementation(asset, instrumentData.iTokenAddress, implementation);
    emit ITokenUpgraded(asset, instrumentData.iTokenAddress, implementation);
  }

  /**
  * @dev Updates the stable debt token implementation for the instrument
  * @param asset The address of the underlying asset of the reserve to be updated
  * @param implementation The address of the new stable debt token implementation
  **/
  function updateStableDebtToken(address asset, address implementation) external onlyLendingPoolManager {
    DataTypes.InstrumentData memory instrumentData = pool.getInstrumentData(asset);
     _upgradeTokenImplementation(asset, instrumentData.stableDebtTokenAddress, implementation);
    emit StableDebtTokenUpgraded(asset, instrumentData.stableDebtTokenAddress, implementation);
  }

  /**
  * @dev Updates the variable debt token implementation for the instrument
  * @param asset The address of the underlying asset of the reserve to be updated
  * @param implementation The address of the new variable debt token implementation
  **/
  function updateVariableDebtToken(address asset, address implementation) external onlyLendingPoolManager {
    DataTypes.InstrumentData memory instrumentData = pool.getInstrumentData(asset);
    _upgradeTokenImplementation(asset, instrumentData.variableDebtTokenAddress, implementation);
    emit VariableDebtTokenUpgraded(asset, instrumentData.variableDebtTokenAddress, implementation);
  }    
    
    /**
     * @dev Updates the SIGH Harvester implementation for the instrument
     * @param asset The address of the underlying asset of the reserve to be updated
     * @param newSighHarvesterImpl The address of the SIGH Harvester implementation
     **/
    function updateSIGHHarvesterForInstrument(  address newSighHarvesterImpl, address asset) external onlyLendingPoolManager {
        DataTypes.InstrumentData memory instrumentData = pool.getInstrumentData(asset);
        updateSIGHHarvesterImplInternal(address(globalAddressesProvider), newSighHarvesterImpl, asset, instrumentData.iTokenAddress, instrumentData.stableDebtTokenAddress, instrumentData.variableDebtTokenAddress );
        emit sighHarvesterImplUpdated(asset, newSighHarvesterImpl );
    }

// ###################################################################################################
// ####### FUNCTIONS TO UPDATE THE LENDING PROTOCOL STATE ####################################
// ###################################################################################################

  /**
  * @dev Enables borrowing on an instrument reserve
  * @param asset The address of the underlying asset
  * @param stableBorrowRateEnabled True if stable borrow rate needs to be enabled by default on this reserve
  **/
  function enableBorrowingOnInstrument(address asset, bool stableBorrowRateEnabled) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setBorrowingEnabled(true);
    currentConfig.setStableRateBorrowingEnabled(stableBorrowRateEnabled);
    pool.setConfiguration(asset, currentConfig.data);
    emit BorrowingOnInstrumentSwitched(asset, true);
    emit StableRateOnInstrumentSwitched(asset, stableBorrowRateEnabled);
  }

  /**
  * @dev Disables borrowing on an instrument reserve
  * @param asset The address of the underlying asset
  **/
  function disableBorrowingOnInstrument(address asset) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setBorrowingEnabled(false);
    pool.setConfiguration(asset, currentConfig.data);
    emit BorrowingOnInstrumentSwitched(asset, false);
  }

  /**
  * @dev Configures the instrument collateralization parameters
  * all the values are expressed in percentages with two decimals of precision. A valid value is 10000, which means 100.00%
  * @param asset The address of the underlying asset of the reserve
  * @param ltv The loan to value of the asset when used as collateral
  * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
  * @param liquidationBonus The bonus liquidators receive to liquidate this asset. The values is always above 100%. A value of 105%
  * means the liquidator will receive a 5% bonus
  **/
  function configureInstrumentAsCollateral(address asset, uint256 ltv, uint256 liquidationThreshold, uint256 liquidationBonus) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);

    //validation of the parameters: the LTV can only be lower or equal than the liquidation threshold
    require(ltv <= liquidationThreshold, "INVALID CONFIGURATION");

    if (liquidationThreshold != 0) {
      //liquidation bonus must be bigger than 100.00%, otherwise the liquidator would receive less collateral than needed to cover the debt
      require(liquidationBonus > PercentageMath.PERCENTAGE_FACTOR, "INVALID CONFIGURATION");
      //if threshold * bonus is less than PERCENTAGE_FACTOR, it's guaranteed that at the moment
      //a loan is taken there is enough collateral available to cover the liquidation bonus
      require(liquidationThreshold.percentMul(liquidationBonus) <= PercentageMath.PERCENTAGE_FACTOR, "INVALID CONFIGURATION");
    }
    else {
      require(liquidationBonus == 0, "INVALID CONFIGURATION");
      //if the liquidation threshold is being set to 0,the Instrument is being disabled as collateral. To do so, we need to ensure no liquidity is deposited
      _checkNoLiquidity(asset);
    }

    currentConfig.setLtv(ltv);
    currentConfig.setLiquidationThreshold(liquidationThreshold);
    currentConfig.setLiquidationBonus(liquidationBonus);
    pool.setConfiguration(asset, currentConfig.data);

    emit InstrumentCollateralParametersUpdated(asset, ltv, liquidationThreshold, liquidationBonus);
  }

  /**
  * @dev Enable stable rate borrowing on a Instrument
  * @param asset The address of the underlying asset of the reserve
  **/
  function enableInstrumentStableRate(address asset) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setStableRateBorrowingEnabled(true);
    pool.setConfiguration(asset, currentConfig.data);
    emit StableRateOnInstrumentSwitched(asset, true);
  }

  /**
  * @dev Disable stable rate borrowing on a reserve
  * @param asset The address of the underlying asset of the reserve
  **/
  function disableInstrumentStableRate(address asset) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setStableRateBorrowingEnabled(false);
    pool.setConfiguration(asset, currentConfig.data);
    emit StableRateOnInstrumentSwitched(asset, false);
  }

  /**
  * @dev Activates a Instrument
  * @param asset The address of the underlying asset of the reserve
  **/
  function activateInstrument(address asset) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setActive(true);
    pool.setConfiguration(asset, currentConfig.data);
    emit InstrumentActivationSwitched(asset, true);
  }

  /**
  * @dev Deactivates a Instrument
  * @param asset The address of the underlying asset of the reserve
  **/
  function deactivateInstrument(address asset) external onlyLendingPoolManager {
    _checkNoLiquidity(asset);
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setActive(false);
    pool.setConfiguration(asset, currentConfig.data);
    emit InstrumentActivationSwitched(asset, false);
  }

  /**
  * @dev Freezes a Instrument. A frozen reserve doesn't allow any new deposit, borrow or rate swap
  *  but allows repayments, liquidations, rate rebalances and withdrawals
  * @param asset The address of the underlying asset of the reserve
  **/
  function freezeInstrument(address asset) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setFrozen(true);
    pool.setConfiguration(asset, currentConfig.data);
    emit InstrumentFreezeSwitched(asset, true);
  }

  /**
  * @dev Unfreezes a Instrument
  * @param asset The address of the underlying asset of the Instrument
  **/
  function unfreezeInstrument(address asset) external onlyLendingPoolManager {
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setFrozen(false);
    pool.setConfiguration(asset, currentConfig.data);
    emit InstrumentFreezeSwitched(asset, false);
  }
    
  /**
  * @dev Updates the reserve factor of a Instrument
  * @param asset The address of the underlying asset of the reserve
  * @param reserveFactor The new reserve factor of the Instrument
  **/
  function setReserveFactor(address asset, uint256 reserveFactor) external onlyLendingPoolManager {
      
    DataTypes.InstrumentConfigurationMap memory currentConfig = pool.getInstrumentConfiguration(asset);
    currentConfig.setReserveFactor(reserveFactor);
    pool.setConfiguration(asset, currentConfig.data);
    emit ReserveFactorChanged(asset, reserveFactor);
  }

  /**
  * @dev Sets the interest rate strategy of a Instrument
  * @param asset The address of the underlying asset of the reserve
  * @param rateStrategyAddress The new address of the interest strategy contract
  **/
  function setInstrumentInterestRateStrategyAddress(address asset, address rateStrategyAddress) external onlyLendingPoolManager {
    pool.setInstrumentInterestRateStrategyAddress(asset, rateStrategyAddress);
    emit InstrumentInterestRateStrategyChanged(asset, rateStrategyAddress);
  }

  /**
  * @dev pauses or unpauses all the actions of the protocol, including aToken transfers
  * @param val true if protocol needs to be paused, false otherwise
  **/
  function setPoolPause(bool val) external onlyLendingPoolManager {
    pool.setPause(val);
  }



   // refreshes the lending pool configuration to update the cached address
    function refreshLendingPoolConfiguration() external onlyLendingPoolManager {
        pool.refreshConfig();
    }

    function getSighHarvesterAddress(address instrumentAddress) external view returns (address sighHarvesterProxyAddress) {
        return sighHarvesterProxies[instrumentAddress];
    }

// #############################################
// ######  FUNCTION TO UPGRADE THE PROXY #######
// #############################################

    // Create a new Proxy contract for the SIGH harvester contract
    function setSIGHHarvesterImplInternal( address globalAddressProvider, address sighHarvesterAddressImpl, address asset, address iTokenProxyAddress, address stableDebtTokenProxyAddress, address variableDebtTokenProxyAddress ) internal returns (address) {
        bytes memory params = abi.encodeWithSignature("initialize(address,address,address,address,address)", globalAddressProvider, asset, iTokenProxyAddress, stableDebtTokenProxyAddress, variableDebtTokenProxyAddress );            // initialize function is called in the new implementation contract
        InitializableAdminUpgradeabilityProxy proxy = new InitializableAdminUpgradeabilityProxy();
        proxy.initialize(sighHarvesterAddressImpl, address(this), params);
        sighHarvesterProxies[asset] = address(proxy);
        emit ProxyCreated(asset, address(proxy));
        return address(proxy);
    }

    // Update the implementation for the SIGH harvester contract
    function updateSIGHHarvesterImplInternal( address globalAddressProvider, address sighHarvesterAddressImpl, address asset, address iTokenProxyAddress, address stableDebtTokenProxyAddress, address variableDebtTokenProxyAddress ) internal {
        address payable proxyAddress = address( uint160(sighHarvesterProxies[asset] ));
        InitializableAdminUpgradeabilityProxy proxy = InitializableAdminUpgradeabilityProxy(proxyAddress);
        bytes memory params = abi.encodeWithSignature("initialize(address,address,address,address,address)", globalAddressProvider, asset, iTokenProxyAddress, stableDebtTokenProxyAddress, variableDebtTokenProxyAddress );           // initialize function is called in the new implementation contract
        proxy.upgradeToAndCall(sighHarvesterAddressImpl, params);
    }


    // Create a new Proxy contract for the iToken / stable debt token / variable debt token
    function _initTokenWithProxy(address implementation, uint8 decimals) internal returns (address) {
        InitializableAdminUpgradeabilityProxy proxy = new InitializableAdminUpgradeabilityProxy();
        bytes memory params = abi.encodeWithSignature( 'initialize(uint8,string,string)', decimals, IERC20Detailed(implementation).name(), IERC20Detailed(implementation).symbol() );
        proxy.initialize(implementation, params);
        return address(proxy);
    }

    // Update the implementation for the Proxy contract for the iToken / stable debt token / variable debt token
    function _upgradeTokenImplementation(address asset, address proxyAddress, address implementation) internal {
        InitializableAdminUpgradeabilityProxy proxy = InitializableAdminUpgradeabilityProxy(payable(proxyAddress));
        DataTypes.InstrumentConfigurationMap memory configuration = pool.getInstrumentConfiguration(asset);
        (, , , uint256 decimals, ) = configuration.getParamsMemory();
        bytes memory params = abi.encodeWithSignature('initialize(uint8,string,string)', uint8(decimals), IERC20Detailed(implementation).name(), IERC20Detailed(implementation).symbol());
        proxy.upgradeToAndCall(implementation, params);
    }



    function _checkNoLiquidity(address asset) internal view {
      DataTypes.InstrumentData memory instrumentData = pool.getInstrumentData(asset);
      uint256 availableLiquidity = ITokenConfiguration(asset).balanceOf(instrumentData.iTokenAddress);
      require(availableLiquidity == 0 && instrumentData.currentLiquidityRate == 0, "Instrument LIQUIDITY NOT 0");
    }






}
