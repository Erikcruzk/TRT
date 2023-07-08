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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/Callisto_Network-Worthpad Security Audit Report/worth-71760542a40e580ad6c0c57c5ec5798072c0a3b0/WorthTokenSale.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

/* Token Interface */
interface Token {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
}

/* WORTH Token Sale Contract */
contract WorthTokenSale is ReentrancyGuard, Context, Ownable {

    using SafeMath for uint256;

    address public tokenAddr;
    address public usdtAddr;
    address public busdAddr;
    
    uint256 public tokenPriceUsd; 
    uint256 public tokenDecimal = 18;
    uint256 public totalTransaction;
    uint256 public totalHardCap;
    uint256 public minContribution;
    uint256 public maxContribution;
    uint256 public hardCap;

    //Keep track of whether contract is up or not
    bool public contractUp;
      
    //Keep track of whether the sale has ended or not
    bool public saleEnded;
    
    //Event to trigger Sale stop
    event SaleStopped(address _owner, uint256 time);

    event TokensTransferred(address beneficiary, uint256 amount);
    event TokensDeposited(address indexed beneficiary, uint256 amount);
    event UsdDeposited(address indexed beneficiary, uint256 amount);
    event HardCapUpdated(uint256 value);
    event TokenPriceUpdated(uint256 value);
    event MinMaxUpdated(uint256 min, uint256 max);
    event TokenAddressUpdated(address value);
    event TokenWithdrawn(address beneficiary,uint256 value);
    event CryptoWithdrawn(address beneficiary,uint256 value);
    event SaleEnded(address _owner, uint256 time);
    
    mapping(address => uint256) public balances;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public allocation;
    mapping(address => uint256) public tokenExchanged;

    bool public whitelist = true;
    uint256 public claimDate;

    //modifiers    
    modifier _contractUp(){
        require(contractUp,"Token Sale hasn't started");
        _;
    }
  
     modifier nonZeroAddress(address _to) {
        require(_to != address(0),"Token Address should not be address 0");
        _;
    }
    
    modifier _saleEnded() {
        require(saleEnded, "Token Sale hasn't ended yet");
        _;
    }
    
    modifier _saleNotEnded() {
        require(!saleEnded, "Token Sale has ended");
        _;
    }

    /* Constructor Arguments : */
    /* 1. WorthToken token contract Address */
    /* 2. Min Contribution (in USD) */
    /* 3. Max Contribution (in USD) */
    /* 4. Hard Cap (in USD) */
    /* 5. Claim Date (in UNIX Timestamp) */
    /* 6. USDT token address */
    /* 7. BUSD token address */
    /* 8. Token ICO Price (in USD) */
    constructor(address _tokenAddr, uint256 _minContribution,
                uint256 _maxContribution,uint256 _hardCap,
                uint256 _claimDate, address _usdtAddr,
                address _busdAddr, uint256 _tokenPriceUsd) nonZeroAddress(_tokenAddr) nonZeroAddress(_usdtAddr) nonZeroAddress(_busdAddr){
        tokenAddr = _tokenAddr;
        minContribution = _minContribution.mul(10 ** uint256(tokenDecimal));
        maxContribution = _maxContribution.mul(10 ** uint256(tokenDecimal));
        hardCap = _hardCap.mul(10 ** uint256(tokenDecimal));
        claimDate = _claimDate;
        usdtAddr = _usdtAddr;
        busdAddr = _busdAddr;
        tokenPriceUsd = _tokenPriceUsd.mul(10 ** uint256(tokenDecimal));
    }

    /* Function     : This function is used to Whitelist address for Sale */
    /* Parameters   : Array Address of all users */
    /* External Function */
    function whitelistAddress(address[] memory _recipients, uint256[] memory _allocation) external onlyOwner returns (bool) {
        require(!contractUp, "Changes are not allowed during Token Sale");
        for (uint256 i = 0; i < _recipients.length; i++) {
            whitelisted[_recipients[i]] = true;
            allocation[_recipients[i]] = _allocation[i];
        }
        return true;
    } 
    
    /* Function     : This function is used to deposit tokens for liquidity manually */
    /* Parameters   : Total amount needed to be added as liquidity */
    /* External Function */    
    function depositTokens(uint256  _amount) external returns (bool) {
        require(_amount <= Token(tokenAddr).balanceOf(msg.sender),"Token Balance of user is less");
        require(Token(tokenAddr).transferFrom(msg.sender,address(this), _amount));
        emit TokensDeposited(msg.sender, _amount);
        return true;
    }

    /* Function     : This function is used to claim token brought */
    /* Parameters   : -- */
    /* External Function */
    function claimToken() external nonReentrant _saleEnded() returns (bool) {
        address userAdd = msg.sender;
        uint256 amountToClaim = tokenExchanged[userAdd];
        require(block.timestamp>claimDate,"Cannot Claim Now");
        require(amountToClaim>0,"There is no amount to claim");
        require(amountToClaim <= Token(tokenAddr).balanceOf(address(this)),"Token Balance of contract is less");
        tokenExchanged[userAdd] = 0;
        require(Token(tokenAddr).transfer(userAdd, amountToClaim),"Transfer Failed");
        emit TokensTransferred(userAdd, amountToClaim);
        return true;
    }
    
    /* This function will accept funds directly sent to the address */
    receive() payable external {
    }

    /* Function     : This function is used to buy WORTH tokens using USDT */
    /* Parameters   : Total amount of WORTH token to buy */
    /* External Function */
    function exchangeUSDTForToken(uint256 _amount) external nonReentrant _contractUp() _saleNotEnded() {
        require(Token(usdtAddr).transferFrom(msg.sender,address(this), _amount));
        uint256 amount = _amount;
        address userAdd = msg.sender;
        uint256 tokenAmount = 0;
        balances[msg.sender] = balances[msg.sender].add(_amount);
        
        if(whitelist){
            require(whitelisted[userAdd],"User is not Whitelisted");
            require(balances[msg.sender]<=allocation[msg.sender],"User max allocation limit reached");
        }
        require(totalHardCap < hardCap, "USD Hardcap Reached");
        require(balances[msg.sender] >= minContribution && balances[msg.sender] <= maxContribution,"Contribution should satisfy min max case");
        totalTransaction = totalTransaction.add(1);
        totalHardCap = totalHardCap.add(amount);
        tokenAmount = amount.mul(10 ** uint256(tokenDecimal)).div(tokenPriceUsd);
        tokenExchanged[userAdd] += tokenAmount;
        
        emit UsdDeposited(msg.sender,_amount);
    }

    /* Function     : This function is used to buy WORTH tokens using BUSD */
    /* Parameters   : Total amount of WORTH token to buy */
    /* External Function */
    function exchangeBUSDForToken(uint256 _amount) external nonReentrant _contractUp() _saleNotEnded() {
        require(Token(busdAddr).transferFrom(msg.sender,address(this), _amount));
        uint256 amount = _amount;
        address userAdd = msg.sender;
        uint256 tokenAmount = 0;
        balances[msg.sender] = balances[msg.sender].add(_amount);
        
        if(whitelist){
            require(whitelisted[userAdd],"User is not Whitelisted");
            require(balances[msg.sender]<=allocation[msg.sender],"User max allocation limit reached");
        }
        require(totalHardCap < hardCap, "USD Hardcap Reached");
        require(balances[msg.sender] >= minContribution && balances[msg.sender] <= maxContribution,"Contribution should satisfy min max case");
        totalTransaction = totalTransaction.add(1);
        totalHardCap = totalHardCap.add(amount);
        tokenAmount = amount.mul(10 ** uint256(tokenDecimal)).div(tokenPriceUsd);
        tokenExchanged[userAdd] += tokenAmount;
        
        emit UsdDeposited(msg.sender,_amount);
    }

    
    /* ONLY OWNER FUNCTIONS */

    /**
    *     @dev Check if sale contract is powered up
    */
    function powerUpContract() external onlyOwner {
        // Contract should not be powered up previously
        require(!contractUp);
        //activate the sale process
        contractUp = true;
    }

    //for Emergency/Hard stop of the sale
    function emergencyStop() external onlyOwner _contractUp() _saleNotEnded() {
        saleEnded = true;    
        emit SaleStopped(msg.sender, block.timestamp);
    }
    
    /**
    *     @dev End the Sale
    */
    function endSale() external onlyOwner _contractUp() _saleNotEnded() {
        //End the sale process
        saleEnded = true;
        emit SaleEnded(msg.sender, block.timestamp);
    }

    /* Function     : Updates Whitelisting feature ON/OFF */
    /* Parameters   : -- */
    /* Only Owner Function */
    function toggleWhitelistStatus() external onlyOwner returns (bool success)  {
        require(!contractUp, "Changes are not allowed during Token Sale");
        if (whitelist) {
            whitelist = false;
        } else {
            whitelist = true;
        }
        return whitelist;     
    }

    /* Function     : Update Token Price */
    /* Parameters   : New token Price (in USD) */
    /* Only Owner Function */    
    function updateTokenPrice(uint256 newTokenValue) external onlyOwner {
        require(!contractUp, "Changes are not allowed during Token Sale");
        tokenPriceUsd = newTokenValue.mul(10 ** uint256(tokenDecimal));
        emit TokenPriceUpdated(newTokenValue);
    }

    /* Function     : Update Hard cap of sale (in USD) */
    /* Parameters   : New Hard cap (in USD) */
    /* Only Owner Function */
    function updateHardCap(uint256 newHardcapValue) external onlyOwner {
        require(!contractUp, "Changes are not allowed during Token Sale");
        hardCap = newHardcapValue.mul(10 ** uint256(tokenDecimal));
        emit HardCapUpdated(newHardcapValue);
    }

    /* Function     : Update Min Max Buy Limits (in USD) */
    /* Parameters 1 : Min Token */
    /* Parameters 2 : Max Token */
    /* Only Owner Function */
    function updateTokenContribution(uint256 min, uint256 max) external onlyOwner {
        require(!contractUp, "Changes are not allowed during Token Sale");
        minContribution = min.mul(10 ** uint256(tokenDecimal));
        maxContribution = max.mul(10 ** uint256(tokenDecimal));
        emit MinMaxUpdated(min,max);
    }
    
    /* Function     : Updates the token address */
    /* Parameters   : New Token Address */
    /* Only Owner Function */
    function updateTokenAddress(address newTokenAddr) external nonZeroAddress(newTokenAddr) onlyOwner {
        require(!contractUp, "Changes are not allowed during Token Sale");
        tokenAddr = newTokenAddr;
        emit TokenAddressUpdated(newTokenAddr);
    }

    /* Function     : Withdraw Tokens remaining after the sale */
    /* Parameters 1 : Address where token should be sent */
    /* Parameters 2 : Token Address */
    /* Only Owner Function */
    // SWC-Unprotected Ether Withdrawal: L279 - L282
    function withdrawTokens(address beneficiary, address _tokenAddr) external nonZeroAddress(beneficiary) onlyOwner _contractUp() _saleEnded() {
        require(Token(_tokenAddr).transfer(beneficiary, Token(_tokenAddr).balanceOf(address(this))));
        emit TokenWithdrawn(_tokenAddr, Token(_tokenAddr).balanceOf(address(this)));
    }

    /* Function     : Withdraws Funds after sale */
    /* Parameters   : Address where Funds should be sent */
    /* Only Owner Function */
    function withdrawCrypto(address payable beneficiary) external nonZeroAddress(beneficiary) onlyOwner _contractUp() _saleEnded() {
        require(address(this).balance>0,"No Crypto inside contract");
        (bool success, ) = beneficiary.call{value:address(this).balance}("");
        require(success, "Transfer failed.");
        emit CryptoWithdrawn(beneficiary, address(this).balance);
    }
    
    /* ONLY OWNER FUNCTION ENDS HERE */

    /* VIEW FUNCTIONS */

    /* Function     : Returns Token Balance inside contract */
    /* Parameters   : -- */
    /* Public View Function */
    function getTokenBalance(address _tokenAddr) public view nonZeroAddress(_tokenAddr) returns (uint256){
        return Token(_tokenAddr).balanceOf(address(this));
    }

    /* Function     : Returns Crypto Balance inside contract */
    /* Parameters   : -- */
    /* Public View Function */
    function getCryptoBalance() public view returns (uint256){
        return address(this).balance;
    }
}
