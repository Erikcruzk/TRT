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

// File: ../sc_datasets/DAppSCAN/PeckShield-Holdefi/Holdefi-5a1e6e0d582120142e8a531f6806eba6665ef2f4/contracts/HoldefiCollaterals.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

/// @title HoldefiCollaterals
/// @author Holdefi Team
/// @notice Collaterals is held by this contract
/// @dev The address of ETH asset considered as 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
contract HoldefiCollaterals {

	address constant public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

	address public holdefiContract;

	/// @dev Initializes the main Holdefi contract address
	constructor() public {
		holdefiContract = msg.sender;
	}

	/// @notice Modifier to check that only Holdefi contract interacts with the function
    modifier onlyHoldefiContract() {
        require (msg.sender == holdefiContract, "Sender should be holdefi contract");
        _;
    }

	/// @notice Only Holdefi contract can send ETH to this contract
    receive() external payable onlyHoldefiContract {
	}

	/// @notice Holdefi contract withdraws collateral from this contract to recipient account
	/// @param collateral Address of the given collateral
	/// @param recipient Address of the recipient
	/// @param amount Amount to be withdrawn
	function withdraw (address collateral, address recipient, uint256 amount)
		external
		onlyHoldefiContract
	{
		bool success = false;
		if (collateral == ethAddress){
			(success, ) = recipient.call{value:amount}("");
		}
		else {
			IERC20 token = IERC20(collateral);
			success = token.transfer(recipient, amount);
		}
		require (success, "Cannot Transfer");
	}

}
