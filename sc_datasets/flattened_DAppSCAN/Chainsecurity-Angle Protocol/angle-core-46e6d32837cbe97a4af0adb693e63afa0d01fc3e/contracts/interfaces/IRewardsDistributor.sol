// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol/angle-core-46e6d32837cbe97a4af0adb693e63afa0d01fc3e/contracts/interfaces/IStakingRewards.sol

// SPDX-License-Identifier: GNU GPLv3

pragma solidity ^0.8.7;

/// @title IStakingRewardsFunctions
/// @author Angle Core Team
/// @notice Interface for the staking rewards contract that interact with the `RewardsDistributor` contract
interface IStakingRewardsFunctions {
    function notifyRewardAmount(uint256 reward) external;

    function recoverERC20(
        address tokenAddress,
        address to,
        uint256 tokenAmount
    ) external;

    function setNewRewardsDistribution(address newRewardsDistribution) external;
}

/// @title IStakingRewards
/// @author Angle Core Team
/// @notice Previous interface with additionnal getters for public variables
interface IStakingRewards is IStakingRewardsFunctions {
    function rewardToken() external view returns (IERC20);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol/angle-core-46e6d32837cbe97a4af0adb693e63afa0d01fc3e/contracts/interfaces/IRewardsDistributor.sol

// SPDX-License-Identifier: GNU GPLv3

pragma solidity ^0.8.7;

/// @title IRewardsDistributor
/// @author Angle Core Team, inspired from Fei protocol
/// (https://github.com/fei-protocol/fei-protocol-core/blob/master/contracts/staking/IRewardsDistributor.sol)
/// @notice Rewards Distributor interface
interface IRewardsDistributor {
    // ========================= Public Parameter Getter ===========================

    function rewardToken() external view returns (IERC20);

    // ======================== External User Available Function ===================

    function drip(IStakingRewards stakingContract) external returns (uint256);

    // ========================= Governor Functions ================================

    function governorWithdrawRewardToken(uint256 amount, address governance) external;

    function governorRecover(
        address tokenAddress,
        address to,
        uint256 amount,
        IStakingRewards stakingContract
    ) external;

    function setUpdateFrequency(uint256 _frequency, IStakingRewards stakingContract) external;

    function setIncentiveAmount(uint256 _incentiveAmount, IStakingRewards stakingContract) external;

    function setAmountToDistribute(uint256 _amountToDistribute, IStakingRewards stakingContract) external;

    function setDuration(uint256 _duration, IStakingRewards stakingContract) external;

    function setStakingContract(
        address _stakingContract,
        uint256 _duration,
        uint256 _incentiveAmount,
        uint256 _dripFrequency,
        uint256 _amountToDistribute
    ) external;

    function setNewRewardsDistributor(address newRewardsDistributor) external;

    function removeStakingContract(IStakingRewards stakingContract) external;
}