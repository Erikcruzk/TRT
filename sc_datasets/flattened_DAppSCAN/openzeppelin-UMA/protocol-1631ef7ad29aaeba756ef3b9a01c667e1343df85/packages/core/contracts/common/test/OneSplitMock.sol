// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/common/interfaces/OneSplit.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

abstract contract OneSplit {
    function getExpectedReturn(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags // See constants in IOneSplit.sol
    ) public view virtual returns (uint256 returnAmount, uint256[] memory distribution);

    function swap(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] memory distribution,
        uint256 flags
    ) public payable virtual returns (uint256 returnAmount);
}

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

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA/protocol-1631ef7ad29aaeba756ef3b9a01c667e1343df85/packages/core/contracts/common/test/OneSplitMock.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.6.0;

/**
 * @title OneSplit Mock that allows manual price injection.
 */
contract OneSplitMock is OneSplit {
    address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    mapping(bytes32 => uint256) prices;

    receive() external payable {}

    // Sets price of 1 FROM = <PRICE> TO
    function setPrice(
        address from,
        address to,
        uint256 price
    ) external {
        prices[keccak256(abi.encodePacked(from, to))] = price;
    }

    function getExpectedReturn(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags // See constants in IOneSplit.sol
    ) public view override returns (uint256 returnAmount, uint256[] memory distribution) {
        returnAmount = prices[keccak256(abi.encodePacked(fromToken, destToken))] * amount;

        return (returnAmount, distribution);
    }

    function swap(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] memory distribution,
        uint256 flags
    ) public payable override returns (uint256 returnAmount) {
        uint256 amountReturn = prices[keccak256(abi.encodePacked(fromToken, destToken))] * amount;

        require(amountReturn >= minReturn, "Min Amount not reached");

        if (destToken == ETH_ADDRESS) {
            msg.sender.transfer(amountReturn);
        } else {
            require(IERC20(destToken).transfer(msg.sender, amountReturn), "erc20-send-failed");
        }
    }
}
