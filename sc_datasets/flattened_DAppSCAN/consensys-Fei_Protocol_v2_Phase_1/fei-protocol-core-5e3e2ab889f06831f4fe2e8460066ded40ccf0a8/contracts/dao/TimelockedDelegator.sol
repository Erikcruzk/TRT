// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
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

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/token/IFei.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/// @title FEI stablecoin interface
/// @author Fei Protocol
interface IFei is IERC20 {
    // ----------- Events -----------

    event Minting(
        address indexed _to,
        address indexed _minter,
        uint256 _amount
    );

    event Burning(
        address indexed _to,
        address indexed _burner,
        uint256 _amount
    );

    event IncentiveContractUpdate(
        address indexed _incentivized,
        address indexed _incentiveContract
    );

    // ----------- State changing api -----------

    function burn(uint256 amount) external;

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    // ----------- Burner only state changing api -----------

    function burnFrom(address account, uint256 amount) external;

    // ----------- Minter only state changing api -----------

    function mint(address account, uint256 amount) external;

    // ----------- Governor only state changing api -----------

    function setIncentiveContract(address account, address incentive) external;

    // ----------- Getters -----------

    function incentiveContract(address account) external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/dao/ITimelockedDelegator.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;


interface ITribe is IERC20 {
    function delegate(address delegatee) external;
}

/// @title TimelockedDelegator interface
/// @author Fei Protocol
interface ITimelockedDelegator {
    // ----------- Events -----------

    event Delegate(address indexed _delegatee, uint256 _amount);

    event Undelegate(address indexed _delegatee, uint256 _amount);

    // ----------- Beneficiary only state changing api -----------

    function delegate(address delegatee, uint256 amount) external;

    function undelegate(address delegatee) external returns (uint256);

    // ----------- Getters -----------

    function delegateContract(address delegatee)
        external
        view
        returns (address);

    function delegateAmount(address delegatee) external view returns (uint256);

    function totalDelegated() external view returns (uint256);

    function tribe() external view returns (ITribe);
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/utils/Timed.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/// @title an abstract contract for timed events
/// @author Fei Protocol
abstract contract Timed {

    /// @notice the start timestamp of the timed period
    uint256 public startTime;

    /// @notice the duration of the timed period
    uint256 public duration;

    event DurationUpdate(uint256 oldDuration, uint256 newDuration);

    event TimerReset(uint256 startTime);

    constructor(uint256 _duration) {
        _setDuration(_duration);
    }

    modifier duringTime() {
        require(isTimeStarted(), "Timed: time not started");
        require(!isTimeEnded(), "Timed: time ended");
        _;
    }

    modifier afterTime() {
        require(isTimeEnded(), "Timed: time not ended");
        _;
    }

    /// @notice return true if time period has ended
    function isTimeEnded() public view returns (bool) {
        return remainingTime() == 0;
    }

    /// @notice number of seconds remaining until time is up
    /// @return remaining
    function remainingTime() public view returns (uint256) {
        return duration - timeSinceStart(); // duration always >= timeSinceStart which is on [0,d]
    }

    /// @notice number of seconds since contract was initialized
    /// @return timestamp
    /// @dev will be less than or equal to duration
    function timeSinceStart() public view returns (uint256) {
        if (!isTimeStarted()) {
            return 0; // uninitialized
        }
        uint256 _duration = duration;
        uint256 timePassed = block.timestamp - startTime; // block timestamp always >= startTime
        return timePassed > _duration ? _duration : timePassed;
    }

    function isTimeStarted() public view returns (bool) {
        return startTime != 0;
    }

    function _initTimed() internal {
        startTime = block.timestamp;
        
        emit TimerReset(block.timestamp);
    }

    function _setDuration(uint256 newDuration) internal {
        require(newDuration != 0, "Timed: zero duration");

        uint256 oldDuration = duration;
        duration = newDuration;
        emit DurationUpdate(oldDuration, newDuration);
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/utils/ILinearTokenTimelock.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/// @title LinearTokenTimelock interface
/// @author Fei Protocol
interface ILinearTokenTimelock {
    // ----------- Events -----------

    event Release(address indexed _beneficiary, address indexed _recipient, uint256 _amount);
    event BeneficiaryUpdate(address indexed _beneficiary);
    event PendingBeneficiaryUpdate(address indexed _pendingBeneficiary);

    // ----------- State changing api -----------

    function release(address to, uint256 amount) external;

    function releaseMax(address to) external;

    function setPendingBeneficiary(address _pendingBeneficiary) external;

    function acceptBeneficiary() external;


    // ----------- Getters -----------

    function lockedToken() external view returns (IERC20);

    function beneficiary() external view returns (address);

    function pendingBeneficiary() external view returns (address);

    function initialBalance() external view returns (uint256);

    function availableForRelease() external view returns (uint256);

    function totalToken() external view returns(uint256);

    function alreadyReleasedAmount() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/utils/LinearTokenTimelock.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

// Inspired by OpenZeppelin TokenTimelock contract
// Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/TokenTimelock.sol


contract LinearTokenTimelock is ILinearTokenTimelock, Timed {

    /// @notice ERC20 basic token contract being held in timelock
    IERC20 public override lockedToken;

    /// @notice beneficiary of tokens after they are released
    address public override beneficiary;

    /// @notice pending beneficiary appointed by current beneficiary
    address public override pendingBeneficiary;

    /// @notice initial balance of lockedToken
    uint256 public override initialBalance;

    uint256 internal lastBalance;

    constructor(
        address _beneficiary,
        uint256 _duration,
        address _lockedToken
    ) Timed(_duration) {
        require(_duration != 0, "LinearTokenTimelock: duration is 0");
        require(
            _beneficiary != address(0),
            "LinearTokenTimelock: Beneficiary must not be 0 address"
        );

        beneficiary = _beneficiary;
        _initTimed();

        _setLockedToken(_lockedToken);
    }

    // Prevents incoming LP tokens from messing up calculations
    modifier balanceCheck() {
        if (totalToken() > lastBalance) {
            uint256 delta = totalToken() - lastBalance;
            initialBalance = initialBalance + delta;
        }
        _;
        lastBalance = totalToken();
    }

    modifier onlyBeneficiary() {
        require(
            msg.sender == beneficiary,
            "LinearTokenTimelock: Caller is not a beneficiary"
        );
        _;
    }

    /// @notice releases `amount` unlocked tokens to address `to`
    function release(address to, uint256 amount) external override onlyBeneficiary balanceCheck {
        require(amount != 0, "LinearTokenTimelock: no amount desired");

        uint256 available = availableForRelease();
        require(amount <= available, "LinearTokenTimelock: not enough released tokens");

        _release(to, amount);
    }

    /// @notice releases maximum unlocked tokens to address `to`
    function releaseMax(address to) external override onlyBeneficiary balanceCheck {
        _release(to, availableForRelease());
    }

    /// @notice the total amount of tokens held by timelock
    function totalToken() public view override virtual returns (uint256) {
        return lockedToken.balanceOf(address(this));
    }

    /// @notice amount of tokens released to beneficiary
    function alreadyReleasedAmount() public view override returns (uint256) {
        return initialBalance - totalToken();
    }

    /// @notice amount of held tokens unlocked and available for release
    function availableForRelease() public view override returns (uint256) {
        uint256 elapsed = timeSinceStart();
        uint256 _duration = duration;

        uint256 totalAvailable = initialBalance * elapsed / _duration;
        uint256 netAvailable = totalAvailable - alreadyReleasedAmount();
        return netAvailable;
    }

    /// @notice current beneficiary can appoint new beneficiary, which must be accepted
    function setPendingBeneficiary(address _pendingBeneficiary)
        public
        override
        onlyBeneficiary
    {
        pendingBeneficiary = _pendingBeneficiary;
        emit PendingBeneficiaryUpdate(_pendingBeneficiary);
    }

    /// @notice pending beneficiary accepts new beneficiary
    function acceptBeneficiary() public override virtual {
        _setBeneficiary(msg.sender);
    }

    function _setBeneficiary(address newBeneficiary) internal {
        require(
            newBeneficiary == pendingBeneficiary,
            "LinearTokenTimelock: Caller is not pending beneficiary"
        );
        beneficiary = newBeneficiary;
        emit BeneficiaryUpdate(newBeneficiary);
        pendingBeneficiary = address(0);
    }

    function _setLockedToken(address tokenAddress) internal {
        lockedToken = IERC20(tokenAddress);
    }

    function _release(address to, uint256 amount) internal {
        lockedToken.transfer(to, amount);
        emit Release(beneficiary, to, amount);
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-Fei_Protocol_v2_Phase_1/fei-protocol-core-5e3e2ab889f06831f4fe2e8460066ded40ccf0a8/contracts/dao/TimelockedDelegator.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;



/// @title a proxy delegate contract for TRIBE
/// @author Fei Protocol
contract Delegatee is Ownable {
    ITribe public tribe;

    /// @notice Delegatee constructor
    /// @param _delegatee the address to delegate TRIBE to
    /// @param _tribe the TRIBE token address
    constructor(address _delegatee, address _tribe) {
        tribe = ITribe(_tribe);
        tribe.delegate(_delegatee);
    }

    /// @notice send TRIBE back to timelock and selfdestruct
    function withdraw() public onlyOwner {
        ITribe _tribe = tribe;
        uint256 balance = _tribe.balanceOf(address(this));
        _tribe.transfer(owner(), balance);
        selfdestruct(payable(owner()));
    }
}

/// @title a timelock for TRIBE allowing for sub-delegation
/// @author Fei Protocol
/// @notice allows the timelocked TRIBE to be delegated by the beneficiary while locked
contract TimelockedDelegator is ITimelockedDelegator, LinearTokenTimelock {
    /// @notice associated delegate proxy contract for a delegatee
    mapping(address => address) public override delegateContract;

    /// @notice associated delegated amount of TRIBE for a delegatee
    /// @dev Using as source of truth to prevent accounting errors by transferring to Delegate contracts
    mapping(address => uint256) public override delegateAmount;

    /// @notice the TRIBE token contract
    ITribe public override tribe;

    /// @notice the total delegated amount of TRIBE
    uint256 public override totalDelegated;

    /// @notice Delegatee constructor
    /// @param _tribe the TRIBE token address
    /// @param _beneficiary default delegate, admin, and timelock beneficiary
    /// @param _duration duration of the token timelock window
    constructor(
        address _tribe,
        address _beneficiary,
        uint256 _duration
    ) LinearTokenTimelock(_beneficiary, _duration, _tribe) {
        tribe = ITribe(_tribe);
        tribe.delegate(_beneficiary);
    }

    /// @notice delegate locked TRIBE to a delegatee
    /// @param delegatee the target address to delegate to
    /// @param amount the amount of TRIBE to delegate. Will increment existing delegated TRIBE
    function delegate(address delegatee, uint256 amount)
        public
        override
        onlyBeneficiary
    {
        require(
            amount <= _tribeBalance(),
            "TimelockedDelegator: Not enough Tribe"
        );

        // withdraw and include an existing delegation
        if (delegateContract[delegatee] != address(0)) {
            amount = amount + undelegate(delegatee);
        }

        ITribe _tribe = tribe;
        address _delegateContract =
            address(new Delegatee(delegatee, address(_tribe)));
        delegateContract[delegatee] = _delegateContract;

        delegateAmount[delegatee] = amount;
        totalDelegated = totalDelegated + amount;

        _tribe.transfer(_delegateContract, amount);

        emit Delegate(delegatee, amount);
    }

    /// @notice return delegated TRIBE to the timelock
    /// @param delegatee the target address to undelegate from
    /// @return the amount of TRIBE returned
    function undelegate(address delegatee)
        public
        override
        onlyBeneficiary
        returns (uint256)
    {
        address _delegateContract = delegateContract[delegatee];
        require(
            _delegateContract != address(0),
            "TimelockedDelegator: Delegate contract nonexistent"
        );

        Delegatee(_delegateContract).withdraw();

        uint256 amount = delegateAmount[delegatee];
        totalDelegated = totalDelegated - amount;

        delegateContract[delegatee] = address(0);
        delegateAmount[delegatee] = 0;

        emit Undelegate(delegatee, amount);

        return amount;
    }

    /// @notice calculate total TRIBE held plus delegated
    /// @dev used by LinearTokenTimelock to determine the released amount
    function totalToken() public view override returns (uint256) {
        return _tribeBalance() + totalDelegated;
    }

    /// @notice accept beneficiary role over timelocked TRIBE. Delegates all held (non-subdelegated) tribe to beneficiary
    function acceptBeneficiary() public override {
        _setBeneficiary(msg.sender);
        tribe.delegate(msg.sender);
    }

    function _tribeBalance() internal view returns (uint256) {
        return tribe.balanceOf(address(this));
    }
}
