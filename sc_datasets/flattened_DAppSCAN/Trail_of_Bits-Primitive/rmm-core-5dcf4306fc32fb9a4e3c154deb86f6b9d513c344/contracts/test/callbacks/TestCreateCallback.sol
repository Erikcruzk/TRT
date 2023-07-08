// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/interfaces/engine/IPrimitiveEngineActions.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  Action functions for the Primitive Engine contract
/// @author Primitive
interface IPrimitiveEngineActions {
    // ===== Pool Updates =====

    /// @notice             Updates the time until expiry of the pool by setting its last timestamp value
    /// @param  poolId      Pool Identifier
    /// @return lastTimestamp Timestamp loaded into the state of the pool's Calibration.lastTimestamp
    function updateLastTimestamp(bytes32 poolId) external returns (uint32 lastTimestamp);

    /// @notice             Initializes a curve with parameters in the `settings` storage mapping in the Engine
    /// @param  strike      Strike price of the pool to calibrate to, with the same decimals as the stable token
    /// @param  sigma       Implied Volatility to calibrate to as an unsigned 32-bit integer w/ precision of 1e4, 10000 = 100%
    /// @param  maturity    Maturity timestamp of the pool, in seconds
    /// @param  gamma       Multiplied against swap in amounts to apply fee, equal to 1 - fee %, an unsigned 32-bit integer, w/ precision of 1e4, 10000 = 100%
    /// @param  riskyPerLp  Risky reserve per liq. with risky decimals, = 1 - N(d1), d1 = (ln(S/K)+(r*sigma^2/2))/sigma*sqrt(tau)
    /// @param  delLiquidity Amount of liquidity to allocate to the curve, wei value with 18 decimals of precision
    /// @param  data        Arbitrary data that is passed to the createCallback function
    /// @return poolId      Pool Identifier
    /// @return delRisky    Total amount of risky tokens provided to reserves
    /// @return delStable   Total amount of stable tokens provided to reserves
    function create(
        uint128 strike,
        uint32 sigma,
        uint32 maturity,
        uint32 gamma,
        uint256 riskyPerLp,
        uint256 delLiquidity,
        bytes calldata data
    )
        external
        returns (
            bytes32 poolId,
            uint256 delRisky,
            uint256 delStable
        );

    // ===== Margin ====

    /// @notice             Adds risky and/or stable tokens to a `recipient`'s internal balance account
    /// @param  recipient   Recipient margin account of the deposited tokens
    /// @param  delRisky    Amount of risky tokens to deposit
    /// @param  delStable   Amount of stable tokens to deposit
    /// @param  data        Arbitrary data that is passed to the depositCallback function
    function deposit(
        address recipient,
        uint256 delRisky,
        uint256 delStable,
        bytes calldata data
    ) external;

    /// @notice             Removes risky and/or stable tokens from a `msg.sender`'s internal balance account
    /// @param  recipient   Address that tokens are transferred to
    /// @param  delRisky    Amount of risky tokens to withdraw
    /// @param  delStable   Amount of stable tokens to withdraw
    function withdraw(
        address recipient,
        uint256 delRisky,
        uint256 delStable
    ) external;

    // ===== Liquidity =====

    /// @notice             Allocates risky and stable tokens to a specific curve with `poolId`
    /// @param  poolId      Pool Identifier
    /// @param  recipient   Address to give the allocated liquidity to
    /// @param  delRisky    Amount of risky tokens to add
    /// @param  delStable   Amount of stable tokens to add
    /// @param  fromMargin  Whether the `msg.sender` pays with their margin balance, or must send tokens
    /// @param  data        Arbitrary data that is passed to the allocateCallback function
    /// @return delLiquidity Amount of liquidity given to `recipient`
    function allocate(
        bytes32 poolId,
        address recipient,
        uint256 delRisky,
        uint256 delStable,
        bool fromMargin,
        bytes calldata data
    ) external returns (uint256 delLiquidity);

    /// @notice               Unallocates risky and stable tokens from a specific curve with `poolId`
    /// @param  poolId        Pool Identifier
    /// @param  delLiquidity  Amount of liquidity to remove
    /// @return delRisky      Amount of risky tokens received from removed liquidity
    /// @return delStable     Amount of stable tokens received from removed liquidity
    function remove(bytes32 poolId, uint256 delLiquidity) external returns (uint256 delRisky, uint256 delStable);

    // ===== Swaps =====

    /// @notice             Swaps between `risky` and `stable` tokens
    /// @param  recipient   Address that receives output token `deltaOut` amount
    /// @param  poolId      Pool Identifier
    /// @param  riskyForStable If true, swap risky to stable, else swap stable to risky
    /// @param  deltaIn     Amount of tokens to swap in
    /// @param  deltaOut    Amount of tokens to swap out
    /// @param  fromMargin  Whether the `msg.sender` uses their margin balance, or must send tokens
    /// @param  toMargin    Whether the `deltaOut` amount is transferred or deposited into margin
    /// @param  data        Arbitrary data that is passed to the swapCallback function
    function swap(
        address recipient,
        bytes32 poolId,
        bool riskyForStable,
        uint256 deltaIn,
        uint256 deltaOut,
        bool fromMargin,
        bool toMargin,
        bytes calldata data
    ) external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/interfaces/engine/IPrimitiveEngineEvents.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  Events of the Primitive Engine contract
/// @author Primitive
interface IPrimitiveEngineEvents {
    /// @notice             Creates a pool with liquidity
    /// @dev                Keccak256 hash of the engine address and the parameters is the `poolId`
    /// @param  from        Calling `msg.sender` of the create function
    /// @param  strike      Strike price of the pool, with precision of stable token
    /// @param  sigma       Implied Volatility of the pool
    /// @param  maturity    Maturity timestamp of the pool
    /// @param  gamma       1 - Fee % of the pool, as an integer with precision of 1e4
    event Create(address indexed from, uint128 indexed strike, uint32 sigma, uint32 indexed maturity, uint32 gamma);

    /// @notice             Updates the time until expiry of the pool with `poolId`
    /// @param  poolId      Pool Identifier
    event UpdateLastTimestamp(bytes32 indexed poolId);

    // ===== Margin ====

    /// @notice             Added stable and/or risky tokens to a margin accouynt
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Margin account recieving deposits
    /// @param  delRisky    Amount of risky tokens deposited
    /// @param  delStable   Amount of stable tokens deposited
    event Deposit(address indexed from, address indexed recipient, uint256 delRisky, uint256 delStable);

    /// @notice             Removes stable and/or risky from a margin account
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that tokens are sent to
    /// @param  delRisky    Amount of risky tokens withdrawn
    /// @param  delStable   Amount of stable tokens withdrawn
    event Withdraw(address indexed from, address indexed recipient, uint256 delRisky, uint256 delStable);

    // ===== Liquidity =====

    /// @notice             Adds liquidity of risky and stable tokens to a specified `poolId`
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that receives liquidity
    /// @param  poolId      Pool Identifier
    /// @param  delRisky    Amount of risky tokens deposited
    /// @param  delStable   Amount of stable tokens deposited
    event Allocate(
        address indexed from,
        address indexed recipient,
        bytes32 indexed poolId,
        uint256 delRisky,
        uint256 delStable
    );

    /// @notice             Adds liquidity of risky and stable tokens to a specified `poolId`
    /// @param  from        Method caller `msg.sender`
    /// @param  poolId      Pool Identifier
    /// @param  delRisky    Amount of risky tokens deposited
    /// @param  delStable   Amount of stable tokens deposited
    event Remove(address indexed from, bytes32 indexed poolId, uint256 delRisky, uint256 delStable);

    // ===== Swaps =====

    /// @notice             Swaps between `risky` and `stable` assets
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that receives `deltaOut` amount of tokens
    /// @param  poolId      Pool Identifier
    /// @param  riskyForStable  If true, swaps risky to stable, else swaps stable to risky
    /// @param  deltaIn     Amount of tokens added to reserves
    /// @param  deltaOut    Amount of tokens removed from reserves
    event Swap(
        address indexed from,
        address indexed recipient,
        bytes32 indexed poolId,
        bool riskyForStable,
        uint256 deltaIn,
        uint256 deltaOut
    );
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/interfaces/engine/IPrimitiveEngineView.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  View functions of the Primitive Engine contract
/// @author Primitive
interface IPrimitiveEngineView {
    // ===== View =====

    /// @notice             Fetches the current invariant based on risky and stable token reserves of pool with `poolId`
    /// @param  poolId      Pool Identifier
    /// @return invariant   Signed fixed point 64.64 number, invariant of `poolId`
    function invariantOf(bytes32 poolId) external view returns (int128 invariant);

    // ===== Constants =====

    /// @return Precision units to scale to when doing token related calculations
    function PRECISION() external view returns (uint256);

    /// @return Amount of seconds after pool expiry which allows swaps, no swaps after buffer
    function BUFFER() external view returns (uint256);

    // ===== Immutables =====

    /// @return Amount of liquidity burned on `create()` calls
    function MIN_LIQUIDITY() external view returns (uint256);

    //// @return Factory address which deployed this engine contract
    function factory() external view returns (address);

    //// @return Risky token address
    function risky() external view returns (address);

    /// @return Stable token address
    function stable() external view returns (address);

    /// @return Multiplier to scale amounts to/from, equal to 10^(18 - riskyDecimals)
    function scaleFactorRisky() external view returns (uint256);

    /// @return Multiplier to scale amounts to/from, equal to 10^(18 - stableDecimals)
    function scaleFactorStable() external view returns (uint256);

    // ===== Pool State =====

    /// @notice                      Fetches the global reserve state for a pool with `poolId`
    /// @param  poolId               Pool Identifier
    /// @return reserveRisky         Risky token balance in the reserve
    /// @return reserveStable        Stable token balance in the reserve
    /// @return liquidity            Total supply of liquidity for the curve
    /// @return blockTimestamp       Timestamp when the cumulative reserve values were last updated
    /// @return cumulativeRisky      Cumulative sum of risky token reserves of the previous update
    /// @return cumulativeStable     Cumulative sum of stable token reserves of the previous update
    /// @return cumulativeLiquidity  Cumulative sum of total supply of liquidity of the previous update
    function reserves(bytes32 poolId)
        external
        view
        returns (
            uint128 reserveRisky,
            uint128 reserveStable,
            uint128 liquidity,
            uint32 blockTimestamp,
            uint256 cumulativeRisky,
            uint256 cumulativeStable,
            uint256 cumulativeLiquidity
        );

    /// @notice                 Fetches `Calibration` pool parameters
    /// @param  poolId          Pool Identifier
    /// @return strike          Strike price of the pool with stable token decimals
    /// @return sigma           Implied Volatility as an unsigned 32-bit integer constant w/ precision of 1e4, 10000 = 100%
    /// @return maturity        Timestamp of maturity in seconds
    /// @return lastTimestamp   Last timestamp used to calculate time until expiry, aka "tau"
    /// @return gamma           = 1 - fee %, as an unsigned 32-bit integer constant w/ precision of 1e4, 10000 = 100%
    function calibrations(bytes32 poolId)
        external
        view
        returns (
            uint128 strike,
            uint32 sigma,
            uint32 maturity,
            uint32 lastTimestamp,
            uint32 gamma
        );

    /// @notice             Fetches position liquidity an account address and poolId
    /// @param  poolId      Pool Identifier
    /// @return liquidity   Liquidity owned by `account` in `poolId`
    function liquidity(address account, bytes32 poolId) external view returns (uint256 liquidity);

    /// @notice                 Fetches the margin balances of `account`
    /// @param  account         Margin account to fetch
    /// @return balanceRisky    Balance of the risky token
    /// @return balanceStable   Balance of the stable token
    function margins(address account) external view returns (uint128 balanceRisky, uint128 balanceStable);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/interfaces/engine/IPrimitiveEngineErrors.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.4;

/// @title  Errors for the Primitive Engine contract
/// @author Primitive
interface IPrimitiveEngineErrors {
    /// @notice Thrown when a callback function calls the engine __again__
    error LockedError();

    /// @notice Thrown when the balanceOf function is not successful and does not return data
    error BalanceError();

    /// @notice Thrown when a pool with poolId already exists
    error PoolDuplicateError();

    /// @notice Thrown when calling an expired pool, where block.timestamp > maturity, + BUFFER if swap
    error PoolExpiredError();

    /// @notice Thrown when liquidity is lower than or equal to the minimum amount of liquidity
    error MinLiquidityError(uint256 value);

    /// @notice Thrown when riskyPerLp is outside the range of acceptable values, 0 < riskyPerLp < 1eRiskyDecimals
    error RiskyPerLpError(uint256 value);

    /// @notice Thrown when sigma is outside the range of acceptable values, 1 <= sigma <= 1e7 with 4 precision
    error SigmaError(uint256 value);

    /// @notice Thrown when strike is not valid, i.e. equal to 0 or greater than 2^128
    error StrikeError(uint256 value);

    /// @notice Thrown when gamma, equal to 1 - fee %, is outside its bounds: 9000 <= gamma < 10000; 1000 = 10% fee
    error GammaError(uint256 value);

    /// @notice Thrown when the parameters of a new pool are invalid, causing initial reserves to be 0
    error CalibrationError(uint256 delRisky, uint256 delStable);

    /// @notice         Thrown when the expected risky balance is less than the actual balance
    /// @param expected Expected risky balance
    /// @param actual   Actual risky balance
    error RiskyBalanceError(uint256 expected, uint256 actual);

    /// @notice         Thrown when the expected stable balance is less than the actual balance
    /// @param expected Expected stable balance
    /// @param actual   Actual stable balance
    error StableBalanceError(uint256 expected, uint256 actual);

    /// @notice Thrown when the pool with poolId has not been created
    error UninitializedError();

    /// @notice Thrown when the risky or stable amount is 0
    error ZeroDeltasError();

    /// @notice Thrown when the liquidity parameter is 0
    error ZeroLiquidityError();

    /// @notice Thrown when the deltaIn parameter is 0
    error DeltaInError();

    /// @notice Thrown when the deltaOut parameter is 0
    error DeltaOutError();

    /// @notice                 Thrown when the invariant check fails
    /// @param  invariant       Pre-swap invariant updated with new tau
    /// @param  nextInvariant   Post-swap invariant
    error InvariantError(int128 invariant, int128 nextInvariant);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/interfaces/IPrimitiveEngine.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.4;




/// @title Primitive Engine Interface
interface IPrimitiveEngine is
    IPrimitiveEngineActions,
    IPrimitiveEngineEvents,
    IPrimitiveEngineView,
    IPrimitiveEngineErrors
{

}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/test/callbacks/Scenarios.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;

abstract contract Scenarios {
    Scenario public scenario = Scenario.SUCCESS;

    enum Scenario {
        FAIL,
        SUCCESS,
        RISKY_ONLY,
        STABLE_ONLY,
        REENTRANCY
    }

    function risky() public view virtual returns (address);

    function stable() public view virtual returns (address);

    function getCaller() public view virtual returns (address);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-Primitive/rmm-core-5dcf4306fc32fb9a4e3c154deb86f6b9d513c344/contracts/test/callbacks/TestCreateCallback.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.6;



abstract contract TestCreateCallback is Scenarios {
    function createCallback(
        uint256 delRisky,
        uint256 delStable,
        bytes calldata data
    ) public {
        data;
        address token0 = risky();
        address token1 = stable();
        address from = getCaller();
        IERC20(token0).transferFrom(from, msg.sender, delRisky);
        IERC20(token1).transferFrom(from, msg.sender, delStable);
    }
}
