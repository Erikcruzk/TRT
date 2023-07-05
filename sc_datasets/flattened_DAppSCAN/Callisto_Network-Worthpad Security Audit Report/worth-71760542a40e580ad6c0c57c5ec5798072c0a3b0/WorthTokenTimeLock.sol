// File: @openzeppelin/contracts/utils/math/SafeMath.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
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
        return a + b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
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
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

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

// File: ../sc_datasets/DAppSCAN/Callisto_Network-Worthpad Security Audit Report/worth-71760542a40e580ad6c0c57c5ec5798072c0a3b0/WorthTokenTimeLock.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

/**
 * Token Contract call and send Functions
*/
interface Token {
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

/* Lock Contract Starts here */
contract WorthTokenTimeLock is Ownable{
    using SafeMath for uint256;
    
    /*
     * deposit vars
    */
    struct Items {
        address tokenAddress;
        address withdrawalAddress;
        uint256 tokenAmount;
        uint256 unlockTime;
        bool withdrawn;
    }
    
    uint256 public depositId;
    uint256[] public allDepositIds;
    mapping (address => uint256[]) public depositsByWithdrawalAddress;
    mapping (uint256 => Items) public lockedToken;
    mapping (address => mapping(address => uint256)) public walletTokenBalance;
    
    event LogWithdrawal(address sentToAddress, uint256 amountTransferred);
    
    /* Function     : This function will Lock the token */
    /* Parameters 1 : Token address */
    /* Parameters 2 : Withdrawal address */
    /* Parameters 1 : Amount to Lock */
    /* Parameters 2 : Unlock time - UNIX Timestamp */
    /* External Function */
    function lockTokens(address _tokenAddress, address _withdrawalAddress, uint256 _amount, uint256 _unlockTime) external returns (uint256 _id) {
        require(_amount > 0, "Amount should be greater than 0");
        require(_unlockTime <= 3217825449, "Enter a valid unlock time");
        
        //update balance in address
        walletTokenBalance[_tokenAddress][_withdrawalAddress] = walletTokenBalance[_tokenAddress][_withdrawalAddress].add(_amount);
        
        _id = ++depositId;
        lockedToken[_id].tokenAddress = _tokenAddress;
        lockedToken[_id].withdrawalAddress = _withdrawalAddress;
        lockedToken[_id].tokenAmount = _amount;
        lockedToken[_id].unlockTime = _unlockTime;
        lockedToken[_id].withdrawn = false;
        
        // SWC-Code With No Effects: L60
        allDepositIds.push(_id);
        depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
        
        // transfer tokens into contract
        require(Token(_tokenAddress).transferFrom(msg.sender, address(this), _amount), "Transfer Failed");
    }
    
    /* Function     : This function will Create Multiple Lock at the same time */
    /* Parameters are in [] Array Format */
    /* Parameters 1 : Token address */
    /* Parameters 2 : Withdrawal address */
    /* Parameters 1 : Amount to Lock */
    /* Parameters 2 : Unlock time - UNIX Timestamp */
    /* External Function */
    function createMultipleLocks(address _tokenAddress, address _withdrawalAddress, uint256[] memory _amounts, uint256[] memory _unlockTimes) external returns (uint256 _id) {
        require(_amounts.length > 0, "Enter at least 1 value");
        require(_amounts.length == _unlockTimes.length, "Number of amounts and number of unlock times should be equal");
        
        uint256 i;
        for(i=0; i<_amounts.length; i++){
            require(_amounts[i] > 0, "Amount should be greater than 0");     
            require(_unlockTimes[i] <= 3217825449, "Enter valid unlock time");
            
            //update balance in address
            walletTokenBalance[_tokenAddress][_withdrawalAddress] = walletTokenBalance[_tokenAddress][_withdrawalAddress].add(_amounts[i]);
            
            _id = ++depositId;
            lockedToken[_id].tokenAddress = _tokenAddress;
            lockedToken[_id].withdrawalAddress = _withdrawalAddress;
            lockedToken[_id].tokenAmount = _amounts[i];
            lockedToken[_id].unlockTime = _unlockTimes[i];
            lockedToken[_id].withdrawn = false;
            
            allDepositIds.push(_id);
            depositsByWithdrawalAddress[_withdrawalAddress].push(_id);
            
            //transfer tokens into contract
            require(Token(_tokenAddress).transferFrom(msg.sender, address(this), _amounts[i]), "Transfer Failed");
        }
    }
    
    /* Function     : This function will Extend the lock duration of the Locked tokens */
    /* Parameters 1 : Lock ID */
    /* Parameters 2 : Unlock Time - in UNIX Timestamp */
    /* Public Function */
    function extendLockDuration(uint256 _id, uint256 _unlockTime) external {
        require(_unlockTime <= 3217825449, "Enter a valid unlock time");
        require(!lockedToken[_id].withdrawn, "Tokens already withdrawn");
        require(msg.sender == lockedToken[_id].withdrawalAddress,"Not the same withdrawal address");
        require(_unlockTime >= lockedToken[_id].unlockTime,"Cannot have time duration less than the previous one");
        
        //set new unlock time
        lockedToken[_id].unlockTime = _unlockTime;
    }
    
    /* Function     : This function will withdraw the tokens once lock time is reached */
    /* Parameters   : Lock ID */
    /* Public Function */
    function withdrawTokens(uint256 _id) external {
        require(block.timestamp >= lockedToken[_id].unlockTime, "Unlock time not reached");
        require(msg.sender == lockedToken[_id].withdrawalAddress, "Not the same withdrawal address");
        require(!lockedToken[_id].withdrawn, "Tokens already withdrawn");
        
        lockedToken[_id].withdrawn = true;
        
        //update balance in address
        walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
        
        //remove this id from this address
        uint256 j;
        uint256 arrLength = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].length;
        for (j=0; j<arrLength; j++) {
            if (depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] == _id) {
                depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][j] = depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress][arrLength - 1];
                depositsByWithdrawalAddress[lockedToken[_id].withdrawalAddress].pop();
                break;
            }
        }
        
        // transfer tokens to wallet address
        require(Token(lockedToken[_id].tokenAddress).transfer(msg.sender, lockedToken[_id].tokenAmount), "Transfer Failed");
        emit LogWithdrawal(msg.sender, lockedToken[_id].tokenAmount);
    }

    /* Function     : This function will total balance of token inside contract */
    /* Parameters   : Token address */
    /* Public View Function */
    function getTotalTokenBalance(address _tokenAddress) view public returns (uint256)
    {
       return Token(_tokenAddress).balanceOf(address(this));
    }
    
    /* Function     : This function will return Token Locked by the user */
    /* Parameters 1 : Token address */
    /* Parameters 2 : Withdrawal address */
    /* Public View Function */
    function getTokenBalanceByAddress(address _tokenAddress, address _walletAddress) view public returns (uint256)
    {
       return walletTokenBalance[_tokenAddress][_walletAddress];
    }
    
    /* Function     : This function will return all Lock ID details */
    /* Parameters   : -- */
    /* Public View Function */
    function getAllDepositIds() view public returns (uint256[] memory)
    {
        return allDepositIds;
    }
    
    /* Function     : This function will return Lock details */
    /* Parameters   : ID of the Lock */
    /* Public View Function */
    function getDepositDetails(uint256 _id) view public returns (address _tokenAddress, address _withdrawalAddress, uint256 _tokenAmount, uint256 _unlockTime, bool _withdrawn)
    {
        return(lockedToken[_id].tokenAddress,lockedToken[_id].withdrawalAddress,lockedToken[_id].tokenAmount,
        lockedToken[_id].unlockTime,lockedToken[_id].withdrawn);
    }
    
    /* Function     : This function will return Lock details */
    /* Parameters   : Withdrawal address */
    /* Public View Function */
    function getDepositsByWithdrawalAddress(address _withdrawalAddress) view public returns (uint256[] memory)
    {
        return depositsByWithdrawalAddress[_withdrawalAddress];
    }
}
