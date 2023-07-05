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

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IAgToken.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title IAgToken
/// @author Angle Core Team
/// @notice Interface for the stablecoins `AgToken` contracts
/// @dev This interface only contains functions of the `AgToken` contract which are called by other contracts
/// of this module or of the first module of the Angle Protocol
interface IAgToken is IERC20Upgradeable {
    // ======================= Minter Role Only Functions ===========================

    /// @notice Lets the `StableMaster` contract or another whitelisted contract mint agTokens
    /// @param account Address to mint to
    /// @param amount Amount to mint
    /// @dev The contracts allowed to issue agTokens are the `StableMaster` contract, `VaultManager` contracts
    /// associated to this stablecoin as well as the flash loan module (if activated) and potentially contracts
    /// whitelisted by governance
    function mint(address account, uint256 amount) external;

    /// @notice Burns `amount` tokens from a `burner` address after being asked to by `sender`
    /// @param amount Amount of tokens to burn
    /// @param burner Address to burn from
    /// @param sender Address which requested the burn from `burner`
    /// @dev This method is to be called by a contract with the minter right after being requested
    /// to do so by a `sender` address willing to burn tokens from another `burner` address
    /// @dev The method checks the allowance between the `sender` and the `burner`
    function burnFrom(
        uint256 amount,
        address burner,
        address sender
    ) external;

    /// @notice Burns `amount` tokens from a `burner` address
    /// @param amount Amount of tokens to burn
    /// @param burner Address to burn from
    /// @dev This method is to be called by a contract with a minter right on the AgToken after being
    /// requested to do so by an address willing to burn tokens from its address
    function burnSelf(uint256 amount, address burner) external;

    // ========================= Treasury Only Functions ===========================

    /// @notice Adds a minter in the contract
    /// @param minter Minter address to add
    /// @dev Zero address checks are performed directly in the `Treasury` contract
    function addMinter(address minter) external;

    /// @notice Removes a minter from the contract
    /// @param minter Minter address to remove
    /// @dev This function can also be called by a minter wishing to revoke itself
    function removeMinter(address minter) external;

    /// @notice Sets a new treasury contract
    /// @param _treasury New treasury address
    function setTreasury(address _treasury) external;

    // ========================= External functions ================================

    /// @notice Checks whether an address has the right to mint agTokens
    /// @param minter Address for which the minting right should be checked
    /// @return Whether the address has the right to mint agTokens or not
    function isMinter(address minter) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/ICoreBorrow.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title ICoreBorrow
/// @author Angle Core Team
/// @notice Interface for the `CoreBorrow` contract
/// @dev This interface only contains functions of the `CoreBorrow` contract which are called by other contracts
/// of this module
interface ICoreBorrow {
    /// @notice Checks if an address corresponds to a treasury of a stablecoin with a flash loan
    /// module initialized on it
    /// @param treasury Address to check
    /// @return Whether the address has the `FLASHLOANER_TREASURY_ROLE` or not
    function isFlashLoanerTreasury(address treasury) external view returns (bool);

    /// @notice Checks whether an address is governor of the Angle Protocol or not
    /// @param admin Address to check
    /// @return Whether the address has the `GOVERNOR_ROLE` or not
    function isGovernor(address admin) external view returns (bool);

    /// @notice Checks whether an address is governor or a guardian of the Angle Protocol or not
    /// @param admin Address to check
    /// @return Whether the address has the `GUARDIAN_ROLE` or not
    /// @dev Governance should make sure when adding a governor to also give this governor the guardian
    /// role by calling the `addGovernor` function
    function isGovernorOrGuardian(address admin) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IFlashAngle.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;


/// @title IFlashAngle
/// @author Angle Core Team
/// @notice Interface for the `FlashAngle` contract
/// @dev This interface only contains functions of the contract which are called by other contracts
/// of this module
interface IFlashAngle {
    /// @notice Reference to the `CoreBorrow` contract managing the FlashLoan module
    function core() external view returns (ICoreBorrow);

    /// @notice Sends the fees taken from flash loans to the treasury contract associated to the stablecoin
    /// @param stablecoin Stablecoin from which profits should be sent
    /// @return balance Amount of profits sent
    /// @dev This function can only be called by the treasury contract
    function accrueInterestToTreasury(IAgToken stablecoin) external returns (uint256 balance);

    /// @notice Adds support for a stablecoin
    /// @param _treasury Treasury associated to the stablecoin to add support for
    /// @dev This function can only be called by the `CoreBorrow` contract
    function addStablecoinSupport(address _treasury) external;

    /// @notice Removes support for a stablecoin
    /// @param _treasury Treasury associated to the stablecoin to remove support for
    /// @dev This function can only be called by the `CoreBorrow` contract
    function removeStablecoinSupport(address _treasury) external;

    /// @notice Sets a new core contract
    /// @param _core Core contract address to set
    /// @dev This function can only be called by the `CoreBorrow` contract
    function setCore(address _core) external;
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/ITreasury.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;



/// @title ITreasury
/// @author Angle Core Team
/// @notice Interface for the `Treasury` contract
/// @dev This interface only contains functions of the `Treasury` which are called by other contracts
/// of this module
interface ITreasury {
    /// @notice Stablecoin handled by this `treasury` contract
    function stablecoin() external view returns (IAgToken);

    /// @notice Checks whether a given address has the  governor role
    /// @param admin Address to check
    /// @return Whether the address has the governor role
    /// @dev Access control is only kept in the `CoreBorrow` contract
    function isGovernor(address admin) external view returns (bool);

    /// @notice Checks whether a given address has the guardian or the governor role
    /// @param admin Address to check
    /// @return Whether the address has the guardian or the governor role
    /// @dev Access control is only kept in the `CoreBorrow` contract which means that this function
    /// queries the `CoreBorrow` contract
    function isGovernorOrGuardian(address admin) external view returns (bool);

    /// @notice Checks whether a given address has well been initialized in this contract
    /// as a `VaultManager``
    /// @param _vaultManager Address to check
    /// @return Whether the address has been initialized or not
    function isVaultManager(address _vaultManager) external view returns (bool);

    /// @notice Sets a new flash loan module for this stablecoin
    /// @param _flashLoanModule Reference to the new flash loan module
    /// @dev This function removes the minting right to the old flash loan module and grants
    /// it to the new module
    function setFlashLoanModule(address _flashLoanModule) external;
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title IOracle
/// @author Angle Core Team
/// @notice Interface for the `Oracle` contract
/// @dev This interface only contains functions of the contract which are called by other contracts
/// of this module
interface IOracle {
    /// @notice Reads the rate from the Chainlink circuit and other data provided
    /// @return quoteAmount The current rate between the in-currency and out-currency in the base
    /// of the out currency
    /// @dev For instance if the out currency is EUR (and hence agEUR), then the base of the returned
    /// value is 10**18
    function read() external view returns (uint256);

    /// @notice Changes the treasury contract
    /// @param _treasury Address of the new treasury contract
    /// @dev This function can be called by an approved `VaultManager` contract which can call
    /// this function after being requested to do so by a `treasury` contract
    /// @dev In some situations (like reactor contracts), the `VaultManager` may not directly be linked
    /// to the `oracle` contract and as such we may need governors to be able to call this function as well
    function setTreasury(address _treasury) external;

    /// @notice Reference to the `treasury` contract handling this `VaultManager`
    function treasury() external view returns (ITreasury treasury);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/mock/MockOracle.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract MockOracle is IOracle {
    event Update(uint256 _peg);

    ITreasury public treasury;

    uint256 public base = 1 ether;
    uint256 public inBase;
    uint256 public precision = 1 ether;
    uint256 public rate;
    bool public outdated;

    /// @notice Initiate with a fixe change rate
    constructor(
        uint256 rate_,
        uint256 _inDecimals,
        ITreasury _treasury
    ) {
        rate = rate_;
        inBase = 10**_inDecimals;
        treasury = _treasury;
    }

    /// @notice Mock read
    function read() external view override returns (uint256) {
        return rate;
    }

    /// @notice change oracle rate
    function update(uint256 newRate) external {
        rate = newRate;
    }

    function changeInBase(uint256 newInBase) external {
        inBase = newInBase;
    }

    function setTreasury(address _treasury) external override {
        treasury = ITreasury(_treasury);
    }
}
