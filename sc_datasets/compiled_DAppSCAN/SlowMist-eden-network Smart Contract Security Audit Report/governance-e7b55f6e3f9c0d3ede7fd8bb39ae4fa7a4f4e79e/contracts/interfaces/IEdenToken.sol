// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20Metadata.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20Mintable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20Mintable is IERC20 {
    function mint(address dst, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20Burnable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20Burnable is IERC20 {
    function burn(uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20Permit.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Permit is IERC20 {
    function getDomainSeparator() external view returns (bytes32);
    function DOMAIN_TYPEHASH() external view returns (bytes32);
    function VERSION_HASH() external view returns (bytes32);
    function PERMIT_TYPEHASH() external view returns (bytes32);
    function nonces(address) external view returns (uint);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20TransferWithAuth.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20TransferWithAuth is IERC20 {
    function transferWithAuthorization(address from, address to, uint256 value, uint256 validAfter, uint256 validBefore, bytes32 nonce, uint8 v, bytes32 r, bytes32 s) external;
    function receiveWithAuthorization(address from, address to, uint256 value, uint256 validAfter, uint256 validBefore, bytes32 nonce, uint8 v, bytes32 r, bytes32 s) external;
    function TRANSFER_WITH_AUTHORIZATION_TYPEHASH() external view returns (bytes32);
    function RECEIVE_WITH_AUTHORIZATION_TYPEHASH() external view returns (bytes32);
    event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20SafeAllowance.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20SafeAllowance is IERC20 {
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IERC20Extended.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;






interface IERC20Extended is 
    IERC20Metadata, 
    IERC20Mintable, 
    IERC20Burnable, 
    IERC20Permit,
    IERC20TransferWithAuth,
    IERC20SafeAllowance 
{}

// File: ../sc_datasets/DAppSCAN/SlowMist-eden-network Smart Contract Security Audit Report/governance-e7b55f6e3f9c0d3ede7fd8bb39ae4fa7a4f4e79e/contracts/interfaces/IEdenToken.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEdenToken is IERC20Extended {
    function maxSupply() external view returns (uint256);
    function updateTokenMetadata(string memory tokenName, string memory tokenSymbol) external returns (bool);
    function metadataManager() external view returns (address);
    function setMetadataManager(address newMetadataManager) external returns (bool);
    event MetadataManagerChanged(address indexed oldManager, address indexed newManager);
    event TokenMetaUpdated(string indexed name, string indexed symbol);
}
