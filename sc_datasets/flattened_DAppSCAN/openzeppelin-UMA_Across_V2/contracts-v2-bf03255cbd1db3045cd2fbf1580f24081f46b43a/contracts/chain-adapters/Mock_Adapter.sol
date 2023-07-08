// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/interfaces/AdapterInterface.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @notice Sends cross chain messages and tokens to contracts on a specific L2 network.
 */

interface AdapterInterface {
    event HubPoolChanged(address newHubPool);

    event MessageRelayed(address target, bytes message);

    event TokensRelayed(address l1Token, address l2Token, uint256 amount, address to);

    function relayMessage(address target, bytes memory message) external payable;

    function relayTokens(
        address l1Token,
        address l2Token,
        uint256 amount,
        address to
    ) external payable;
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

// File: ../sc_datasets/DAppSCAN/openzeppelin-UMA_Across_V2/contracts-v2-bf03255cbd1db3045cd2fbf1580f24081f46b43a/contracts/chain-adapters/Mock_Adapter.sol

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;


/**
 * @notice Contract used for testing communication between HubPool and Adapter.
 */
contract Mock_Adapter is AdapterInterface {
    event RelayMessageCalled(address target, bytes message, address caller);

    event RelayTokensCalled(address l1Token, address l2Token, uint256 amount, address to, address caller);

    Mock_Bridge public immutable bridge;

    constructor() {
        bridge = new Mock_Bridge();
    }

    function relayMessage(address target, bytes memory message) external payable override {
        bridge.bridgeMessage(target, message);
        emit RelayMessageCalled(target, message, msg.sender);
    }

    function relayTokens(
        address l1Token,
        address l2Token,
        uint256 amount,
        address to
    ) external payable override {
        IERC20(l1Token).approve(address(bridge), amount);
        bridge.bridgeTokens(l1Token, amount);
        emit RelayTokensCalled(l1Token, l2Token, amount, to, msg.sender);
    }
}

// This contract is intended to "act like" a simple version of an L2 bridge.
// It's primarily meant to better reflect how a true L2 bridge interaction might work to give better gas estimates.
contract Mock_Bridge {
    event BridgedTokens(address token, uint256 amount);
    event BridgedMessage(address target, bytes message);

    mapping(address => uint256) deposits;

    function bridgeTokens(address token, uint256 amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        deposits[token] += amount;
        emit BridgedTokens(token, amount);
    }

    function bridgeMessage(address target, bytes memory message) public {
        emit BridgedMessage(target, message);
    }
}
