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

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/interfaces/IImpossibleWrappedToken.sol

// SPDX-License-Identifier: GPL-3
// Copyright (C) 2015, 2016, 2017 Dapphub

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity =0.7.6;

interface IImpossibleWrappedToken is IERC20 {
    function deposit(address) external returns (uint256);

    function withdraw(address, uint256) external returns (uint256);

    function amtToUnderlyingAmt(uint256) external returns (uint256);
}

/*
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

                       TERMS AND CONDITIONS

  0. Definitions.

  "This License" refers to version 3 of the GNU General Public License.

  "Copyright" also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.

  "The Program" refers to any copyrightable work licensed under this
License.  Each licensee is addressed as "you".  "Licensees" and
"recipients" may be individuals or organizations.

  To "modify" a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a "modified version" of the
earlier work or a work "based on" the earlier work.

  A "covered work" means either the unmodified Program or a work based
on the Program.

  To "propagate" a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.

  To "convey" a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.

  An interactive user interface displays "Appropriate Legal Notices"
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.

  1. Source Code.

  The "source code" for a work means the preferred form of the work
for making modifications to it.  "Object code" means any non-source
form of a work.

  A "Standard Interface" means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.

  The "System Libraries" of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
"Major Component", in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.

  The "Corresponding Source" for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.

  The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.

  The Corresponding Source for a work in source code form is that
same work.

  2. Basic Permissions.

  All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.

  You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.

  Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.

  3. Protecting Users' Legal Rights From Anti-Circumvention Law.

  No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.

  When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.

  4. Conveying Verbatim Copies.

  You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.

  You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.

  5. Conveying Modified Source Versions.

  You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:

    a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.

    b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    "keep intact all notices".

    c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.

    d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.

  A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
"aggregate" if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.

  6. Conveying Non-Source Forms.

  You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:

    a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.

    b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.

    c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.

    d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.

    e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.

  A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.

  A "User Product" is either (1) a "consumer product", which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, "normally used" refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.

  "Installation Information" for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.

  If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).

  The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.

  Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.

  7. Additional Terms.

  "Additional permissions" are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.

  When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.

  Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:

    a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or

    b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or

    c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or

    d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or

    e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or

    f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.

  All other non-permissive additional terms are considered "further
restrictions" within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.

  If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.

  Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.

  8. Termination.

  You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).

  However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.

  Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.

  Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.

  9. Acceptance Not Required for Having Copies.

  You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.

  10. Automatic Licensing of Downstream Recipients.

  Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.

  An "entity transaction" is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.

  You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.

  11. Patents.

  A "contributor" is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's "contributor version".

  A contributor's "essential patent claims" are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, "control" includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.

  Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.

  In the following three paragraphs, a "patent license" is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To "grant" such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.

  If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  "Knowingly relying" means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.

  If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.

  A patent license is "discriminatory" if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.

  Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.

  12. No Surrender of Others' Freedom.

  If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.

  13. Use with the GNU Affero General Public License.

  Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.

  14. Revised Versions of this License.

  The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

  Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.

  If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.

  Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.

  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. Limitation of Liability.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

  17. Interpretation of Sections 15 and 16.

  If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in return for a fee.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) <year>  <name of author>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:

    <program>  Copyright (C) <year>  <name of author>
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an "about box".

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
<http://www.gnu.org/licenses/>.

  The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
<http://www.gnu.org/philosophy/why-not-lgpl.html>.

*/

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/ImpossibleWrappedToken.sol

// SPDX-License-Identifier: GPL-3
// Copyright (C) 2015, 2016, 2017 Dapphub

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity =0.7.6;



contract ImpossibleWrappedToken is IImpossibleWrappedToken {
    using SafeMath for uint256;

    string public override name;
    string public override symbol;
    uint8 public override decimals = 18;
    uint256 public override totalSupply;

    address public underlying;
    uint256 public underlyingBalance;
    uint256 public ratioNum;
    uint256 public ratioDenom;

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    constructor(
        address _underlying,
        uint256 _ratioNum,
        uint256 _ratioDenom
    ) {
        underlying = _underlying;
        ratioNum = _ratioNum;
        ratioDenom = _ratioDenom;
        string memory desc = string(abi.encodePacked(IERC20(_underlying).symbol()));
        name = string(abi.encodePacked('IF-Wrapped ', desc));
        symbol = string(abi.encodePacked('WIF ', desc));
    }

    // wad = amount of wrapped tokens
    function deposit(address dst, uint256 wad) public returns (uint256 transferAmt) {
        transferAmt = wad.mul(ratioDenom).div(ratioNum);
        bool success = IERC20(underlying).transferFrom(msg.sender, address(this), transferAmt);
        require(success, 'ImpossibleWrapper: TRANSFERFROM_FAILED');
        _deposit(dst, wad);
        underlyingBalance = underlyingBalance.add(transferAmt);
        emit Transfer(address(0), msg.sender, wad);
    }

    // wad = amount of wrapped tokens
    function deposit(address dst) public override returns (uint256 transferAmt) {
        uint256 balance = IERC20(underlying).balanceOf(address(this));
        transferAmt = balance.sub(underlyingBalance);
        uint256 wad = transferAmt.mul(ratioNum).div(ratioDenom);
        _deposit(dst, wad);
        underlyingBalance = balance;
        emit Transfer(address(0), dst, wad);
    }

    // wad = amount of wrapped tokens
    function _deposit(address dst, uint256 wad) internal {
        balanceOf[dst] = balanceOf[dst].add(wad);
        totalSupply = totalSupply.add(wad);
    }

    // wad = amount of wrapped tokens
    function withdraw(address dst, uint256 wad) public override returns (uint256 transferAmt) {
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(wad);
        emit Transfer(msg.sender, address(0), wad);
        return _withdraw(dst, wad);
    }

    function withdraw(
        address src,
        address dst,
        uint256 wad
    ) public returns (uint256 transferAmt) {
        allowance[src][msg.sender] = allowance[src][msg.sender].sub(wad);
        balanceOf[src] = balanceOf[src].sub(wad);
        emit Transfer(src, address(0), wad);
        return _withdraw(dst, wad);
    }

    function _withdraw(address dst, uint256 wad) internal returns (uint256 transferAmt) {
        totalSupply = totalSupply.sub(wad);
        transferAmt = wad.mul(ratioDenom).div(ratioNum);
        bool success = IERC20(underlying).transfer(dst, transferAmt);
        require(success, 'IF Wrapper: UNDERLYING_TRANSFER_FAIL');
        underlyingBalance = underlyingBalance.sub(transferAmt);
    }

    function amtToUnderlyingAmt(uint256 amt) public view override returns (uint256) {
        return amt.mul(ratioDenom).div(ratioNum);
    }

    function approve(address guy, uint256 wad) public override returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) public override returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) public override returns (bool) {
        require(balanceOf[src] >= wad, '');

        if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
            require(allowance[src][msg.sender] >= wad, 'ImpossibleWrapper: INSUFF_ALLOWANCE');
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}

/*
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

                       TERMS AND CONDITIONS

  0. Definitions.

  "This License" refers to version 3 of the GNU General Public License.

  "Copyright" also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.

  "The Program" refers to any copyrightable work licensed under this
License.  Each licensee is addressed as "you".  "Licensees" and
"recipients" may be individuals or organizations.

  To "modify" a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a "modified version" of the
earlier work or a work "based on" the earlier work.

  A "covered work" means either the unmodified Program or a work based
on the Program.

  To "propagate" a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.

  To "convey" a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.

  An interactive user interface displays "Appropriate Legal Notices"
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.

  1. Source Code.

  The "source code" for a work means the preferred form of the work
for making modifications to it.  "Object code" means any non-source
form of a work.

  A "Standard Interface" means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.

  The "System Libraries" of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
"Major Component", in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.

  The "Corresponding Source" for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.

  The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.

  The Corresponding Source for a work in source code form is that
same work.

  2. Basic Permissions.

  All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.

  You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.

  Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.

  3. Protecting Users' Legal Rights From Anti-Circumvention Law.

  No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.

  When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.

  4. Conveying Verbatim Copies.

  You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.

  You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.

  5. Conveying Modified Source Versions.

  You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:

    a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.

    b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    "keep intact all notices".

    c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.

    d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.

  A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
"aggregate" if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.

  6. Conveying Non-Source Forms.

  You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:

    a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.

    b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.

    c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.

    d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.

    e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.

  A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.

  A "User Product" is either (1) a "consumer product", which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, "normally used" refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.

  "Installation Information" for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.

  If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).

  The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.

  Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.

  7. Additional Terms.

  "Additional permissions" are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.

  When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.

  Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:

    a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or

    b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or

    c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or

    d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or

    e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or

    f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.

  All other non-permissive additional terms are considered "further
restrictions" within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.

  If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.

  Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.

  8. Termination.

  You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).

  However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.

  Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.

  Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.

  9. Acceptance Not Required for Having Copies.

  You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.

  10. Automatic Licensing of Downstream Recipients.

  Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.

  An "entity transaction" is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.

  You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.

  11. Patents.

  A "contributor" is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's "contributor version".

  A contributor's "essential patent claims" are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, "control" includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.

  Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.

  In the following three paragraphs, a "patent license" is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To "grant" such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.

  If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  "Knowingly relying" means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.

  If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.

  A patent license is "discriminatory" if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.

  Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.

  12. No Surrender of Others' Freedom.

  If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.

  13. Use with the GNU Affero General Public License.

  Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.

  14. Revised Versions of this License.

  The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

  Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.

  If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.

  Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.

  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. Limitation of Liability.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

  17. Interpretation of Sections 15 and 16.

  If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in returns for a fee.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) <year>  <name of author>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:

    <program>  Copyright (C) <year>  <name of author>
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an "about box".

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
<http://www.gnu.org/licenses/>.

  The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
<http://www.gnu.org/philosophy/why-not-lgpl.html>.

*/

// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_impossible_finance_swap_v1.2/impossible-swap-core-29aaef89f996acdbee92b67c4d95fb608dc8b876/contracts/ImpossibleSwapFactory.sol

// SPDX-License-Identifier: GPL-3
pragma solidity =0.7.6;



/**
    @title  Swap Factory for Impossible Swap V3
    @author Impossible Finance
    @notice This factory builds upon basic Uni V2 factory by changing "feeToSetter"
            to "governance" and adding a whitelist
    @dev    See documentation at: https://docs.impossible.finance/impossible-swap/overview
*/

contract ImpossibleSwapFactory is IImpossibleSwapFactory {
    address public override feeTo;
    address public override governance;
    address public router;
    bool public whitelist;
    mapping(address => bool) public approvedTokens;

    mapping(address => mapping(address => address)) public override getPair;
    address[] public override allPairs;

    /**
     @notice The constructor for the IF swap factory
     @param _governance The address for IF Governance
    */
    constructor(address _governance) {
        governance = _governance;
    }

    modifier onlyGovernance() {
        require(msg.sender == governance, 'IF: FORBIDDEN');
        _;
    }

    /**
     @notice The constructor for the IF swap factory
     @dev _governance The address for IF Governance
     @return uint256 The current number of pairs in the IF swap
    */
    function allPairsLength() external view override returns (uint256) {
        return allPairs.length;
    }

    /**
     @notice Sets router address in factory
     @dev Router is checked in pair contracts to ensure calls are from IF routers only
     @dev Can only be set by IF governance
     @param _router The address of the IF router
    */
    function setRouter(address _router) external onlyGovernance {
        router = _router;
    }

    /**
     @notice Either allow or stop a token from being a valid token for new pair contracts
     @dev Changes can only be made by IF governance
     @param token The address of the token
     @param allowed The boolean to include/exclude this token in the whitelist
    */
    function changeTokenAccess(address token, bool allowed) external onlyGovernance {
        approvedTokens[token] = allowed;
    }

    /**
     @notice Turns on or turns off the whitelist feature
     @dev Can only be set by IF governance
     @param b The boolean that whitelist is set to
    */
    function setWhitelist(bool b) external onlyGovernance {
        whitelist = b;
    }

    /**
     @notice Creates a new Impossible Pair contract
     @dev If whitelist is on, can only use approved tokens in whitelist
     @dev tokenA must not be equal to tokenB
     @param tokenA The address of token A. Token A will be in the new Pair contract
     @param tokenB The address of token B. Token B will be in the new Pair contract
     @return pair The address of the created pair containing token A and token B
    */
    function createPair(address tokenA, address tokenB) external override returns (address pair) {
        if (whitelist) {
            require(approvedTokens[tokenA] && approvedTokens[tokenB], 'IF: RESTRICTED_TOKENS');
        }
        require(tokenA != tokenB, 'IF: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'IF: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'IF: PAIR_EXISTS');

        bytes memory bytecode = type(ImpossiblePair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        IImpossiblePair(pair).initialize(token0, token1, router);

        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    /**
     @notice Sets the address that fees from the swap are paid to
     @dev Can only be called by IF governance
     @param _feeTo The address that will receive swap fees
    */
    function setFeeTo(address _feeTo) external override onlyGovernance {
        feeTo = _feeTo;
    }

    /**
     @notice Sets the address for IF governance
     @dev Can only be called by IF governance
     @param _governance The address of the new IF governance
    */
    function setGovernance(address _governance) external override onlyGovernance {
        governance = _governance;
    }
}
