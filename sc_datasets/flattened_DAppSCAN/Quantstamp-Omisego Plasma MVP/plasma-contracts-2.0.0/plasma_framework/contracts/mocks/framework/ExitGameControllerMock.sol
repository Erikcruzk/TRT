// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/interfaces/IExitProcessor.sol

pragma solidity 0.5.11;

/**
 * @dev An interface that allows custom logic to process exits for different requirements.
 *      This interface is used to dispatch to each custom processor when 'processExits' is called on PlasmaFramework.
 */
interface IExitProcessor {
    /**
     * @dev Function interface for processing exits.
     * @param exitId Unique ID for exit per tx type
     * @param vaultId ID of the vault that funds the exit
     * @param token Address of the token contract
     * @param processExitInitiator Address of the processExit intitiator
     */
    function processExit(uint168 exitId, uint256 vaultId, address token, address payable processExitInitiator) external;
}

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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/utils/PriorityQueue.sol

pragma solidity 0.5.11;

/**
 * @title PriorityQueue
 * @dev Min-heap priority queue implementation
 */
contract PriorityQueue is OnlyFromAddress {
    using SafeMath for uint256;

    struct Queue {
        uint256[] heapList;
        uint256 currentSize;
    }

    Queue public queue;
    address public framework;

    constructor() public {
        queue.heapList = [0];
        queue.currentSize = 0;

        // it is expected that this should be called by PlasmaFramework
        // and only PlasmaFramework contract can add things to the queue
        framework = msg.sender;
    }

    /**
     * @notice Gets num of elements in the queue
     */
    function currentSize() external view returns (uint256) {
        return queue.currentSize;
    }

    /**
     * @notice Gets all elements in the queue
     */
    function heapList() external view returns (uint256[] memory) {
        return queue.heapList;
    }

    /**
     * @notice Inserts an element into the queue by the framework
     * @dev Does not perform deduplication
     */
    function insert(uint256 _element) external onlyFrom(framework) {
        queue.heapList.push(_element);
        queue.currentSize = queue.currentSize.add(1);
        percUp(queue, queue.currentSize);
    }

    /**
     * @notice Deletes the smallest element from the queue by the framework
     * @dev Fails when queue is empty
     * @return The smallest element in the priority queue
     */
    function delMin() external onlyFrom(framework) returns (uint256) {
        require(queue.currentSize > 0, "Queue is empty");
        uint256 retVal = queue.heapList[1];
        queue.heapList[1] = queue.heapList[queue.currentSize];
        delete queue.heapList[queue.currentSize];
        queue.currentSize = queue.currentSize.sub(1);
        percDown(queue, 1);
        queue.heapList.length = queue.heapList.length.sub(1);
        return retVal;
    }

    /**
     * @notice Returns the smallest element from the queue
     * @dev Fails when queue is empty
     * @return The smallest element in the priority queue
     */
    function getMin() external view returns (uint256) {
        require(queue.currentSize > 0, "Queue is empty");
        return queue.heapList[1];
    }

    function percUp(Queue storage self, uint256 pointer) private {
        uint256 i = pointer;
        uint256 j = i;
        uint256 newVal = self.heapList[i];
        while (newVal < self.heapList[i.div(2)]) {
            self.heapList[i] = self.heapList[i.div(2)];
            i = i.div(2);
        }
        if (i != j) {
            self.heapList[i] = newVal;
        }
    }

    function percDown(Queue storage self, uint256 pointer) private {
        uint256 i = pointer;
        uint256 j = i;
        uint256 newVal = self.heapList[i];
        uint256 mc = minChild(self, i);
        while (mc <= self.currentSize && newVal > self.heapList[mc]) {
            self.heapList[i] = self.heapList[mc];
            i = mc;
            mc = minChild(self, i);
        }
        if (i != j) {
            self.heapList[i] = newVal;
        }
    }

    function minChild(Queue storage self, uint256 i) private view returns (uint256) {
        if (i.mul(2).add(1) > self.currentSize) {
            return i.mul(2);
        } else {
            if (self.heapList[i.mul(2)] < self.heapList[i.mul(2).add(1)]) {
                return i.mul(2);
            } else {
                return i.mul(2).add(1);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/utils/PosLib.sol

pragma solidity 0.5.11;

/**
 * @dev UTXO position = (blknum * BLOCK_OFFSET + txIndex * TX_OFFSET + outputIndex).
 * TX position = (blknum * BLOCK_OFFSET + txIndex * TX_OFFSET)
 */
library PosLib {
    struct Position {
        uint64 blockNum;
        uint16 txIndex;
        uint16 outputIndex;
    }

    uint256 constant internal BLOCK_OFFSET = 1000000000;
    uint256 constant internal TX_OFFSET = 10000;

    uint256 constant internal MAX_OUTPUT_INDEX = TX_OFFSET - 1;
    // Since we are using a merkle tree of depth 16, max tx index size is 2^16 - 1
    uint256 constant internal MAX_TX_INDEX = 2 ** 16 - 1;
    // The maximum block number we can handle depends on ExitPriority. ExitPriority only uses 56 bits for blockNum + txIndex
    // This is 720575940379 blocks, which works out to be 342 years of blocks (given a block occurs every 15 seconds)
    uint256 constant internal MAX_BLOCK_NUM = ((2 ** 56 - 1) - MAX_TX_INDEX) / (BLOCK_OFFSET / TX_OFFSET);

    /**
     * @notice Returns transaction position which is an utxo position of zero index output
     * @param pos UTXO position of the output
     * @return Position of a transaction
     */
    function toStrictTxPos(Position memory pos)
        internal
        pure
        returns (Position memory)
    {
        return Position(pos.blockNum, pos.txIndex, 0);
    }

    /**
     * @notice Used for calculating exit priority
     * @param pos UTXO position for the output
     * @return Identifier of the transaction
     */
    function getTxPositionForExitPriority(Position memory pos)
        internal
        pure
        returns (uint56)
    {
        return uint56(encode(pos) / TX_OFFSET);
    }

    /**
     * @notice Encodes a position
     * @param pos Position
     * @return Position encoded as an integer
     */
    function encode(Position memory pos) internal pure returns (uint256) {
        require(pos.outputIndex <= MAX_OUTPUT_INDEX, "Invalid output index");
        require(pos.blockNum <= MAX_BLOCK_NUM, "Invalid block number");

        return pos.blockNum * BLOCK_OFFSET + pos.txIndex * TX_OFFSET + pos.outputIndex;
    }

    /**
     * @notice Decodes a position from an integer value
     * @param pos Encoded position
     * @return Position
     */
    function decode(uint256 pos) internal pure returns (Position memory) {
        uint256 blockNum = pos / BLOCK_OFFSET;
        uint256 txIndex = (pos % BLOCK_OFFSET) / TX_OFFSET;
        uint16 outputIndex = uint16(pos % TX_OFFSET);

        require(blockNum <= MAX_BLOCK_NUM, "blockNum exceeds max size allowed in PlasmaFramework");
        require(txIndex <= MAX_TX_INDEX, "txIndex exceeds the size of uint16");
        return Position(uint64(blockNum), uint16(txIndex), outputIndex);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/utils/ExitPriority.sol

pragma solidity 0.5.11;

library ExitPriority {

    using PosLib for PosLib.Position;

    uint256 constant private SIZEOF_TIMESTAMP = 32;
    uint256 constant private SIZEOF_EXITID = 168;

    /**
     * @dev Returns an exit priority for a given UTXO position and a unique ID.
     * The priority for Plasma M(ore)VP protocol is a combination of 'exitableAt' and 'txPos'.
     * Since 'exitableAt' only provides granularity of block, adding 'txPos' gives higher priority to transactions added earlier in the same block.
     * @notice Detailed explanation on field lengths can be found at https://github.com/omisego/plasma-contracts/pull/303#discussion_r328850572
     * @param exitId Unique exit identifier
     * @return An exit priority
     *   Anatomy of returned value, most significant bits first
     *   32 bits  - The exitable_at timestamp (in seconds); can represent dates until the year 2106
     *   56 bits  - The transaction position. Be aware that child chain block number jumps with the interval of CHILD_BLOCK_INTERVAL (usually 1000).
                    blocknum * (BLOCK_OFFSET / TX_OFFSET) + txindex; 56 bits can represent all transactions for 342 years, assuming a 15 second block time.
     *   168 bits - The exit id
     */
    function computePriority(uint32 exitableAt, PosLib.Position memory txPos, uint168 exitId)
        internal
        pure
        returns (uint256)
    {
        return (uint256(exitableAt) << (256 - SIZEOF_TIMESTAMP)) | (uint256(txPos.getTxPositionForExitPriority()) << SIZEOF_EXITID) | uint256(exitId);
    }

    function parseExitableAt(uint256 priority) internal pure returns (uint32) {
        return uint32(priority >> (256 - SIZEOF_TIMESTAMP));
    }

    function parseExitId(uint256 priority) internal pure returns (uint168) {
        // Exit ID uses only 168 least significant bits
        return uint168(priority);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/framework/ExitGameController.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;





/**
 * @notice Controls the logic and functions for ExitGame to interact with the PlasmaFramework
 *         Plasma M(ore)VP relies on exit priority to secure the user from invalid transactions
 *         The priority queue ensures the exit is processed with the exit priority
 *         For details, see the Plasma MVP spec: https://ethresear.ch/t/minimal-viable-plasma/426
 */
contract ExitGameController is ExitGameRegistry {
    // exit hashed (priority, vault id, token) => IExitProcessor
    mapping (bytes32 => IExitProcessor) public delegations;
    // hashed (vault id, token) => PriorityQueue
    mapping (bytes32 => PriorityQueue) public exitsQueues;
    // outputId => exitId
    mapping (bytes32 => uint168) public outputsFinalizations;
    bool private mutex = false;

    event ExitQueueAdded(
        uint256 vaultId,
        address token
    );

    event ProcessedExitsNum(
        uint256 processedNum,
        uint256 vaultId,
        address token
    );

    event ExitQueued(
        uint168 indexed exitId,
        uint256 priority
    );

    constructor(uint256 _minExitPeriod, uint256 _initialImmuneExitGames)
        public
        ExitGameRegistry(_minExitPeriod, _initialImmuneExitGames)
    {
    }

    /**
     * @dev Prevents reentrant calls by using a mutex.
     */
    modifier nonReentrant() {
        require(!mutex, "Reentrant call");
        mutex = true;
        _;
        assert(mutex);
        mutex = false;
    }

    /**
     * @notice Activates non reentrancy mode
     *         Guards against reentering into publicly accessible code that modifies state related to exits
     * @dev Accessible only from non quarantined exit games, uses a mutex
     */
    function activateNonReentrant() external onlyFromNonQuarantinedExitGame() {
        require(!mutex, "Reentrant call");
        mutex = true;
    }

    /**
     * @notice Deactivates non reentrancy mode
     * @dev Accessible only from non quarantined exit games, uses a mutex
     */
    function deactivateNonReentrant() external onlyFromNonQuarantinedExitGame() {
        assert(mutex);
        mutex = false;
    }

    /**
     * @notice Checks if the queue for a specified token was created
     * @param vaultId ID of the vault that handles the token
     * @param token Address of the token
     * @return bool Defines whether the queue for a token was created
     */
    function hasExitQueue(uint256 vaultId, address token) public view returns (bool) {
        bytes32 key = exitQueueKey(vaultId, token);
        return hasExitQueue(key);
    }

    /**
     * @notice Adds queue to the Plasma framework
     * @dev The queue is created as a new contract instance
     * @param vaultId ID of the vault
     * @param token Address of the token
     */
    function addExitQueue(uint256 vaultId, address token) external {
        require(vaultId != 0, "Vault ID must not be 0");
        bytes32 key = exitQueueKey(vaultId, token);
        require(!hasExitQueue(key), "Exit queue exists");
        exitsQueues[key] = new PriorityQueue();
        emit ExitQueueAdded(vaultId, token);
    }

    /**
     * @notice Enqueue exits from exit game contracts is a function that places the exit into the
     *         priority queue to enforce the priority of exit during 'processExits'
     * @dev emits ExitQueued event, which can be used to back trace the priority inside the queue
     * @dev Caller of this function should add "pragma experimental ABIEncoderV2;" on top of file
     * @dev Priority (exitableAt, txPos, exitId) must be unique per queue. Do not enqueue when the same priority is already in the queue.
     * @param vaultId Vault ID of the vault that stores exiting funds
     * @param token Token for the exit
     * @param exitableAt The earliest time a specified exit can be processed
     * @param txPos Transaction position for the exit priority. For SE it should be the exit tx, for IFE it should be the youngest input tx position.
     * @param exitId ID used by the exit processor contract to determine how to process the exit
     * @param exitProcessor The exit processor contract, called during "processExits"
     * @return A unique priority number computed for the exit
     */
    function enqueue(
        uint256 vaultId,
        address token,
        uint32 exitableAt,
        PosLib.Position calldata txPos,
        uint168 exitId,
        IExitProcessor exitProcessor
    )
        external
        onlyFromNonQuarantinedExitGame
        returns (uint256)
    {
        bytes32 key = exitQueueKey(vaultId, token);
        require(hasExitQueue(key), "The queue for the (vaultId, token) pair is not yet added to the Plasma framework");
        PriorityQueue queue = exitsQueues[key];

        uint256 priority = ExitPriority.computePriority(exitableAt, txPos, exitId);

        queue.insert(priority);

        bytes32 delegationKey = getDelegationKey(priority, vaultId, token);
        require(address(delegations[delegationKey]) == address(0), "The same priority is already enqueued");
        delegations[delegationKey] = exitProcessor;

        emit ExitQueued(exitId, priority);
        return priority;
    }

    /**
     * @notice Processes any exits that have completed the challenge period. Exits are processed according to the exit priority.
     * @dev Emits ProcessedExitsNum event
     * @param vaultId Vault ID of the vault that stores exiting funds
     * @param token The token type to process
     * @param topExitId Unique identifier for prioritizing the first exit to process. Set to zero to skip this check.
     * @param maxExitsToProcess Maximum number of exits to process
     * @param senderData A keccak256 hash of the sender's address
     * @return Total number of processed exits
     */
    function processExits(uint256 vaultId, address token, uint168 topExitId, uint256 maxExitsToProcess, bytes32 senderData) external nonReentrant {
        require(senderData == keccak256(abi.encodePacked(msg.sender)), "Incorrect SenderData");
        bytes32 key = exitQueueKey(vaultId, token);
        require(hasExitQueue(key), "The token is not yet added to the Plasma framework");
        PriorityQueue queue = exitsQueues[key];
        require(queue.currentSize() > 0, "Exit queue is empty");

        uint256 uniquePriority = queue.getMin();
        uint168 exitId = ExitPriority.parseExitId(uniquePriority);
        require(topExitId == 0 || exitId == topExitId,
            "Top exit ID of the queue is different to the one specified");

        bytes32 delegationKey = getDelegationKey(uniquePriority, vaultId, token);
        IExitProcessor processor = delegations[delegationKey];
        uint256 processedNum = 0;

        while (processedNum < maxExitsToProcess && ExitPriority.parseExitableAt(uniquePriority) < block.timestamp) {
            delete delegations[delegationKey];
            queue.delMin();
            processedNum++;

            processor.processExit(exitId, vaultId, token, msg.sender);

            if (queue.currentSize() == 0) {
                break;
            }

            uniquePriority = queue.getMin();
            delegationKey = getDelegationKey(uniquePriority, vaultId, token);
            exitId = ExitPriority.parseExitId(uniquePriority);
            processor = delegations[delegationKey];
        }

        emit ProcessedExitsNum(processedNum, vaultId, token);
    }

    /**
     * @notice Checks whether any of the output with the given outputIds is already spent
     * @param _outputIds Output IDs to check
     */
    function isAnyInputFinalizedByOtherExit(bytes32[] calldata _outputIds, uint168 exitId) external view returns (bool) {
        for (uint i = 0; i < _outputIds.length; i++) {
            uint168 finalizedExitId = outputsFinalizations[_outputIds[i]];
            if (finalizedExitId != 0 && finalizedExitId != exitId) {
                return true;
            }
        }
        return false;
    }

    /**
     * @notice Batch flags already spent outputs (only not already spent)
     * @param outputIds Output IDs to flag
     */
    function batchFlagOutputsFinalized(bytes32[] calldata outputIds, uint168 exitId) external onlyFromNonQuarantinedExitGame {
        for (uint i = 0; i < outputIds.length; i++) {
            require(outputIds[i] != bytes32(""), "Should not flag with empty outputId");
            if (outputsFinalizations[outputIds[i]] == 0) {
                outputsFinalizations[outputIds[i]] = exitId;
            }
        }
    }

    /**
     * @notice Flags a single output as spent if it is not flagged already
     * @param outputId The output ID to flag as spent
     */
    function flagOutputFinalized(bytes32 outputId, uint168 exitId) external onlyFromNonQuarantinedExitGame {
        require(outputId != bytes32(""), "Should not flag with empty outputId");
        if (outputsFinalizations[outputId] == 0) {
            outputsFinalizations[outputId] = exitId;
        }
    }

     /**
     * @notice Checks whether output with a given outputId is finalized
     * @param outputId Output ID to check
     */
    function isOutputFinalized(bytes32 outputId) external view returns (bool) {
        return outputsFinalizations[outputId] != 0;
    }

    function getNextExit(uint256 vaultId, address token) external view returns (uint256) {
        bytes32 key = exitQueueKey(vaultId, token);
        return exitsQueues[key].getMin();
    }

    function exitQueueKey(uint256 vaultId, address token) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(vaultId, token));
    }

    function hasExitQueue(bytes32 queueKey) private view returns (bool) {
        return address(exitsQueues[queueKey]) != address(0);
    }

    function getDelegationKey(uint256 priority, uint256 vaultId, address token) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(priority, vaultId, token));
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/mocks/framework/ExitGameControllerMock.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;

contract ExitGameControllerMock is ExitGameController {
    address private maintainer;

    constructor(uint256 _minExitPeriod, uint256 _initialImmuneExitGames)
        public
        ExitGameController(_minExitPeriod, _initialImmuneExitGames)
    {
        maintainer = msg.sender;
    }

    /**
     * override to make it non-abstract contract
     * this mock file set the user that deploys the contract as maintainer to simplify the test.
     */
    function getMaintainer() public view returns (address) {
        return maintainer;
    }
}
