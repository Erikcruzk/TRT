// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/GlobalAddressesProvider/IGlobalAddressesProvider.sol

// SPDX-License-Identifier: agpl-3.0

pragma solidity ^0.7.0;

/**
@title GlobalAddressesProvider interface
@notice provides the interface to fetch the LendingPoolCore address
 */

interface IGlobalAddressesProvider  {

// ########################################################################################
// #########  PROTOCOL MANAGERS ( LendingPool Manager and SighFinance Manager ) ###########
// ########################################################################################

    function getLendingPoolManager() external view returns (address);
    function getPendingLendingPoolManager() external view returns (address);

    function setPendingLendingPoolManager(address _pendinglendingPoolManager) external;
    function acceptLendingPoolManager() external;

    function getSIGHFinanceManager() external view returns (address);
    function getPendingSIGHFinanceManager() external view returns (address);

    function setPendingSIGHFinanceManager(address _PendingSIGHFinanceManager) external;
    function acceptSIGHFinanceManager() external;

// #########################################################################
// ####___________ LENDING POOL PROTOCOL CONTRACTS _____________############
// ########## 1. LendingPoolConfigurator (Upgradagble) #####################
// ########## 2. LendingPoolCore (Upgradagble) #############################
// ########## 3. LendingPool (Upgradagble) #################################
// ########## 4. LendingPoolDataProvider (Upgradagble) #####################
// ########## 5. LendingPoolParametersProvider (Upgradagble) ###############
// ########## 6. FeeProvider (Upgradagble) #################################
// ########## 7. LendingPoolLiqAndLoanManager (Directly Changed) ##########
// ########## 8. LendingRateOracle (Directly Changed) ######################
// #########################################################################

    function getLendingPoolConfigurator() external view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) external;

    function getLendingPool() external view returns (address);
    function setLendingPoolImpl(address _pool) external;

    function getFeeProvider() external view returns (address);
    function setFeeProviderImpl(address _feeProvider) external;

    function getLendingPoolLiqAndLoanManager() external view returns (address);
    function setLendingPoolLiqAndLoanManager(address _manager) external;

    function getLendingRateOracle() external view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) external;

// ####################################################################################
// ####___________ SIGH FINANCE RELATED CONTRACTS _____________########################
// ########## 1. SIGH (Initialized only once) #########################################
// ########## 2. SIGH Finance Configurator (Upgradagble) ################################
// ########## 2. SIGH Speed Controller (Initialized only once) ########################
// ########## 3. SIGH Treasury (Upgradagble) ###########################################
// ########## 4. SIGH Mechanism Handler (Upgradagble) ###################################
// ########## 5. SIGH Staking (Upgradagble) ###################################
// ####################################################################################

    function getSIGHAddress() external view returns (address);
    function setSIGHAddress(address sighAddress) external;

    function getSIGHNFTBoosters() external view returns (address) ;
    function setSIGHNFTBoosters(address _SIGHNFTBooster) external ;

    function getSIGHFinanceConfigurator() external view returns (address);
    function setSIGHFinanceConfiguratorImpl(address sighAddress) external;

    function getSIGHSpeedController() external view returns (address);
    function setSIGHSpeedController(address _SIGHSpeedController) external;

    function getSIGHTreasury() external view returns (address);                                 //  ADDED FOR SIGH FINANCE
    function setSIGHTreasuryImpl(address _SIGHTreasury) external;                                   //  ADDED FOR SIGH FINANCE

    function getSIGHVolatilityHarvester() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHVolatilityHarvesterImpl(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

    function getSIGHStaking() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHStaking(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

// #######################################################
// ####___________ PRICE ORACLE CONTRACT _____________####
// ####_____ SIGH FINANCE FEE COLLECTOR : ADDRESS ____####
// ####_____   SIGH PAYCOLLECTOR : ADDRESS        ____####
// #######################################################

    function getPriceOracle() external view returns (address);
    function setPriceOracle(address _priceOracle) external;


    // SIGH FINANCE FEE COLLECTOR - DEPOSIT / BORROWING / FLASH LOAN FEE TRANSERRED TO THIS ADDRESS
    function getSIGHFinanceFeeCollector() external view returns (address) ;
    function setSIGHFinanceFeeCollector(address _feeCollector) external ;

    function getSIGHPAYAggregator() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHPAYAggregator(address _SIGHPAYAggregator) external;             //  ADDED FOR SIGH FINANCE

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20Detailed.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @dev Optional functions from the ERC20 standard.
 */
interface IERC20Detailed {


    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory) ;

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory) ;

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() external view returns (uint8) ;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ISIGHHarvester.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface ISIGHHarvester {

    function accureSIGHForLiquidityStream(address user) external;
    function accureSIGHForBorrowingStream(address user) external;

    function claimSIGH(address[] calldata users) external;
    function claimMySIGH(address user) external;

    function getSighAccured(address account) external view returns (uint);

  function updatePlatformFee(address user, uint platformFeeIncrease, uint platformFeeDecrease) external  ;
  function updateReserveFee(address user, uint reserveFeeIncrease, uint reserveFeeDecrease) external  ;

  function getPlatformFee(address user) external view returns (uint) ;
  function getReserveFee(address user)  external view returns (uint) ;

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/tokenization/IncentivizedERC20.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;





/**
 * @title ERC20
 * @notice Basic ERC20 implementation
 * @author Aave, inspired by the Openzeppelin ERC20 implementation
 **/
contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
  using SafeMath for uint256;

  mapping(address => uint256) internal _balances;
  mapping(address => uint256) internal _averageBalances;
  mapping(address => mapping(address => uint256)) private _allowances;

  uint256 internal _totalSupply;
  uint256 internal averageTotalSupply;

  string private _name;
  string private _symbol;
  uint8 private _decimals;

  constructor(string memory name, string memory symbol, uint8 decimals) {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  /**
   * @return The name of the token
   **/
  function name() public view override returns (string memory) {
    return _name;
  }

  /**
   * @return The symbol of the token
   **/
  function symbol() public view override returns (string memory) {
    return _symbol;
  }

  /**
   * @return The decimals of the token
   **/
  function decimals() public view override returns (uint8) {
    return _decimals;
  }

  /**
   * @return The total supply of the token
   **/
  function totalSupply() public view virtual override returns (uint256) {
    return _totalSupply;
  }

  /**
   * @return The averaged total supply of the token, requried by the SIGH Volatility harvester
   **/
  function getAverageTotalSupply() public view returns (uint256) {
    return averageTotalSupply;
  }


  /**
   * @return The balance of the token
   **/
  function balanceOf(address account) public view virtual override returns (uint256) {
    return _balances[account];
  }

  /**
   * @return The average balance of the token
   **/
  function _averageBalanceOf(address account) public view returns (uint256) {
    _averageBalances[account];
  }


  /**
   * @dev Executes a transfer of tokens from _msgSender() to recipient
   * @param recipient The recipient of the tokens
   * @param amount The amount of tokens being transferred
   * @return `true` if the transfer succeeds, `false` otherwise
   **/
  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    emit Transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev Returns the allowance of spender on the tokens owned by owner
   * @param owner The owner of the tokens
   * @param spender The user allowed to spend the owner's tokens
   * @return The amount of owner's tokens spender is allowed to spend
   **/
  function allowance(address owner, address spender) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev Allows `spender` to spend the tokens owned by _msgSender()
   * @param spender The user allowed to spend _msgSender() tokens
   * @return `true`
   **/
  function approve(address spender, uint256 amount) public virtual override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev Executes a transfer of token from sender to recipient, if _msgSender() is allowed to do so
   * @param sender The owner of the tokens
   * @param recipient The recipient of the tokens
   * @param amount The amount of tokens being transferred
   * @return `true` if the transfer succeeds, `false` otherwise
   **/
  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance'));
    emit Transfer(sender, recipient, amount);
    return true;
  }

  /**
   * @dev Increases the allowance of spender to spend _msgSender() tokens
   * @param spender The user allowed to spend on behalf of _msgSender()
   * @param addedValue The amount being added to the allowance
   * @return `true`
   **/
  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Decreases the allowance of spender to spend _msgSender() tokens
   * @param spender The user allowed to spend on behalf of _msgSender()
   * @param subtractedValue The amount being subtracted to the allowance
   * @return `true`
   **/
  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero'));
    return true;
  }

  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
    require(sender != address(0), 'ERC20: transfer from the zero address');
    require(recipient != address(0), 'ERC20: transfer to the zero address');

    _beforeTokenTransfer(sender, recipient, amount);

    uint256 oldSenderBalance = _balances[sender];
    _balances[sender] = oldSenderBalance.sub(amount, 'ERC20: transfer amount exceeds balance');
    _averageBalances[sender] = _averageBalances[sender] == 0 ? amount : _averageBalances[sender].mul(9).sub(amount).div(10);         // Average Balance Updated

    _balances[recipient] = _balances[recipient].add(amount);
    _averageBalances[recipient] = _averageBalances[recipient] == 0 ? amount : _averageBalances[recipient].mul(9).add(amount).div(10);   // Average Balance Updated
  }

  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), 'ERC20: mint to the zero address');

    _beforeTokenTransfer(address(0), account, amount);

    uint256 oldTotalSupply = _totalSupply;
    _totalSupply = oldTotalSupply.add(amount);

    averageTotalSupply = calculateAverageTotalSupply(_totalSupply);   //average total supply updated

    uint256 oldAccountBalance = _balances[account];
    _balances[account] = oldAccountBalance.add(amount);
    _averageBalances[account] = _averageBalances[account] == 0 ? amount : _averageBalances[account].mul(9).add(amount).div(10);   // Average Balance Updated

  }

  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), 'ERC20: burn from the zero address');

    _beforeTokenTransfer(account, address(0), amount);

    uint256 oldTotalSupply = _totalSupply;
    _totalSupply = oldTotalSupply.sub(amount);

    averageTotalSupply = calculateAverageTotalSupply(_totalSupply);  //average total supply updated

    uint256 oldAccountBalance = _balances[account];
    _balances[account] = oldAccountBalance.sub(amount, 'ERC20: burn amount exceeds balance');
    _averageBalances[account] = _averageBalances[account] == 0 ? amount : _averageBalances[account].mul(9).sub(amount).div(10);   // Average Balance Updated

  }

  function _approve(address owner, address spender, uint256 amount) internal virtual {
    require(owner != address(0), 'ERC20: approve from the zero address');
    require(spender != address(0), 'ERC20: approve to the zero address');

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _setName(string memory newName) internal {
    _name = newName;
  }

  function _setSymbol(string memory newSymbol) internal {
    _symbol = newSymbol;
  }

  function _setDecimals(uint8 newDecimals) internal {
    _decimals = newDecimals;
  }

  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
  }

  // Calculates the average total supply over last 100 transactions
  function calculateAverageTotalSupply(uint newTotalSupply) internal view returns(uint256) {
    return averageTotalSupply == 0 ? newTotalSupply : averageTotalSupply.mul(99).add(newTotalSupply).div(100);
  }

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/types/DataTypes.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

library DataTypes {

  struct InstrumentData {

    InstrumentConfigurationMap configuration;      //stores the instrument configuration
    uint128 liquidityIndex;                     //the liquidity index. Expressed in ray
    uint128 variableBorrowIndex;                //variable borrow index. Expressed in ray

    uint128 currentLiquidityRate;               //the current supply rate. Expressed in ray
    uint128 currentVariableBorrowRate;          //the current variable borrow rate. Expressed in ray
    uint128 currentStableBorrowRate;            //the current stable borrow rate. Expressed in ray

    uint40 lastUpdateTimestamp;

    address iTokenAddress;                      //tokens addresses
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;

    address interestRateStrategyAddress;        //address of the interest rate strategy

    uint8 id;                                   //the id of the instrument. Represents the position in the list of the active instruments
    uint8 decimals;
  }

  struct InstrumentConfigurationMap {
    //bit 0-15: LTV
    //bit 16-31: Liq. threshold
    //bit 32-47: Liq. bonus
    //bit 48-55: Decimals
    //bit 56: Reserve is active
    //bit 57: reserve is frozen
    //bit 58: borrowing is enabled
    //bit 59: stable rate borrowing enabled
    //bit 60-63: reserved
    //bit 64-79: reserve factor
    uint256 data;
  }

  struct UserConfigurationMap {
    uint256 data;
  }

  enum InterestRateMode {NONE, STABLE, VARIABLE}
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ILendingPool.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;


interface ILendingPool {

    //######################################
    //############### EVENTS ###############
    //######################################

  /**
   * @dev Emitted on deposit()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   **/
  event Deposit(address indexed instrument, address indexed user,uint256 amount);

  /**
   * @dev Emitted on withdraw()
   * @param instrument The address of the underlyng asset being withdrawn
   * @param user The address initiating the withdrawal, owner of iTokens
   * @param to Address that will receive the underlying
   * @param amount The amount to be withdrawn
   **/
  event Withdraw(address indexed instrument, address indexed user, address indexed to, uint256 amount);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrument The address of the underlying asset being borrowed
   * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
   * initiator of the transaction on flashLoan()
   * @param onBehalfOf The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
   * @param borrowRate The numeric rate at which the user has borrowed
   **/
  event Borrow(address indexed instrument, address user, address indexed onBehalfOf, uint256 amount, uint256 borrowRateMode, uint256 borrowRate);

  /**
   * @dev Emitted on repay()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The beneficiary of the repayment, getting his debt reduced
   * @param repayer The address of the user initiating the repay(), providing the funds
   * @param loanRepaid The amount repaid
   * @param totalFeeRepaid The total Fee repaid
   **/
  event Repay(address indexed instrument, address indexed user, address indexed repayer, uint256 loanRepaid, uint256 totalFeeRepaid);

  /**
   * @dev Emitted on swapBorrowRateMode()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address of the user swapping his rate mode
   * @param rateMode The rate mode that the user wants to swap to
   **/
  event Swap(address indexed instrument, address indexed user, uint256 rateMode);

  /**
   * @dev Emitted on setUserUseInstrumentAsCollateral()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address of the user enabling the usage as collateral
   **/
  event InstrumentUsedAsCollateralEnabled(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on setUserUseInstrumentAsCollateral()
   * @param instrument The address of the underlying asset
   * @param user The address of the user enabling the usage as collateral
   **/
  event InstrumentUsedAsCollateralDisabled(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on rebalanceStableBorrowRate()
   * @param instrument The address of the underlying asset
   * @param user The address of the user for which the rebalance has been executed
   **/
  event RebalanceStableBorrowRate(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on flashLoan()
   * @param target The address of the flash loan receiver contract
   * @param initiator The address initiating the flash loan
   * @param asset The address of the asset being flash borrowed
   * @param amount The amount flash borrowed
   * @param premium The fee flash borrowed
   * @param boosterID  The boosterID of the Booster used to get a discount on the Fee
   **/
  event FlashLoan(address indexed target, address indexed initiator, address indexed asset, uint256 amount, uint256 premium, uint16 boosterID );

  event Paused();
  event Unpaused();

  /**
   * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
   * LendingPoolCollateral manager using a DELEGATECALL
   * This allows to have the events in the generated ABI for LendingPool.
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
   * @param liquidator The address of the liquidator
   * @param receiveIToken `true` if the liquidators wants to receive the collateral iTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  event LiquidationCall(address indexed collateralAsset, address indexed debtAsset, address indexed user, uint256 debtToCover, uint256 liquidatedCollateralAmount, address liquidator, bool receiveIToken);

  /**
   * @dev Emitted when the state of a instrument is updated. NOTE: This event is actually declared
   * in the InstrumentLogic library and emitted in the updateInterestRates() function. Since the function is internal,
   * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it gets added to the LendingPool ABI
   * @param instrument The address of the underlying asset
   * @param liquidityRate The new liquidity rate
   * @param stableBorrowRate The new stable borrow rate
   * @param variableBorrowRate The new variable borrow rate
   * @param liquidityIndex The new liquidity index
   * @param variableBorrowIndex The new variable borrow index
   **/
  event InstrumentDataUpdated(address indexed instrument, uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate, uint256 liquidityIndex, uint256 variableBorrowIndex);

  /**
   * @dev Emitted on deposit()
   * @param instrumentAddress The address of the underlying asset 
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/
  event depositFeeDeducted(address instrumentAddress, address user, uint amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);
  
  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/  
  event borrowFeeUpdated(address instrumentAddress, address user, uint256 amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address repaying the amount
   * @param onBehalfOf The user whose debt is being repaid
   * @param amount The amount borrowed out
   * @param platformFeePay Platform Fee paid
   * @param reserveFeePay Reserve Fee paid
   **/  
  event feeRepaid(address instrumentAddress, address user, address onBehalfOf, uint256 amount, uint256 platformFeePay, uint256 reserveFeePay);



    //#########################################
    //############### FUNCTIONS ###############
    //#########################################



  function refreshConfig() external;

  /**
   * @dev Deposits an `amount` of underlying asset, receiving in return overlying iTokens.
   * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
   * @param asset The address of the underlying asset to deposit
   * @param amount The amount to be deposited
   * @param boosterID of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   **/
  function deposit(address asset, uint256 amount, uint16 boosterID) external;

  /**
   * @dev Withdraws an `amount` of underlying asset, burning the equivalent iTokens owned
   * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
   * @param asset The address of the underlying asset to withdraw
   * @param amount The underlying amount to be withdrawn
   *   - Send the value type(uint256).max in order to withdraw the whole iToken balance
   * @param to Address that will receive the underlying, same as msg.sender if the user
   *   wants to receive it on his own wallet, or a different address if the beneficiary is a
   *   different wallet
   * @return The final amount withdrawn
   **/
  function withdraw(address asset, uint256 amount, address to) external returns (uint256);

  /**
   * @dev Allows users to borrow a specific `amount` of the underlying asset, provided that the borrower
   * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
   * corresponding debt token (StableDebtToken or VariableDebtToken)
   * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
   *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
   * @param asset The address of the underlying asset to borrow
   * @param amount The amount to be borrowed
   * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
   * @param boosterID of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
   * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
   * if he has been given credit delegation allowance
   **/
  function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 boosterID, address onBehalfOf) external;

  /**
   * @notice Repays a borrowed `amount`, burning the equivalent debt tokens owned
   * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
   * @param asset The address of the borrowed underlying asset previously borrowed
   * @param amount The amount to repay
   * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
   * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
   * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
   * user calling the function if he wants to reduce/remove his own debt, or the address of any other
   * other borrower whose debt should be removed
   * @return The final amount repaid
   **/
  function repay(address asset, uint256 amount, uint256 rateMode, address onBehalfOf) external returns (uint256);

  /**
   * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
   * @param asset The address of the underlying asset borrowed
   * @param rateMode The rate mode that the user wants to swap to
   **/
  function swapBorrowRateMode(address asset, uint256 rateMode) external;

  /**
   * @dev Rebalances the stable interest rate of a user to the current stable rate defined
   * - Users can be rebalanced if the following conditions are satisfied:
   *     1. Usage ratio is above 95%
   *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
   *        borrowed at a stable rate and depositors are not earning enough
   * @param asset The address of the underlying asset borrowed
   * @param user The address of the user to be rebalanced
   **/
  function rebalanceStableBorrowRate(address asset, address user) external;

  /**
   * @dev Allows depositors to enable/disable a specific deposited asset as collateral
   * @param asset The address of the underlying asset deposited
   * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
   **/
  function setUserUseInstrumentAsCollateral(address asset, bool useAsCollateral) external;

  /**
   * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
   * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
   *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param receiveIToken `true` if the liquidators wants to receive the collateral iTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  function liquidationCall(address collateralAsset, address debtAsset, address user, uint256 debtToCover, bool receiveIToken) external;

  /**
   * @dev Allows smartcontracts to access the liquidity of the pool within one transaction, as long as the amount taken plus a fee is returned.
   * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
   * @param asset The addresses of the assets being flash-borrowed
   * @param amount The amounts amounts being flash-borrowed
   * @param _params Variadic packed params to pass to the receiver as extra information
   * @param boosterId of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   **/
  function flashLoan( address receiverAddress, address asset, uint256 amount, bytes calldata _params, uint16 boosterId) external;

  /**
   * @dev Returns the user account data across all the instruments
   * @param user The address of the user
   * @return totalCollateralUSD the total collateral in USD of the user
   * @return totalDebtUSD the total debt in USD of the user
   * @return availableBorrowsUSD the borrowing power left of the user
   * @return currentLiquidationThreshold the liquidation threshold of the user
   * @return ltv the loan to value of the user
   * @return healthFactor the current health factor of the user
   **/
  function getUserAccountData(address user) external view returns (
      uint256 totalCollateralUSD,
      uint256 totalDebtUSD,
      uint256 availableBorrowsUSD,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );

  function getInstrumentConfiguration(address asset) external view returns ( DataTypes.InstrumentConfigurationMap memory );

  function initInstrument(address asset,address iTokenAddress, address stableDebtAddress, address variableDebtAddress, address interestRateStrategyAddress) external;

  function setInstrumentInterestRateStrategyAddress(address instrument, address rateStrategyAddress) external;

  function setConfiguration(address instrument, uint256 configuration) external;



  /**
   * @dev Returns the configuration of the user across all the instruments
   * @param user The user address
   * @return The configuration of the user
   **/
  function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);

  /**
   * @dev Returns the normalized income normalized income of the instrument
   * @param asset The address of the underlying asset
   * @return The instrument's normalized income
   */
  function getInstrumentNormalizedIncome(address asset) external view returns (uint256);

  /**
   * @dev Returns the normalized variable debt per unit of asset
   * @param asset The address of the underlying asset
   * @return The instrument normalized variable debt
   */
  function getInstrumentNormalizedVariableDebt(address asset) external view returns (uint256);

  /**
   * @dev Returns the state and configuration of the instrument
   * @param asset The address of the underlying asset
   * @return The state of the instrument
   **/
  function getInstrumentData(address asset) external view returns (DataTypes.InstrumentData memory);

  function finalizeTransfer(address asset, address from, address to, uint256 amount, uint256 balanceFromAfter, uint256 balanceToBefore) external;

  function getInstrumentsList() external view returns (address[] memory);

  function setPause(bool val) external;



}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/VersionedInitializable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title VersionedInitializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 *
 * @author Aave, SIGH Finance, inspired by the OpenZeppelin Initializable contract
 */
abstract contract VersionedInitializable {
    /**
   * @dev Indicates that the contract has been initialized.
   */
    uint256 private lastInitializedRevision = 0;

    /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
    bool private initializing;

    /**
   * @dev Modifier to use in the initializer function of a contract.
   */
    modifier initializer() {
        uint256 revision = getRevision();
        require(initializing || isConstructor() || revision > lastInitializedRevision, "Contract instance has already been initialized");

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            lastInitializedRevision = revision;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev returns the revision number of the contract.
    /// Needs to be defined in the inherited class as a constant.
    function getRevision() internal virtual pure returns(uint256);


    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        //solium-disable-next-line
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ICreditDelegationToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface ICreditDelegationToken {

  event BorrowAllowanceDelegated(address indexed fromUser, address indexed toUser, address asset, uint256 amount);

  /**
   * @dev delegates borrowing power to a user on the specific debt token
   * @param delegatee the address receiving the delegated borrowing power
   * @param amount the maximum amount being delegated. Delegation will still
   * respect the liquidation constraints (even if delegated, a delegatee cannot force a delegator HF to go below 1)
   **/
  function approveDelegation(address delegatee, uint256 amount) external;

  /**
   * @dev returns the borrow allowance of the user
   * @param fromUser The user to giving allowance
   * @param toUser The user to give allowance to
   * @return the current allowance of toUser
   **/
  function borrowAllowance(address fromUser, address toUser) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ISIGHHarvestDebtToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface ISIGHHarvestDebtToken {

  function setSIGHHarvesterAddress(address _SIGHHarvesterAddress) external  returns (bool) ;

  function claimSIGH(address[] memory users) external  ;
  function claimMySIGH() external ;

  function getSighAccured(address user)  external view  returns (uint) ;

//  ############################################
//  ######### FUNCTIONS RELATED TO FEE #########
//  ############################################

  function updatePlatformFee(address user, uint platformFeeIncrease, uint platformFeeDecrease) external  ;
  function updateReserveFee(address user, uint reserveFeeIncrease, uint reserveFeeDecrease) external  ;

  function getPlatformFee(address user) external view returns (uint) ;
  function getReserveFee(address user)  external view returns (uint) ;

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/tokenization/base/DebtTokenBase.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;








/**
 * @title DebtTokenBase g
 * @notice Base contract for different types of debt tokens, like StableDebtToken or VariableDebtToken
 * @author Aave
 */

abstract contract DebtTokenBase is ISIGHHarvestDebtToken, IncentivizedERC20, VersionedInitializable, ICreditDelegationToken {

  using SafeMath for uint256;

  address public immutable UNDERLYING_ASSET_ADDRESS;
  ILendingPool public immutable POOL;
  IGlobalAddressesProvider public immutable ADDRESSES_PROVIDER;
  ISIGHHarvester public sighHarvester;

  mapping(address => mapping(address => uint256)) internal _borrowAllowances;

  /**
   * @dev Only lending pool can call functions marked by this modifier
   **/
  modifier onlyLendingPool {
    require(_msgSender() == address(POOL), "CALLER MUST BE LENDING POOL");
    _;
  }

  /**
   * @dev The metadata of the token will be set on the proxy, that the reason of
   * passing "NULL" and 0 as metadata
   */
  constructor(address addressesProvider, address pool, address underlyingAssetAddress, string memory name, string memory symbol) IncentivizedERC20(name, symbol, 18) {
    POOL = ILendingPool(pool);
    ADDRESSES_PROVIDER = IGlobalAddressesProvider(addressesProvider);
    UNDERLYING_ASSET_ADDRESS = underlyingAssetAddress;
  }

  /**
   * @dev Initializes the debt token.
   * @param name The name of the token
   * @param symbol The symbol of the token
   * @param decimals The decimals of the token
   */
  function initialize(uint8 decimals, string memory name, string memory symbol) public initializer {
    _setName(name);
    _setSymbol(symbol);
    _setDecimals(decimals);
  }

  /**
   * @dev delegates borrowing power to a user on the specific debt token
   * @param delegatee the address receiving the delegated borrowing power
   * @param amount the maximum amount being delegated. Delegation will still
   * respect the liquidation constraints (even if delegated, a delegatee cannot
   * force a delegator HF to go below 1)
   **/
  function approveDelegation(address delegatee, uint256 amount) external override {
    _borrowAllowances[_msgSender()][delegatee] = amount;
    emit BorrowAllowanceDelegated(_msgSender(), delegatee, UNDERLYING_ASSET_ADDRESS, amount);
  }

  /**
   * @dev returns the borrow allowance of the user
   * @param fromUser The user to giving allowance
   * @param toUser The user to give allowance to
   * @return the current allowance of toUser
   **/
  function borrowAllowance(address fromUser, address toUser) external view override returns (uint256) {
    return _borrowAllowances[fromUser][toUser];
  }

  function _decreaseBorrowAllowance(address delegator, address delegatee, uint256 amount) internal {
    uint256 newAllowance = _borrowAllowances[delegator][delegatee].sub(amount, "BORROW ALLOWANCE NOT ENOUGH");
    _borrowAllowances[delegator][delegatee] = newAllowance;
    emit BorrowAllowanceDelegated(delegator, delegatee, UNDERLYING_ASSET_ADDRESS, newAllowance);
  }

  /**
   * @dev Being non transferrable, the debt token does not implement any of the
   * standard ERC20 functions for transfer and allowance.
   **/
  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
      recipient; amount;
      revert('TRANSFER_NOT_SUPPORTED');
  }

  function allowance(address owner, address spender) public view virtual override returns (uint256){
    owner; spender;
    revert('ALLOWANCE_NOT_SUPPORTED');
  }

  function approve(address spender, uint256 amount) public virtual override returns (bool) {
    spender; amount;
    revert('APPROVAL_NOT_SUPPORTED');
  }

  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
    sender; recipient; amount;
    revert('TRANSFER_NOT_SUPPORTED');
  }

  function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
    spender; addedValue;
    revert('ALLOWANCE_NOT_SUPPORTED');
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
    spender;
    subtractedValue;
    revert('ALLOWANCE_NOT_SUPPORTED');
  }

//  ########################################################
//  ######### FUNCTIONS RELATED TO SIGH HARVESTING #########
//  ########################################################

    /**
   * @dev Sets the SIGH Harvester Proxy Contract Address
   * @param _SIGHHarvesterAddress The SIGH Harvester Proxy Contract Address
   * @return The amount transferred
   **/
  function setSIGHHarvesterAddress(address _SIGHHarvesterAddress) external override returns (bool) {
    require(ADDRESSES_PROVIDER.getLendingPoolConfigurator() == msg.sender,'ONLY LP CONFIGURATOR');
    sighHarvester = ISIGHHarvester(_SIGHHarvesterAddress);
    return true;
  }

  function claimSIGH(address[] memory users) public override {
    return sighHarvester.claimSIGH(users);
  }

  function claimMySIGH() public override {
    return sighHarvester.claimMySIGH(msg.sender);
  }

  function getSighAccured(address user)  external view override returns (uint)  {
    return sighHarvester.getSighAccured(user);
  }

//  ############################################
//  ######### FUNCTIONS RELATED TO FEE #########
//  ############################################

  function updatePlatformFee(address user, uint platformFeeIncrease, uint platformFeeDecrease) external onlyLendingPool override {
    sighHarvester.updatePlatformFee(user,platformFeeIncrease,platformFeeDecrease);
  }

  function updateReserveFee(address user, uint reserveFeeIncrease, uint reserveFeeDecrease) external onlyLendingPool override {
    sighHarvester.updateReserveFee(user,reserveFeeIncrease,reserveFeeDecrease);
  }

  function getPlatformFee(address user) external view override returns (uint) {
    return sighHarvester.getPlatformFee(user);
  }

  function getReserveFee(address user)  external view override returns (uint) {
    return sighHarvester.getReserveFee(user);
  }

}
