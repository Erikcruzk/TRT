// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/interfaces/ITwapOracle.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;

interface ITwapOracle {
    enum UpdateType {PRIMARY, SECONDARY, OWNER, CHAINLINK, UNISWAP_V2}

    function getTwap(uint256 timestamp) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/tranchessV1/interfaces/IFund.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;
pragma experimental ABIEncoderV2;

interface IFund {
    /// @notice A linear transformation matrix that represents a rebalance.
    ///
    ///         ```
    ///             [ ratioM          0        0 ]
    ///         R = [ ratioA2M  ratioAB        0 ]
    ///             [ ratioB2M        0  ratioAB ]
    ///         ```
    ///
    ///         Amounts of the three tranches `m`, `a` and `b` can be rebalanced by multiplying the matrix:
    ///
    ///         ```
    ///         [ m', a', b' ] = [ m, a, b ] * R
    ///         ```
    struct Rebalance {
        uint256 ratioM;
        uint256 ratioA2M;
        uint256 ratioB2M;
        uint256 ratioAB;
        uint256 timestamp;
    }

    function trancheWeights() external pure returns (uint256 weightA, uint256 weightB);

    function tokenUnderlying() external view returns (address);

    function tokenM() external view returns (address);

    function tokenA() external view returns (address);

    function tokenB() external view returns (address);

    function underlyingDecimalMultiplier() external view returns (uint256);

    function twapOracle() external view returns (ITwapOracle);

    function feeCollector() external view returns (address);

    function endOfDay(uint256 timestamp) external pure returns (uint256);

    function shareTotalSupply(uint256 tranche) external view returns (uint256);

    function shareBalanceOf(uint256 tranche, address account) external view returns (uint256);

    function allShareBalanceOf(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function shareBalanceVersion(address account) external view returns (uint256);

    function shareAllowance(
        uint256 tranche,
        address owner,
        address spender
    ) external view returns (uint256);

    function shareAllowanceVersion(address owner, address spender) external view returns (uint256);

    function getRebalanceSize() external view returns (uint256);

    function getRebalance(uint256 index) external view returns (Rebalance memory);

    function getRebalanceTimestamp(uint256 index) external view returns (uint256);

    function currentDay() external view returns (uint256);

    function fundActivityStartTime() external view returns (uint256);

    function exchangeActivityStartTime() external view returns (uint256);

    function isFundActive(uint256 timestamp) external view returns (bool);

    function isPrimaryMarketActive(address primaryMarket, uint256 timestamp)
        external
        view
        returns (bool);

    function isExchangeActive(uint256 timestamp) external view returns (bool);

    function getTotalShares() external view returns (uint256);

    function historicalTotalShares(uint256 timestamp) external view returns (uint256);

    function historicalNavs(uint256 timestamp)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function extrapolateNav(uint256 timestamp, uint256 price)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function calculateNavB(uint256 navM, uint256 navA) external pure returns (uint256);

    function doRebalance(
        uint256 amountM,
        uint256 amountA,
        uint256 amountB,
        uint256 index
    )
        external
        view
        returns (
            uint256 newAmountM,
            uint256 newAmountA,
            uint256 newAmountB
        );

    function batchRebalance(
        uint256 amountM,
        uint256 amountA,
        uint256 amountB,
        uint256 fromIndex,
        uint256 toIndex
    )
        external
        view
        returns (
            uint256 newAmountM,
            uint256 newAmountA,
            uint256 newAmountB
        );

    function refreshBalance(address account, uint256 targetVersion) external;

    function refreshAllowance(
        address owner,
        address spender,
        uint256 targetVersion
    ) external;

    function mint(
        uint256 tranche,
        address account,
        uint256 amount
    ) external;

    function burn(
        uint256 tranche,
        address account,
        uint256 amount
    ) external;

    function transfer(
        uint256 tranche,
        address sender,
        address recipient,
        uint256 amount
    ) external;

    function transferFrom(
        uint256 tranche,
        address spender,
        address sender,
        address recipient,
        uint256 amount
    ) external returns (uint256 newAllowance);

    function increaseAllowance(
        uint256 tranche,
        address sender,
        address spender,
        uint256 addedValue
    ) external returns (uint256 newAllowance);

    function decreaseAllowance(
        uint256 tranche,
        address sender,
        address spender,
        uint256 subtractedValue
    ) external returns (uint256 newAllowance);

    function approve(
        uint256 tranche,
        address owner,
        address spender,
        uint256 amount
    ) external;

    event RebalanceTriggered(
        uint256 indexed index,
        uint256 indexed day,
        uint256 ratioM,
        uint256 ratioA2M,
        uint256 ratioB2M,
        uint256 ratioAB
    );
    event Settled(uint256 indexed day, uint256 navM, uint256 navA, uint256 navB);
    event InterestRateUpdated(uint256 baseInterestRate, uint256 floatingInterestRate);
    event Transfer(
        uint256 indexed tranche,
        address indexed from,
        address indexed to,
        uint256 amount
    );
    event Approval(
        uint256 indexed tranche,
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    event BalancesRebalanced(
        address indexed account,
        uint256 version,
        uint256 balanceM,
        uint256 balanceA,
        uint256 balanceB
    );
    event AllowancesRebalanced(
        address indexed owner,
        address indexed spender,
        uint256 version,
        uint256 allowanceM,
        uint256 allowanceA,
        uint256 allowanceB
    );
}

// File: ../sc_datasets/DAppSCAN/PeckShield-TranchessV2/contract-core-6876889ff08ddadb78973cadca821128ebb6503c/contracts/tranchessV1/interfaces/IFundV2.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.10 <0.8.0;
pragma experimental ABIEncoderV2;

interface IFundV2 is IFund {
    function historicalUnderlying(uint256 timestamp) external view returns (uint256);

    function getTotalUnderlying() external view returns (uint256);

    function getStrategyUnderlying() external view returns (uint256);

    function getTotalDebt() external view returns (uint256);

    function transferToStrategy(uint256 amount) external;

    function transferFromStrategy(uint256 amount) external;

    function reportProfit(uint256 profit, uint256 performanceFee) external;

    function reportLoss(uint256 loss) external;
}
