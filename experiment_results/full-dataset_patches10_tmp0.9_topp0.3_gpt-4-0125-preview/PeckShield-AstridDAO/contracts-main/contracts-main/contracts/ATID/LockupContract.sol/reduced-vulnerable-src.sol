



pragma solidity 0.8.13;

















library SafeMath {
    








    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    








    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    










    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    








    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    










    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    












    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    










    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    












    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}





pragma solidity 0.8.13;







interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);
    
    
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    
    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}





pragma solidity 0.8.13;












interface IERC2612 {
    





















    function permit(address owner, address spender, uint256 amount, 
                    uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    










    function nonces(address owner) external view returns (uint256);
    
    function version() external view returns (string memory);
    function permitTypeHash() external view returns (bytes32);
    function domainSeparator() external view returns (bytes32);
}





pragma solidity 0.8.13;


interface IATIDToken is IERC20, IERC2612 { 
   
    
    
    event CommunityIssuanceAddressSet(address _communityIssuanceAddress);
    event ATIDStakingAddressSet(address _atidStakingAddress);
    event LockupContractFactoryAddressSet(address _lockupContractFactoryAddress);

    
    
    function sendToATIDStaking(address _sender, uint256 _amount) external;

    function getDeploymentStartTime() external view returns (uint256);
}





pragma solidity 0.8.13;













contract LockupContract {
    using SafeMath for uint;

    
    string constant public NAME = "LockupContract";

    
    uint constant public SECONDS_IN_ONE_MONTH = 2628000; 
    

    address public immutable beneficiary;

    IATIDToken public atidToken;
    
    uint public immutable initialAmount;
    
    uint public claimedAmount;

    
    uint public immutable deploymentStartTime;
    
    uint public immutable monthsToWaitBeforeUnlock;
    
    uint public immutable releaseSchedule;

    

    event LockupContractCreated(address _beneficiary, uint _amount, uint _monthsToWaitBeforeUnlock, uint _releaseSchedule);
    event LockupContractWithdrawn(uint _ATIDwithdrawal);

    

    constructor 
    (
        address _atidTokenAddress, 
        address _beneficiary, 
        uint _amount,
        uint _monthsToWaitBeforeUnlock,
        uint _releaseSchedule
    )
    {
        require(_releaseSchedule > 0, "LockupContract: release schedule cannot be 0");

        atidToken = IATIDToken(_atidTokenAddress);
        
        beneficiary =  _beneficiary;
        deploymentStartTime = block.timestamp;
        monthsToWaitBeforeUnlock = _monthsToWaitBeforeUnlock;
        releaseSchedule = _releaseSchedule;

        initialAmount = _amount;
        claimedAmount = 0;

        emit LockupContractCreated(_beneficiary, _amount, _monthsToWaitBeforeUnlock, _releaseSchedule);
    }

    function _getReleasedAmount() internal view returns (uint) {
        uint unlockTimestamp = deploymentStartTime + (monthsToWaitBeforeUnlock * SECONDS_IN_ONE_MONTH);
        if (block.timestamp < unlockTimestamp) {
            return 0;
        }
        uint monthsSinceUnlock = ((block.timestamp - unlockTimestamp) / SECONDS_IN_ONE_MONTH) + 1;
        uint monthlyReleaseAmount = initialAmount / releaseSchedule;
        uint releasedAmount = monthlyReleaseAmount * monthsSinceUnlock;
        
        if (releasedAmount > initialAmount){
            return initialAmount;
        }

        return releasedAmount;
    }

    
    function canWithdraw(uint amount) public view returns (bool) {
        uint claimableAmount = _getReleasedAmount() - claimedAmount; 
        return amount <= claimableAmount; 
    }

    
    function withdrawATID(uint amount) external {
        require(amount > 0, "LockupContract: requested amount should > 0");
        require(canWithdraw(amount), "LockupContract: requested amount cannot be withdrawed");

        IATIDToken atidTokenCached = atidToken;
        
        require(atidTokenCached.transfer(beneficiary, amount), "LockupContract: cannot withdraw ATID");
        claimedAmount += amount;

        emit LockupContractWithdrawn(amount);
    }
}