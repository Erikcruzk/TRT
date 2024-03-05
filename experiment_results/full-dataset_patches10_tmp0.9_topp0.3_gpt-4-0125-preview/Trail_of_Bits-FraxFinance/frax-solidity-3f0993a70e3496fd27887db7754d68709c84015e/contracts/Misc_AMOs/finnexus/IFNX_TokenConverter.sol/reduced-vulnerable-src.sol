


pragma solidity 0.6.11;











contract Context {
    
    
    constructor () internal { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}




pragma solidity 0.6.11;














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




pragma solidity 0.6.11;






interface IERC20 {
    


    function totalSupply() external view returns (uint256);

    


    function balanceOf(address account) external view returns (uint256);

    






    function transfer(address recipient, uint256 amount) external returns (bool);

    






    function allowance(address owner, address spender) external view returns (uint256);

    













    function approve(address spender, uint256 amount) external returns (bool);

    








    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    





    event Transfer(address indexed from, address indexed to, uint256 value);

    



    event Approval(address indexed owner, address indexed spender, uint256 value);
}




pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;




interface IFNX_TokenConverter {
    struct lockedReward {
        uint256 startTime; 
        uint256 total;     
        
        
    }
    
    struct lockedIdx {
        uint256 beginIdx;
        uint256 totalIdx;
    }

    function cfnxAddress() external returns (address); 
    function fnxAddress() external returns (address);  
    function timeSpan() external returns (uint256); 
    function dispatchTimes() external returns (uint256);    
    function txNum() external returns (uint256); 
    function lockPeriod() external returns (uint256);
    function lockedBalances(address) external returns (uint256); 
    function lockedAllRewards(address, uint256) external returns (lockedReward memory); 
    function lockedIndexs(address) external returns (lockedIdx memory); 
    function getbackLeftFnx(address ) external;
    function setParameter(address ,address ,uint256 ,uint256 ,uint256 ) external;
    function lockedBalanceOf(address ) external view returns (uint256);
    function inputCfnxForInstallmentPay(uint256 ) external;
    function claimFnxExpiredReward() external;
    function getClaimAbleBalance(address) external view returns (uint256);
}