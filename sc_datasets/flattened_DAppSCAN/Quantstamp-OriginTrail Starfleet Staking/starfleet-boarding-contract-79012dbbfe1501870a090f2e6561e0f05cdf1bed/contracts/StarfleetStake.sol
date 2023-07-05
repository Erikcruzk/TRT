// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: openzeppelin-solidity/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-OriginTrail Starfleet Staking/starfleet-boarding-contract-79012dbbfe1501870a090f2e6561e0f05cdf1bed/contracts/mocks/IBridgeCustodian.sol

pragma solidity ^0.6.10;

/// @title IBridgeCustodian interface - The interface required for an address to qualify as a custodian.
interface IBridgeCustodian {
    function getOwners() external view returns (address[] memory);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-OriginTrail Starfleet Staking/starfleet-boarding-contract-79012dbbfe1501870a090f2e6561e0f05cdf1bed/contracts/StarfleetStake.sol

pragma solidity 0.6.10;




contract StarfleetStake is Ownable {

    using SafeMath for uint256;
    IERC20 token;

    address public constant TRAC_TOKEN_ADDRESS = 0xaA7a9CA87d3694B5755f213B5D04094b8d0F0A6F;

    // minimum number of tokens for successful onboarding
    uint256 public constant MIN_THRESHOLD = 2e25;

    // maximum number of tokens allowed to be onboarded
    uint256 public constant MAX_THRESHOLD = 10e25;

    // Time periods

    // Official start time of the staking period
    uint256 public t_zero;
    uint256 public constant BOARDING_PERIOD_LENGTH = 30 days;
    uint256 public constant LOCK_PERIOD_LENGTH = 180 days;
    uint256 public constant BRIDGE_PERIOD_LENGTH = 180 days;
    uint256 public boarding_period_end;
    uint256 public lock_period_end;
    uint256 public bridge_period_end;
    bool public min_threshold_reached = false;

    // list of participants
    address[] internal participants;

    // participant stakes
    mapping(address => uint256) internal stake;
    mapping(address => uint256) internal participant_indexes;

    // for feature O1
    mapping(address => uint256) internal starTRAC_snapshot;

    event TokenStaked(address indexed staker, uint256 amount);
    event TokenWithdrawn(address indexed staker, uint256 amount);
    event TokenFallbackWithdrawn(address indexed staker, uint256 amount);
    event TokenTransferred(address indexed custodian, uint256 amount);
    event MinThresholdReached();

    constructor(uint256 start_time,address token_address)  public {

        if(start_time > now){
            t_zero = start_time;
        }else{
            t_zero = now;
        }

        boarding_period_end = t_zero.add(BOARDING_PERIOD_LENGTH);
        lock_period_end = t_zero.add(BOARDING_PERIOD_LENGTH).add(LOCK_PERIOD_LENGTH);
        bridge_period_end = t_zero.add(BOARDING_PERIOD_LENGTH).add(LOCK_PERIOD_LENGTH).add(BRIDGE_PERIOD_LENGTH);
        if (token_address!=address(0x0)){
            // for testing purposes
            token = IERC20(token_address);
        }else{
            // default use TRAC
            token = IERC20(TRAC_TOKEN_ADDRESS);
        }

    }

    // Override Ownable renounceOwnership function
    function renounceOwnership() public override onlyOwner {
        require(false, "Cannot renounce ownership of contract");
    }

    // Functional requirement FR1
    function depositTokens(uint256 amount) public {

        require(amount>0, "Amount cannot be zero");
        require(now >= t_zero, "Cannot deposit before staking starts");
        require(now < t_zero.add(BOARDING_PERIOD_LENGTH), "Cannot deposit after boarding period has expired");
        require(token.balanceOf(address(this)).add(amount) <= MAX_THRESHOLD, "Sender cannot deposit amounts that would cross the MAX_THRESHOLD");
        require(token.allowance(msg.sender, address(this)) >= amount, "Sender allowance must be equal to or higher than chosen amount");
        require(token.balanceOf(msg.sender) >= amount, "Sender balance must be equal to or higher than chosen amount!");

        bool transaction_result = token.transferFrom(msg.sender, address(this), amount);
        require(transaction_result, "Token transaction execution failed!");

        if (stake[msg.sender] == 0){
            participant_indexes[msg.sender] = participants.length;
            participants.push(msg.sender);
        }

        stake[msg.sender] = stake[msg.sender].add(amount);

        if ( token.balanceOf(address(this)) >= MIN_THRESHOLD && min_threshold_reached == false){
            min_threshold_reached = true;
            emit MinThresholdReached();
        }

        emit TokenStaked(msg.sender, amount);

    }

    function getStake(address participant) public view returns(uint256){
        return stake[participant];
    }

    function getNumberOfParticipants() public view returns(uint256){
        return participants.length;
    }

    function getParticipants() public view returns(address[] memory){
        return participants;
    }

    function isMinimumReached() public view returns(bool){
        return min_threshold_reached;
    }

    // Functional requirement FR2
    function withdrawTokens() public {

        require(!min_threshold_reached, "Cannot withdraw if minimum threshold has been reached");
        require(stake[msg.sender] > 0,"Cannot withdraw if there are no tokens staked with this address");
        uint256 amount = stake[msg.sender];
        stake[msg.sender] = 0;

        uint256 participant_index = participant_indexes[msg.sender];
        require(participant_index < participants.length, "Sender is not listed in participant list");
        if (participant_index != participants.length.sub(1)) {
            address last_participant = participants[participants.length.sub(1)];
            participants[participant_index] = last_participant;
            participant_indexes[last_participant] = participant_index;
        }
        participants.pop();

        bool transaction_result = token.transfer(msg.sender, amount);
        require(transaction_result, "Token transaction execution failed!");
        emit TokenWithdrawn(msg.sender, amount);


    }

    // Functional requirement FR6
    function fallbackWithdrawTokens() public {

        require(now > bridge_period_end, "Cannot use fallbackWithdrawTokens before end of bridge period");
        require(starTRAC_snapshot[msg.sender] > 0, "Cannot withdraw as this address has no starTRAC associated");
        uint256 amount = starTRAC_snapshot[msg.sender];
        starTRAC_snapshot[msg.sender] = 0;
        bool transaction_result = token.transfer(msg.sender, amount);
        require(transaction_result, "Token transaction execution failed!");
        emit TokenFallbackWithdrawn(msg.sender, amount);


    }

    // Functional requirement FR5
    function accountStarTRAC(address[] memory contributors, uint256[] memory amounts) onlyOwner public {
        require(now > bridge_period_end, "Cannot account starTRAC tokens before end of bridge period");
        require(contributors.length == amounts.length, "Wrong input - contributors and amounts have different lenghts");
        for (uint i = 0; i < contributors.length; i++) {
            starTRAC_snapshot[contributors[i]] = amounts[i];
        }

    }

    function getStarTRACamount(address contributor) public view returns(uint256){
        return starTRAC_snapshot[contributor];
    }


    // Functional requirement FR4
    function transferTokens(address payable custodian) onlyOwner public {

        require(custodian != address(0x0), "Custodian cannot be a zero address");
        uint contract_size;
        assembly { contract_size := extcodesize(custodian) }
        require(contract_size > 0, "Cannot transfer tokens to custodian that is not a contract!");

        IBridgeCustodian custodian_contract = IBridgeCustodian(custodian);
        bool has_owners_function = false;
        try custodian_contract.getOwners() returns (address[] memory owners) {
            has_owners_function = true;
            require(owners.length > 0, "Cannot transfer tokens to custodian without owners defined!");
        } catch {}
        require(has_owners_function, "Cannot transfer tokens to custodian without getOwners function!");
        require(now >= lock_period_end && now < bridge_period_end, "Cannot transfer tokens outside of the bridge period");

        uint256 balance_transferred= token.balanceOf(address(this));
        bool transaction_result = token.transfer(custodian, balance_transferred);
        require(transaction_result, "Token transaction execution failed!");

        emit TokenTransferred(custodian, balance_transferred);
    }

    function withdrawMisplacedEther() onlyOwner public {
        uint256 balance = address(this).balance;
        if (balance > 0) {
            msg.sender.transfer(balance);
        }
    }

    function withdrawMisplacedTokens(address token_contract_address) onlyOwner public {
        require(token_contract_address != address(token), "Cannot use this function with the TRAC contract");
        IERC20 token_contract = IERC20(token_contract_address);

        uint256 balance = token_contract.balanceOf(address(this));
        if (balance > 0) {
            bool transaction_result = token_contract.transfer(msg.sender, balance);
            require(transaction_result, "Token transaction execution failed");
        }
    }

}
