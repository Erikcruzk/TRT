// File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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

// File: ../sc_datasets/DAppSCAN/Runtime_Vеrification-StakeWise/contracts-19da824f44079c2b94c8cca84de77f5bdf3f0e54/contracts/interfaces/IRewardEthToken.sol

// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.7.5;

/**
 * @dev Interface of the RewardEthToken contract.
 */
interface IRewardEthToken is IERC20Upgradeable {
    /**
    * @dev Event for tracking updated maintainer.
    * @param maintainer - address of the new maintainer, where the fee will be paid.
    */
    event MaintainerUpdated(address maintainer);

    /**
    * @dev Event for tracking updated maintainer fee.
    * @param maintainerFee - new maintainer fee.
    */
    event MaintainerFeeUpdated(uint256 maintainerFee);

    /**
    * @dev Structure for storing information about user reward checkpoint.
    * @param rewardPerToken - user reward per token.
    * @param reward - user reward checkpoint.
    */
    struct Checkpoint {
        uint256 rewardPerToken;
        uint256 reward;
    }

    /**
    * @dev Event for tracking rewards update by balance reporters.
    * @param periodRewards - rewards since the last update.
    * @param totalRewards - total amount of rewards.
    * @param rewardPerToken - calculated reward per token for account reward calculation.
    * @param updateTimestamp - last rewards update timestamp by balance reporters.
    */
    event RewardsUpdated(
        uint256 periodRewards,
        uint256 totalRewards,
        uint256 rewardPerToken,
        uint256 updateTimestamp
    );

    /**
    * @dev Constructor for initializing the RewardEthToken contract.
    * @param _admin - address of the contract admin.
    * @param _stakedEthToken - address of the StakedEthToken contract.
    * @param _balanceReporters - address of the BalanceReporters contract.
    * @param _stakedTokens - address of the StakedTokens contract.
    * @param _maintainer - maintainer's address.
    * @param _maintainerFee - maintainer's fee. Must be less than 10000 (100.00%).
    */
    function initialize(
        address _admin,
        address _stakedEthToken,
        address _balanceReporters,
        address _stakedTokens,
        address _maintainer,
        uint256 _maintainerFee
    ) external;

    /**
    * @dev Function for getting the address of the maintainer, where the fee will be paid.
    */
    function maintainer() external view returns (address);

    /**
    * @dev Function for changing the maintainer's address.
    * @param _newMaintainer - new maintainer's address.
    */
    function setMaintainer(address _newMaintainer) external;

    /**
    * @dev Function for getting maintainer fee. The percentage fee users pay from their reward for using the pool service.
    */
    function maintainerFee() external view returns (uint256);

    /**
    * @dev Function for changing the maintainer's fee.
    * @param _newMaintainerFee - new maintainer's fee. Must be less than 10000 (100.00%).
    */
    function setMaintainerFee(uint256 _newMaintainerFee) external;

    /**
    * @dev Function for retrieving the last total rewards update timestamp.
    */
    function updateTimestamp() external view returns (uint256);

    /**
    * @dev Function for retrieving the total rewards amount.
    */
    function totalRewards() external view returns (uint256);

    /**
    * @dev Function for retrieving current reward per token used for account reward calculation.
    */
    function rewardPerToken() external view returns (uint256);

    /**
    * @dev Function for retrieving account's current checkpoint.
    * @param account - address of the account to retrieve the checkpoint for.
    */
    function checkpoints(address account) external view returns (uint256, uint256);

    /**
    * @dev Function for updating account's reward checkpoint.
    * @param account - address of the account to update the reward checkpoint for.
    */
    function updateRewardCheckpoint(address account) external;

    /**
    * @dev Function for updating validators total rewards.
    * Can only be called by Balance Reporters contract.
    * @param newTotalRewards - new total rewards.
    */
    function updateTotalRewards(uint256 newTotalRewards) external;

    /**
    * @dev Function for claiming rewards. Can only be called by StakedTokens contract.
    * @param tokenContract - address of the token contract.
    * @param claimedRewards - total rewards to claim.
    */
    function claimRewards(address tokenContract, uint256 claimedRewards) external;
}
