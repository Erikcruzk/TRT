// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/GlobalAddressesProvider/AddressStorage.sol

// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.7.0;

contract AddressStorage {
    mapping(bytes32 => address) private addresses;

    function getAddress(bytes32 _key) public view returns (address) {
        return addresses[_key];
    }

    function _setAddress(bytes32 _key, address _value) internal {
        addresses[_key] = _value;
    }

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/GlobalAddressesProvider/GlobalAddressesProvider.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;


/**
* @title GlobalAddressesProvider contract
* @notice Is the main registry of the protocol. All the different components of the protocol are accessible through the addresses provider.
* @author _astromartian, built upon the Aave protocol's AddressesProviderContract(v1)
**/

contract GlobalAddressesProvider is IGlobalAddressesProvider, AddressStorage {

    bool isSighInitialized;
    bool isNFTBoosterInitialized;

    //#############################################
    //################### EVENTS ##################
    //#############################################
    
    //LendingPool and SIGH Finance Managers
    event PendingSIGHFinanceManagerUpdated( address _pendingSighFinanceManager );
    event SIGHFinanceManagerUpdated( address _sighFinanceManager );
    event PendingLendingPoolManagerUpdated( address _pendingLendingPoolManager );
    event LendingPoolManagerUpdated( address _lendingPoolManager );

    //LendingPool Contracts
    event LendingPoolConfiguratorUpdated(address indexed newAddress);
    event LendingPoolUpdated(address indexed newAddress);
    event LendingPoolLiqAndLoanManagerUpdated(address indexed newAddress);
    event LendingRateOracleUpdated(address indexed newAddress);
    event FeeProviderUpdated(address indexed newAddress);

    //SIGH Finance Contracts
    event SIGHFinanceConfiguratorUpdated(address indexed sighFinanceConfigAddress);       
    event SIGHAddressUpdated(address indexed sighAddress);    
    event SIGHNFTBoosterUpdated(address indexed boosterAddress);
    event SIGHSpeedControllerUpdated(address indexed speedControllerAddress);
    event SIGHVolatilityHarvesterImplUpdated(address indexed newAddress);                   
    event SIGHTreasuryImplUpdated(address indexed newAddress);                           
    event SIGHStakingImplUpdated(address indexed SIGHStakingAddress);                    

    //Contracts which collect Fee & SIGH Pay
    event SIGHFinanceFeeCollectorUpdated(address indexed newAddress);
    event SIGHFinanceSIGHPAYAggregatorUpdated(address indexed newAddress);

    //Price Oracle and general events
    event PriceOracleUpdated(address indexed newAddress);
    event ProxyCreated(bytes32 id, address indexed newAddress);

    //#########################################################
    //################### bytes32 parameters ##################
    //#########################################################
    
    //LendingPool and SIGH Finance Managers    
    bytes32 private constant LENDING_POOL_MANAGER = "LENDING_POOL_MANAGER";                         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE LENDINGPOOL
    bytes32 private constant PENDING_LENDING_POOL_MANAGER = "PENDING_LENDING_POOL_MANAGER";         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE LENDINGPOOL 
    bytes32 private constant SIGH_FINANCE_MANAGER = "SIGH_FINANCE_MANAGER";                         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE SIGH FINANCE
    bytes32 private constant PENDING_SIGH_FINANCE_MANAGER = "PENDING_SIGH_FINANCE_MANAGER";         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE SIGH FINANCE 

    //LendingPool Contracts    
    bytes32 private constant LENDING_POOL_CONFIGURATOR = "LENDING_POOL_CONFIGURATOR";       // CONTROLLED BY LENDINGPOOL MANAGER. MAKES STATE CHANGES RELATED TO LENDING PROTOCOL
    bytes32 private constant LENDING_POOL = "LENDING_POOL";
    bytes32 private constant LENDING_POOL_LIQANDLOAN_MANAGER = "LIQANDLOAN_MANAGER";
    bytes32 private constant LENDING_RATE_ORACLE = "LENDING_RATE_ORACLE";
    bytes32 private constant FEE_PROVIDER = "FEE_PROVIDER";

    //SIGH Finance Contracts
    bytes32 private constant SIGH_FINANCE_CONFIGURATOR = "SIGH_FINANCE_CONFIGURATOR";       // CONTROLLED BY SIGHFINANCE MANAGER. MAKES STATE CHANGES RELATED TO SIGH FINANCE
    bytes32 private constant SIGH = "SIGH";
    bytes32 private constant SIGH_Finance_NFT_BOOSTERS = "SIGH_Finance_NFT_BOOSTERS";
    bytes32 private constant SIGH_SPEED_CONTROLLER = "SIGH_SPEED_CONTROLLER";           
    bytes32 private constant SIGH_VOLATILITY_HARVESTER = "SIGH_VOLATILITY_HARVESTER";         
    bytes32 private constant SIGH_TREASURY = "SIGH_TREASURY";                           
    bytes32 private constant SIGH_STAKING = "SIGH_STAKING";                             

    //Contracts which collect Fee & SIGH Pay
    bytes32 private constant SIGH_Finance_Fee_Collector = "SIGH_Finance_Fee_Collector";
    bytes32 private constant SIGH_Finance_SIGHPAY_AGGREGATOR = "SIGH_Finance_SIGHPAY_AGGREGATOR";

    //Price Oracle and general contracts
    bytes32 private constant PRICE_ORACLE = "PRICE_ORACLE";


// ################################
// ######  CONSTRUCTOR ############
// ################################

    constructor(address SIGHFinanceManagerAddress, address LendingPoolManagerAddress) {
        _setAddress(SIGH_FINANCE_MANAGER, SIGHFinanceManagerAddress);
        _setAddress(LENDING_POOL_MANAGER, LendingPoolManagerAddress);

        emit SIGHFinanceManagerUpdated( getAddress(SIGH_FINANCE_MANAGER) );
        emit LendingPoolManagerUpdated( getAddress(LENDING_POOL_MANAGER) );
    }

// ################################
// #########  MODIFIERS ###########
// ################################

    modifier onlySIGHFinanceManager {
        address sighFinanceManager =  getAddress(SIGH_FINANCE_MANAGER);
        require( sighFinanceManager == msg.sender, "The caller must be the SIGH FINANCE Manager" );
        _;
    }

    modifier onlyLendingPoolManager {
        address LendingPoolManager =  getAddress(LENDING_POOL_MANAGER);
        require( LendingPoolManager == msg.sender, "The caller must be the Lending Protocol Manager" );
        _;
    }

// ########################################################################################
// #########  PROTOCOL MANAGERS ( LendingPool Manager and SighFinance Manager ) ###########
// ########################################################################################

    function getLendingPoolManager() external view override returns (address) {
        return getAddress(LENDING_POOL_MANAGER);
    }

    function getPendingLendingPoolManager() external view override returns (address) {
        return getAddress(PENDING_LENDING_POOL_MANAGER);
    }

    function setPendingLendingPoolManager(address _pendinglendingPoolManager) external override  onlyLendingPoolManager {
        _setAddress(PENDING_LENDING_POOL_MANAGER, _pendinglendingPoolManager);
        emit PendingLendingPoolManagerUpdated(_pendinglendingPoolManager);
    }

    function acceptLendingPoolManager() external override {
        address pendingLendingPoolManager = getAddress(PENDING_LENDING_POOL_MANAGER);
        require(msg.sender == pendingLendingPoolManager, "Only the Pending Lending Pool Manager can call this function to be accepted to become the Lending Pool Manager");
        _setAddress(LENDING_POOL_MANAGER, pendingLendingPoolManager);
        _setAddress(PENDING_LENDING_POOL_MANAGER, address(0));
        emit PendingLendingPoolManagerUpdated( getAddress(PENDING_LENDING_POOL_MANAGER) );
        emit LendingPoolManagerUpdated( getAddress(LENDING_POOL_MANAGER) );
    }

    function getSIGHFinanceManager() external view override returns (address) {
        return getAddress(SIGH_FINANCE_MANAGER);
    }

    function getPendingSIGHFinanceManager() external view override returns (address) {
        return getAddress(PENDING_SIGH_FINANCE_MANAGER);
    }

    function setPendingSIGHFinanceManager(address _PendingSIGHFinanceManager) external override  onlySIGHFinanceManager {
        _setAddress(PENDING_SIGH_FINANCE_MANAGER, _PendingSIGHFinanceManager);
        emit PendingSIGHFinanceManagerUpdated(_PendingSIGHFinanceManager);
    }

    function acceptSIGHFinanceManager() external override {
        address _PendingSIGHFinanceManager = getAddress(PENDING_SIGH_FINANCE_MANAGER);
        require(msg.sender == _PendingSIGHFinanceManager, "Only the Pending SIGH Finance Manager can call this function to be accepted to become the SIGH Finance Manager");
        _setAddress(SIGH_FINANCE_MANAGER, _PendingSIGHFinanceManager);
        _setAddress(PENDING_SIGH_FINANCE_MANAGER, address(0));
        emit PendingSIGHFinanceManagerUpdated( getAddress(PENDING_SIGH_FINANCE_MANAGER) );
        emit SIGHFinanceManagerUpdated( getAddress(SIGH_FINANCE_MANAGER) );
    }


// #########################################################################
// ####___________ LENDING POOL PROTOCOL CONTRACTS _____________############
// ########## 1. LendingPoolConfigurator (Upgradagble) #####################
// ########## 3. LendingPool (Upgradagble) #################################
// ########## 6. FeeProvider (Upgradagble) #################################
// ########## 7. LendingPoolLiqAndLoanManager (Directly Changed) ##########
// ########## 8. LendingRateOracle (Directly Changed) ######################
// #########################################################################


// ############################################
// ######  LendingPoolConfigurator proxy ######
// ############################################

    /**
    * @dev returns the address of the LendingPoolConfigurator proxy
    * @return the lending pool configurator proxy address
    **/
    function getLendingPoolConfigurator() external view override returns (address) {
        return getAddress(LENDING_POOL_CONFIGURATOR);
    }

    /**
    * @dev updates the implementation of the lending pool configurator
    * @param _configurator the new lending pool configurator implementation
    **/
    function setLendingPoolConfiguratorImpl(address _configurator) external override onlyLendingPoolManager {
        updateImplInternal(LENDING_POOL_CONFIGURATOR, _configurator);
        emit LendingPoolConfiguratorUpdated(_configurator);
    }



// ################################
// ######  LendingPool proxy ######
// ################################
    /**
    * @dev returns the address of the LendingPool proxy
    * @return the lending pool proxy address
    **/
    function getLendingPool() external view override returns (address) {
        return getAddress(LENDING_POOL);
    }


    /**
    * @dev updates the implementation of the lending pool
    * @param _pool the new lending pool implementation
    **/
    function setLendingPoolImpl(address _pool) external override onlyLendingPoolManager {
        updateImplInternal(LENDING_POOL, _pool);
        emit LendingPoolUpdated(_pool);
    }
    
    
// ###################################
// ######  getFeeProvider proxy ######
// ###################################
    /**
    * @dev returns the address of the FeeProvider proxy
    * @return the address of the Fee provider proxy
    **/
    function getFeeProvider() external view override returns (address) {
        return getAddress(FEE_PROVIDER);
    }

    /**
    * @dev updates the implementation of the FeeProvider proxy
    * @param _feeProvider the new lending pool fee provider implementation
    **/
    function setFeeProviderImpl(address _feeProvider) external override onlyLendingPoolManager {
        updateImplInternal(FEE_PROVIDER, _feeProvider);
        emit FeeProviderUpdated(_feeProvider);
    }

// ##################################################
// ######  LendingPoolLiqAndLoanManager ######
// ##################################################
    /**
    * @dev returns the address of the LendingPoolLiqAndLoanManager. Since the manager is used
    * through delegateCall within the LendingPool contract, the proxy contract pattern does not work properly hence
    * the addresses are changed directly.
    * @return the address of the Lending pool LiqAndLoan manager
    **/

    function getLendingPoolLiqAndLoanManager() external view override returns (address) {
        return getAddress(LENDING_POOL_LIQANDLOAN_MANAGER);
    }

    /**
    * @dev updates the address of the Lending pool LiqAndLoan manager
    * @param _manager the new lending pool LiqAndLoan manager address
    **/
    function setLendingPoolLiqAndLoanManager(address _manager) external override onlyLendingPoolManager {
        _setAddress(LENDING_POOL_LIQANDLOAN_MANAGER, _manager);
        emit LendingPoolLiqAndLoanManagerUpdated(_manager);
    }

// ##################################################
// ######  LendingRateOracle ##################
// ##################################################

    function getLendingRateOracle() external view override returns (address) {
        return getAddress(LENDING_RATE_ORACLE);
    }

    function setLendingRateOracle(address _lendingRateOracle) external override onlyLendingPoolManager {
        _setAddress(LENDING_RATE_ORACLE, _lendingRateOracle);
        emit LendingRateOracleUpdated(_lendingRateOracle);
    }


// ####################################################################################
// ####___________ SIGH FINANCE RELATED CONTRACTS _____________########################
// ########## 1. SIGH (Initialized only once) #########################################
// ########## 1. SIGH NFT BOOSTERS (Initialized only once) ############################
// ########## 2. SIGHFinanceConfigurator (Upgradable) #################################
// ########## 2. SIGH Speed Controller (Initialized only once) ########################
// ########## 3. SIGHTreasury (Upgradagble) ###########################################
// ########## 4. SIGHVolatilityHarvester (Upgradagble) ###################################
// ########## 5. SIGHStaking (Upgradagble) ###################################
// ####################################################################################

// ################################                                                     
// ######  SIGH ADDRESS ###########                                                     
// ################################                                                     

    function getSIGHAddress() external view override returns (address) {
        return getAddress(SIGH);
    }

    function setSIGHAddress(address sighAddress) external override onlySIGHFinanceManager {
        // require (!isSighInitialized, "SIGH Instrument address can only be initialized once.");
        isSighInitialized  = true;
        // updateImplInternal(SIGH, sighAddress);
        _setAddress(SIGH, sighAddress);
        emit SIGHAddressUpdated(sighAddress);
    }

// #####################################
// ######  SIGH NFT BOOSTERS ###########
// #####################################

    // SIGH FINANCE NFT BOOSTERS - Provide Discount on Deposit & Borrow Fee
    function getSIGHNFTBoosters() external view override returns (address) {
        return getAddress(SIGH_Finance_NFT_BOOSTERS);
    }

    function setSIGHNFTBoosters(address _SIGHNFTBooster) external override onlySIGHFinanceManager {
        // require (!isNFTBoosterInitialized, "SIGH NFT Boosters address can only be initialized once.");
//        isNFTBoosterInitialized  = true;
        _setAddress(SIGH_Finance_NFT_BOOSTERS, _SIGHNFTBooster);
        emit SIGHNFTBoosterUpdated(_SIGHNFTBooster);
    }

// ############################################
// ######  SIGHFinanceConfigurator proxy ######
// ############################################

    /**
    * @dev returns the address of the SIGHFinanceConfigurator proxy
    * @return the SIGH Finance configurator proxy address
    **/
    function getSIGHFinanceConfigurator() external view override returns (address) {
        return getAddress(SIGH_FINANCE_CONFIGURATOR);
    }

    /**
    * @dev updates the implementation of the lending pool configurator
    * @param _configurator the new lending pool configurator implementation
    **/
    function setSIGHFinanceConfiguratorImpl(address _configurator) external override onlySIGHFinanceManager {
        updateImplInternal(SIGH_FINANCE_CONFIGURATOR, _configurator);
        emit SIGHFinanceConfiguratorUpdated(_configurator);
    }

// ############################################
// ######  SIGH Speed Controller ########
// ############################################

    /**
    * @dev returns the address of the SIGH_SPEED_CONTROLLER proxy
    * @return the SIGH Speed Controller address
    **/
    function getSIGHSpeedController() external view override returns (address) {
        return getAddress(SIGH_SPEED_CONTROLLER);
    }

    /**
    * @dev sets the address of the SIGH Speed Controller
    * @param _SIGHSpeedController the SIGH Speed Controller implementation
    **/
    function setSIGHSpeedController(address _SIGHSpeedController) external override onlySIGHFinanceManager {
        // require (!isSighSpeedControllerInitialized, "SIGH Speed Controller address can only be initialized once.");
        // isSighSpeedControllerInitialized  = true;
        updateImplInternal(SIGH_SPEED_CONTROLLER, _SIGHSpeedController);
        emit SIGHSpeedControllerUpdated(_SIGHSpeedController);
    }



// #################################  ADDED BY SIGH FINANCE
// ######  SIGHTreasury proxy ######  ADDED BY SIGH FINANCE
// #################################  ADDED BY SIGH FINANCE

    function getSIGHTreasury() external view override returns (address) {
        return getAddress(SIGH_TREASURY);
    }

    /**
    * @dev updates the address of the SIGH Treasury Contract
    * @param _SIGHTreasury the new SIGH Treasury Contract address
    **/
    function setSIGHTreasuryImpl(address _SIGHTreasury) external override onlySIGHFinanceManager {
        updateImplInternal(SIGH_TREASURY, _SIGHTreasury);
        emit SIGHTreasuryImplUpdated(_SIGHTreasury);
    }

// #############################################  ADDED BY SIGH FINANCE
// ######  SIGHVolatilityHarvester proxy #######     ADDED BY SIGH FINANCE
// #############################################  ADDED BY SIGH FINANCE

    function getSIGHVolatilityHarvester() external view override returns (address) {
        return getAddress(SIGH_VOLATILITY_HARVESTER);
    }

    /**
    * @dev updates the address of the SIGH Distribution Handler Contract (Manages the SIGH Speeds)
    * @param _SIGHVolatilityHarvester the new SIGH Distribution Handler (Impl) Address
    **/
    function setSIGHVolatilityHarvesterImpl(address _SIGHVolatilityHarvester) external override onlySIGHFinanceManager  {
        updateImplInternal(SIGH_VOLATILITY_HARVESTER, _SIGHVolatilityHarvester);
        emit SIGHVolatilityHarvesterImplUpdated(_SIGHVolatilityHarvester);
    }

// #############################################  ADDED BY SIGH FINANCE
// ######  SIGHStaking proxy ###################  ADDED BY SIGH FINANCE
// #############################################  ADDED BY SIGH FINANCE

    function getSIGHStaking() external view override returns (address) {
        return getAddress(SIGH_STAKING);
    }

    /**
    * @dev updates the address of the SIGH Distribution Handler Contract (Manages the SIGH Speeds)
    * @param _SIGHStaking the new lending pool LiqAndLoan manager address
    **/
    function setSIGHStaking(address _SIGHStaking) external override onlySIGHFinanceManager  {
        updateImplInternal(SIGH_STAKING, _SIGHStaking);
        emit SIGHStakingImplUpdated(_SIGHStaking);
    }

// #############################################
// ######  SIGH PAY AGGREGATOR #################
// #############################################

    // SIGH FINANCE : SIGH PAY AGGREGATOR - Collects SIGH PAY Payments
    function getSIGHPAYAggregator() external view override returns (address) {
        return getAddress(SIGH_Finance_SIGHPAY_AGGREGATOR);
    }

    function setSIGHPAYAggregator(address _SIGHPAYAggregator) external override onlySIGHFinanceManager {
        updateImplInternal(SIGH_Finance_SIGHPAY_AGGREGATOR, _SIGHPAYAggregator);
        emit SIGHFinanceSIGHPAYAggregatorUpdated(_SIGHPAYAggregator);
    }

// ####################################################
// ######  SIGH FINANCE FEE COLLECTOR #################
// ###################################################

    // SIGH FINANCE FEE COLLECTOR - BORROWING / FLASH LOAN FEE TRANSFERRED TO THIS ADDRESS
    function getSIGHFinanceFeeCollector() external view override returns (address) {
        return getAddress(SIGH_Finance_Fee_Collector);
    }

    function setSIGHFinanceFeeCollector(address _feeCollector) external override onlySIGHFinanceManager {
        _setAddress(SIGH_Finance_Fee_Collector, _feeCollector);
        emit SIGHFinanceFeeCollectorUpdated(_feeCollector);
    }

// ###################################################################################
// ######  THESE CONTRACTS ARE NOT USING PROXY SO ADDRESS ARE DIRECTLY UPDATED #######
// ###################################################################################

    /**
    * @dev the functions below are storing specific addresses that are outside the context of the protocol
    * hence the upgradable proxy pattern is not used
    **/
    function getPriceOracle() external view override returns (address) {
        return getAddress(PRICE_ORACLE);
    }

    function setPriceOracle(address _priceOracle) external override onlyLendingPoolManager {
        _setAddress(PRICE_ORACLE, _priceOracle);
        emit PriceOracleUpdated(_priceOracle);
    }


// #############################################
// ######  FUNCTION TO UPGRADE THE PROXY #######
// #############################################

    /**
    * @dev internal function to update the implementation of a specific component of the protocol
    * @param _id the id of the contract to be updated
    * @param _newAddress the address of the new implementation
    **/
    function updateImplInternal(bytes32 _id, address _newAddress) internal {
        address payable proxyAddress = address(uint160(getAddress(_id)));

        InitializableAdminUpgradeabilityProxy proxy = InitializableAdminUpgradeabilityProxy(proxyAddress);
        bytes memory params = abi.encodeWithSignature("initialize(address)", address(this));            // initialize function is called in the new implementation contract

        if (proxyAddress == address(0)) {
            proxy = new InitializableAdminUpgradeabilityProxy();
            proxy.initialize(_newAddress, address(this), params);
            _setAddress(_id, address(proxy));
            emit ProxyCreated(_id, address(proxy));
        } else {
            proxy.upgradeToAndCall(_newAddress, params);
        }
    }
}

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/SIGHContracts/ISIGHSpeedController.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Speed Controller Contract
 * @notice Distributes a token to a different contract at a fixed rate.
 * @dev This contract must be poked via the `drip()` function every so often.
 * @author _astromartian
 */

interface ISIGHSpeedController {

// #############################################################################################
// ###########   SIGH DISTRIBUTION : INITIALIZED DRIPPING (Can be called only once)   ##########
// #############################################################################################

  function beginDripping () external returns (bool);
  function updateSighVolatilityDistributionSpeed(uint newSpeed) external returns (bool);

// ############################################################################################################
// ###########   SIGH DISTRIBUTION : ADDING / REMOVING NEW PROTOCOL WHICH WILL RECEIVE SIGH TOKENS   ##########
// ############################################################################################################

  function supportNewProtocol( address newProtocolAddress, uint sighSpeedRatio ) external returns (bool);
  function updateProtocolState(address _protocolAddress, bool isSupported_, uint newRatio_) external  returns (bool);

// #####################################################################
// ###########   SIGH DISTRIBUTION FUNCTION - DRIP FUNCTION   ##########
// #####################################################################

  function drip() external ;

// ###############################################################
// ###########   EXTERNAL VIEW functions TO GET STATE   ##########
// ###############################################################

  function getGlobalAddressProvider() external view returns (address);
  function getSighAddress() external view returns (address);
  function getSighVolatilityHarvester() external view returns (address);

  function getSIGHBalance() external view returns (uint);
  function getSIGHVolatilityHarvestingSpeed() external view returns (uint);

  function getSupportedProtocols() external view returns (address[] memory);
  function isThisProtocolSupported(address protocolAddress) external view returns (bool);
  function getSupportedProtocolState(address protocolAddress) external view returns (bool isSupported,
                                                                                    uint sighHarvestingSpeedRatio,
                                                                                    uint totalDrippedAmount,
                                                                                    uint recentlyDrippedAmount );
  function getTotalAmountDistributedToProtocol(address protocolAddress) external view returns (uint);
  function getRecentAmountDistributedToProtocol(address protocolAddress) external view returns (uint);
  function getSIGHSpeedRatioForProtocol(address protocolAddress) external view returns (uint);
  function totalProtocolsSupported() external view returns (uint);

  function _isDripAllowed() external view returns (bool);
  function getlastDripBlockNumber() external view returns (uint);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/SIGHContracts/ISIGHVolatilityHarvester.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Distribution Handler Contract
 * @notice Handles the SIGH Loss Minimizing Mechanism for the Lending Protocol
 * @dev Accures SIGH for the supported markets based on losses made every 24 hours, along with Staking speeds. This accuring speed is updated every hour
 * @author SIGH Finance
 */

interface ISIGHVolatilityHarvester {

    function refreshConfig() external;

    function addInstrument( address _instrument, address _iTokenAddress,address _stableDebtToken,address _variableDebtToken, address _sighStreamAddress, uint8 _decimals ) external returns (bool);   // onlyLendingPoolCore
    function removeInstrument( address _instrument ) external returns (bool);   //

    function Instrument_SIGH_StateUpdated(address instrument_, uint _bearSentiment,uint _bullSentiment, bool _isSIGHMechanismActivated  ) external returns (bool); // onlySighFinanceConfigurator

    function updateSIGHSpeed(uint SIGHSpeed_) external returns (bool);                                                      // onlySighFinanceConfigurator
    function updateStakingSpeedForAnInstrument(address instrument_, uint newStakingSpeed) external returns (bool);          // onlySighFinanceConfigurator
    function updateCryptoMarketSentiment(  uint cryptoMarketSentiment_ ) external returns (bool);                      // onlySighFinanceConfigurator
    function updateDeltaTimestampRefresh(uint deltaBlocksLimit) external returns (bool);                               // onlySighFinanceConfigurator
    function updateETHOracleAddress( address _EthOracleAddress ) external returns (bool) ;

    function refreshSIGHSpeeds() external returns (bool);

    function updateSIGHSupplyIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPoolCore
    function updateSIGHBorrowIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPoolCore

    function transferSighTotheUser(address instrument, address user, uint sigh_Amount ) external  returns (uint);             // onlyITokenContract(instrument)

    // ###### VIEW FUNCTIONS ######
    function getSIGHBalance() external view returns (uint);
    function getAllInstrumentsSupported() external view returns (address[] memory );

    function getInstrumentData (address instrument_) external view returns (string memory name, address iTokenAddress, uint decimals, bool isSIGHMechanismActivated,uint256 supplyindex, uint256 borrowindex  );

    function getInstrumentSpeeds(address instrument) external view returns (uint8 side, uint suppliers_speed, uint borrowers_speed, uint staking_speed );
    function getInstrumentVolatilityStates(address instrument) external view returns ( uint8 side, uint _total24HrSentimentVolatility, uint percentTotalSentimentVolatility, uint _total24HrVolatility, uint percentTotalVolatility  );
    function getInstrumentSighLimits(address instrument) external view returns ( uint _bearSentiment , uint _bullSentiment  );

    function getAllPriceSnapshots(address instrument_ ) external view returns (uint256[24] memory);
    function getBlockNumbersForPriceSnapshots() external view returns (uint256[24] memory);

    function getSIGHSpeed() external view returns (uint);
    function getSIGHSpeedUsed() external view returns (uint);

    function isInstrumentSupported (address instrument_) external view returns (bool);
    function totalInstrumentsSupported() external view returns (uint);

    function getInstrumentSupplyIndex(address instrument_) external view returns (uint);
    function getInstrumentBorrowIndex(address instrument_) external view returns (uint);

    function getCryptoMarketSentiment () external view returns (uint);
    function checkPriceSnapshots(address instrument_, uint clock) external view returns (uint256);
    function checkinitializationCounter(address instrument_) external view returns (uint32);

    function getdeltaTimestamp() external view returns (uint);
    function getprevHarvestRefreshTimestamp() external view returns (uint);
    function getBlocksRemainingToNextSpeedRefresh() external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/SIGHContracts/SIGHFinanceConfigurator.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;




/**
* @title SighFinanceConfigurator contract
* @author SIGH Finance
* @notice Executes configuration methods for SIGH FINANCE contract, SIGHVolatilityHarvester and the SighStaking Contract
* to efficiently regulate the SIGH economics
**/

contract SIGHFinanceConfigurator is VersionedInitializable {

    using SafeMath for uint256;
    GlobalAddressesProvider public globalAddressesProvider;

// ######################
// ####### EVENTS #######
// ######################

    /**
    * @dev emitted when a instrument is initialized.
    * @param _instrument the address of the instrument
    * @param _iToken the address of the overlying iToken contract
    * @param _interestRateStrategyAddress the address of the interest rate strategy for the instrument
    **/
    event InstrumentInitialized( address indexed _instrument, address indexed _iToken, address _interestRateStrategyAddress );
    event InstrumentRemoved( address indexed _instrument);      // emitted when a instrument is removed.


// #############################
// ####### PROXY RELATED #######
// #############################

    uint256 public constant CONFIGURATOR_REVISION = 0x1;

    function getRevision() internal override virtual pure returns (uint256) {
        return CONFIGURATOR_REVISION;
    }

    function initialize(GlobalAddressesProvider _globalAddressesProvider) public initializer {
        globalAddressesProvider = _globalAddressesProvider;
    }

// ########################
// ####### MODIFIER #######
// ########################
    /**
    * @dev only the lending pool manager can call functions affected by this modifier
    **/
    modifier onlySIGHFinanceManager {
        require( globalAddressesProvider.getSIGHFinanceManager() == msg.sender, "The caller must be the SIGH Mechanism Manager" );
        _;
    }


// #################################################
// ####### SIGH SPEED CONTROLLER FUNCTIONS #########
// #################################################

    // CALLED ONLY ONCE : TESTED
    function beginDrippingFromSIGHSpeedController() external onlySIGHFinanceManager returns (bool) {
        ISIGHSpeedController sigh_speed_Controller = ISIGHSpeedController( globalAddressesProvider.getSIGHSpeedController() );
        require(sigh_speed_Controller.beginDripping(), "Initialization failed." );
        return true;
    }

    // TESTED
    function updateSighVolatilityDistributionSpeedInSIGHSpeedController(uint newSpeed_) external onlySIGHFinanceManager returns (bool) {
        ISIGHSpeedController sigh_speed_Controller = ISIGHSpeedController( globalAddressesProvider.getSIGHSpeedController() );
        require(sigh_speed_Controller.updateSighVolatilityDistributionSpeed(newSpeed_), "Update failed." );
        return true;
    }

    // TESTED
    function supportNewProtocolInSIGHSpeedController( address newProtocolAddress, uint sighSpeedRatio ) external onlySIGHFinanceManager returns (bool) {
        ISIGHSpeedController sigh_speed_Controller = ISIGHSpeedController( globalAddressesProvider.getSIGHSpeedController() );
        require(sigh_speed_Controller.supportNewProtocol(newProtocolAddress, sighSpeedRatio), "New Protocol addition failed." );
        return true;
    }

    // TESTED
    function updateProtocolStateInSIGHSpeedController(address protocolAddress_, bool isSupported_, uint newRatio_) external onlySIGHFinanceManager returns (bool) {
        ISIGHSpeedController sigh_speed_Controller = ISIGHSpeedController( globalAddressesProvider.getSIGHSpeedController() );
        require(sigh_speed_Controller.updateProtocolState(protocolAddress_,isSupported_,newRatio_), " Protocol update failed." );
        return true;
    }

// #####################################################
// ####### SIGH VOLATILITY HARVESTER FUNCTIONS #########
// #####################################################

    function refreshSIGHVolatilityHarvesterConfig() external onlySIGHFinanceManager  {
        ISIGHVolatilityHarvester sigh_volatility_harvester = ISIGHVolatilityHarvester( globalAddressesProvider.getSIGHVolatilityHarvester() );
        sigh_volatility_harvester.refreshConfig() ;
    }

    function updateInstrumentConfigVolatilityHarvester(address instrument_,  uint _bearSentiment,uint _bullSentiment, bool _isSIGHMechanismActivated ) external onlySIGHFinanceManager returns (bool) {
        ISIGHVolatilityHarvester sigh_volatility_harvester = ISIGHVolatilityHarvester( globalAddressesProvider.getSIGHVolatilityHarvester() );
        require(sigh_volatility_harvester.Instrument_SIGH_StateUpdated( instrument_, _bearSentiment, _bullSentiment, _isSIGHMechanismActivated ), "Instrument_SIGH_StateUpdated() execution failed." );
        return true;
    }

    function updateSIGHSpeed_VolatilityHarvester(uint newSighSpeed) external onlySIGHFinanceManager returns (bool) {
        ISIGHVolatilityHarvester sigh_volatility_harvester = ISIGHVolatilityHarvester( globalAddressesProvider.getSIGHVolatilityHarvester() );
        require(sigh_volatility_harvester.updateSIGHSpeed( newSighSpeed ), "updateSIGHSpeed() execution failed." );
        return true;
    }


    function updateStakingSpeed_VolatilityHarvester(address instrument_, uint newStakingSpeed) external onlySIGHFinanceManager returns (bool) {
        ISIGHVolatilityHarvester sigh_volatility_harvester = ISIGHVolatilityHarvester( globalAddressesProvider.getSIGHVolatilityHarvester() );
        require(sigh_volatility_harvester.updateStakingSpeedForAnInstrument( instrument_, newStakingSpeed ), "updateStakingSpeedForAnInstrument() execution failed." );
        return true;
    }

    function UpdateCryptoMarketSentiment_VolatilityHarvester( uint maxVolatilityProtocolLimit_) external onlySIGHFinanceManager returns (bool) {
        ISIGHVolatilityHarvester sigh_volatility_harvester = ISIGHVolatilityHarvester( globalAddressesProvider.getSIGHVolatilityHarvester() );
        require(sigh_volatility_harvester.updateCryptoMarketSentiment( maxVolatilityProtocolLimit_ ), "updateCryptoMarketSentiment() execution failed." );
        return true;
    }

    function updateDeltaTimestamp_VolatilityHarvester(uint deltaBlocksLimit) external onlySIGHFinanceManager returns (bool) {
        ISIGHVolatilityHarvester sigh_volatility_harvester = ISIGHVolatilityHarvester( globalAddressesProvider.getSIGHVolatilityHarvester() );
        require(sigh_volatility_harvester.updateDeltaTimestampRefresh( deltaBlocksLimit ), "updateDeltaTimestampRefresh() execution failed." );
        return true;
    }

// #########################################
// ####### SIGH TREASURY FUNCTIONS #########
// #########################################

//    function initializeInstrumentStateInSIGHTreasury(address instrument) external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.initializeInstrumentState(instrument),"Instrument initialization failed");
//
//    }
//
//    function refreshConfigInSIGHTreasury() external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.refreshConfig(),"Failed to refresh");
//    }
//
//    function switchSIGHBurnAllowedInSIGHTreasury() external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.switchSIGHBurnAllowed(),"Switching SIGH Burn in Treasury Failed");
//    }
//
//    function updateSIGHBurnSpeedInSIGHTreasury( uint newSpeed) external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.updateSIGHBurnSpeed(newSpeed),"Failed to update SIGH burn speed");
//    }
//
//    function initializeInstrumentDistributionInSIGHTreasury(address targetAddress, address instrumnetToBeDistributed, uint distributionSpeed) external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.initializeInstrumentDistribution(targetAddress, instrumnetToBeDistributed, distributionSpeed),"Instrument Distribution function failed");
//    }
//
//    function changeInstrumentBeingDrippedInSIGHTreasury(address instrumentToBeDistributed ) external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.changeInstrumentBeingDripped(instrumentToBeDistributed),"Change Instrument being Distributed function failed");
//    }
//
//    function updateDripSpeedInSIGHTreasury( uint newdistributionSpeed ) external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.updateDripSpeed(newdistributionSpeed),"Change Instrument dripping speed function failed");
//    }
//
//   function resetInstrumentDistributionInSIGHTreasury() external onlySIGHFinanceManager {
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        require(sigh_treasury.resetInstrumentDistribution(),"Reset Instrument distribution function failed");
//    }
//
//   function transferSighFromSIGHTreasury(address target, uint amount) external onlySIGHFinanceManager returns (uint){
//        ISighTreasury sigh_treasury = ISighTreasury( globalAddressesProvider.getSIGHTreasury() );
//        uint sighTransferred = sigh_treasury.transferSighTo(target, amount);
//        return sighTransferred;
//    }

// #########################################
// ####### SIGH STAKING FUNCTIONS ##########
// #########################################

//   function supportNewInstrumentForDistributionInSIGH_Staking(address instrument, uint speed) external onlySIGHFinanceManager {
//        ISighStaking sigh_staking = ISighStaking( globalAddressesProvider.getSIGHStaking() );
//        require(sigh_staking.supportNewInstrumentForDistribution(instrument, speed),"Addition of new instrument as SIGH Staking reward failed");
//    }
//
//   function removeInstrumentFromDistributionInSIGH_Staking(address instrument ) external onlySIGHFinanceManager {
//        ISighStaking sigh_staking = ISighStaking( globalAddressesProvider.getSIGHStaking() );
//        require(sigh_staking.removeInstrumentFromDistribution(instrument ),"Removing the instrument as a SIGH Staking reward failed");
//    }
//
//   function setDistributionSpeedForStakingRewardInSIGH_Staking(address instrument, uint speed) external onlySIGHFinanceManager {
//        ISighStaking sigh_staking = ISighStaking( globalAddressesProvider.getSIGHStaking() );
//        require(sigh_staking.setDistributionSpeed(instrument, speed),"Updating distribution speed for SIGH Staking reward failed");
//    }
//
//   function updateMaxSighThatCanBeStakedInSIGH_Staking( uint amount) external onlySIGHFinanceManager {
//        ISighStaking sigh_staking = ISighStaking( globalAddressesProvider.getSIGHStaking() );
//        require(sigh_staking.updateMaxSighThatCanBeStaked(amount),"Updating Maximum SIGH Staking limit failed");
//    }

}