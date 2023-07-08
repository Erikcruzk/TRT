// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IDFSRegistry.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IDFSRegistry {
 
    function getAddr(bytes32 _id) public view virtual returns (address);

    function addNewContract(
        bytes32 _id,
        address _contractAddr,
        uint256 _waitPeriod
    ) public virtual;

    function startContractChange(bytes32 _id, address _newContractAddr) public virtual;

    function approveContractChange(bytes32 _id) public virtual;

    function cancelContractChange(bytes32 _id) public virtual;

    function changeWaitPeriod(bytes32 _id, uint256 _newWaitPeriod) public virtual;
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

interface IERC20 {
    function totalSupply() external view returns (uint256 supply);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function decimals() external view returns (uint256 digits);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
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

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/SafeERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;



library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {ERC20-approve}, and its usage is discouraged.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
        );
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/auth/AdminVault.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/// @title A stateful contract that holds and can change owner/admin
contract AdminVault {
    address public owner;
    address public admin;

    constructor() {
        owner = msg.sender;
        admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;
    }

    /// @notice Admin is able to change owner
    /// @param _owner Address of new owner
    function changeOwner(address _owner) public {
        require(admin == msg.sender, "msg.sender not admin");
        owner = _owner;
    }

    /// @notice Admin is able to set new admin
    /// @param _admin Address of multisig that becomes new admin
    function changeAdmin(address _admin) public {
        require(admin == msg.sender, "msg.sender not admin");
        admin = _admin;
    }

}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/auth/AdminAuth.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/// @title AdminAuth Handles owner/admin priviligies over smart contracts
contract AdminAuth {
    using SafeERC20 for IERC20;

    AdminVault public constant adminVault = AdminVault(0xCCf3d848e08b94478Ed8f46fFead3008faF581fD);

    modifier onlyOwner() {
        require(adminVault.owner() == msg.sender, "msg.sender not owner");
        _;
    }

    modifier onlyAdmin() {
        require(adminVault.admin() == msg.sender, "msg.sender not admin");
        _;
    }

    /// @notice withdraw stuck funds
    function withdrawStuckFunds(address _token, address _receiver, uint256 _amount) public onlyOwner {
        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            payable(_receiver).transfer(_amount);
        } else {
            IERC20(_token).safeTransfer(_receiver, _amount);
        }
    }

    /// @notice Destroy the contract
    function kill() public onlyAdmin {
        selfdestruct(payable(msg.sender));
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/ITrigger.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract ITrigger {
    function isTriggered(bytes memory, bytes memory) public virtual returns (bool);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IDSProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IDSProxy {
    // function execute(bytes memory _code, bytes memory _data)
    //     public
    //     payable
    //     virtual
    //     returns (address, bytes32);

    function execute(address _target, bytes memory _data) public payable virtual returns (bytes32);

    function setCache(address _cacheAddr) public payable virtual returns (bool);

    function owner() public view virtual returns (address);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/StrategyData.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

/// @title Struct data in a separate contract so it can be used in multiple places
contract StrategyData {
    struct Template {
        string name;
        bytes32[] triggerIds;
        bytes32[] actionIds;
        uint8[][] paramMapping;
    }

    struct Task {
        string name;
        bytes[][] callData;
        bytes[][] subData;
        bytes32[] actionIds;
        uint8[][] paramMapping;
    }

    struct Strategy {
        uint templateId;
        address proxy;
        bytes[][] subData;
        bytes[][] triggerData;
        bool active;

        uint posInUserArr;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/DefisaverLogger.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract DefisaverLogger {
    event LogEvent(
        address indexed contractAddress,
        address indexed caller,
        string indexed logName,
        bytes data
    );

    // solhint-disable-next-line func-name-mixedcase
    function Log(
        address _contract,
        address _caller,
        string memory _logName,
        bytes memory _data
    ) public {
        emit LogEvent(_contract, _caller, _logName, _data);
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/Subscriptions.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;




/// @title Storage of strategies and templates
contract Subscriptions is StrategyData, AdminAuth {
    DefisaverLogger public constant logger = DefisaverLogger(0x5c55B921f590a89C1Ebe84dF170E655a82b62126);

    string public constant ERR_EMPTY_STRATEGY = "Strategy does not exist";
    string public constant ERR_SENDER_NOT_OWNER = "Sender is not strategy owner";
    string public constant ERR_USER_POS_EMPTY = "No user positions";

    /// @dev The order of strategies might change as they are deleted
    Strategy[] public strategies;

    /// @dev Templates are fixed and are non removable
    Template[] public templates;

    /// @dev Keeps track of all the users strategies (their indexes in the array)
    mapping (address => uint[]) public usersPos;

    /// @dev Increments on state change, used for easier off chain tracking of changes
    uint public updateCounter;

    /// @notice Creates a new strategy with an existing template
    /// @param _templateId Id of the template used for strategy
    /// @param _active If the strategy is turned on at the start
    /// @param _subData Subscription data for actions
    /// @param _triggerData Subscription data for triggers
    function createStrategy(
        uint _templateId,
        bool _active,
        bytes[][] memory _subData,
        bytes[][] memory _triggerData
    ) public returns (uint) {
        strategies.push(
            Strategy({
                templateId: _templateId,
                proxy: msg.sender,
                active: _active,
                subData: _subData,
                triggerData: _triggerData,
                posInUserArr: (usersPos[msg.sender].length - 1)
            })
        );

        usersPos[msg.sender].push(strategies.length - 1);

        updateCounter++;

        logger.Log(address(this), msg.sender, "CreateStrategy", abi.encode(strategies.length - 1));

        return strategies.length - 1;
    }

    /// @notice Creates a new template to use in strategies
    /// @dev Templates once created can't be changed
    /// @param _name Name of template, used mainly for logging
    /// @param _triggerIds Array of trigger ids which translate to trigger addresses
    /// @param _actionIds Array of actions ids which translate to action addresses
    /// @param _paramMapping Array that holds metadata of how inputs are mapped to sub/return data
    function createTemplate(
        string memory _name,
        bytes32[] memory _triggerIds,
        bytes32[] memory _actionIds,
        uint8[][] memory _paramMapping
    ) public returns (uint) {
        
        templates.push(
            Template({
                name: _name,
                triggerIds: _triggerIds,
                actionIds: _actionIds,
                paramMapping: _paramMapping
            })
        );

        updateCounter++;

        logger.Log(address(this), msg.sender, "CreateTemplate", abi.encode(templates.length - 1));

        return templates.length - 1;
    }

    /// @notice Updates the users strategy
    /// @dev Only callable by proxy who created the strategy
    /// @param _startegyId Id of the strategy to update
    /// @param _templateId Id of the template used for strategy
    /// @param _active If the strategy is turned on at the start
    /// @param _subData Subscription data for actions
    /// @param _triggerData Subscription data for triggers
    function updateStrategy(
        uint _startegyId,
        uint _templateId,
        bool _active,
        bytes[][] memory _subData,
        bytes[][] memory _triggerData
    ) public {
        Strategy storage s = strategies[_startegyId];

        require(s.proxy != address(0), ERR_EMPTY_STRATEGY);
        require(msg.sender == s.proxy, ERR_SENDER_NOT_OWNER);

        s.templateId = _templateId;
        s.active = _active;
        s.subData = _subData;
        s.triggerData = _triggerData;

        updateCounter++;

        logger.Log(address(this), msg.sender, "UpdateStrategy", abi.encode(_startegyId));
    }

    /// @notice Unsubscribe an existing strategy
    /// @dev Only callable by proxy who created the strategy
    /// @param _subId Subscription id
    function removeStrategy(uint256 _subId) public {
        Strategy memory s = strategies[_subId];
        require(s.proxy != address(0), ERR_EMPTY_STRATEGY);
        require(msg.sender == s.proxy, ERR_SENDER_NOT_OWNER);

        uint lastSub = strategies.length - 1;

        _removeUserPos(msg.sender, s.posInUserArr);

        strategies[_subId] = strategies[lastSub]; // last strategy put in place of the deleted one
        strategies.pop(); // delete last strategy, because it moved

        logger.Log(address(this), msg.sender, "Unsubscribe", abi.encode(_subId));
    }

    function _removeUserPos(address _user, uint _index) internal {
        require(usersPos[_user].length > 0, ERR_USER_POS_EMPTY);
        uint lastPos = usersPos[_user].length - 1;

        usersPos[_user][_index] = usersPos[_user][lastPos];
        usersPos[_user].pop();
    }

    ///////////////////// VIEW ONLY FUNCTIONS ////////////////////////////

    function getTemplateFromStrategy(uint _strategyId) public view returns (Template memory) {
        uint templateId = strategies[_strategyId].templateId;
        return templates[templateId];
    }

    function getStrategy(uint _strategyId) public view returns (Strategy memory) {
        return strategies[_strategyId];
    }

    function getTemplate(uint _templateId) public view returns (Template memory) {
        return templates[_templateId];
    }

    function getStrategyCount() public view returns (uint256) {
        return strategies.length;
    }

    function getTemplateCount() public view returns (uint256) {
        return templates.length;
    }

    function getStrategies() public view returns (Strategy[] memory) {
        return strategies;
    }

    function getTemplates() public view returns (Template[] memory) {
        return templates;
    }

    function userHasStrategies(address _user) public view returns (bool) {
        return usersPos[_user].length > 0;
    }

    function getUserStrategies(address _user) public view returns (Strategy[] memory) {
        Strategy[] memory userStrategies = new Strategy[](usersPos[_user].length);
        
        for (uint i = 0; i < usersPos[_user].length; ++i) {
            userStrategies[i] = strategies[usersPos[_user][i]];
        }

        return userStrategies;
    }

    function getPaginatedStrategies(uint _page, uint _perPage) public view returns (Strategy[] memory) {
        Strategy[] memory strategiesPerPage = new Strategy[](_perPage);

        uint start = _page * _perPage;
        uint end = start + _perPage;

        end = (end > strategiesPerPage.length) ? strategiesPerPage.length : end;

        uint count = 0;
        for (uint i = start; i < end; i++) {
            strategiesPerPage[count] = strategies[i];
            count++;
        }

        return strategiesPerPage;
    }

    function getPaginatedTemplates(uint _page, uint _perPage) public view returns (Template[] memory) {
        Template[] memory templatesPerPage = new Template[](_perPage);

        uint start = _page * _perPage;
        uint end = start + _perPage;

        end = (end > templatesPerPage.length) ? templatesPerPage.length : end;

        uint count = 0;
        for (uint i = start; i < end; i++) {
            templatesPerPage[count] = templates[i];
            count++;
        }

        return templatesPerPage;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/BotAuth.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/// @title Handles authorization of who can call the execution of strategies
contract BotAuth is AdminAuth {
    mapping(address => bool) public approvedCallers;

    /// @notice Checks if the caller is approved for the specific strategy
    /// @dev Currently auth callers are approved for all strategies
    /// @param _caller Address of the caller
    function isApproved(uint256, address _caller) public view returns (bool) {
        return approvedCallers[_caller];
    }

    /// @notice Adds a new bot address which will be able to call repay/boost
    /// @param _caller Bot address
    function addCaller(address _caller) public onlyOwner {
        approvedCallers[_caller] = true;
    }

    /// @notice Removes a bot address so it can't call repay/boost
    /// @param _caller Bot address
    function removeCaller(address _caller) public onlyOwner {
        approvedCallers[_caller] = false;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/DFSRegistry.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/// @title Stores all the important DFS addresses and can be changed (timelock)
contract DFSRegistry is AdminAuth {
    DefisaverLogger public constant logger = DefisaverLogger(
        0x5c55B921f590a89C1Ebe84dF170E655a82b62126
    );

    string public constant ERR_ENTRY_ALREADY_EXISTS = "Entry id already exists";
    string public constant ERR_ENTRY_NON_EXISTENT = "Entry id doesn't exists";
    string public constant ERR_ENTRY_NOT_IN_CHANGE = "Entry not in change process";
    string public constant ERR_WAIT_PERIOD_SHORTER = "New wait period must be bigger";
    string public constant ERR_CHANGE_NOT_READY = "Change not ready yet";
    string public constant ERR_EMPTY_PREV_ADDR = "Previous addr is 0";
    string public constant ERR_ALREADY_IN_CONTRACT_CHANGE = "Already in contract change";
    string public constant ERR_ALREADY_IN_WAIT_PERIOD_CHANGE = "Already in wait period change";

    struct Entry {
        address contractAddr;
        uint256 waitPeriod;
        uint256 changeStartTime;
        bool inContractChange;
        bool inWaitPeriodChange;
        bool exists;
    }

    mapping(bytes32 => Entry) public entries;
    mapping(bytes32 => address) public previousAddresses;

    mapping(bytes32 => address) public pendingAddresses;
    mapping(bytes32 => uint256) public pendingWaitTimes;

    /// @notice Given an contract id returns the registred address
    /// @dev Id is keccak256 of the contract name
    /// @param _id Id of contract
    function getAddr(bytes32 _id) public view returns (address) {
        return entries[_id].contractAddr;
    }

    /// @notice Helper function to easily query if id is registred
    /// @param _id Id of contract
    function isRegistered(bytes32 _id) public view returns (bool) {
        return entries[_id].exists;
    }

    /////////////////////////// OWNER ONLY FUNCTIONS ///////////////////////////

    /// @notice Adds a new contract to the registry
    /// @param _id Id of contract
    /// @param _contractAddr Address of the contract
    /// @param _waitPeriod Amount of time to wait before a contract address can be changed
    function addNewContract(
        bytes32 _id,
        address _contractAddr,
        uint256 _waitPeriod
    ) public onlyOwner {
        require(!entries[_id].exists, ERR_ENTRY_ALREADY_EXISTS);

        entries[_id] = Entry({
            contractAddr: _contractAddr,
            waitPeriod: _waitPeriod,
            changeStartTime: 0,
            inContractChange: false,
            inWaitPeriodChange: false,
            exists: true
        });

        // Remember tha address so we can revert back to old addr if needed
        previousAddresses[_id] = _contractAddr;

        logger.Log(
            address(this),
            msg.sender,
            "AddNewContract",
            abi.encode(_id, _contractAddr, _waitPeriod)
        );
    }

    /// @notice Revertes to the previous address immediately
    /// @dev In case the new version has a fault, a quick way to fallback to the old contract
    /// @param _id Id of contract
    function revertToPreviousAddress(bytes32 _id) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(previousAddresses[_id] != address(0), ERR_EMPTY_PREV_ADDR);

        address currentAddr = entries[_id].contractAddr;
        entries[_id].contractAddr = previousAddresses[_id];

        logger.Log(
            address(this),
            msg.sender,
            "RevertToPreviousAddress",
            abi.encode(_id, currentAddr, previousAddresses[_id])
        );
    }

    /// @notice Starts an address change for an existing entry
    /// @dev Can override a change that is currently in progress
    /// @param _id Id of contract
    /// @param _newContractAddr Address of the new contract
    function startContractChange(bytes32 _id, address _newContractAddr) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(!entries[_id].inWaitPeriodChange, ERR_ALREADY_IN_WAIT_PERIOD_CHANGE);

        entries[_id].changeStartTime = block.timestamp; // solhint-disable-line
        entries[_id].inContractChange = true;

        pendingAddresses[_id] = _newContractAddr;

        logger.Log(
            address(this),
            msg.sender,
            "StartContractChange",
            abi.encode(_id, entries[_id].contractAddr, _newContractAddr)
        );
    }

    /// @notice Changes new contract address, correct time must have passed
    /// @param _id Id of contract
    function approveContractChange(bytes32 _id) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(entries[_id].inContractChange, ERR_ENTRY_NOT_IN_CHANGE);
        require(
            block.timestamp >= (entries[_id].changeStartTime + entries[_id].waitPeriod), // solhint-disable-line
            ERR_CHANGE_NOT_READY
        );

        address oldContractAddr = entries[_id].contractAddr;
        entries[_id].contractAddr = pendingAddresses[_id];
        entries[_id].inContractChange = false;
        entries[_id].changeStartTime = 0;

        pendingAddresses[_id] = address(0);
        previousAddresses[_id] = oldContractAddr;

        logger.Log(
            address(this),
            msg.sender,
            "ApproveContractChange",
            abi.encode(_id, oldContractAddr, entries[_id].contractAddr)
        );
    }

    /// @notice Cancel pending change
    /// @param _id Id of contract
    function cancelContractChange(bytes32 _id) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(entries[_id].inContractChange, ERR_ENTRY_NOT_IN_CHANGE);

        address oldContractAddr = pendingAddresses[_id];

        pendingAddresses[_id] = address(0);
        entries[_id].inContractChange = false;
        entries[_id].changeStartTime = 0;

        logger.Log(
            address(this),
            msg.sender,
            "CancelContractChange",
            abi.encode(_id, oldContractAddr, entries[_id].contractAddr)
        );
    }

    /// @notice Starts the change for waitPeriod
    /// @param _id Id of contract
    /// @param _newWaitPeriod New wait time
    function startWaitPeriodChange(bytes32 _id, uint256 _newWaitPeriod) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(!entries[_id].inContractChange, ERR_ALREADY_IN_CONTRACT_CHANGE);

        pendingWaitTimes[_id] = _newWaitPeriod;

        entries[_id].changeStartTime = block.timestamp; // solhint-disable-line
        entries[_id].inWaitPeriodChange = true;

        logger.Log(
            address(this),
            msg.sender,
            "StartWaitPeriodChange",
            abi.encode(_id, _newWaitPeriod)
        );
    }

    /// @notice Changes new wait period, correct time must have passed
    /// @param _id Id of contract
    function approveWaitPeriodChange(bytes32 _id) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(entries[_id].inWaitPeriodChange, ERR_ENTRY_NOT_IN_CHANGE);
        require(
            block.timestamp >= (entries[_id].changeStartTime + entries[_id].waitPeriod), // solhint-disable-line
            ERR_CHANGE_NOT_READY
        );

        uint256 oldWaitTime = entries[_id].waitPeriod;
        entries[_id].waitPeriod = pendingWaitTimes[_id];
        
        entries[_id].inWaitPeriodChange = false;
        entries[_id].changeStartTime = 0;

        pendingWaitTimes[_id] = 0;

        logger.Log(
            address(this),
            msg.sender,
            "ApproveWaitPeriodChange",
            abi.encode(_id, oldWaitTime, entries[_id].waitPeriod)
        );
    }

    /// @notice Cancel wait period change
    /// @param _id Id of contract
    function cancelWaitPeriodChange(bytes32 _id) public onlyOwner {
        require(entries[_id].exists, ERR_ENTRY_NON_EXISTENT);
        require(entries[_id].inWaitPeriodChange, ERR_ENTRY_NOT_IN_CHANGE);

        uint256 oldWaitPeriod = pendingWaitTimes[_id];

        pendingWaitTimes[_id] = 0;
        entries[_id].inWaitPeriodChange = false;
        entries[_id].changeStartTime = 0;

        logger.Log(
            address(this),
            msg.sender,
            "CancelWaitPeriodChange",
            abi.encode(_id, oldWaitPeriod, entries[_id].waitPeriod)
        );
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/ProxyAuth.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;



/// @title ProxyAuth Gets DSProxy auth from users and is callable by the Executor
contract ProxyAuth is AdminAuth {

    address public constant REGISTRY_ADDR = 0xB0e1682D17A96E8551191c089673346dF7e1D467;
    IDFSRegistry public constant registry = IDFSRegistry(REGISTRY_ADDR);

    bytes32 constant STRATEGY_EXECUTOR_ID = keccak256("StrategyExecutor");
    string public constant ERR_SENDER_NOT_EXECUTOR = "Sender not executor addr";

    modifier onlyExecutor {
        address executorAddr = registry.getAddr(STRATEGY_EXECUTOR_ID);
        require(msg.sender == executorAddr, ERR_SENDER_NOT_EXECUTOR);
        _;
    }

    /// @notice Calls the .execute() method of the specified users DSProxy
    /// @dev Contract gets the authority from the user to call it, only callable by Executor
    /// @param _proxyAddr Address of the users DSProxy
    /// @param _contractAddr Address of the contract which to execute
    /// @param _data Call data of the function to be called
    function callExecute(
        address _proxyAddr,
        address _contractAddr,
        bytes memory _data
    ) public payable onlyExecutor {

        IDSProxy(_proxyAddr).execute{value: msg.value}(_contractAddr, _data);

        // return if anything left
        if (address(this).balance > 0) {
            msg.sender.transfer(address(this).balance);
        }
    }

}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-DeFi Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/StrategyExecutor.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;








/// @title Main entry point for executing automated strategies
contract StrategyExecutor is StrategyData, AdminAuth {

    address public constant PROXY_AUTH_ADDR = 0x3Aa5ebB10DC797CAC828524e59A333d0A371443c;

    address public constant REGISTRY_ADDR = 0xB0e1682D17A96E8551191c089673346dF7e1D467;
    DFSRegistry public constant registry = DFSRegistry(REGISTRY_ADDR);

    bytes32 constant BOT_AUTH_ID = keccak256("BotAuth");
    bytes32 constant SUBSCRIPTION_ID = keccak256("Subscriptions");
    bytes32 constant TASK_MANAGER_ID = keccak256("TaskExecutor");

    string public constant ERR_TRIGGER_NOT_ACTIVE = "Trigger not activated";
    string public constant ERR_BOT_NOT_APPROVED = "Bot is not approved";
    string public constant ERR_STARTEGY_NOT_ACTIVE = "Strategy is not active";

    /// @notice Checks all the triggers and executes actions
    /// @dev Only auhtorized callers can execute it
    /// @param _strategyId Id of the strategy
    /// @param _triggerCallData All input data needed to execute triggers
    /// @param _actionsCallData All input data needed to execute actions
    function executeStrategy(
        uint256 _strategyId,
        bytes[][] memory _triggerCallData,
        bytes[][] memory _actionsCallData
    ) public   {
        Subscriptions sub = Subscriptions(registry.getAddr(SUBSCRIPTION_ID));

        Strategy memory strategy = sub.getStrategy(_strategyId);
        require(strategy.active, ERR_STARTEGY_NOT_ACTIVE);

        // check bot auth
        checkCallerAuth(_strategyId);

        // check if all the triggers are true
        checkTriggers(_strategyId, strategy, _triggerCallData, sub);

        // execute actions
        callActions(_strategyId, strategy, _actionsCallData);
    }

    /// @notice Checks if msg.sender has auth, reverts if not
    /// @param _strategyId Id of the strategy
    function checkCallerAuth(uint256 _strategyId) public view {
        address botAuthAddr = registry.getAddr(BOT_AUTH_ID);
        require(
            BotAuth(botAuthAddr).isApproved(_strategyId, msg.sender),
            ERR_BOT_NOT_APPROVED
        );
    }

    /// @notice Checks if all the triggers are true, reverts if not
    /// @param _strategy Strategy data we have in storage
    /// @param _triggerCallData All input data needed to execute triggers
    function checkTriggers(
        uint _strategyId,
        Strategy memory _strategy,
        bytes[][] memory _triggerCallData,
        Subscriptions _sub
    ) public {

        bytes32[] memory triggerIds = _sub.getTemplateFromStrategy(_strategyId).triggerIds;

        for (uint256 i = 0; i < triggerIds.length; ++i) {
            address triggerAddr = registry.getAddr(triggerIds[i]);

            // TODO: change the 0
            bool isTriggered = ITrigger(triggerAddr).isTriggered(_triggerCallData[i][0], _strategy.triggerData[i][0]);
            require(isTriggered, ERR_TRIGGER_NOT_ACTIVE);
        }
    }

    /// @notice Execute all the actions in order
    /// @param _strategy Strategy data we have in storage
    /// @param _actionsCallData All input data needed to execute actions
    function callActions(uint _strategyId, Strategy memory _strategy, bytes[][] memory _actionsCallData) internal {
        address actionManagerProxyAddr = registry.getAddr(TASK_MANAGER_ID);

        ProxyAuth(PROXY_AUTH_ADDR).callExecute{value: msg.value}(
            _strategy.proxy,
            actionManagerProxyAddr,
            abi.encodeWithSignature(
                "executeStrategyTask(uint256,bytes[][])",
                _strategyId,
                _actionsCallData
            )
        );
    }
}
