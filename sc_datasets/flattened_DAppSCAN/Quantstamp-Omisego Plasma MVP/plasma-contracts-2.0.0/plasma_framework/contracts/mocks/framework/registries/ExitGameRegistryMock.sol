// File: openzeppelin-solidity/contracts/utils/Address.sol

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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/Protocol.sol

pragma solidity 0.5.11;

/**
 * @notice Protocols for the PlasmaFramework
 */
library Protocol {
    uint8 constant internal MVP_VALUE = 1;
    uint8 constant internal MORE_VP_VALUE = 2;

    // solhint-disable-next-line func-name-mixedcase
    function MVP() internal pure returns (uint8) {
        return MVP_VALUE;
    }

    // solhint-disable-next-line func-name-mixedcase
    function MORE_VP() internal pure returns (uint8) {
        return MORE_VP_VALUE;
    }

    function isValidProtocol(uint8 protocol) internal pure returns (bool) {
        return protocol == MVP_VALUE || protocol == MORE_VP_VALUE;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/utils/Quarantine.sol

pragma solidity 0.5.11;

/**
 * @notice Provides a way to quarantine (disable) contracts for a specified period of time
 * @dev The immunitiesRemaining member allows deployment to the platform with some
 * pre-verified contracts that don't get quarantined
 */
library Quarantine {
    struct Data {
        mapping(address => uint256) store;
        uint256 quarantinePeriod;
        uint256 immunitiesRemaining;
    }

    /**
     * @notice Checks whether a contract is quarantined
     */
    function isQuarantined(Data storage _self, address _contractAddress) internal view returns (bool) {
        return block.timestamp < _self.store[_contractAddress];
    }

    /**
     * @notice Places a contract into quarantine
     * @param _contractAddress The address of the contract
     */
    function quarantine(Data storage _self, address _contractAddress) internal {
        require(_contractAddress != address(0), "An empty address cannot be quarantined");
        require(_self.store[_contractAddress] == 0, "The contract is already quarantined");

        if (_self.immunitiesRemaining == 0) {
            _self.store[_contractAddress] = block.timestamp + _self.quarantinePeriod;
        } else {
            _self.immunitiesRemaining--;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/utils/OnlyFromAddress.sol

pragma solidity 0.5.11;

contract OnlyFromAddress {

    modifier onlyFrom(address caller) {
        require(msg.sender == caller, "Caller address is unauthorized");
        _;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/registries/ExitGameRegistry.sol

pragma solidity 0.5.11;



contract ExitGameRegistry is OnlyFromAddress {
    using Quarantine for Quarantine.Data;

    mapping(uint256 => address) private _exitGames; // txType => exit game contract address
    mapping(address => uint256) private _exitGameToTxType; // exit game contract address => tx type
    mapping(uint256 => uint8) private _protocols; // tx type => protocol (MVP/MORE_VP)
    Quarantine.Data private _exitGameQuarantine;

    event ExitGameRegistered(
        uint256 txType,
        address exitGameAddress,
        uint8 protocol
    );

    /**
     * @dev It takes at least 3 * minExitPeriod before each new exit game contract is able to start protecting existing transactions
     *      see: https://github.com/omisego/plasma-contracts/issues/172
     *           https://github.com/omisego/plasma-contracts/issues/197
     */
    constructor (uint256 _minExitPeriod, uint256 _initialImmuneExitGames)
        public
    {
        _exitGameQuarantine.quarantinePeriod = 4 * _minExitPeriod;
        _exitGameQuarantine.immunitiesRemaining = _initialImmuneExitGames;
    }

    /**
     * @notice A modifier to verify that the call is from a non-quarantined exit game
     */
    modifier onlyFromNonQuarantinedExitGame() {
        require(_exitGameToTxType[msg.sender] != 0, "The call is not from a registered exit game contract");
        require(!_exitGameQuarantine.isQuarantined(msg.sender), "ExitGame is quarantined");
        _;
    }

    /**
     * @notice interface to get the 'maintainer' address.
     * @dev see discussion here: https://git.io/Je8is
     */
    function getMaintainer() public view returns (address);

    /**
     * @notice Checks whether the contract is safe to use and is not under quarantine
     * @dev Exposes information about exit games quarantine
     * @param _contract Address of the exit game contract
     * @return boolean Whether the contract is safe to use and is not under quarantine
     */
    function isExitGameSafeToUse(address _contract) public view returns (bool) {
        return _exitGameToTxType[_contract] != 0 && !_exitGameQuarantine.isQuarantined(_contract);
    }

    /**
     * @notice Registers an exit game within the PlasmaFramework. Only the maintainer can call the function.
     * @dev Emits ExitGameRegistered event to notify clients
     * @param _txType The tx type where the exit game wants to register
     * @param _contract Address of the exit game contract
     * @param _protocol The transaction protocol, either 1 for MVP or 2 for MoreVP
     */
    function registerExitGame(uint256 _txType, address _contract, uint8 _protocol) public onlyFrom(getMaintainer()) {
        require(_txType != 0, "Should not register with tx type 0");
        require(Address.isContract(_contract), "Should not register with a non-contract address");
        require(_exitGames[_txType] == address(0), "The tx type is already registered");
        require(_exitGameToTxType[_contract] == 0, "The exit game contract is already registered");
        require(Protocol.isValidProtocol(_protocol), "Invalid protocol value");

        _exitGames[_txType] = _contract;
        _exitGameToTxType[_contract] = _txType;
        _protocols[_txType] = _protocol;
        _exitGameQuarantine.quarantine(_contract);

        emit ExitGameRegistered(_txType, _contract, _protocol);
    }

    /**
     * @notice Public getter for retrieving protocol with tx type
     */
    function protocols(uint256 _txType) public view returns (uint8) {
        return _protocols[_txType];
    }

    /**
     * @notice Public getter for retrieving exit game address with tx type
     */
    function exitGames(uint256 _txType) public view returns (address) {
        return _exitGames[_txType];
    }

    /**
     * @notice Public getter for retrieving tx type with exit game address
     */
    function exitGameToTxType(address _exitGame) public view returns (uint256) {
        return _exitGameToTxType[_exitGame];
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/mocks/framework/registries/ExitGameRegistryMock.sol

pragma solidity 0.5.11;

contract ExitGameRegistryMock is ExitGameRegistry {
    address private maintainer;

    constructor (uint256 _minExitPeriod, uint256 _initialImmuneExitGames)
        public
        ExitGameRegistry(_minExitPeriod, _initialImmuneExitGames)
    {
    }

    /** override to make it non-abstract contract */
    function getMaintainer() public view returns (address) {
        return maintainer;
    }

    /** test helper function */
    function setMaintainer(address maintainerToSet) public {
        maintainer = maintainerToSet;
    }

    function checkOnlyFromNonQuarantinedExitGame() public onlyFromNonQuarantinedExitGame view returns (bool) {
        return true;
    }
}
