// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IDFSRegistry.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IERC20.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/Address.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/SafeMath.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/SafeERC20.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/auth/AdminVault.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/auth/AdminAuth.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/DS/DSMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract DSMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "");
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "");
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "");
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x / y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }

    function imin(int256 x, int256 y) internal pure returns (int256 z) {
        return x <= y ? x : y;
    }

    function imax(int256 x, int256 y) internal pure returns (int256 z) {
        return x >= y ? x : y;
    }

    uint256 constant WAD = 10**18;
    uint256 constant RAY = 10**27;

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/mcd/IManager.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IManager {
    function last(address) virtual public returns (uint);
    function cdpCan(address, uint, address) virtual public view returns (uint);
    function ilks(uint) virtual public view returns (bytes32);
    function owns(uint) virtual public view returns (address);
    function urns(uint) virtual public view returns (address);
    function vat() virtual public view returns (address);
    function open(bytes32, address) virtual public returns (uint);
    function give(uint, address) virtual public;
    function cdpAllow(uint, address, uint) virtual public;
    function urnAllow(address, uint) virtual public;
    function frob(uint, int, int) virtual public;
    function flux(uint, address, uint) virtual public;
    function move(uint, address, uint) virtual public;
    function exit(address, uint, address, uint) virtual public;
    function quit(uint, address) virtual public;
    function enter(address, uint) virtual public;
    function shift(uint, uint) virtual public;
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/mcd/IVat.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IVat {

    struct Urn {
        uint256 ink;   // Locked Collateral  [wad]
        uint256 art;   // Normalised Debt    [wad]
    }

    struct Ilk {
        uint256 Art;   // Total Normalised Debt     [wad]
        uint256 rate;  // Accumulated Rates         [ray]
        uint256 spot;  // Price with Safety Margin  [ray]
        uint256 line;  // Debt Ceiling              [rad]
        uint256 dust;  // Urn Debt Floor            [rad]
    }

    mapping (bytes32 => mapping (address => Urn )) public urns;
    mapping (bytes32 => Ilk)                       public ilks;
    mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]

    function can(address, address) virtual public view returns (uint);
    function dai(address) virtual public view returns (uint);
    function frob(bytes32, address, address, address, int, int) virtual public;
    function hope(address) virtual public;
    function move(address, address, uint) virtual public;
    function fork(bytes32, address, address, int, int) virtual public;
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/mcd/IPipInterface.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract IPipInterface {
    function read() public virtual returns (bytes32);
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/mcd/ISpotter.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract ISpotter {
    struct Ilk {
        IPipInterface pip;
        uint256 mat;
    }

    mapping (bytes32 => Ilk) public ilks;

    uint256 public par;

}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/IDSProxy.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/utils/DefisaverLogger.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/StrategyData.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/core/Subscriptions.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/interfaces/ITrigger.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

abstract contract ITrigger {
    function isTriggered(bytes memory, bytes memory) public virtual returns (bool);
}

// File: ../sc_datasets/DAppSCAN/consensys-DeFi_Saver/defisaver-v3-contracts-cb29669a84c2d6fffaf2231c0938eb407c060919/contracts/triggers/McdRatioTrigger.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;






contract McdRatioTrigger is ITrigger, AdminAuth, DSMath {
    IManager public constant manager = IManager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
    IVat public constant vat = IVat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
    ISpotter public constant spotter = ISpotter(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);

    enum RatioState {OVER, UNDER}

    function isTriggered(bytes memory _callData, bytes memory _subData)
        public
        view
        override
        returns (bool)
    {
        uint256 nextPrice = parseParamData(_callData);
        (uint256 cdpId, uint256 ratio, RatioState state) = parseSubData(_subData);

        uint256 currRatio = getRatio(cdpId, nextPrice);

        if (state == RatioState.OVER) {
            if (currRatio > ratio) return true;
        }

        if (state == RatioState.UNDER) {
            if (currRatio < ratio) return true;
        }

        return false;
    }

    function parseSubData(bytes memory _data)
        public
        pure
        returns (
            uint256,
            uint256,
            RatioState
        )
    {
        (uint256 cdpId, uint256 ratio, uint8 state) = abi.decode(_data, (uint256, uint256, uint8));

        return (cdpId, ratio, RatioState(state));
    }

    function parseParamData(bytes memory _data) public pure returns (uint256 nextPrice) {
        (nextPrice) = abi.decode(_data, (uint256));
    }

    /// @notice Gets CDP ratio
    /// @param _cdpId Id of the CDP
    /// @param _nextPrice Next price for user
    function getRatio(uint256 _cdpId, uint256 _nextPrice) public view returns (uint256) {
        bytes32 ilk = manager.ilks(_cdpId);
        uint256 price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;

        (uint256 collateral, uint256 debt) = getCdpInfo(_cdpId, ilk);

        if (debt == 0) return 0;

        return rdiv(wmul(collateral, price), debt) / (10**18);
    }

    /// @notice Gets CDP info (collateral, debt)
    /// @param _cdpId Id of the CDP
    /// @param _ilk Ilk of the CDP
    function getCdpInfo(uint256 _cdpId, bytes32 _ilk) public view returns (uint256, uint256) {
        address urn = manager.urns(_cdpId);

        (uint256 collateral, uint256 debt) = vat.urns(_ilk, urn);
        (, uint256 rate, , , ) = vat.ilks(_ilk);

        return (collateral, rmul(debt, rate));
    }

    /// @notice Gets a price of the asset
    /// @param _ilk Ilk of the CDP
    function getPrice(bytes32 _ilk) public view returns (uint256) {
        (, uint256 mat) = spotter.ilks(_ilk);
        (, , uint256 spot, , ) = vat.ilks(_ilk);

        return rmul(rmul(spot, spotter.par()), mat);
    }
}
