// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossibleERC20.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IImpossibleERC20 {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/libraries/SafeMath.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
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
        return div(a, b, 'SafeMath: division by zero');
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
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/ImpossibleERC20.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;



contract ImpossibleERC20 is IImpossibleERC20 {
    using SafeMath for uint256;

    string public override name = 'Impossible Swap LPs';
    string public override symbol = 'IF-LP';
    uint8 public constant override decimals = 18;
    uint256 public override totalSupply;
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    bytes32 public override DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant override PERMIT_TYPEHASH =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint256) public override nonces;

    constructor() {
        // Initializes a placeholder name/domain separator for testing permit typehashs
        _setupDomainSeparator();
    }

    function _initBetterDesc(address _token0, address _token1) internal {
        // This sets name/symbol to include tokens in LP token
        string memory desc = string(abi.encodePacked(IERC20(_token0).symbol(), '/', IERC20(_token1).symbol()));
        name = string(abi.encodePacked('Impossible Swap LPs: ', desc));
        symbol = string(abi.encodePacked('IF-LP: ', desc));
        _setupDomainSeparator();
    }

    function _setupDomainSeparator() internal {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint256 value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint256 value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value
    ) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint256 value) external override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        if (allowance[from][msg.sender] != uint256(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        require(deadline >= block.timestamp, 'IF: EXPIRED');
        bytes32 digest =
            keccak256(
                abi.encodePacked(
                    '\x19\x01',
                    DOMAIN_SEPARATOR,
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
                )
            );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'IF: INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/libraries/Math.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

// a library for performing various math operations

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/libraries/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossiblePair.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IImpossiblePair is IImpossibleERC20 {
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint256 reserve0, uint256 reserve1);
    event changeInvariant(bool _isXybk, uint256 _ratioStart, uint256 _ratioEnd);
    event updatedTradeFees(uint256 _oldFee, uint256 _newFee);
    event updatedDelay(uint256 _oldDelay, uint256 _newDelay);
    event updatedHardstops(uint8 _ratioStart, uint8 _ratioEnd);
    event updatedWithdrawalFeeRatio(uint256 _oldWithdrawalFee, uint256 _newWithdrawalFee);
    event updatedBoost(
        uint32 _oldBoost0,
        uint32 _oldBoost1,
        uint32 _newBoost0,
        uint32 _newBoost1,
        uint256 _start,
        uint256 _end
    );

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address); // address of token0

    function token1() external view returns (address); // address of token1

    function router() external view returns (address); // address of token1

    function getReserves() external view returns (uint256, uint256); // reserves of token0/token1

    function calcBoost() external view returns (uint256, uint256);

    function mint(address) external returns (uint256);

    function burn(address) external returns (uint256, uint256);

    function swap(
        uint256,
        uint256,
        address,
        bytes calldata
    ) external;

    function skim(address to) external;

    function sync() external;

    function getFeeAndXybk() external view returns (uint256, bool); // Uses single storage slot, save gas

    function delay() external view returns (uint256); // Amount of time delay required before any change to boost etc, denoted in seconds

    function initialize(
        address,
        address,
        address
    ) external;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossibleSwapFactory.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IImpossibleSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
    event UpdatedGovernance(address governance);

    function feeTo() external view returns (address);

    function governance() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;

    function setGovernance(address) external;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossibleCallee.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;

interface IImpossibleCallee {
    function ImpossibleCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/ImpossiblePair.sol

/// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;





/**
    @title  Pair contract for Impossible Swap V3
    @author Impossible Finance
    @notice This factory builds upon basic Uni V2 Pair by adding xybk
            invariant, ability to switch between invariants/boost levels,
            and ability to set asymmetrical tuning.
    @dev    See documentation at: https://docs.impossible.finance/impossible-swap/overview
*/
contract ImpossiblePair is IImpossiblePair, ImpossibleERC20, ReentrancyGuard {
    using SafeMath for uint256;

    uint256 public constant override MINIMUM_LIQUIDITY = 10**3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    /**
     @dev It's impractical to call evm_mine 28800 times per test so we set to 50
     @dev These time vars are based on BSC's 3 second block time
    */
    uint256 private constant THIRTY_MINS = 600;
    uint32 private constant TWO_WEEKS = 403200;
    uint32 private constant ONE_DAY_PROD = 28800;
    uint32 private constant ONE_DAY_TESTING = 50;

    /**
     @dev tradeFee is fee collected per swap in basis points. Init at 30bp.
    */
    uint16 private tradeFee = 30;

    /**
     @dev ratioStart/ratioEnd are hard stops. When ratios of tokens in pools go above
          ratioEnd or below ratioStart, trade in the direction that further imbalances
          pool is halted. Trades that reduce imbalance will still be allowed.
     @dev This is to control amount of IL faced by LPs on a pool-by-pool basis
    */
    uint8 public ratioStart;
    uint8 public ratioEnd;

    bool private isXybk;

    address public override factory;
    address public override token0;
    address public override token1;
    address public override router;

    uint128 private reserve0;
    uint128 private reserve1;

    uint256 public kLast;

    /**
     @dev These are the variables for boost.
     @dev Boosts in practice are a function of oldBoost, newBoost, startBlock and endBlock
     @dev We linearly interpolate between oldBoost and newBoost over the blocks
     @dev Note that governance being able to instantly change boosts is dangerous
     @dev Boost0 applies when pool balance0 >= balance1 (when token1 is the more expensive token)
     @dev Boost1 applies when pool balance1 > balance0 (when token0 is the more expensive token)
    */
    uint32 private oldBoost0 = 1;
    uint32 private oldBoost1 = 1;
    uint32 private newBoost0 = 1;
    uint32 private newBoost1 = 1;

    /**
     @dev BSC mines 10m blocks a year. uint32 will last 400 years before overflowing
    */
    uint256 public startBlockChange;
    uint256 public endBlockChange;

    /**
     @dev feesAccrued is used to batch fees to Impossible to reduce cost for users/LPs
    */
    uint256 private feesAccrued;

    /**
     @dev withdrawalFeeRatio is the fee collected on burn. Init as 1/201=0.4795% fee (if feeOn)
    */
    uint256 public withdrawalFeeRatio = 201; //

    /**
     @dev Delay sets the duration for boost changes over time. Init as 1 day
     @dev In test environment, set to 50 blocks.
    */
    uint256 public override delay = ONE_DAY_TESTING;

    modifier onlyIFRouter() {
        require(msg.sender == router, 'IF: FORBIDDEN');
        _;
    }

    modifier onlyGovernance() {
        require(msg.sender == IImpossibleSwapFactory(factory).governance(), 'IF: FORBIDDEN');
        _;
    }

    /**
     @notice Gets the fee per swap in basis points, as well as if this pair is uni or xybk
     @return _tradeFee Fee per swap in basis points
     @return _isXybk Boolean if this swap is using uniswap or xybk
    */
    function getFeeAndXybk() external view override returns (uint256 _tradeFee, bool _isXybk) {
        _tradeFee = tradeFee;
        _isXybk = isXybk;
    }

    /**
     @notice Gets the reserves in the pair contract
     @return _reserve0 Reserve amount of token0 in the pair
     @return _reserve1 Reserve amount of token1 in the pair
    */
    function getReserves() public view override returns (uint256 _reserve0, uint256 _reserve1) {
        _reserve0 = uint256(reserve0);
        _reserve1 = uint256(reserve1);
    }

    /**
     @notice Getter for the stored boost state
     @dev Helper function for internal use. If uni invariant, all boosts=1
     @return _newBoost0 New boost0 value
     @return _newBoost1 New boost1 value
     @return _oldBoost0 Old boost0 value
     @return _oldBoost1 Old boost1 value
    */
    function getBoost()
        internal
        view
        returns (
            uint32 _newBoost0,
            uint32 _newBoost1,
            uint32 _oldBoost0,
            uint32 _oldBoost1
        )
    {
        _newBoost0 = newBoost0;
        _newBoost1 = newBoost1;
        _oldBoost0 = oldBoost0;
        _oldBoost1 = oldBoost1;
    }

    /**
     @notice Helper function to calculate a linearly interpolated boost
     @dev Calculations: old + |new - old| * (curr-start)/end-start
     @param oldBst The old boost
     @param newBst The new boost
     @param end The endblock which linear interpolation ends at
     @return uint256 Linearly interpolated boost value
    */
    function linInterpolate(
        uint32 oldBst,
        uint32 newBst,
        uint256 end
    ) internal view returns (uint256) {
        uint256 start = startBlockChange;
        if (newBst > oldBst) {
            /// old + diff * (curr-start) / (end-start)
            return
                uint256(oldBst).add(
                    (uint256(newBst).sub(uint256(oldBst))).mul(block.number.sub(start)).div(end.sub(start))
                );
        } else {
            /// old - diff * (curr-start) / (end-start)
            return
                uint256(oldBst).sub(
                    (uint256(oldBst).sub(uint256(newBst))).mul(block.number.sub(start)).div(end.sub(start))
                );
        }
    }

    /**
     @notice Function to get/calculate actual boosts in the system
     @dev If block.number > endBlock, just return new boosts
     @return _boost0 The actual boost0 value
     @return _boost1 The actual boost1 value
    */
    function calcBoost() public view override returns (uint256 _boost0, uint256 _boost1) {
        uint256 _endBlockChange = endBlockChange;
        if (block.number >= _endBlockChange) {
            (uint32 _newBoost0, uint32 _newBoost1, , ) = getBoost();
            _boost0 = uint256(_newBoost0);
            _boost1 = uint256(_newBoost1);
        } else {
            (uint32 _newBoost0, uint32 _newBoost1, uint32 _oldBoost0, uint32 _oldBoost1) = getBoost();
            _boost0 = linInterpolate(_oldBoost0, _newBoost0, _endBlockChange);
            _boost1 = linInterpolate(_oldBoost1, _newBoost1, _endBlockChange);
        }
    }

    /**
     @notice Safe transfer implementation for tokens
     @dev Requires the transfer to succeed and return either null or True
     @param token The token to transfer
     @param to The address to transfer to
     @param value The amount of tokens to transfer
    */
    function _safeTransfer(
        address token,
        address to,
        uint256 value
    ) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'IF: TRANSFER_FAILED');
    }

    /**
     @notice Switches pool from uniswap invariant to xybk invariant
     @dev Can only be called by IF governance
     @dev Requires the pool to be uniswap invariant currently
     @dev _ratioStart and _ratioEnd must be between 0 and 100
     @param _ratioStart If token ratios in pool are below this, trade that further imbalances pool is halted
     @param _ratioEnd If token ratios in pool are above this, trade that further imbalances pool is halted
     @param _newBoost0 The new boost0
     @param _newBoost1 The new boost1
    */
    function makeXybk(
        uint8 _ratioStart,
        uint8 _ratioEnd,
        uint32 _newBoost0,
        uint32 _newBoost1
    ) external onlyGovernance nonReentrant {
        require(!isXybk, 'IF: IS_ALREADY_XYBK');
        require(_ratioStart <= 100 && _ratioEnd <= 100, 'IF: INVALID_RATIO');
        _updateBoost(_newBoost0, _newBoost1);
        ratioStart = _ratioStart;
        ratioEnd = _ratioEnd;
        isXybk = true;
        emit changeInvariant(isXybk, _ratioStart, _ratioEnd);
    }

    /**
     @notice Switches pool from xybk invariant to uniswap invariant
     @dev Can only be called by IF governance
     @dev Requires the pool to be xybk invariant currently
    */
    function makeUni() external onlyGovernance nonReentrant {
        require(isXybk, 'IF: IS_ALREADY_UNI');
        require(block.number >= endBlockChange, 'IF: BOOST_ALREADY_CHANGING');
        require(newBoost0 == 1 && newBoost1 == 1, 'IF: INVALID_BOOST');
        isXybk = false;
        oldBoost0 = 1; // Set boost to 1
        oldBoost1 = 1; // xybk with boost=1 is just xy=k formula
        ratioStart = 0;
        ratioEnd = 100;
        emit changeInvariant(isXybk, ratioStart, ratioEnd);
    }

    /**
     @notice Setter function for trade fee per swap
     @dev Can only be called by IF governance
     @dev uint8 fee means 255 basis points max, or max trade fee of 2.56%
     @dev uint8 type means fee cannot be negative
     @param _newFee The new trade fee collected per swap, in basis points
    */
    function updateTradeFees(uint8 _newFee) external onlyGovernance {
        uint16 _oldFee = tradeFee;
        tradeFee = uint16(_newFee);
        emit updatedTradeFees(_oldFee, _newFee);
    }

    /**
     @notice Setter function for time delay for boost changes
     @dev Can only be called by IF governance
     @dev Delay must be between 30 minutes and 2 weeks
     @param _newDelay The new time delay in BSC blocks (3 second block time)
    */
    function updateDelay(uint256 _newDelay) external onlyGovernance {
        require(_newDelay >= THIRTY_MINS && delay <= TWO_WEEKS, 'IF: INVALID_DELAY');
        uint256 _oldDelay = delay;
        delay = _newDelay;
        emit updatedDelay(_oldDelay, _newDelay);
    }

    /**
     @notice Setter function for hard stop ratios in the pair
     @dev Can only be called by IF governance
     @dev _ratioStart and _ratioEnd must be between 0 and 100
     @dev Note: Allows halting trade in pools through setting _ratioStart > _ratioEnd
     @param _ratioStart If token ratios in pool are below this, trade that further imbalances pool is halted
     @param _ratioEnd If token ratios in pool are above this, trade that further imbalances pool is halted
    */
    function updateHardstops(uint8 _ratioStart, uint8 _ratioEnd) external onlyGovernance nonReentrant {
        require(isXybk, 'IF: IS_CURRENTLY_UNI');
        require(_ratioStart <= 100 && _ratioEnd <= 100, 'IF: INVALID_RATIO');
        ratioStart = _ratioStart;
        ratioEnd = _ratioEnd;
        emit updatedHardstops(_ratioStart, _ratioEnd);
    }

    /**
     @notice Setter function for pool boost state
     @dev Can only be called by IF governance
     @dev Pool has to be using xybk invariant to update boost
     @param _newBoost0 The new boost0
     @param _newBoost1 The new boost1
    */
    function updateBoost(uint32 _newBoost0, uint32 _newBoost1) external onlyGovernance nonReentrant {
        require(isXybk, 'IF: IS_CURRENTLY_UNI');
        _updateBoost(_newBoost0, _newBoost1);
    }

    /**
     @notice Internal helper function to change boosts
     @dev _newBoost0 and _newBoost1 have to be between 1 and 1000000
     @dev Pool cannot already have changing boosts
     @param _newBoost0 The new boost0
     @param _newBoost1 The new boost1
    */
    function _updateBoost(uint32 _newBoost0, uint32 _newBoost1) internal {
        require(
            _newBoost0 >= 1 && _newBoost1 >= 1 && _newBoost0 <= 1000000 && _newBoost1 <= 1000000,
            'IF: INVALID_BOOST'
        );
        require(block.number >= endBlockChange, 'IF: BOOST_ALREADY_CHANGING');
        (uint256 _reserve0, uint256 _reserve1) = getReserves();
        _mintFee(_reserve0, _reserve1);
        oldBoost0 = newBoost0;
        oldBoost1 = newBoost1;
        newBoost0 = _newBoost0;
        newBoost1 = _newBoost1;
        startBlockChange = block.number;
        endBlockChange = block.number + delay;
        emit updatedBoost(oldBoost0, oldBoost1, newBoost0, newBoost1, startBlockChange, endBlockChange);
    }

    /**
     @notice Setter function for the withdrawal fee that goes to Impossible per burn
     @dev Can only be called by IF governance
     @dev Fee is 1/_newFeeRatio. So <1% is 1/(>=100)
     @param _newFeeRatio The new fee ratio
    */
    function updateWithdrawalFeeRatio(uint256 _newFeeRatio) external onlyGovernance {
        require(_newFeeRatio >= 100, 'IF: INVALID_FEE'); // capped at 1%
        uint256 _oldFeeRatio = withdrawalFeeRatio;
        withdrawalFeeRatio = _newFeeRatio;
        emit updatedWithdrawalFeeRatio(_oldFeeRatio, _newFeeRatio);
    }

    /**
     @notice Constructor function for pair address
     @dev For pairs associated with IF swap, msg.sender is always the factory
    */
    constructor() {
        factory = msg.sender;
    }

    /**
     @notice Initialization function by factory on deployment
     @dev Can only be called by factory, and will only be called once
     @dev _initBetterDesc adds token0/token1 symbols to ERC20 LP name, symbol
     @param _token0 Address of token0 in pair
     @param _token0 Address of token1 in pair
     @param _router Address of trusted IF router
    */
    function initialize(
        address _token0,
        address _token1,
        address _router
    ) external override {
        require(msg.sender == factory, 'IF: FORBIDDEN');
        router = _router;
        token0 = _token0;
        token1 = _token1;
        _initBetterDesc(_token0, _token1);
    }

    /**
     @notice Updates reserve state in pair
     @dev No TWAP/oracle functionality
     @param balance0 The new balance for token0
     @param balance1 The new balance for token1
    */
    function _update(uint256 balance0, uint256 balance1) private {
        reserve0 = uint128(balance0);
        reserve1 = uint128(balance1);
        emit Sync(reserve0, reserve1);
    }

    /**
     @notice Mints fee to IF governance multisig treasury
     @dev If feeOn, mint liquidity equal to 4/5th of growth in sqrt(K)
     @param _reserve0 The latest balance for token0 for fee calculations
     @param _reserve1 The latest balance for token1 for fee calculations
     @return feeOn If the mint/burn fee is turned on in this pair
    */
    function _mintFee(uint256 _reserve0, uint256 _reserve1) private returns (bool feeOn) {
        address feeTo = IImpossibleSwapFactory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint256 _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint256 rootK =
                    isXybk ? Math.sqrt(_xybkComputeK(_reserve0, _reserve1)) : Math.sqrt(_reserve0.mul(_reserve1));
                uint256 rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint256 numerator = totalSupply.mul(rootK.sub(rootKLast)).mul(4);
                    uint256 denominator = rootK.add(rootKLast.mul(4));
                    uint256 liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    /**
     @notice Mints LP tokens based on sent underlying tokens. Underlying tokens must already be sent to contract
     @dev Function should be called from IF router unless you know what you're doing
     @dev Openzeppelin reentrancy guards are used
     @param to The address to mint LP tokens to
     @return liquidity The amount of LP tokens minted
    */
    function mint(address to) external override nonReentrant returns (uint256 liquidity) {
        (uint256 _reserve0, uint256 _reserve1) = getReserves(); // gas savings
        uint256 balance0 = IERC20(token0).balanceOf(address(this));
        uint256 balance1 = IERC20(token1).balanceOf(address(this));
        uint256 amount0 = balance0.sub(_reserve0);
        uint256 amount1 = balance1.sub(_reserve1);

        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint256 _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
        }
        require(liquidity > 0, 'IF: INSUFFICIENT_LIQUIDITY_MINTED');
        _mint(to, liquidity);

        _update(balance0, balance1);
        if (feeOn) kLast = isXybk ? _xybkComputeK(balance0, balance1) : balance0.mul(balance1);
        emit Mint(msg.sender, amount0, amount1);
    }

    /**
     @notice Burns LP tokens and returns underlying tokens. LP tokens must already be sent to contract
     @dev Function should be called from IF router unless you know what you're doing
     @dev Openzeppelin reentrancy guards are used
     @param to The address to send underlying tokens to
     @return amount0 The amount of token0's sent
     @return amount1 The amount of token1's sent
    */
    function burn(address to) external override nonReentrant returns (uint256 amount0, uint256 amount1) {
        (uint256 _reserve0, uint256 _reserve1) = getReserves(); // gas savings
        bool feeOn = _mintFee(_reserve0, _reserve1);
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        uint256 balance0 = IERC20(_token0).balanceOf(address(this));
        uint256 balance1 = IERC20(_token1).balanceOf(address(this));
        uint256 liquidity = balanceOf[address(this)];

        {
            uint256 _totalSupply = totalSupply;
            amount0 = liquidity.mul(balance0) / _totalSupply;
            amount1 = liquidity.mul(balance1) / _totalSupply;

            require(amount0 > 0 && amount1 > 0, 'IF: INSUFFICIENT_LIQUIDITY_BURNED');

            if (feeOn) {
                uint256 _feeRatio = withdrawalFeeRatio; // 1/201 ~= 0.4975%
                amount0 -= amount0.div(_feeRatio);
                amount1 -= amount1.div(_feeRatio);
                // Takes the 0.4975% Fee of LP tokens and adds allowance to claim for the IImpossibleSwapFactory feeTo Address
                feesAccrued = feesAccrued.add(liquidity.div(_feeRatio));
                _burn(address(this), liquidity.sub(liquidity.div(_feeRatio)));
            } else {
                _burn(address(this), liquidity);
            }

            _safeTransfer(_token0, to, amount0);
            _safeTransfer(_token1, to, amount1);
        }

        {
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
            _update(balance0, balance1);
            if (feeOn) kLast = isXybk ? _xybkComputeK(balance0, balance1) : balance0.mul(balance1);
        }
        emit Burn(msg.sender, amount0, amount1, to);
    }

    /**
     @notice Performs a swap operation. Tokens must already be sent to contract
     @dev Input/output amount of tokens must >0 and pool needs to have sufficient liquidity
     @dev Openzeppelin reentrancy guards are used
     @dev Swap is reverted if it exceeds lower or upper hard stops
     @dev Post-swap invariant check is performed (either uni or xybk)
     @param amount0Out The amount of token0's to output
     @param amount1Out The amount of token1's to output
     @param to The address to output tokens to
     @param data Call data allowing for another function call
    */
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external override onlyIFRouter nonReentrant {
        require(amount0Out > 0 || amount1Out > 0, 'IF: INSUFFICIENT_OUTPUT_AMOUNT');
        (uint256 _reserve0, uint256 _reserve1) = getReserves(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'IF: INSUFFICIENT_LIQUIDITY');

        uint256 balance0;
        uint256 balance1;
        uint256 amount0In;
        uint256 amount1In;
        {
            require(to != token0 && to != token1, 'IF: INVALID_TO');
            if (amount0Out > 0) _safeTransfer(token0, to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) _safeTransfer(token1, to, amount1Out); // optimistically transfer tokens
            if (data.length > 0) IImpossibleCallee(to).ImpossibleCall(msg.sender, amount0Out, amount1Out, data);
            balance0 = IERC20(token0).balanceOf(address(this));
            balance1 = IERC20(token1).balanceOf(address(this));
            // Check bounds
            amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
            amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        }

        require(amount0In > 0 || amount1In > 0, 'IF: INSUFFICIENT_INPUT_AMOUNT');

        {
            // Avoid stack too deep errors
            bool _isXybk = isXybk;
            if (_isXybk) {
                bool side = balance0 >= balance1;
                uint256 ratio = side ? ratioStart : ratioEnd;
                if (side && ratio > 0) {
                    require(balance1.mul(ratio) < balance0.mul(100 - ratio), 'IF: EXCEED_UPPER_STOP');
                } else if (!side && ratio < 100) {
                    require(balance0.mul(ratio) > balance1.mul(100 - ratio), 'IF: EXCEED_LOWER_STOP');
                }
            }
            uint256 _tradeFee = uint256(tradeFee);
            uint256 balance0Adjusted = balance0.mul(10000).sub(amount0In.mul(_tradeFee)); // tradeFee amt of basis pts
            uint256 balance1Adjusted = balance1.mul(10000).sub(amount1In.mul(_tradeFee)); // tradeFee amt of basis pts
            _isXybk
                ? require(
                    _xybkCheckK(balance0Adjusted, balance1Adjusted, _xybkComputeK(_reserve0, _reserve1).mul(10000**2)),
                    'IF: INSUFFICIENT_XYBK_K'
                )
                : require(
                    balance0Adjusted.mul(balance1Adjusted) >= _reserve0.mul(_reserve1).mul(10000**2),
                    'IF: INSUFFICIENT_UNI_K'
                );
        }

        _update(balance0, balance1);

        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    /**
     @notice Internal function to compute the K value for an xybk pair based on token balances and boost
     @dev More details on math at: https://docs.impossible.finance/impossible-swap/swap-math
     @param _balance0 Current state of balance0 in contract
     @param _balance1 Current state of balance1 in contract
     @return k Value of K invariant
    */
    function _xybkComputeK(uint256 _balance0, uint256 _balance1) private view returns (uint256 k) {
        (uint256 _boost0, uint256 _boost1) = calcBoost();
        uint256 boost = (_balance0 > _balance1) ? _boost0.sub(1) : _boost1.sub(1);
        uint256 denom = boost.mul(2).add(1); // 1+2*boost
        uint256 term = boost.mul(_balance0.add(_balance1)).div(denom.mul(2)); // boost*(x+y)/(2+4*boost)
        k = (Math.sqrt(term**2 + _balance0.mul(_balance1).div(denom)) + term)**2;
    }

    /**
     @notice Performing K invariant check through an approximation from old K
     @dev More details on math at: https://docs.impossible.finance/impossible-swap/swap-math
     @dev If K_new >= K_old, correctness should still hold
     @param _balance0 Current state of balance0 in contract
     @param _balance1 Current state of balance1 in contract
     @param _oldK The K value pre-swap
     @return bool Whether the new balances satisfy the K check for xybk
    */
    function _xybkCheckK(
        uint256 _balance0,
        uint256 _balance1,
        uint256 _oldK
    ) private view returns (bool) {
        uint256 sqrtOldK = Math.sqrt(_oldK);
        (uint256 _boost0, uint256 _boost1) = calcBoost();
        uint256 boost = (_balance0 > _balance1) ? _boost0.sub(1) : _boost1.sub(1);
        uint256 innerTerm = boost.mul(sqrtOldK);
        return (_balance0.add(innerTerm)).mul(_balance1.add(innerTerm)).div((boost.add(1))**2) >= _oldK;
    }

    /**
     @notice Claims LP tokens to IF governance based on accumulated mint/burn fees
     @dev More details on math at: https://docs.impossible.finance/impossible-swap/swap-math
     @dev Openzeppelin reentrancy guards are used
    */
    function claimFees() external nonReentrant {
        uint256 transferAmount = feesAccrued;
        feesAccrued = 0; //Resets amount owed to claim to zero first
        _safeTransfer(address(this), IImpossibleSwapFactory(factory).feeTo(), transferAmount); //Tranfers owed debt to fee collection address
    }

    /**
     @notice Forces balances to match reserves
     @dev Requires balance0 >= reserve0 and balance1 >= reserve1
     @param to Address to send excess underlying tokens to
    */
    function skim(address to) external override nonReentrant {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        (uint256 _reserve0, uint256 _reserve1) = getReserves();
        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(_reserve0));
        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(_reserve1));
    }

    /**
     @notice Forces reserves to match balances
    */
    function sync() external override nonReentrant {
        uint256 _balance0 = IERC20(token0).balanceOf(address(this));
        uint256 _balance1 = IERC20(token1).balanceOf(address(this));
        _update(_balance0, _balance1);
    }
}
