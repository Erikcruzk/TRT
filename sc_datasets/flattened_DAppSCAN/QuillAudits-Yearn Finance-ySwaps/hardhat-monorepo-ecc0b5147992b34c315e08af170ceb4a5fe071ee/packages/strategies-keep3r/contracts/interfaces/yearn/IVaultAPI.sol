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

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/yearn/IVaultAPI.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

struct StrategyParams {
  uint256 performanceFee;
  uint256 activation;
  uint256 debtRatio;
  uint256 rateLimit;
  uint256 lastReport;
  uint256 totalDebt;
  uint256 totalGain;
  uint256 totalLoss;
}

interface VaultAPI is IERC20 {
  function apiVersion() external view returns (string memory);

  function withdraw(uint256 shares, address recipient) external;

  function token() external view returns (address);

  function totalAssets() external view returns (uint256);

  function strategies(address _strategy) external view returns (StrategyParams memory);

  /**
   * View how much the Vault would increase this Strategy's borrow limit,
   * based on its present performance (since its last report). Can be used to
   * determine expectedReturn in your Strategy.
   */
  function creditAvailable(address _strategy) external view returns (uint256);

  /**
   * View how much the Vault would like to pull back from the Strategy,
   * based on its present performance (since its last report). Can be used to
   * determine expectedReturn in your Strategy.
   */
  function debtOutstanding() external view returns (uint256);

  /**
   * View how much the Vault expect this Strategy to return at the current
   * block, based on its present performance (since its last report). Can be
   * used to determine expectedReturn in your Strategy.
   */
  function expectedReturn() external view returns (uint256);

  /**
   * This is the main contact point where the Strategy interacts with the
   * Vault. It is critical that this call is handled as intended by the
   * Strategy. Therefore, this function will be called by BaseStrategy to
   * make sure the integration is correct.
   */
  function report(
    uint256 _gain,
    uint256 _loss,
    uint256 _debtPayment
  ) external returns (uint256);

  /**
   * This function should only be used in the scenario where the Strategy is
   * being retired but no migration of the positions are possible, or in the
   * extreme scenario that the Strategy needs to be put into "Emergency Exit"
   * mode in order for it to exit as quickly as possible. The latter scenario
   * could be for any reason that is considered "critical" that the Strategy
   * exits its position as fast as possible, such as a sudden change in
   * market conditions leading to losses, or an imminent failure in an
   * external dependency.
   */
  function revokeStrategy() external;

  /**
   * View the governance address of the Vault to assert privileged functions
   * can only be called by governance. The Strategy serves the Vault, so it
   * is subject to governance defined by the Vault.
   */
  function governance() external view returns (address);
}
